import 'package:customer/controllers/theme_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeData.brandPrimaryBlue,
        title: const Text('Privacy Policy'),
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
                    'Privacy Policy',
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

            // Introduction
            _buildSection(
              'Introduction',
              'This Privacy Policy describes how OPay ("we," "us," or "our") collects, uses, and shares your personal information when you use our mobile application and services.',
              isDark,
            ),

            // Information We Collect
            _buildSection(
              'Information We Collect',
              'We collect information you provide directly to us, such as when you create an account, make a transaction, or contact customer support. This includes:\n\n• Personal information (name, email, phone number)\n• Financial information (payment methods, transaction history)\n• Device information (IP address, device type, operating system)\n• Location data (with your permission)\n• Usage data (how you interact with our app)',
              isDark,
            ),

            // How We Use Your Information
            _buildSection(
              'How We Use Your Information',
              'We use the information we collect to:\n\n• Provide, maintain, and improve our services\n• Process transactions and send related information\n• Send you technical notices and support messages\n• Communicate with you about products, services, and promotions\n• Monitor and analyze trends and usage\n• Detect, investigate, and prevent fraudulent transactions',
              isDark,
            ),

            // Information Sharing
            _buildSection(
              'Information Sharing',
              'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this policy:\n\n• With service providers who assist our operations\n• To comply with legal obligations\n• To protect our rights and prevent fraud\n• In connection with a business transfer',
              isDark,
            ),

            // Data Security
            _buildSection(
              'Data Security',
              'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. This includes:\n\n• Encryption of sensitive data\n• Secure server infrastructure\n• Regular security assessments\n• Employee access controls',
              isDark,
            ),

            // Your Rights
            _buildSection(
              'Your Rights',
              'You have the following rights regarding your personal information:\n\n• Access: Request a copy of your personal data\n• Rectification: Correct inaccurate or incomplete data\n• Erasure: Request deletion of your data\n• Portability: Receive your data in a structured format\n• Restriction: Limit how we process your data\n• Objection: Object to certain data processing',
              isDark,
            ),

            // Cookies and Tracking
            _buildSection(
              'Cookies and Tracking Technologies',
              'We use cookies and similar technologies to enhance your experience, analyze usage, and assist in our marketing efforts. You can control cookie preferences through your device settings.',
              isDark,
            ),

            // International Data Transfers
            _buildSection(
              'International Data Transfers',
              'Your information may be transferred to and processed in countries other than your own. We ensure appropriate safeguards are in place to protect your data during such transfers.',
              isDark,
            ),

            // Children\'s Privacy
            _buildSection(
              'Children\'s Privacy',
              'Our services are not intended for children under 13. We do not knowingly collect personal information from children under 13. If we become aware of such collection, we will delete the information.',
              isDark,
            ),

            // Changes to This Policy
            _buildSection(
              'Changes to This Privacy Policy',
              'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy on this page and updating the "Last updated" date.',
              isDark,
            ),

            // Contact Us
            _buildSection(
              'Contact Us',
              'If you have any questions about this Privacy Policy, please contact us:\n\nEmail: privacy@opay.ng\nPhone: 0800-123-4567\nAddress: OPay Nigeria, Lagos, Nigeria',
              isDark,
            ),

            const SizedBox(height: 32),

            // Acceptance
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
              child: Text(
                'By using our app, you agree to the collection and use of information in accordance with this policy. If you do not agree, please do not use our services.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppThemeData.grey300 : AppThemeData.grey700,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
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
