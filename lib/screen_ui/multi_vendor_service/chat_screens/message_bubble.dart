import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/controllers/enhanced_chat_controller.dart';
import 'package:customer/models/conversation_model.dart';
import 'package:customer/utils/network_image_widget.dart';
import 'full_screen_image_viewer.dart';
import 'full_screen_video_viewer.dart';

class MessageBubble extends StatelessWidget {
  final EnhancedMessage message;
  final bool isMe;
  final bool isDark;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: isMe ? 64 : 16,
        right: isMe ? 16 : 64,
        top: 4,
        bottom: 4,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) _buildAvatar(),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    _buildMessageContent(context),
                    const SizedBox(height: 4),
                    _buildMessageFooter(),
                  ],
                ),
              ),
              if (isMe) const SizedBox(width: 8),
              if (isMe) _buildMessageStatus(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppThemeData.brandPrimaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.support_agent,
        size: 16,
        color: AppThemeData.brandPrimaryBlue,
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    final conversation = message.conversation;

    switch (conversation.messageType) {
      case 'text':
        return _buildTextMessage();
      case 'image':
        return _buildImageMessage(context);
      case 'video':
        return _buildVideoMessage(context);
      default:
        return _buildTextMessage();
    }
  }

  Widget _buildTextMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color:
            isMe
                ? AppThemeData.brandPrimaryBlue
                : isDark
                ? AppThemeData.grey700
                : AppThemeData.grey100,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft:
              isMe ? const Radius.circular(18) : const Radius.circular(4),
          bottomRight:
              isMe ? const Radius.circular(4) : const Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        message.conversation.message ?? '',
        style: TextStyle(
          fontFamily: AppThemeData.regular,
          fontSize: 16,
          color:
              isMe
                  ? Colors.white
                  : isDark
                  ? AppThemeData.grey50
                  : AppThemeData.grey900,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildImageMessage(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Get.to(
            FullScreenImageViewer(imageUrl: message.conversation.url!.url),
          ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 250, maxHeight: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft:
                isMe ? const Radius.circular(18) : const Radius.circular(4),
            bottomRight:
                isMe ? const Radius.circular(4) : const Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft:
                isMe ? const Radius.circular(18) : const Radius.circular(4),
            bottomRight:
                isMe ? const Radius.circular(4) : const Radius.circular(18),
          ),
          child: NetworkImageWidget(
            imageUrl: message.conversation.url!.url,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildVideoMessage(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Get.to(
            FullScreenVideoViewer(
              heroTag: message.conversation.id.toString(),
              videoUrl: message.conversation.url!.url,
            ),
          ),
      child: Container(
        width: 200,
        height: 120,
        decoration: BoxDecoration(
          color: isDark ? AppThemeData.grey700 : AppThemeData.grey200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft:
                isMe ? const Radius.circular(18) : const Radius.circular(4),
            bottomRight:
                isMe ? const Radius.circular(4) : const Radius.circular(18),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (message.conversation.videoThumbnail?.isNotEmpty ?? false)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft:
                      isMe
                          ? const Radius.circular(18)
                          : const Radius.circular(4),
                  bottomRight:
                      isMe
                          ? const Radius.circular(4)
                          : const Radius.circular(18),
                ),
                child: NetworkImageWidget(
                  imageUrl: message.conversation.videoThumbnail!,
                  fit: BoxFit.cover,
                  width: 200,
                  height: 120,
                ),
              ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft:
                      isMe
                          ? const Radius.circular(18)
                          : const Radius.circular(4),
                  bottomRight:
                      isMe
                          ? const Radius.circular(4)
                          : const Radius.circular(18),
                ),
              ),
            ),
            const Icon(Icons.play_circle_fill, color: Colors.white, size: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageFooter() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatTime(message.conversation.createdAt),
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppThemeData.grey400 : AppThemeData.grey600,
            fontFamily: AppThemeData.regular,
          ),
        ),
        if (message.status == MessageStatus.failed) ...[
          const SizedBox(width: 4),
          GestureDetector(
            onTap:
                () => Get.find<EnhancedChatController>().retryMessage(
                  message.conversation.id!,
                ),
            child: Icon(Icons.refresh, size: 14, color: AppThemeData.danger300),
          ),
        ],
      ],
    );
  }

  Widget _buildMessageStatus() {
    if (message.status == MessageStatus.failed) {
      return Icon(Icons.error, size: 16, color: AppThemeData.danger300);
    }

    if (message.status == MessageStatus.sending) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            AppThemeData.brandPrimaryBlue,
          ),
        ),
      );
    }

    return Icon(
      message.status == MessageStatus.delivered ||
              message.status == MessageStatus.read
          ? Icons.done_all
          : Icons.done,
      size: 16,
      color:
          message.status == MessageStatus.read
              ? AppThemeData.brandPrimaryBlue
              : AppThemeData.grey500,
    );
  }

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';

    final dateTime = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(dateTime);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(dateTime);
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }
}
