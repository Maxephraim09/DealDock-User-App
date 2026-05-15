import 'dart:convert';

import 'package:customer/controllers/theme_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  const AddPaymentMethodScreen({super.key});

  @override
  State<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  static const String _paymentMethodsKey = 'payment_methods';

  final _formKey = GlobalKey<FormState>();
  String _selectedMethod = 'card';
  String _selectedWalletType = 'OPay';
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardholderController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardholderController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeData.brandPrimaryBlue,
        title: const Text('Add Payment Method'),
        elevation: 0,
      ),
      backgroundColor: isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Method Selection
              Text(
                'Select Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildMethodOption('card', 'Card', Icons.credit_card, isDark),
                  const SizedBox(width: 12),
                  _buildMethodOption(
                    'bank',
                    'Bank Account',
                    Icons.account_balance,
                    isDark,
                  ),
                  const SizedBox(width: 12),
                  _buildMethodOption(
                    'wallet',
                    'Digital Wallet',
                    Icons.account_balance_wallet,
                    isDark,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Form Fields based on selected method
              if (_selectedMethod == 'card') ...[
                _buildCardForm(isDark),
              ] else if (_selectedMethod == 'bank') ...[
                _buildBankForm(isDark),
              ] else if (_selectedMethod == 'wallet') ...[
                _buildWalletForm(isDark),
              ],

              const SizedBox(height: 32),

              // Add Button
              RoundedButtonFill(
                title: 'Add Payment Method',
                width: double.infinity,
                height: 6,
                color: AppThemeData.brandPrimaryBlue,
                textColor: Colors.white,
                onPress: _addPaymentMethod,
              ),

              const SizedBox(height: 16),

              // Security Notice
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppThemeData.brandPrimaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppThemeData.brandPrimaryBlue.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.security,
                      color: AppThemeData.brandPrimaryBlue,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your payment information is encrypted and secure. We use industry-standard security measures to protect your data.',
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              isDark
                                  ? AppThemeData.grey300
                                  : AppThemeData.grey700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodOption(
    String value,
    String label,
    IconData icon,
    bool isDark,
  ) {
    final isSelected = _selectedMethod == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMethod = value),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? AppThemeData.brandPrimaryBlue
                    : (isDark ? AppThemeData.surfaceDarkCard : Colors.white),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isSelected
                      ? AppThemeData.brandPrimaryBlue
                      : (isDark ? AppThemeData.grey700 : AppThemeData.grey200),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color:
                    isSelected ? Colors.white : AppThemeData.brandPrimaryBlue,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color:
                      isSelected
                          ? Colors.white
                          : (isDark
                              ? AppThemeData.grey50
                              : AppThemeData.grey900),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardForm(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
          ),
        ),
        const SizedBox(height: 16),

        // Card Number
        TextFormField(
          controller: _cardNumberController,
          decoration: InputDecoration(
            labelText: 'Card Number',
            hintText: '1234 5678 9012 3456',
            prefixIcon: const Icon(Icons.credit_card),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            _CardNumberFormatter(),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter card number';
            }
            if (value.replaceAll(' ', '').length < 16) {
              return 'Please enter a valid card number';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        // Expiry and CVV
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _expiryController,
                decoration: InputDecoration(
                  labelText: 'Expiry Date',
                  hintText: 'MM/YY',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  _ExpiryDateFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _cvvController,
                decoration: InputDecoration(
                  labelText: 'CVV',
                  hintText: '123',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Cardholder Name
        TextFormField(
          controller: _cardholderController,
          decoration: InputDecoration(
            labelText: 'Cardholder Name',
            hintText: 'John Doe',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter cardholder name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBankForm(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bank Account Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
          ),
        ),
        const SizedBox(height: 16),

        // Account Number
        TextFormField(
          controller: _accountNumberController,
          decoration: InputDecoration(
            labelText: 'Account Number',
            hintText: '0123456789',
            prefixIcon: const Icon(Icons.account_balance),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter account number';
            }
            if (value.length < 10) {
              return 'Account number must be 10 digits';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        // Bank Name
        TextFormField(
          controller: _bankNameController,
          decoration: InputDecoration(
            labelText: 'Bank Name',
            hintText: 'e.g., GTBank, Access Bank',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter bank name';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        // Account Name
        TextFormField(
          controller: _accountNameController,
          decoration: InputDecoration(
            labelText: 'Account Name',
            hintText: 'John Doe',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter account name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildWalletForm(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Digital Wallet',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
          ),
        ),
        const SizedBox(height: 16),

        // Wallet Options
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppThemeData.surfaceDarkCard : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? AppThemeData.grey700 : AppThemeData.grey200,
            ),
          ),
          child: Column(
            children: [
              _buildWalletOption(
                'OPay',
                'OPay Wallet',
                Icons.account_balance_wallet,
                isDark,
              ),
              const SizedBox(height: 12),
              _buildWalletOption(
                'Flutterwave',
                'Flutterwave Wallet',
                Icons.account_balance_wallet,
                isDark,
              ),
              const SizedBox(height: 12),
              _buildWalletOption(
                'Paystack',
                'Paystack Wallet',
                Icons.account_balance_wallet,
                isDark,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Selected wallet: $_selectedWalletType',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppThemeData.grey300 : AppThemeData.grey700,
          ),
        ),
      ],
    );
  }

  Widget _buildWalletOption(
    String id,
    String name,
    IconData icon,
    bool isDark,
  ) {
    final isSelected = _selectedWalletType == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedWalletType = id),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppThemeData.brandPrimaryBlue.withOpacity(0.12)
                  : Colors.transparent,
          border: Border.all(
            color:
                isSelected
                    ? AppThemeData.brandPrimaryBlue
                    : AppThemeData.grey300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  isSelected
                      ? AppThemeData.brandPrimaryBlue
                      : AppThemeData.brandPrimaryBlue,
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color:
                    isSelected
                        ? AppThemeData.brandPrimaryBlue
                        : AppThemeData.grey900,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppThemeData.brandPrimaryBlue,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _addPaymentMethod() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final storedJson = prefs.getString(_paymentMethodsKey);
    final storedList =
        storedJson != null && storedJson.isNotEmpty
            ? (jsonDecode(storedJson) as List<dynamic>)
                .map(
                  (item) =>
                      Map<String, dynamic>.from(item as Map<String, dynamic>),
                )
                .toList()
            : <Map<String, dynamic>>[];

    final newMethod = <String, dynamic>{
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': _selectedMethod,
      'isDefault': storedList.isEmpty,
    };

    if (_selectedMethod == 'card') {
      newMethod.addAll({
        'name': _cardNumberController.text.trim(),
        'brand': 'Card',
        'expiry': _expiryController.text.trim(),
      });
    } else if (_selectedMethod == 'bank') {
      newMethod.addAll({
        'name':
            '${_bankNameController.text.trim()} - ${_accountNumberController.text.trim()}',
        'brand': _bankNameController.text.trim(),
        'accountNumber': _accountNumberController.text.trim(),
      });
    } else if (_selectedMethod == 'wallet') {
      newMethod.addAll({
        'name': '$_selectedWalletType Wallet',
        'brand': _selectedWalletType,
        'balance': '₦0.00',
      });
    }

    if (newMethod['isDefault'] == true) {
      for (var method in storedList) {
        method['isDefault'] = false;
      }
    }

    storedList.add(newMethod);
    await prefs.setString(_paymentMethodsKey, jsonEncode(storedList));

    Get.snackbar(
      'Success',
      'Payment method added successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    Get.back(result: true);
  }
}

// Custom input formatters
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write(' ');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && i + 1 != text.length) {
        buffer.write('/');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
