import 'package:customer/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/constant.dart';
import '../../controllers/theme_controller.dart';
import '../../models/user_model.dart';
import '../multi_vendor_service/wallet_screen/wallet_screen.dart';
import 'parcel_tracking_screen.dart';

class ParcelSummaryScreen extends StatelessWidget {
  final Map<String, dynamic> parcelData;

  const ParcelSummaryScreen({super.key, required this.parcelData});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

    final pickupAddress = parcelData['pickupAddress'] as ShippingAddress;
    final deliveryAddress = parcelData['deliveryAddress'] as ShippingAddress;
    final parcelType = parcelData['parcelType'] as String;
    final weight = parcelData['weight'] as double;
    final description = parcelData['description'] as String;
    final deliveryType = parcelData['deliveryType'] as String;
    final estimatedPrice = parcelData['estimatedPrice'] as double;

    return Scaffold(
      backgroundColor: isDark ? AppThemeData.surfaceDark : AppThemeData.grey50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppThemeData.brandDeepBlue,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () => Get.back(),
                child: Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Parcel Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Review Your Order',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppThemeData.brandMutedSteelBlue,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please confirm the details before proceeding to payment',
                style: TextStyle(
                  fontSize: 16,
                  color: AppThemeData.brandMutedSteelBlue,
                ),
              ),
              const SizedBox(height: 24),
              _buildSummaryCard(
                'Pickup Location',
                pickupAddress.locality ?? 'N/A',
                Icons.location_on,
              ),
              const SizedBox(height: 16),
              _buildSummaryCard(
                'Delivery Location',
                deliveryAddress.locality ?? 'N/A',
                Icons.location_on,
              ),
              const SizedBox(height: 16),
              _buildSummaryCard(
                'Parcel Details',
                '$parcelType • ${weight}kg${description.isNotEmpty ? '\n$description' : ''}',
                Icons.inventory,
              ),
              const SizedBox(height: 16),
              _buildSummaryCard(
                'Delivery Type',
                deliveryType,
                Icons.local_shipping,
              ),
              const SizedBox(height: 16),
              _buildSummaryCard(
                'Estimated Delivery',
                deliveryType == 'Express' ? '2-4 hours' : '1-2 days',
                Icons.schedule,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Delivery Fee',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppThemeData.brandMutedSteelBlue,
                          ),
                        ),
                        Text(
                          '₦${estimatedPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppThemeData.brandPrimaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppThemeData.brandMutedSteelBlue,
                          ),
                        ),
                        Text(
                          '₦${estimatedPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppThemeData.brandPrimaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _proceedToPayment(context, estimatedPrice),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemeData.brandPrimaryBlue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Proceed to Payment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppThemeData.brandPrimaryBlue, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppThemeData.brandMutedSteelBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppThemeData.brandMutedSteelBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToPayment(BuildContext context, double amount) {
    final userBalance = Constant.userModel?.walletAmount ?? 0.0;

    if (userBalance >= amount) {
      // Sufficient balance - proceed to payment
      _processPayment(amount);
    } else {
      // Insufficient balance - navigate to add funds
      Get.to(const WalletScreen())?.then((_) {
        // Check balance again after returning from wallet
        final updatedBalance = Constant.userModel?.walletAmount ?? 0.0;
        if (updatedBalance >= amount) {
          _processPayment(amount);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Insufficient balance. Please add funds to continue.',
              ),
            ),
          );
        }
      });
    }
  }

  void _processPayment(double amount) {
    // Generate tracking code
    final trackingCode = _generateTrackingCode();

    // Here you would typically call the backend API to create the order
    // For now, we'll simulate success and navigate to tracking

    Get.offAll(
      () => ParcelTrackingScreen(
        trackingCode: trackingCode,
        parcelData: parcelData,
      ),
    );
  }

  String _generateTrackingCode() {
    // Generate a 6-digit alphanumeric code
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = StringBuffer();
    for (var i = 0; i < 6; i++) {
      random.write(
        chars[(chars.length *
                (DateTime.now().millisecondsSinceEpoch % 1000) /
                1000)
            .floor()],
      );
    }
    return random.toString();
  }
}
