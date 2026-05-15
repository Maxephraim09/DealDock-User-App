import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/controllers/enhanced_chat_controller.dart';

class MessageInput extends StatefulWidget {
  final bool isDark;

  const MessageInput({super.key, required this.isDark});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetX<EnhancedChatController>(
      builder: (controller) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isDark ? AppThemeData.grey800 : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color:
                    widget.isDark
                        ? Colors.black.withOpacity(0.2)
                        : AppThemeData.grey200,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Typing indicator
              Obx(() {
                if (controller.typingIndicator.isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          widget.isDark
                              ? AppThemeData.grey700
                              : AppThemeData.grey100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      controller.typingIndicator.value,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            widget.isDark
                                ? AppThemeData.grey300
                                : AppThemeData.grey600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              // Input row
              Row(
                children: [
                  // Attachment button
                  GestureDetector(
                    onTap: () => _showAttachmentOptions(context, controller),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppThemeData.brandPrimaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.attach_file,
                        color: AppThemeData.brandPrimaryBlue,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Text input
                  Expanded(
                    child: TextField(
                      focusNode: _focusNode,
                      controller: controller.messageController,
                      textInputAction: TextInputAction.send,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Type a message...'.tr,
                        hintStyle: TextStyle(
                          color: AppThemeData.grey500,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                      onChanged: (text) {
                        controller.onMessageTextChanged(text);
                      },
                      onSubmitted: (value) {
                        if (controller.canSendMessage) {
                          _sendMessage(controller);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Send button
                  Obx(() {
                    final canSend = controller.canSendMessage;
                    return GestureDetector(
                      onTap: canSend ? () => _sendMessage(controller) : null,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              canSend
                                  ? AppThemeData.brandPrimaryBlue
                                  : AppThemeData.grey400,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.send, color: Colors.white, size: 20),
                      ),
                    );
                  }),
                ],
              ),

              // Pending messages indicator
              Obx(() {
                if (controller.pendingMessageIds.isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppThemeData.info50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppThemeData.info200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppThemeData.info300,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Sending ${controller.pendingMessageIds.length} message${controller.pendingMessageIds.length > 1 ? 's' : ''}...',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppThemeData.info600,
                            fontFamily: AppThemeData.medium,
                          ),
                        ),
                      ],
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

  void _sendMessage(EnhancedChatController controller) {
    final message = controller.messageController.text.trim();
    if (message.isEmpty) return;

    controller.sendMessage(message, null, '', 'text');
    controller.clearMessageInput();
  }

  void _showAttachmentOptions(
    BuildContext context,
    EnhancedChatController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.isDark ? AppThemeData.grey800 : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Send Media'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: AppThemeData.medium,
                    color:
                        widget.isDark
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAttachmentOption(
                      icon: Icons.image,
                      label: 'Photo'.tr,
                      onTap: () => _pickImage(context, controller, 'gallery'),
                    ),
                    _buildAttachmentOption(
                      icon: Icons.camera_alt,
                      label: 'Camera'.tr,
                      onTap: () => _pickImage(context, controller, 'camera'),
                    ),
                    _buildAttachmentOption(
                      icon: Icons.videocam,
                      label: 'Video'.tr,
                      onTap: () => _pickVideo(context, controller),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        Get.back();
        onTap();
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppThemeData.brandPrimaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppThemeData.brandPrimaryBlue, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color:
                  widget.isDark ? AppThemeData.grey300 : AppThemeData.grey700,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(
    BuildContext context,
    EnhancedChatController controller,
    String source,
  ) async {
    try {
      // Implementation for picking image
      // This would integrate with the existing image picker logic
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to pick image'.tr,
        backgroundColor: AppThemeData.danger300,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _pickVideo(
    BuildContext context,
    EnhancedChatController controller,
  ) async {
    try {
      // Implementation for picking video
      // This would integrate with the existing video picker logic
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to pick video'.tr,
        backgroundColor: AppThemeData.danger300,
        colorText: Colors.white,
      );
    }
  }
}
