import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/theme_controller.dart';
import 'package:customer/models/onprovider_order_model.dart';
import 'package:customer/models/provider_serivce_model.dart';
import 'package:customer/screen_ui/on_demand_service/on_demand_payment_screen.dart';
import 'package:customer/screen_ui/on_demand_service/payment_option_screen.dart';
import 'package:customer/service/fire_store_utils.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarketRunnerBookingScreen extends StatefulWidget {
  final Map<String, dynamic> runner;

  const MarketRunnerBookingScreen({super.key, required this.runner});

  @override
  State<MarketRunnerBookingScreen> createState() =>
      _MarketRunnerBookingScreenState();
}

class _MarketRunnerBookingScreenState extends State<MarketRunnerBookingScreen> {
  late final TextEditingController _itemDescriptionController;
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _itemDescriptionController = TextEditingController();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _itemDescriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _handleRunnerPayment() async {
    final description = _itemDescriptionController.text.trim();
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please describe the items to be delivered.'.tr),
        ),
      );
      return;
    }

    final int quantity = int.tryParse(_quantityController.text.trim()) ?? 1;
    final double totalAmount =
        double.tryParse(widget.runner['price']?.toString() ?? '0') ?? 0.0;

    if (totalAmount <= 0) return;

    final double walletBalance =
        (Constant.userModel?.walletAmount ?? 0.0).toDouble();
    final String orderCode = 'RUN-${DateTime.now().millisecondsSinceEpoch}';

    final order = OnProviderOrderModel(
      authorID: FireStoreUtils.getCurrentUid(),
      author: Constant.userModel!,
      provider: ProviderServiceModel(
        title: widget.runner['name'] ?? 'Market Runner',
        description: description,
        id: widget.runner['id'] ?? '',
        price: totalAmount.toString(),
        disPrice: totalAmount.toString(),
        priceUnit: 'Fixed',
      ),
      status: Constant.orderPlaced,
      quantity: quantity.toDouble(),
      notes: description,
      otp: orderCode,
      paymentStatus: walletBalance >= totalAmount,
    );

    if (walletBalance >= totalAmount) {
      await FireStoreUtils.onDemandOrderPlace(order, totalAmount);
      await FireStoreUtils.updateUserWallet(
        amount: '-${totalAmount.toString()}',
        userId: FireStoreUtils.getCurrentUid(),
      );

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text('Payment Successful'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Order Code: $orderCode'),
                  const SizedBox(height: 8),
                  Text('Runner booking confirmed'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/orders');
                  },
                  child: Text('OK'),
                ),
              ],
            ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentOptionScreen(amount: totalAmount),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;
    final runner = widget.runner;
    final isActive = runner['status'] == 'Active';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppThemeData.brandPrimaryBlue,
        title: const Text('Runner Booking'),
      ),
      backgroundColor: isDark ? AppThemeData.surfaceDark : AppThemeData.grey50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                runner['name'] ?? 'Runner',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:
                      isDark ? Colors.white : AppThemeData.brandMutedSteelBlue,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppThemeData.brandPrimaryBlue,
                    backgroundImage:
                        runner['image'] != null
                            ? NetworkImage(runner['image']) as ImageProvider
                            : null,
                    child:
                        runner['image'] == null
                            ? const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 28,
                            )
                            : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          runner['status'] ?? 'Status unavailable',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                isActive
                                    ? AppThemeData.brandPrimaryBlue
                                    : AppThemeData.grey500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Rating: ${runner['rating'] ?? '-'}',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                isDark
                                    ? AppThemeData.grey300
                                    : AppThemeData.grey700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${runner['deliveries'] ?? 0} deliveries',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                isDark
                                    ? AppThemeData.grey300
                                    : AppThemeData.grey700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppThemeData.grey900 : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppThemeData.grey700 : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  'Proceed with this runner to complete your booking.',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppThemeData.grey300 : AppThemeData.grey700,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _itemDescriptionController,
                minLines: 3,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Item description'.tr,
                  hintText: 'Describe what you need delivered'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity (optional)'.tr,
                  hintText: 'Enter quantity'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: isActive ? _handleRunnerPayment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemeData.brandPrimaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Center(
                  child: Text(
                    'Continue to Payment'.tr,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
