import 'dart:convert';

import 'package:customer/controllers/theme_controller.dart';
import 'package:customer/screen_ui/profile_screen/add_payment_method_screen.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  static const String _paymentMethodsKey = 'payment_methods';

  final List<Map<String, dynamic>> _defaultPaymentMethods = [
    {
      'id': '1',
      'type': 'card',
      'name': '**** **** **** 1234',
      'brand': 'Visa',
      'isDefault': true,
      'expiry': '12/26',
    },
    {
      'id': '2',
      'type': 'bank',
      'name': 'GTBank - 0123456789',
      'brand': 'GTBank',
      'isDefault': false,
    },
    {
      'id': '3',
      'type': 'wallet',
      'name': 'OPay Wallet',
      'brand': 'OPay',
      'isDefault': false,
      'balance': '₦2,450.00',
    },
  ];

  List<Map<String, dynamic>> _paymentMethods = [];

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    final prefs = await SharedPreferences.getInstance();
    final storedJson = prefs.getString(_paymentMethodsKey);
    if (storedJson != null && storedJson.isNotEmpty) {
      final list = jsonDecode(storedJson) as List<dynamic>;
      setState(() {
        _paymentMethods =
            list
                .map(
                  (item) =>
                      Map<String, dynamic>.from(item as Map<String, dynamic>),
                )
                .toList();
      });
    } else {
      setState(() {
        _paymentMethods = List<Map<String, dynamic>>.from(
          _defaultPaymentMethods,
        );
      });
    }
  }

  Future<void> _savePaymentMethods() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_paymentMethodsKey, jsonEncode(_paymentMethods));
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeData.brandPrimaryBlue,
        title: const Text('Payment Methods'),
        elevation: 0,
      ),
      backgroundColor: isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
      body: Column(
        children: [
          // Header Section
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
                  'Manage Your Payment Methods',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add, remove, or set default payment methods for quick and secure transactions.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Payment Methods List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                final method = _paymentMethods[index];
                return _buildPaymentMethodCard(method, isDark);
              },
            ),
          ),

          // Add New Method Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: RoundedButtonFill(
              title: 'Add New Payment Method',
              width: double.infinity,
              height: 6,
              color: AppThemeData.brandPrimaryBlue,
              textColor: Colors.white,
              onPress: () async {
                final added = await Get.to<bool?>(
                  () => const AddPaymentMethodScreen(),
                );
                if (added == true) {
                  await _loadPaymentMethods();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method, bool isDark) {
    IconData getIcon() {
      switch (method['type']) {
        case 'card':
          return Icons.credit_card;
        case 'bank':
          return Icons.account_balance;
        case 'wallet':
          return Icons.account_balance_wallet;
        default:
          return Icons.payment;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppThemeData.surfaceDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              method['isDefault']
                  ? AppThemeData.brandPrimaryBlue
                  : (isDark ? AppThemeData.grey700 : AppThemeData.grey200),
          width: method['isDefault'] ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppThemeData.brandPrimaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              getIcon(),
              color: AppThemeData.brandPrimaryBlue,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      method['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                            isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                      ),
                    ),
                    if (method['isDefault']) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppThemeData.brandPrimaryBlue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Default',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  method['brand'],
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppThemeData.grey300 : AppThemeData.grey600,
                  ),
                ),
                if (method['balance'] != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Balance: ${method['balance']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppThemeData.brandPrimaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (method['expiry'] != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Expires: ${method['expiry']}',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          isDark ? AppThemeData.grey400 : AppThemeData.grey500,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Actions
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'set_default':
                  _setAsDefault(method['id']);
                  break;
                case 'delete':
                  _deletePaymentMethod(method['id']);
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  if (!method['isDefault'])
                    const PopupMenuItem(
                      value: 'set_default',
                      child: Text('Set as Default'),
                    ),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
            icon: Icon(
              Icons.more_vert,
              color: isDark ? AppThemeData.grey400 : AppThemeData.grey600,
            ),
          ),
        ],
      ),
    );
  }

  void _setAsDefault(String methodId) {
    setState(() {
      for (var method in _paymentMethods) {
        method['isDefault'] = method['id'] == methodId;
      }
    });
    _savePaymentMethods();
    Get.snackbar(
      'Success',
      'Default payment method updated',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _deletePaymentMethod(String methodId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Payment Method'),
            content: const Text(
              'Are you sure you want to delete this payment method?',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    _paymentMethods.removeWhere(
                      (method) => method['id'] == methodId,
                    );
                  });
                  await _savePaymentMethods();
                  Get.back();
                  Get.snackbar(
                    'Success',
                    'Payment method deleted',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
