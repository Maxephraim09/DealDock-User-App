import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/screen_ui/pay_bills_service/widgets/input_field_widget.dart';
import 'package:customer/screen_ui/pay_bills_service/widgets/payment_button_widget.dart';
import 'package:customer/themes/show_toast_dialog.dart';
import 'package:customer/screen_ui/multi_vendor_service/wallet_screen/add_funds_screen.dart';

class ElectricityScreen extends StatefulWidget {
  const ElectricityScreen({super.key});

  @override
  State<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends State<ElectricityScreen> {
  final meterNumberController = TextEditingController();
  final amountController = TextEditingController();
  String? selectedProvider;
  bool isLoading = false;

  final List<String> providers = [
    'YEDC',
    'AEDC',
    'IKEDC',
    'EKEDC',
    'PHED',
    'IBEDC',
    'KEDCO',
    'JED',
    'BEDC',
    'EEDC',
  ];

  @override
  void dispose() {
    meterNumberController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void _handlePayBill() async {
    if (meterNumberController.text.isEmpty) {
      ShowToastDialog.showToast('Please enter meter number'.tr);
      return;
    }
    if (selectedProvider == null) {
      ShowToastDialog.showToast('Please select a provider'.tr);
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
      await Future.delayed(const Duration(seconds: 2));

      ShowToastDialog.showToast(
        'Electricity payment of ₦$amount for meter ${meterNumberController.text} ($selectedProvider) successful'
            .tr,
      );

      meterNumberController.clear();
      amountController.clear();
      selectedProvider = null;

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
          'Pay Electricity',
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
                        'Payment will be processed immediately'.tr,
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
              InputFieldWidget(
                label: 'Meter Number'.tr,
                hintText: '1234567890',
                controller: meterNumberController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Text(
                'Select Provider'.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppThemeData.brandMutedSteelBlue,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children:
                    providers.map((provider) {
                      final isSelected = selectedProvider == provider;
                      return FilterChip(
                        label: Text(provider),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            selectedProvider = selected ? provider : null;
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: AppThemeData.brandPrimaryBlue,
                        labelStyle: TextStyle(
                          color:
                              isSelected
                                  ? Colors.white
                                  : AppThemeData.brandMutedSteelBlue,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color:
                                isSelected
                                    ? AppThemeData.brandPrimaryBlue
                                    : const Color(0xFFE5E7EB),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 16),
              InputFieldWidget(
                label: 'Amount'.tr,
                hintText: '5000',
                controller: amountController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              PaymentButtonWidget(
                title: 'Pay Now'.tr,
                onPressed: _handlePayBill,
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
