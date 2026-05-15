import 'package:customer/controllers/theme_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../multi_vendor_service/chat_screens/chat_board_screen.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I reset my password?',
      'answer':
          'To reset your password, go to the login screen and tap "Forgot Password". Enter your email address and follow the instructions sent to your email.',
      'category': 'Account',
    },
    {
      'question': 'How do I add a payment method?',
      'answer':
          'Navigate to Profile > Payment Methods > Add New Payment Method. You can add credit/debit cards, bank accounts, or digital wallets.',
      'category': 'Payments',
    },
    {
      'question': 'Why was my transaction declined?',
      'answer':
          'Transactions can be declined due to insufficient funds, incorrect card details, expired cards, or security restrictions. Please check your payment method and try again.',
      'category': 'Payments',
    },
    {
      'question': 'How do I track my orders?',
      'answer':
          'Go to the Orders section in your profile or home screen. You can view all your past and current orders with real-time tracking information.',
      'category': 'Orders',
    },
    {
      'question': 'How do I contact customer support?',
      'answer':
          'You can contact support through the app by going to Profile > Support, or call our helpline at 0800-123-4567.',
      'category': 'Support',
    },
    {
      'question': 'How do I enable biometric login?',
      'answer':
          'Go to Profile > Security Settings > Biometric Authentication. Make sure your device has fingerprint/face recognition enabled in system settings.',
      'category': 'Security',
    },
    {
      'question': 'What are the delivery charges?',
      'answer':
          'Delivery charges vary based on distance and order value. Orders above ₦5,000 qualify for free delivery. You can see exact charges during checkout.',
      'category': 'Delivery',
    },
    {
      'question': 'How do I cancel an order?',
      'answer':
          'Orders can be cancelled within 5 minutes of placement. Go to your active orders and tap "Cancel Order". Refunds will be processed within 3-5 business days.',
      'category': 'Orders',
    },
    {
      'question': 'How do I update my profile information?',
      'answer':
          'Go to Profile > Edit Profile. You can update your name, phone number, email, and delivery addresses.',
      'category': 'Account',
    },
    {
      'question': 'What payment methods do you accept?',
      'answer':
          'We accept credit/debit cards (Visa, Mastercard), bank transfers, digital wallets (OPay, Flutterwave), and cash on delivery.',
      'category': 'Payments',
    },
  ];

  String _selectedCategory = 'All';
  String _searchText = '';
  final List<String> _categories = [
    'All',
    'Account',
    'Payments',
    'Orders',
    'Security',
    'Delivery',
    'Support',
  ];

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

    final filteredFAQs =
        _faqs.where((faq) {
          final matchesCategory =
              _selectedCategory == 'All' ||
              faq['category'] == _selectedCategory;
          final matchesSearch =
              _searchText.isEmpty ||
              faq['question'].toLowerCase().contains(
                _searchText.toLowerCase(),
              ) ||
              faq['answer'].toLowerCase().contains(_searchText.toLowerCase()) ||
              faq['category'].toLowerCase().contains(_searchText.toLowerCase());
          return matchesCategory && matchesSearch;
        }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeData.brandPrimaryBlue,
        title: const Text('Frequently Asked Questions'),
        elevation: 0,
      ),
      backgroundColor: isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppThemeData.brandPrimaryBlue,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search FAQs...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white.withOpacity(0.7),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),

          // Category Filter
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;

                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor:
                        isDark
                            ? AppThemeData.surfaceDarkCard
                            : Colors.grey.shade100,
                    selectedColor: AppThemeData.brandPrimaryBlue,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color:
                          isSelected
                              ? Colors.white
                              : (isDark
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          // FAQ List
          Expanded(
            child:
                filteredFAQs.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color:
                                isDark
                                    ? AppThemeData.grey600
                                    : AppThemeData.grey400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No FAQs found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color:
                                  isDark
                                      ? AppThemeData.grey400
                                      : AppThemeData.grey600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your search or category filter',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  isDark
                                      ? AppThemeData.grey500
                                      : AppThemeData.grey500,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredFAQs.length,
                      itemBuilder: (context, index) {
                        final faq = filteredFAQs[index];
                        return _buildFAQItem(faq, isDark);
                      },
                    ),
          ),

          // Contact Support
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppThemeData.surfaceDarkCard : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppThemeData.grey700 : AppThemeData.grey200,
                ),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Still need help?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Our support team is here to help you 24/7',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppThemeData.grey300 : AppThemeData.grey600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.to(() => ChatBoardScreen());
                        },
                        icon: const Icon(Icons.chat),
                        label: const Text('Chat Support'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppThemeData.brandPrimaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final Uri phoneUri = Uri(
                            scheme: 'tel',
                            path: '08012345678',
                          );
                          if (await canLaunchUrl(phoneUri)) {
                            await launchUrl(phoneUri);
                          } else {
                            Get.snackbar(
                              'Error',
                              'Could not launch phone call',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                        icon: const Icon(Icons.call),
                        label: const Text('Call Us'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppThemeData.brandPrimaryBlue,
                          side: const BorderSide(
                            color: AppThemeData.brandPrimaryBlue,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(Map<String, dynamic> faq, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppThemeData.surfaceDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppThemeData.grey700 : AppThemeData.grey200,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          faq['question'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
          ),
        ),
        subtitle: Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppThemeData.brandPrimaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            faq['category'],
            style: TextStyle(
              fontSize: 10,
              color: AppThemeData.brandPrimaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              faq['answer'],
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppThemeData.grey300 : AppThemeData.grey700,
                height: 1.5,
              ),
            ),
          ),
        ],
        iconColor: AppThemeData.brandPrimaryBlue,
        collapsedIconColor: AppThemeData.brandPrimaryBlue,
      ),
    );
  }
}
