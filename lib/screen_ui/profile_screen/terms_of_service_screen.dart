import 'package:customer/controllers/theme_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeData.brandPrimaryBlue,
        title: const Text('Terms of Service'),
        elevation: 0,
      ),
      backgroundColor: isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppThemeData.brandPrimaryBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terms of Service',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last updated: January 15, 2024',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Acceptance of Terms
            _buildSection(
              'Acceptance of Terms',
              'By accessing and using the OPay mobile application ("App") and our services, you accept and agree to be bound by the terms and provision of this agreement.',
              isDark,
            ),

            // Description of Service
            _buildSection(
              'Description of Service',
              'OPay provides digital payment and financial services including but not limited to:\n\n• Mobile money transfers\n• Bill payments\n• Airtime and data purchases\n• Merchant payments\n• Wallet services\n• Financial management tools',
              isDark,
            ),

            // User Accounts
            _buildSection(
              'User Accounts',
              'To use our services, you must:\n\n• Be at least 18 years old\n• Provide accurate and complete information\n• Maintain the security of your account\n• Accept responsibility for all activities under your account\n• Notify us immediately of any unauthorized use',
              isDark,
            ),

            // Acceptable Use
            _buildSection(
              'Acceptable Use',
              'You agree to use our services only for lawful purposes. You shall not:\n\n• Violate any applicable laws or regulations\n• Infringe on intellectual property rights\n• Transmit harmful or malicious code\n• Attempt to gain unauthorized access\n• Use the service for fraudulent activities\n• Interfere with service operations',
              isDark,
            ),

            // Payment Terms
            _buildSection(
              'Payment Terms',
              '• All transactions are subject to available funds\n• We reserve the right to decline transactions\n• Fees may apply to certain services\n• Refunds are processed according to our policy\n• You are responsible for all charges incurred',
              isDark,
            ),

            // Privacy and Data Protection
            _buildSection(
              'Privacy and Data Protection',
              'Your privacy is important to us. Our collection and use of personal information is governed by our Privacy Policy, which is incorporated into these Terms by reference.',
              isDark,
            ),

            // Intellectual Property
            _buildSection(
              'Intellectual Property',
              'The App and its original content, features, and functionality are owned by OPay and are protected by international copyright, trademark, patent, trade secret, and other intellectual property laws.',
              isDark,
            ),

            // Disclaimers
            _buildSection(
              'Disclaimers',
              'The service is provided "as is" without warranties of any kind. We do not guarantee:\n\n• Uninterrupted service availability\n• Error-free operation\n• Security of your data\n• Compatibility with all devices\n• Suitability for your specific needs',
              isDark,
            ),

            // Limitation of Liability
            _buildSection(
              'Limitation of Liability',
              'In no event shall OPay be liable for any indirect, incidental, special, consequential, or punitive damages arising out of or relating to your use of the service.',
              isDark,
            ),

            // Termination
            _buildSection(
              'Termination',
              'We may terminate or suspend your account and access to the service immediately, without prior notice, for any reason including breach of these Terms.',
              isDark,
            ),

            // Governing Law
            _buildSection(
              'Governing Law',
              'These Terms shall be interpreted and governed by the laws of Nigeria. Any disputes shall be resolved in the competent courts of Lagos, Nigeria.',
              isDark,
            ),

            // Changes to Terms
            _buildSection(
              'Changes to Terms',
              'We reserve the right to modify these Terms at any time. We will notify users of material changes via the App or email. Continued use constitutes acceptance.',
              isDark,
            ),

            // Contact Information
            _buildSection(
              'Contact Information',
              'For questions about these Terms, please contact us:\n\nEmail: legal@opay.ng\nPhone: 0800-123-4567\nAddress: OPay Nigeria, Lagos, Nigeria',
              isDark,
            ),

            const SizedBox(height: 32),

            // Agreement Confirmation
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    isDark ? AppThemeData.surfaceDarkCard : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? AppThemeData.grey700 : AppThemeData.grey200,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppThemeData.brandPrimaryBlue,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'By continuing to use OPay services, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service.',
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          isDark ? AppThemeData.grey300 : AppThemeData.grey700,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppThemeData.grey300 : AppThemeData.grey700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
