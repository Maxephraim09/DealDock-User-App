import 'package:customer/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme_controller.dart';
import 'parcel_booking_screen.dart';
import 'my_booking_screen.dart';
import 'parcel_dashboard_screen.dart';
import 'receive_package_screen.dart';

class LogisticsHomeScreen extends StatelessWidget {
  const LogisticsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

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
                    color: AppThemeData.brandPrimaryBlue.withOpacity(0.2),
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
                'Logistics',
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Parcel Delivery Services',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppThemeData.brandMutedSteelBlue,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Send, track, and manage your parcels',
                style: TextStyle(
                  fontSize: 16,
                  color: AppThemeData.brandMutedSteelBlue,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildServiceCard(
                      icon: Icons.send,
                      title: 'Send Package',
                      subtitle: 'Book a new delivery',
                      onTap: () => Get.to(const ParcelBookingScreen()),
                    ),
                    _buildServiceCard(
                      icon: Icons.track_changes,
                      title: 'Track Parcel',
                      subtitle: 'Monitor your shipments',
                      onTap: () => Get.to(const ParcelDashboardScreen()),
                    ),
                    _buildServiceCard(
                      icon: Icons.history,
                      title: 'Delivery History',
                      subtitle: 'View past orders',
                      onTap: () => Get.to(() => const MyBookingScreen()),
                    ),
                    _buildServiceCard(
                      icon: Icons.inventory,
                      title: 'Receive Package',
                      subtitle: 'Confirm delivered package',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ReceivePackageScreen(),
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

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            const BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: AppThemeData.brandPrimaryBlue),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppThemeData.brandMutedSteelBlue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppThemeData.brandMutedSteelBlue,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
