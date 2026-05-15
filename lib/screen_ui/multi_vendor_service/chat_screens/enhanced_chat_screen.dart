import 'package:customer/themes/app_them_data.dart';
import '../../../controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/controllers/enhanced_chat_controller.dart';
import 'message_bubble.dart';
import 'message_input.dart';

class EnhancedChatScreen extends StatelessWidget {
  const EnhancedChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

    return GetX<EnhancedChatController>(
      init: EnhancedChatController(),
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
          body: Stack(
            children: [
              Column(
                children: [
                  // Header section
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
                                : AppThemeData.brandPrimaryBlue.withOpacity(
                                  0.05,
                                ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              isDark
                                  ? AppThemeData.grey700
                                  : AppThemeData.brandPrimaryBlue.withOpacity(
                                    0.12,
                                  ),
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
                                  'Fast support for orders, payments & service'
                                      .tr,
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
                                  'Use quick actions to start your chat faster.'
                                      .tr,
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

                  // Quick actions
                  _buildQuickActions(controller, isDark),

                  // Messages list
                  Expanded(
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
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
                                  ? _buildMessagesList(controller, isDark)
                                  : _buildEmptyState(isDark),
                        ),
                      ),
                    ),
                  ),

                  // Message input
                  MessageInput(isDark: isDark),
                ],
              ),

              // Scroll to bottom button
              Obx(() {
                if (controller.showScrollToBottom.value) {
                  return Positioned(
                    right: 24,
                    bottom: 100,
                    child: GestureDetector(
                      onTap: controller.scrollToBottom,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppThemeData.brandPrimaryBlue,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(EnhancedChatController controller, bool isDark) {
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
              controller.messageController.text = action['message'] as String;
              controller.sendMessage(
                action['message'] as String,
                null,
                '',
                'text',
              );
              controller.messageController.clear();
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

  Widget _buildMessagesList(EnhancedChatController controller, bool isDark) {
    return Obx(() {
      if (controller.isLoading.value && controller.messages.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.messages.isEmpty) {
        return _buildEmptyState(isDark);
      }

      return ListView.builder(
        controller: controller.scrollController,
        reverse: true,
        padding: const EdgeInsets.all(16),
        itemCount:
            controller.messages.length +
            (controller.isLoadingMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.messages.length &&
              controller.isLoadingMore.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final message = controller.messages[index];
          final isMe =
              message.conversation.senderId == controller.customerId.value;

          return MessageBubble(message: message, isMe: isMe, isDark: isDark);
        },
      );
    });
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: isDark ? AppThemeData.grey600 : AppThemeData.grey400,
            ),
            const SizedBox(height: 16),
            Text(
              'No messages yet'.tr,
              style: TextStyle(
                fontSize: 18,
                fontFamily: AppThemeData.medium,
                color: isDark ? AppThemeData.grey300 : AppThemeData.grey700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a conversation by using the quick actions above or typing a message below.'
                  .tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppThemeData.grey400 : AppThemeData.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
