import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/screen_ui/pay_bills_service/widgets/input_field_widget.dart';
import 'package:customer/screen_ui/pay_bills_service/widgets/payment_button_widget.dart';
import 'package:customer/themes/show_toast_dialog.dart';
import 'package:customer/screen_ui/multi_vendor_service/wallet_screen/add_funds_screen.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final phoneController = TextEditingController();
  String? selectedNetwork;
  String? selectedPlan;
  bool isLoading = false;

  final List<String> networks = ['MTN', 'Airtel', 'Glo', '9mobile'];
  final Map<String, List<Map<String, dynamic>>> dataBundles = {
    'MTN': [
      {'name': '500MB - ₦100', 'price': 100.0},
      {'name': '1GB - ₦200', 'price': 200.0},
      {'name': '5GB - ₦500', 'price': 500.0},
      {'name': '10GB - ₦1000', 'price': 1000.0},
    ],
    'Airtel': [
      {'name': '500MB - ₦100', 'price': 100.0},
      {'name': '1GB - ₦200', 'price': 200.0},
      {'name': '5GB - ₦500', 'price': 500.0},
      {'name': '10GB - ₦1000', 'price': 1000.0},
    ],
    'Glo': [
      {'name': '500MB - ₦100', 'price': 100.0},
      {'name': '1GB - ₦200', 'price': 200.0},
      {'name': '5GB - ₦500', 'price': 500.0},
      {'name': '10GB - ₦1000', 'price': 1000.0},
    ],
    '9mobile': [
      {'name': '500MB - ₦100', 'price': 100.0},
      {'name': '1GB - ₦200', 'price': 200.0},
      {'name': '5GB - ₦500', 'price': 500.0},
      {'name': '10GB - ₦1000', 'price': 1000.0},
    ],
  };

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void _handleBuyData() async {
    if (phoneController.text.isEmpty) {
      ShowToastDialog.showToast('Please enter phone number'.tr);
      return;
    }
    if (selectedNetwork == null) {
      ShowToastDialog.showToast('Please select a network'.tr);
      return;
    }
    if (selectedPlan == null) {
      ShowToastDialog.showToast('Please select a data plan'.tr);
      return;
    }

    final amount =
        dataBundles[selectedNetwork]!.firstWhere(
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
        'Data bundle $selectedPlan purchased for ${phoneController.text} ($selectedNetwork)'
            .tr,
      );

      phoneController.clear();
      selectedNetwork = null;
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
          'Buy Data',
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
                        'Data will be activated instantly'.tr,
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
                label: 'Phone Number'.tr,
                hintText: '08012345678',
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
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
                'Select Data Plan'.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppThemeData.brandMutedSteelBlue,
                ),
              ),
              const SizedBox(height: 8),
              if (selectedNetwork != null)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dataBundles[selectedNetwork]!.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final plan = dataBundles[selectedNetwork]![index];
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
                    'Select a network first'.tr,
                    style: TextStyle(fontSize: 14, color: AppThemeData.grey400),
                  ),
                ),
              const SizedBox(height: 32),
              PaymentButtonWidget(
                title: 'Buy Data'.tr,
                onPressed: _handleBuyData,
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
