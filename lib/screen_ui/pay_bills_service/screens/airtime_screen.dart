import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/screen_ui/pay_bills_service/widgets/input_field_widget.dart';
import 'package:customer/screen_ui/pay_bills_service/widgets/payment_button_widget.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/show_toast_dialog.dart';
import 'package:customer/screen_ui/multi_vendor_service/wallet_screen/add_funds_screen.dart';

class AirtimeScreen extends StatefulWidget {
  const AirtimeScreen({super.key});

  @override
  State<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends State<AirtimeScreen> {
  final phoneController = TextEditingController();
  final amountController = TextEditingController();
  String? selectedNetwork;
  bool isLoading = false;

  final List<String> networks = ['MTN', 'Airtel', 'Glo', '9mobile'];
  final Map<String, double> airtimePrices = {
    'MTN': 100,
    'Airtel': 100,
    'Glo': 100,
    '9mobile': 100,
  };

  @override
  void dispose() {
    phoneController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void _handleBuyAirtime() async {
    if (phoneController.text.isEmpty) {
      ShowToastDialog.showToast('Please enter phone number'.tr);
      return;
    }
    if (selectedNetwork == null) {
      ShowToastDialog.showToast('Please select a network'.tr);
      return;
    }
    if (amountController.text.isEmpty) {
      ShowToastDialog.showToast('Please enter amount'.tr);
      return;
    }

    final double amount = double.tryParse(amountController.text) ?? 0.0;
    if (amount <= 0) {
      ShowToastDialog.showToast('Please enter a valid amount'.tr);
      return;
    }

    final walletBalance = Constant.userModel?.walletAmount ?? 0.0;
    if (walletBalance < amount) {
      ShowToastDialog.showToast('Insufficient wallet balance'.tr);
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddFundsScreen()),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      ShowToastDialog.showToast(
        'Airtime of ₦$amount sent to ${phoneController.text} ($selectedNetwork)'
            .tr,
      );

      phoneController.clear();
      amountController.clear();
      selectedNetwork = null;

      setState(() => isLoading = false);

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } catch (e) {
      setState(() => isLoading = false);
      ShowToastDialog.showToast('Transaction failed. Please try again.'.tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: AppThemeData.brandDeepBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Buy Airtime',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppThemeData.brandPrimaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppThemeData.brandPrimaryBlue.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppThemeData.brandPrimaryBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Airtime will be sent instantly to your phone number'
                            .tr,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppThemeData.brandMutedSteelBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Phone Number
              InputFieldWidget(
                label: 'Phone Number'.tr,
                hintText: '08012345678',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Network Selection
              Text(
                'Select Network'.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppThemeData.brandMutedSteelBlue,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: networks.map((network) {
                  final isSelected = selectedNetwork == network;
                  return FilterChip(
                    label: Text(network),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedNetwork = selected ? network : null;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: AppThemeData.brandPrimaryBlue,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppThemeData.brandMutedSteelBlue,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected
                            ? AppThemeData.brandPrimaryBlue
                            : const Color(0xFFE5E7EB),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Amount
              InputFieldWidget(
                label: 'Amount'.tr,
                hintText: '500',
                controller: amountController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Buy Button
              PaymentButtonWidget(
                title: 'Buy Airtime'.tr,
                onPressed: _handleBuyAirtime,
                isLoading: isLoading,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
