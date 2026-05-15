import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../models/conversation_model.dart';
import '../models/inbox_model.dart';
import '../service/fire_store_utils.dart';
import '../service/send_notification.dart';

enum MessageStatus { sending, sent, delivered, read, failed }

class EnhancedMessage {
  final ConversationModel conversation;
  MessageStatus status;
  bool isRead;

  EnhancedMessage({
    required this.conversation,
    this.status = MessageStatus.sent,
    this.isRead = false,
  });

  factory EnhancedMessage.fromConversation(ConversationModel conversation) {
    return EnhancedMessage(
      conversation: conversation,
      status: MessageStatus.sent,
      isRead: false,
    );
  }
}

class EnhancedChatController extends GetxController {
  // Core controllers
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker imagePicker = ImagePicker();

  // Reactive state
  final RxBool isLoading = true.obs;
  final RxBool isTyping = false.obs;
  final RxBool isAtBottom = true.obs;
  final RxString typingIndicator = ''.obs;

  // Chat metadata
  final RxString orderId = ''.obs;
  final RxString customerId = ''.obs;
  final RxString customerName = ''.obs;
  final RxString customerProfileImage = ''.obs;
  final RxString restaurantId = ''.obs;
  final RxString restaurantName = ''.obs;
  final RxString restaurantProfileImage = ''.obs;
  final RxString token = ''.obs;
  final RxString chatType = ''.obs;

  // Messages with enhanced state
  final RxList<EnhancedMessage> messages = <EnhancedMessage>[].obs;
  final RxList<String> pendingMessageIds = <String>[].obs;

  // Pagination
  final int pageSize = 20;
  DocumentSnapshot? lastDocument;
  final RxBool hasMoreMessages = true.obs;
  final RxBool isLoadingMore = false.obs;

  // Keyboard and UI state
  final RxDouble keyboardHeight = 0.0.obs;
  final RxBool showScrollToBottom = false.obs;

  // Typing indicator timer
  Timer? _typingTimer;

  @override
  void onInit() {
    super.onInit();
    getArguments();
    setupScrollController();
    setupKeyboardListener();
    loadInitialMessages();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    _typingTimer?.cancel();
    super.onClose();
  }

  void getArguments() {
    final argumentData = Get.arguments;
    if (argumentData != null) {
      orderId.value = argumentData['orderId'] ?? '';
      customerId.value = argumentData['customerId'] ?? '';
      customerName.value = argumentData['customerName'] ?? '';
      customerProfileImage.value = argumentData['customerProfileImage'] ?? '';
      restaurantId.value = argumentData['restaurantId'] ?? '';
      restaurantName.value = argumentData['restaurantName'] ?? '';
      restaurantProfileImage.value =
          argumentData['restaurantProfileImage'] ?? '';
      token.value = argumentData['token'] ?? '';
      chatType.value = argumentData['chatType'] ?? '';
    }
    isLoading.value = false;
  }

  void setupScrollController() {
    scrollController.addListener(() {
      final isAtBottom =
          scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100;
      this.isAtBottom.value = isAtBottom;

      if (scrollController.position.pixels < 200) {
        showScrollToBottom.value = false;
      } else {
        showScrollToBottom.value = true;
      }

      // Load more messages when scrolling to top
      if (scrollController.position.pixels <= 50 &&
          hasMoreMessages.value &&
          !isLoadingMore.value) {
        loadMoreMessages();
      }
    });
  }

