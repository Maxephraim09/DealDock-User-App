import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/screen_ui/pay_bills_service/widgets/input_field_widget.dart';
import 'package:customer/screen_ui/pay_bills_service/widgets/payment_button_widget.dart';
import 'package:customer/themes/show_toast_dialog.dart';
import 'package:customer/screen_ui/multi_vendor_service/wallet_screen/add_funds_screen.dart';

class ExamPinScreen extends StatefulWidget {
  const ExamPinScreen({super.key});

  @override
  State<ExamPinScreen> createState() => _ExamPinScreenState();
}

class _ExamPinScreenState extends State<ExamPinScreen> {
  final quantityController = TextEditingController();
  String? selectedExam;
  bool isLoading = false;

  final List<String> exams = ['WAEC', 'JAMB', 'NABTEB', 'NECO'];
  final Map<String, double> examPrices = {
    'WAEC': 3500.0,
    'JAMB': 4000.0,
    'NABTEB': 3500.0,
    'NECO': 3500.0,
  };

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  void _handleBuyPin() async {
    if (selectedExam == null) {
      ShowToastDialog.showToast('Please select an exam'.tr);
      return;
    }
    if (quantityController.text.isEmpty) {
      ShowToastDialog.showToast('Please enter quantity'.tr);
      return;
    }

    final int quantity = int.tryParse(quantityController.text) ?? 0;
    if (quantity <= 0) {
      ShowToastDialog.showToast('Please enter a valid quantity'.tr);
      return;
    }

    final pricePerPin = examPrices[selectedExam]!;
    final totalAmount = pricePerPin * quantity;

    final walletBalance = Constant.userModel?.walletAmount ?? 0.0;
    if (walletBalance < totalAmount) {
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
        '$quantity $selectedExam exam pin(s) purchased for ₦$totalAmount'.tr,
      );

      quantityController.clear();
      selectedExam = null;

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
      backgroundColor: AppThemeData.grey50,
      appBar: AppBar(
        backgroundColor: AppThemeData.brandDeepBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Buy Exam Pins',
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
                        'Exam pins will be sent to your email instantly'.tr,
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
              Text(
                'Select Exam Type'.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppThemeData.brandMutedSteelBlue,
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: exams.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final exam = exams[index];
                  final price = examPrices[exam]!;
                  final isSelected = selectedExam == exam;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedExam = exam;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? AppThemeData.brandPrimaryBlue
                                : Colors.white,
                        border: Border.all(
                          color:
                              isSelected
                                  ? AppThemeData.brandPrimaryBlue
                                  : AppThemeData.grey200,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exam,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : AppThemeData.brandMutedSteelBlue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₦${price.toStringAsFixed(0)} per pin',
                                style: TextStyle(
                                  fontSize: 13,
                                  color:
                                      isSelected
                                          ? Colors.white70
                                          : AppThemeData.grey500,
                                ),
                              ),
                            ],
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              InputFieldWidget(
                label: 'Quantity'.tr,
                hintText: '1',
                controller: quantityController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              if (selectedExam != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppThemeData.brandPrimaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppThemeData.brandMutedSteelBlue,
                        ),
                      ),
                      Text(
                        '₦${(examPrices[selectedExam]! * (int.tryParse(quantityController.text) ?? 1)).toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppThemeData.brandPrimaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 32),
              PaymentButtonWidget(
                title: 'Buy Pins'.tr,
                onPressed: _handleBuyPin,
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
