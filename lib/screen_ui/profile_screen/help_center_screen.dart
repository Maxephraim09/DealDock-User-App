import 'package:customer/controllers/theme_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final List<Map<String, dynamic>> _helpTopics = [
    {
      'title': 'Getting Started',
      'description': 'Learn the basics of using our app',
      'icon': Icons.play_circle_outline,
      'articles': [
        {'title': 'How to create an account', 'readTime': '2 min'},
        {'title': 'Setting up your profile', 'readTime': '3 min'},
        {'title': 'First time ordering guide', 'readTime': '5 min'},
      ],
    },
    {
      'title': 'Account & Security',
      'description': 'Manage your account and security settings',
      'icon': Icons.security,
      'articles': [
        {'title': 'Changing your password', 'readTime': '2 min'},
        {'title': 'Enabling biometric login', 'readTime': '3 min'},
        {'title': 'Managing payment methods', 'readTime': '4 min'},
        {'title': 'Account verification process', 'readTime': '3 min'},
      ],
    },
    {
      'title': 'Orders & Delivery',
      'description': 'Everything about ordering and delivery',
      'icon': Icons.local_shipping,
      'articles': [
        {'title': 'How to place an order', 'readTime': '4 min'},
        {'title': 'Tracking your delivery', 'readTime': '2 min'},
        {'title': 'Order cancellation policy', 'readTime': '3 min'},
        {'title': 'Delivery time estimates', 'readTime': '2 min'},
      ],
    },
    {
      'title': 'Payments & Billing',
      'description': 'Payment methods and billing information',
      'icon': Icons.payment,
      'articles': [
        {'title': 'Accepted payment methods', 'readTime': '2 min'},
        {'title': 'Understanding your bill', 'readTime': '3 min'},
        {'title': 'Refund policy', 'readTime': '4 min'},
        {'title': 'Failed payment troubleshooting', 'readTime': '3 min'},
      ],
    },
    {
      'title': 'Troubleshooting',
      'description': 'Common issues and how to fix them',
      'icon': Icons.build,
      'articles': [
        {'title': 'App not loading properly', 'readTime': '3 min'},
        {'title': 'Login problems', 'readTime': '2 min'},
        {'title': 'Payment errors', 'readTime': '4 min'},
        {'title': 'Location services issues', 'readTime': '3 min'},
      ],
    },
  ];

  final List<Map<String, dynamic>> _quickActions = [
    {
      'title': 'Contact Support',
      'subtitle': 'Get help from our team',
      'icon': Icons.headset_mic,
      'action': 'support',
    },
    {
      'title': 'Live Chat',
      'subtitle': 'Chat with a representative',
      'icon': Icons.chat,
      'action': 'chat',
    },
    {
      'title': 'Call Us',
      'subtitle': 'Speak to our support team',
      'icon': Icons.call,
      'action': 'call',
    },
    {
      'title': 'Video Tutorials',
      'subtitle': 'Watch step-by-step guides',
      'icon': Icons.video_library,
      'action': 'videos',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeData.brandPrimaryBlue,
        title: const Text('Help Center'),
        elevation: 0,
      ),
      backgroundColor: isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppThemeData.brandPrimaryBlue,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How can we help you?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find answers to common questions or get in touch with our support team.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Quick Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.2,
                        ),
                    itemCount: _quickActions.length,
                    itemBuilder: (context, index) {
                      final action = _quickActions[index];
                      return _buildQuickActionCard(action, isDark);
                    },
                  ),
                ],
              ),
            ),

            // Help Topics
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Browse Help Topics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                ),
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: _helpTopics.length,
              itemBuilder: (context, index) {
                final topic = _helpTopics[index];
                return _buildHelpTopicCard(topic, isDark);
              },
            ),

            // Popular Articles
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Popular Articles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPopularArticle(
                    'How to reset your password',
                    'Learn how to securely reset your account password',
                    '5 min read',
                    isDark,
                  ),
                  const SizedBox(height: 8),
                  _buildPopularArticle(
                    'Understanding delivery fees',
                    'Everything you need to know about delivery charges',
                    '3 min read',
                    isDark,
                  ),
                  const SizedBox(height: 8),
                  _buildPopularArticle(
                    'Payment methods guide',
                    'Explore all available payment options',
                    '4 min read',
                    isDark,
                  ),
                ],
              ),
            ),

            // Contact Information
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppThemeData.surfaceDarkCard : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppThemeData.grey700 : AppThemeData.grey200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Still need help?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildContactInfo(
                    'Customer Support',
                    '0800-123-4567',
                    'Mon-Fri 8AM-8PM',
                    Icons.phone,
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildContactInfo(
                    'Email Support',
                    'support@opay.ng',
                    '24/7 response within 2 hours',
                    Icons.email,
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildContactInfo(
                    'Live Chat',
                    'Available 24/7',
                    'Average response time: 2 minutes',
                    Icons.chat_bubble,
                    isDark,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(Map<String, dynamic> action, bool isDark) {
    return GestureDetector(
      onTap: () => _handleQuickAction(action['action']),
      child: Container(
        padding: const EdgeInsets.all(16),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              action['icon'],
              size: 32,
              color: AppThemeData.brandPrimaryBlue,
            ),
            const SizedBox(height: 8),
            Text(
              action['title'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              action['subtitle'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppThemeData.grey400 : AppThemeData.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpTopicCard(Map<String, dynamic> topic, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppThemeData.surfaceDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppThemeData.grey700 : AppThemeData.grey200,
        ),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppThemeData.brandPrimaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(topic['icon'], color: AppThemeData.brandPrimaryBlue),
        ),
        title: Text(
          topic['title'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
          ),
        ),
        subtitle: Text(
          topic['description'],
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppThemeData.grey400 : AppThemeData.grey600,
          ),
        ),
        children: [
          ...topic['articles'].map<Widget>((article) {
            return ListTile(
              title: Text(
                article['title'],
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                ),
              ),
              trailing: Text(
                article['readTime'],
                style: TextStyle(
                  fontSize: 12,
                  color: AppThemeData.brandPrimaryBlue,
                ),
              ),
              onTap: () {
                // TODO: Navigate to article
                Get.snackbar(
                  'Article',
                  'Opening: ${article['title']}',
                  backgroundColor: AppThemeData.brandPrimaryBlue,
                  colorText: Colors.white,
                );
              },
            );
          }),
        ],
        iconColor: AppThemeData.brandPrimaryBlue,
        collapsedIconColor: AppThemeData.brandPrimaryBlue,
      ),
    );
  }

  Widget _buildPopularArticle(
    String title,
    String description,
    String readTime,
    bool isDark,
  ) {
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
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppThemeData.grey400 : AppThemeData.grey600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            readTime,
            style: TextStyle(
              fontSize: 12,
              color: AppThemeData.brandPrimaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(
    String title,
    String value,
    String subtitle,
    IconData icon,
    bool isDark,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppThemeData.brandPrimaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppThemeData.brandPrimaryBlue, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                ),
              ),
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
                  color: isDark ? AppThemeData.grey400 : AppThemeData.grey600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleQuickAction(String action) {
    switch (action) {
      case 'support':
        // TODO: Navigate to support screen
        Get.snackbar(
          'Support',
          'Opening support chat...',
          backgroundColor: AppThemeData.brandPrimaryBlue,
          colorText: Colors.white,
        );
        break;
      case 'chat':
        // TODO: Open live chat
        Get.snackbar(
          'Live Chat',
          'Connecting to live chat...',
          backgroundColor: AppThemeData.brandPrimaryBlue,
          colorText: Colors.white,
        );
        break;
      case 'call':
        _launchPhoneCall();
        break;
      case 'videos':
        // TODO: Navigate to video tutorials
        Get.snackbar(
          'Video Tutorials',
          'Opening video library...',
          backgroundColor: AppThemeData.brandPrimaryBlue,
          colorText: Colors.white,
        );
        break;
    }
  }

  void _launchPhoneCall() async {
    const phoneNumber = 'tel:08001234567';
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      Get.snackbar(
        'Error',
        'Could not launch phone call',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
