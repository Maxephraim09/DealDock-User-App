import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/chat_controller.dart';
import 'package:customer/models/conversation_model.dart';
import 'package:customer/themes/app_them_data.dart';
import '../../../controllers/theme_controller.dart';
import 'package:customer/utils/network_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../service/fire_store_utils.dart';
import '../../../widget/firebase_pagination/src/fireStore_pagination.dart';
import '../../../widget/firebase_pagination/src/models/view_type.dart';
import 'ChatVideoContainer.dart';
import 'full_screen_image_viewer.dart';
import 'full_screen_video_viewer.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;
    return GetX(
      init: ChatController(),
      builder: (controller) {
        final hasConversation = controller.orderId.value.isNotEmpty;
        final title =
            controller.restaurantName.value.isNotEmpty
                ? controller.restaurantName.value
                : 'Support Chat'.tr;
        final subtitle =
            controller.restaurantName.value.isNotEmpty
                ? 'Chat with support'.tr
                : 'Ask us anything, we are here to help'.tr;

        return Scaffold(
          backgroundColor: isDark ? AppThemeData.grey900 : AppThemeData.grey50,
          appBar: AppBar(
            backgroundColor: AppThemeData.brandPrimaryBlue,
            centerTitle: false,
            titleSpacing: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppThemeData.medium,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.support_agent, color: Colors.white),
                tooltip: 'Support info'.tr,
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                color: isDark ? AppThemeData.grey900 : AppThemeData.grey50,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? AppThemeData.grey800
                            : AppThemeData.brandPrimaryBlue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          isDark
                              ? AppThemeData.grey700
                              : AppThemeData.brandPrimaryBlue.withOpacity(0.12),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppThemeData.brandPrimaryBlue,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fast support for orders, payments & service'.tr,
                              style: TextStyle(
                                fontFamily: AppThemeData.medium,
                                fontSize: 15,
                                color:
                                    isDark
                                        ? AppThemeData.grey50
                                        : AppThemeData.grey900,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Use quick actions to start your chat faster.'.tr,
                              style: TextStyle(
                                fontSize: 13,
                                color:
                                    isDark
                                        ? AppThemeData.grey400
                                        : AppThemeData.grey700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildQuickActions(controller, isDark),
              const SizedBox(height: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark ? AppThemeData.grey900 : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color:
                              isDark
                                  ? Colors.black.withOpacity(0.3)
                                  : AppThemeData.grey200,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child:
                          hasConversation
                              ? FirestorePagination(
                                controller: controller.scrollController,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (
                                  context,
                                  documentSnapshots,
                                  index,
                                ) {
                                  ConversationModel inboxModel =
                                      ConversationModel.fromJson(
                                        documentSnapshots[index].data()
                                            as Map<String, dynamic>,
                                      );
                                  return chatItemView(
                                    isDark,
                                    inboxModel.senderId ==
                                        FireStoreUtils.getCurrentUid(),
                                    inboxModel,
                                  );
                                },
                                onEmpty: Constant.showEmptyView(
                                  message: "No conversations found".tr,
                                ),
                                query: FirebaseFirestore.instance
                                    .collection(
                                      controller.chatType.value == "Driver"
                                          ? 'chat_driver'
                                          : controller.chatType.value ==
                                                  "Provider" ||
                                              controller.chatType.value ==
                                                  "provider"
                                          ? 'chat_provider'
                                          : controller.chatType.value ==
                                                  "worker" ||
                                              controller.chatType.value ==
                                                  "Worker"
                                          ? 'chat_worker'
                                          : 'chat_store',
                                    )
                                    .doc(controller.orderId.value)
                                    .collection("thread")
                                    .orderBy('createdAt', descending: false),
                                isLive: true,
                                viewType: ViewType.list,
                              )
                              : Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: Text(
                                    'No active support thread found yet. Start by selecting a quick action or ask your question below.'
                                        .tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          isDark
                                              ? AppThemeData.grey400
                                              : AppThemeData.grey700,
                                    ),
                                  ),
                                ),
                              ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildMessageInput(context, controller, isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(ChatController controller, bool isDark) {
    final actions = [
      {'label': 'Order status', 'message': 'Where is my order?'.tr},
      {'label': 'Payment issue', 'message': 'I need help with payment.'.tr},
      {
        'label': 'Change address',
        'message': 'I want to update my delivery address.'.tr,
      },
    ];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final action = actions[index];
          return GestureDetector(
            onTap: () {
              controller.messageController.value.text =
                  action['message'] as String;
              controller.sendMessage(
                action['message'] as String,
                null,
                '',
                'text',
              );
              controller.messageController.value.clear();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? AppThemeData.grey800
                        : AppThemeData.brandPrimaryBlue.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isDark
                          ? AppThemeData.grey700
                          : AppThemeData.brandPrimaryBlue.withOpacity(0.24),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.flash_on,
                    size: 16,
                    color: AppThemeData.brandPrimaryBlue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    action['label'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: AppThemeData.medium,
                      color:
                          isDark
                              ? AppThemeData.grey50
                              : AppThemeData.brandPrimaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemCount: actions.length,
      ),
    );
  }

  Widget _buildMessageInput(
    BuildContext context,
    ChatController controller,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppThemeData.grey800 : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color:
                isDark ? Colors.black.withOpacity(0.2) : AppThemeData.grey200,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onCameraClick(context, controller),
            child: Container(
              decoration: BoxDecoration(
                color: AppThemeData.brandPrimaryBlue.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                "assets/icons/ic_picture_one.svg",
                color: AppThemeData.brandPrimaryBlue,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              controller: controller.messageController.value,
              decoration: InputDecoration(
                hintText: 'Type message here...'.tr,
                hintStyle: TextStyle(color: AppThemeData.grey500),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onSubmitted: (value) {
                if (controller.messageController.value.text.isNotEmpty) {
                  controller.sendMessage(
                    controller.messageController.value.text,
                    null,
                    '',
                    'text',
                  );
                  controller.messageController.value.clear();
                }
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              if (controller.messageController.value.text.isNotEmpty) {
                controller.sendMessage(
                  controller.messageController.value.text,
                  null,
                  '',
                  'text',
                );
                controller.messageController.value.clear();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppThemeData.brandPrimaryBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(14),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget chatItemView(isDark, bool isMe, ConversationModel data) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child:
          isMe
              ? Align(
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    data.messageType == "text"
                        ? Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            color: AppThemeData.primary300,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Text(
                            data.message.toString(),
                            style: const TextStyle(
                              fontFamily: AppThemeData.medium,
                              fontSize: 16,
                              color: AppThemeData.grey50,
                            ),
                          ),
                        )
                        : data.messageType == "image"
                        ? ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(
                                    FullScreenImageViewer(
                                      imageUrl: data.url!.url,
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: data.url!.url,
                                  child: NetworkImageWidget(
                                    imageUrl: data.url!.url,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        : FloatingActionButton(
                          mini: true,
                          heroTag: data.id,
                          backgroundColor: AppThemeData.primary300,
                          onPressed: () {
                            Get.to(
                              FullScreenVideoViewer(
                                heroTag: data.id.toString(),
                                videoUrl: data.url!.url,
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                    const SizedBox(height: 5),
                    Text(
                      DateFormat('MMM d, yyyy hh:mm aa').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          data.createdAt!.millisecondsSinceEpoch,
                        ),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  data.messageType == "text"
                      ? Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          color:
                              isDark
                                  ? AppThemeData.grey700
                                  : AppThemeData.grey200,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Text(
                          data.message.toString(),
                          style: TextStyle(
                            fontFamily: AppThemeData.medium,
                            fontSize: 16,
                            color:
                                isDark
                                    ? AppThemeData.grey100
                                    : AppThemeData.grey800,
                          ),
                        ),
                      )
                      : data.messageType == "image"
                      ? ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 50,
                          maxWidth: 200,
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(
                                    FullScreenImageViewer(
                                      imageUrl: data.url!.url,
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: data.url!.url,
                                  child: NetworkImageWidget(
                                    imageUrl: data.url!.url,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : FloatingActionButton(
                        mini: true,
                        heroTag: data.id,
                        backgroundColor: AppThemeData.primary300,
                        onPressed: () {
                          Get.to(
                            FullScreenVideoViewer(
                              heroTag: data.id.toString(),
                              videoUrl: data.url!.url,
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat('MMM d, yyyy hh:mm aa').format(
                      DateTime.fromMillisecondsSinceEpoch(
                        data.createdAt!.millisecondsSinceEpoch,
                      ),
                    ),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
    );
  }

  void onCameraClick(BuildContext context, ChatController controller) {
    final action = CupertinoActionSheet(
      message: Text('Send Media'.tr, style: const TextStyle(fontSize: 15.0)),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: false,
          onPressed: () async {
            Get.back();
            XFile? image = await controller.imagePicker.pickImage(
              source: ImageSource.gallery,
            );
            if (image != null) {
              Url url = await FireStoreUtils.uploadChatImageToFireStorage(
                File(image.path),
                context,
              );
              controller.sendMessage('', url, '', 'image');
            }
          },
          child: Text("Choose image from gallery".tr),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: false,
          onPressed: () async {
            Get.back();
            XFile? galleryVideo = await controller.imagePicker.pickVideo(
              source: ImageSource.gallery,
            );
            if (galleryVideo != null) {
              ChatVideoContainer? videoContainer =
                  await FireStoreUtils.uploadChatVideoToFireStorage(
                    context,
                    File(galleryVideo.path),
                  );
              if (videoContainer != null) {
                controller.sendMessage(
                  '',
                  videoContainer.videoUrl,
                  videoContainer.thumbnailUrl,
                  'video',
                );
              }
            }
          },
          child: Text("Choose video from gallery".tr),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: false,
          onPressed: () async {
            Get.back();
            XFile? image = await controller.imagePicker.pickImage(
              source: ImageSource.camera,
            );
            if (image != null) {
              Url url = await FireStoreUtils.uploadChatImageToFireStorage(
                File(image.path),
                context,
              );
              controller.sendMessage('', url, '', 'image');
            }
          },
          child: Text("Take a picture".tr),
        ),
        // CupertinoActionSheetAction(
        //   isDestructiveAction: false,
        //   onPressed: () async {
        //     Get.back();
        //     XFile? recordedVideo = await controller.imagePicker.pickVideo(source: ImageSource.camera);
        //     if (recordedVideo != null) {
        //       ChatVideoContainer videoContainer = await FireStoreUtils.uploadChatVideoToFireStorage(File(recordedVideo.path), context);
        //       controller.sendMessage('', videoContainer.videoUrl, videoContainer.thumbnailUrl, 'video');
        //     }
        //   },
        //   child: Text("Record video".tr),
        // )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancel'.tr),
        onPressed: () {
          Get.back();
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }
}
