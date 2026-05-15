import 'package:customer/controllers/theme_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeData.brandPrimaryBlue,
        title: const Text('About OPay'),
        elevation: 0,
      ),
      backgroundColor: isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppThemeData.brandPrimaryBlue,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: AppThemeData.brandPrimaryBlue,
                      size: 40,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'OPay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Your Trusted Digital Finance Partner',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Version 2.1.0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // About Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mission Section
                  _buildSectionCard(
                    'Our Mission',
                    'To democratize financial services and empower everyone with seamless, secure, and affordable digital payment solutions.',
                    Icons.flag,
                    isDark,
                  ),

                  const SizedBox(height: 16),

                  // What We Do
                  _buildSectionCard(
                    'What We Do',
                    'OPay is Nigeria\'s leading fintech company providing comprehensive digital financial services including mobile payments, money transfers, bill payments, and merchant solutions.',
                    Icons.business,
                    isDark,
                  ),

                  const SizedBox(height: 16),

                  // Our Values
                  _buildSectionCard(
                    'Our Values',
                    '• Innovation: Constantly evolving to meet customer needs\n• Security: Protecting your money and data with bank-level security\n• Accessibility: Making financial services available to everyone\n• Trust: Building lasting relationships through transparency',
                    Icons.star,
                    isDark,
                  ),

                  const SizedBox(height: 24),

                  // Stats Section
                  Text(
                    'By the Numbers',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          '50M+',
                          'Active Users',
                          Icons.people,
                          isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          '500K+',
                          'Merchants',
                          Icons.store,
                          isDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          '₦2T+',
                          'Transaction Volume',
                          Icons.trending_up,
                          isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          '99.9%',
                          'Uptime',
                          Icons.verified,
                          isDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Awards & Recognition
                  Text(
                    'Awards & Recognition',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildAwardCard(
                    '🏆 Fintech Company of the Year 2023',
                    'Nigerian Fintech Awards',
                    isDark,
                  ),

                  const SizedBox(height: 8),

                  _buildAwardCard(
                    '🥇 Best Digital Payment Solution',
                    'Africa Tech Excellence Awards',
                    isDark,
                  ),

                  const SizedBox(height: 8),

                  _buildAwardCard(
                    '⭐ Most Trusted Fintech Brand',
                    'Customer Choice Awards',
                    isDark,
                  ),

                  const SizedBox(height: 24),

                  // Contact Section
                  Text(
                    'Get in Touch',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildContactCard(
                    'Customer Support',
                    '0800-123-4567',
                    '24/7 Support',
                    Icons.support_agent,
                    isDark,
                    () => _launchPhoneCall(),
                  ),

                  const SizedBox(height: 8),

                  _buildContactCard(
                    'Email Us',
                    'support@opay.ng',
                    'We respond within 2 hours',
                    Icons.email,
                    isDark,
                    () => _launchEmail(),
                  ),

                  const SizedBox(height: 8),

                  _buildContactCard(
                    'Visit Website',
                    'www.opay.ng',
                    'Learn more about our services',
                    Icons.language,
                    isDark,
                    () => _launchWebsite(),
                  ),

                  const SizedBox(height: 24),

                  // Social Media
                  Text(
                    'Follow Us',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        'Facebook',
                        Icons.facebook,
                        () => _launchSocial('facebook'),
                      ),
                      const SizedBox(width: 16),
                      _buildSocialButton(
                        'Twitter',
                        Icons.alternate_email,
                        () => _launchSocial('twitter'),
                      ),
                      const SizedBox(width: 16),
                      _buildSocialButton(
                        'Instagram',
                        Icons.camera_alt,
                        () => _launchSocial('instagram'),
                      ),
                      const SizedBox(width: 16),
                      _buildSocialButton(
                        'LinkedIn',
                        Icons.business,
                        () => _launchSocial('linkedin'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Footer
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? AppThemeData.surfaceDarkCard
                              : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Made with ❤️ in Nigeria',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color:
                                isDark
                                    ? AppThemeData.grey50
                                    : AppThemeData.grey900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '© 2024 OPay. All rights reserved.',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                isDark
                                    ? AppThemeData.grey400
                                    : AppThemeData.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    String title,
    String content,
    IconData icon,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppThemeData.surfaceDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppThemeData.grey700 : AppThemeData.grey200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppThemeData.brandPrimaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppThemeData.brandPrimaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppThemeData.grey300 : AppThemeData.grey700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppThemeData.surfaceDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppThemeData.grey700 : AppThemeData.grey200,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppThemeData.brandPrimaryBlue, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppThemeData.grey400 : AppThemeData.grey600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAwardCard(String award, String organization, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppThemeData.surfaceDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppThemeData.grey700 : AppThemeData.grey200,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  award,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  organization,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppThemeData.grey400 : AppThemeData.grey600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.emoji_events, color: Colors.amber, size: 24),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    bool isDark,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppThemeData.surfaceDarkCard : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppThemeData.grey700 : AppThemeData.grey200,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppThemeData.brandPrimaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppThemeData.brandPrimaryBlue, size: 20),
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
                      fontWeight: FontWeight.w500,
                      color:
                          isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppThemeData.brandPrimaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          isDark ? AppThemeData.grey400 : AppThemeData.grey600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? AppThemeData.grey400 : AppThemeData.grey600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppThemeData.brandPrimaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppThemeData.brandPrimaryBlue, size: 24),
      ),
    );
  }

  void _launchPhoneCall() async {
    const phoneNumber = 'tel:08001234567';
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    }
  }

  void _launchEmail() async {
    const email = 'mailto:support@opay.ng';
    if (await canLaunch(email)) {
      await launch(email);
    }
  }

  void _launchWebsite() async {
    const url = 'https://www.opay.ng';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _launchSocial(String platform) async {
    final urls = {
      'facebook': 'https://www.facebook.com/opayng',
      'twitter': 'https://twitter.com/opay_ng',
      'instagram': 'https://www.instagram.com/opay_ng',
      'linkedin': 'https://www.linkedin.com/company/opay-ng',
    };

    final url = urls[platform];
    if (url != null && await canLaunch(url)) {
      await launch(url);
    }
  }
}
