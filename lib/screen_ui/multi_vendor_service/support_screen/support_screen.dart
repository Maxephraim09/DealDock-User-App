import 'package:customer/controllers/theme_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/show_toast_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../chat_screens/chat_board_screen.dart';
import '../../profile_screen/faq_screen.dart';
import '../../profile_screen/report_issue_screen.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ThemeController>(
      builder: (controller) {
        final isDark = controller.isDark.value;
        return Scaffold(
          backgroundColor:
              isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
          appBar: AppBar(
            backgroundColor:
                isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
              ),
              onPressed: () => Get.back(),
            ),
            title: Text(
              'Customer Support'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section with greeting
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF30588C),
                          const Color(0xFF2E608C).withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How can we help?'.tr,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'We are here to support you 24/7'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Support options grid
                  Text(
                    'Support Options'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Chat with support
                  _buildSupportCard(
                    isDark: isDark,
                    icon: Icons.chat_bubble_outline,
                    title: 'Chat with Support'.tr,
                    subtitle: 'Get instant help from our team'.tr,
                    onTap: () {
                      Get.to(() => ChatBoardScreen());
                    },
                  ),
                  const SizedBox(height: 12),

                  // FAQs
                  _buildSupportCard(
                    isDark: isDark,
                    icon: Icons.help_outline,
                    title: 'FAQs'.tr,
                    subtitle: 'Find answers to common questions'.tr,
                    onTap: () {
                      Get.to(() => const FAQScreen());
                    },
                  ),
                  const SizedBox(height: 12),

                  // Report issue
                  _buildSupportCard(
                    isDark: isDark,
                    icon: Icons.error_outline,
                    title: 'Report Issue'.tr,
                    subtitle: 'Tell us about any problems'.tr,
                    onTap: () {
                      Get.to(() => const ReportIssueScreen());
                    },
                  ),
                  const SizedBox(height: 12),

                  // Call support
                  _buildSupportCard(
                    isDark: isDark,
                    icon: Icons.phone_in_talk_outlined,
                    title: 'Call Support'.tr,
                    subtitle: 'Speak with our support team'.tr,
                    onTap: () {
                      _launchPhoneCall(context, '+1234567890');
                    },
                  ),
                  const SizedBox(height: 24),

                  // Contact info section
                  Text(
                    'Contact Information'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          isDark ? AppThemeData.grey900 : AppThemeData.grey50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isDark
                                ? AppThemeData.grey800
                                : AppThemeData.grey200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF30588C,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.email_outlined,
                            color: Color(0xFF30588C),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email'.tr,
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isDark
                                          ? AppThemeData.grey400
                                          : AppThemeData.grey500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'support@example.com',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isDark
                                          ? AppThemeData.grey50
                                          : AppThemeData.grey900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Phone
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          isDark ? AppThemeData.grey900 : AppThemeData.grey50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isDark
                                ? AppThemeData.grey800
                                : AppThemeData.grey200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF30588C,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.phone_outlined,
                            color: Color(0xFF30588C),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Phone'.tr,
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isDark
                                          ? AppThemeData.grey400
                                          : AppThemeData.grey500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '+1-800-123-4567',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isDark
                                          ? AppThemeData.grey50
                                          : AppThemeData.grey900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Hours
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          isDark ? AppThemeData.grey900 : AppThemeData.grey50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isDark
                                ? AppThemeData.grey800
                                : AppThemeData.grey200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF30588C,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.access_time_outlined,
                            color: Color(0xFF30588C),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hours'.tr,
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isDark
                                          ? AppThemeData.grey400
                                          : AppThemeData.grey500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '24/7 Available'.tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isDark
                                          ? AppThemeData.grey50
                                          : AppThemeData.grey900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSupportCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppThemeData.grey900 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppThemeData.grey800 : AppThemeData.grey200,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF30588C).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF30588C), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          isDark ? AppThemeData.grey400 : AppThemeData.grey500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDark ? AppThemeData.grey400 : AppThemeData.grey400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _launchPhoneCall(BuildContext context, String phoneNumber) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Call Support'.tr),
          content: Text(
            'Please call $phoneNumber for immediate assistance.'.tr,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'.tr),
            ),
          ],
        );
      },
    );
  }
}