  void setupKeyboardListener() {
    // Keyboard height tracking for better UX
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This would be implemented with keyboard visibility detection
    });
  }

  Future<void> loadInitialMessages() async {
    try {
      final collectionName = getCollectionName();
      final query = FirebaseFirestore.instance
          .collection(collectionName)
          .doc(orderId.value)
          .collection('thread')
          .orderBy('createdAt', descending: true)
          .limit(pageSize);

      final snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        final enhancedMessages =
            snapshot.docs
                .map(
                  (doc) => EnhancedMessage.fromConversation(
                    ConversationModel.fromJson(doc.data()),
                  ),
                )
                .toList()
                .reversed
                .toList();

        messages.assignAll(enhancedMessages);
        lastDocument = snapshot.docs.last;

        // Auto scroll to bottom for initial load
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToBottom(animate: false);
        });
      }
    } catch (e) {
      print('Error loading initial messages: $e');
    }
  }

  Future<void> loadMoreMessages() async {
    if (!hasMoreMessages.value || isLoadingMore.value || lastDocument == null) {
      return;
    }

    isLoadingMore.value = true;

    try {
      final collectionName = getCollectionName();
      final query = FirebaseFirestore.instance
          .collection(collectionName)
          .doc(orderId.value)
          .collection('thread')
          .orderBy('createdAt', descending: true)
          .startAfterDocument(lastDocument!)
          .limit(pageSize);

      final snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        final newMessages =
            snapshot.docs
                .map(
                  (doc) => EnhancedMessage.fromConversation(
                    ConversationModel.fromJson(doc.data()),
                  ),
                )
                .toList()
                .reversed
                .toList();

        messages.insertAll(0, newMessages);
        lastDocument = snapshot.docs.last;
      } else {
        hasMoreMessages.value = false;
      }
    } catch (e) {
      print('Error loading more messages: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> sendMessage(
    String message,
    Url? url,
    String videoThumbnail,
    String messageType,
  ) async {
    if (message.trim().isEmpty && url == null) return;

    // Create optimistic message
    final tempId = const Uuid().v4();
    final optimisticMessage = ConversationModel(
      id: tempId,
      message: message,
      senderId: customerId.value,
      receiverId: restaurantId.value,
      createdAt: Timestamp.now(),
      url: url,
      orderId: orderId.value,
      messageType: messageType,
      videoThumbnail: videoThumbnail,
    );

    final enhancedMessage = EnhancedMessage(
      conversation: optimisticMessage,
      status: MessageStatus.sending,
    );

    // Add to UI immediately
    messages.add(enhancedMessage);
    pendingMessageIds.add(tempId);

    // Scroll to bottom
    scrollToBottom();

    try {
      // Create inbox entry
      final inboxModel = InboxModel(
        lastSenderId: customerId.value,
        customerId: customerId.value,
        customerName: customerName.value,
        restaurantId: restaurantId.value,
        restaurantName: restaurantName.value,
        createdAt: Timestamp.now(),
        orderId: orderId.value,
        customerProfileImage: customerProfileImage.value,
        restaurantProfileImage: restaurantProfileImage.value,
        lastMessage: message,
        chatType: chatType.value,
      );

      await _addToInbox(inboxModel);

      // Create conversation message
      final conversationModel = ConversationModel(
        id: const Uuid().v4(),
        message: message,
        senderId: customerId.value,
        receiverId: restaurantId.value,
        createdAt: Timestamp.now(),
        url: url,
        orderId: orderId.value,
        messageType: messageType,
        videoThumbnail: videoThumbnail,
      );

      // Set message text for media
      if (url != null) {
        if (url.mime.contains('image')) {
          conversationModel.message = "sent a photo".tr;
        } else if (url.mime.contains('video')) {
          conversationModel.message = "sent a video".tr;
        }
      }

      // Send to backend
      await _addToChat(conversationModel);

      // Update status to sent
      final index = messages.indexWhere((m) => m.conversation.id == tempId);
      if (index != -1) {
        messages[index].status = MessageStatus.sent;
        messages.refresh();
      }

      // Send notification
      await SendNotification.sendChatFcmMessage(
        customerName.value,
        conversationModel.message.toString(),
        token.value,
        {
          "type": "chat",
          "chatType": chatType.value,
          "orderId": orderId.value,
          "customerId": customerId.value,
          "customerName": customerName.value,
          "customerProfileImage": customerProfileImage.value,
          "restaurantId": restaurantId.value,
          "restaurantName": restaurantName.value,
          "restaurantProfileImage": restaurantProfileImage.value,
          "token": token.value,
        },
      );

      // Remove from pending
      pendingMessageIds.remove(tempId);
    } catch (e) {
      print('Error sending message: $e');

      // Mark as failed
      final index = messages.indexWhere((m) => m.conversation.id == tempId);
      if (index != -1) {
        messages[index].status = MessageStatus.failed;
        messages.refresh();
      }

      pendingMessageIds.remove(tempId);
    }
  }

  Future<void> retryMessage(String messageId) async {
    final index = messages.indexWhere((m) => m.conversation.id == messageId);
    if (index == -1 || messages[index].status != MessageStatus.failed) return;

    final message = messages[index];
    message.status = MessageStatus.sending;
    messages.refresh();

    try {
      // Retry sending logic
      final conversationModel = message.conversation;
      await _addToChat(conversationModel);

      message.status = MessageStatus.sent;
      messages.refresh();
    } catch (e) {
      message.status = MessageStatus.failed;
      messages.refresh();
    }
  }

  Future<void> _addToInbox(InboxModel inboxModel) async {
    if (chatType.value == "Driver") {
      await FireStoreUtils.addDriverInbox(inboxModel);
    } else if (chatType.value == "worker" || chatType.value == "Worker") {
      await FireStoreUtils.addWorkerInbox(inboxModel);
    } else if (chatType.value == "provider" || chatType.value == "Provider") {
      await FireStoreUtils.addProviderInbox(inboxModel);
    } else {
      await FireStoreUtils.addRestaurantInbox(inboxModel);
    }
  }

  Future<void> _addToChat(ConversationModel conversationModel) async {
    if (chatType.value == "Driver") {
      await FireStoreUtils.addDriverChat(conversationModel);
    } else if (chatType.value == "worker" || chatType.value == "Worker") {
      await FireStoreUtils.addWorkerChat(conversationModel);
    } else if (chatType.value == "provider" || chatType.value == "Provider") {
      await FireStoreUtils.addProviderChat(conversationModel);
    } else {
      await FireStoreUtils.addRestaurantChat(conversationModel);
    }
  }

  String getCollectionName() {
    if (chatType.value == "Driver") return 'chat_driver';
    if (chatType.value == "worker" || chatType.value == "Worker")
      return 'chat_worker';
    if (chatType.value == "provider" || chatType.value == "Provider")
      return 'chat_provider';
    return 'chat_store';
  }

  void scrollToBottom({bool animate = true}) {
    if (!scrollController.hasClients) return;

    if (animate) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  void onMessageTextChanged(String text) {
    // Handle typing indicator
    if (text.isNotEmpty && !isTyping.value) {
      isTyping.value = true;
      // Send typing indicator to backend if needed
    }

    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      isTyping.value = false;
      // Stop typing indicator
    });
  }

  bool get canSendMessage {
    return messageController.text.trim().isNotEmpty && !isLoading.value;
  }

  void clearMessageInput() {
    messageController.clear();
    isTyping.value = false;
    _typingTimer?.cancel();
  }
}
