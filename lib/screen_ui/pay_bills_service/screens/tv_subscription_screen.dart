import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/screen_ui/pay_bills_service/widgets/input_field_widget.dart';
import 'package:customer/screen_ui/pay_bills_service/widgets/payment_button_widget.dart';
import 'package:customer/themes/show_toast_dialog.dart';
import 'package:customer/screen_ui/multi_vendor_service/wallet_screen/add_funds_screen.dart';

class TvSubscriptionScreen extends StatefulWidget {
  const TvSubscriptionScreen({super.key});

  @override
  State<TvSubscriptionScreen> createState() => _TvSubscriptionScreenState();
}

class _TvSubscriptionScreenState extends State<TvSubscriptionScreen> {
  final smartCardController = TextEditingController();
  String? selectedProvider;
  String? selectedPlan;
  bool isLoading = false;

  final List<String> providers = ['DSTV', 'GOTV', 'Startimes'];
  final Map<String, List<Map<String, dynamic>>> tvBundles = {
    'DSTV': [
      {'name': 'Family - ₦2750', 'price': 2750.0},
      {'name': 'Yanga - ₦4000', 'price': 4000.0},
      {'name': 'Compact - ₦7500', 'price': 7500.0},
      {'name': 'Premium - ₦12000', 'price': 12000.0},
    ],
    'GOTV': [
      {'name': 'Lite - ₦1100', 'price': 1100.0},
      {'name': 'Plus - ₦2050', 'price': 2050.0},
      {'name': 'Max - ₦3850', 'price': 3850.0},
    ],
    'Startimes': [
      {'name': 'Basic - ₦1000', 'price': 1000.0},
      {'name': 'Smart - ₦2000', 'price': 2000.0},
      {'name': 'Classic - ₦3500', 'price': 3500.0},
    ],
  };

  @override
  void dispose() {
    smartCardController.dispose();
    super.dispose();
  }

  void _handleSubscribe() async {
    if (smartCardController.text.isEmpty) {
      ShowToastDialog.showToast('Please enter smart card number'.tr);
      return;
    }
    if (selectedProvider == null) {
      ShowToastDialog.showToast('Please select a provider'.tr);
      return;
    }
    if (selectedPlan == null) {
      ShowToastDialog.showToast('Please select a plan'.tr);
      return;
    }

    final amount =
        tvBundles[selectedProvider]!.firstWhere(
              (plan) => plan['name'] == selectedPlan,
            )['price']
            as double;

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
        'TV subscription $selectedPlan activated for ${smartCardController.text} ($selectedProvider)'
            .tr,
      );

      smartCardController.clear();
      selectedProvider = null;
      selectedPlan = null;

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
          'TV Subscription',
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
                        'Subscription will be activated immediately'.tr,
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
                label: 'Smart Card Number'.tr,
                hintText: '1234567890',
                controller: smartCardController,
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
                children: providers.map((provider) {
                  final isSelected = selectedProvider == provider;
                  return FilterChip(
                    label: Text(provider),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedProvider = selected ? provider : null;
                        selectedPlan = null;
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
              Text(
                'Select Plan'.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppThemeData.brandMutedSteelBlue,
                ),
              ),
              const SizedBox(height: 8),
              if (selectedProvider != null)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tvBundles[selectedProvider]!.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final plan = tvBundles[selectedProvider]![index];
                    final planName = plan['name'] as String;
                    final isSelected = selectedPlan == planName;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPlan = planName;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppThemeData.brandPrimaryBlue
                              : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? AppThemeData.brandPrimaryBlue
                                : const Color(0xFFE5E7EB),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              planName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : AppThemeData.brandMutedSteelBlue,
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              else
                Center(
                  child: Text(
                    'Select a provider first'.tr,
                    style: TextStyle(fontSize: 14, color: AppThemeData.grey400),
                  ),
                ),
              const SizedBox(height: 32),
              PaymentButtonWidget(
                title: 'Subscribe Now'.tr,
                onPressed: _handleSubscribe,
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
