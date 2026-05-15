import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/controllers/theme_controller.dart';
import 'package:customer/screen_ui/on_demand_service/market_runner_booking_screen.dart';

class MarketRunnerScreen extends StatelessWidget {
  const MarketRunnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

    // Mock data - Replace with actual Firestore/API data fetch
    final List<Map<String, dynamic>> marketRunners = [
      {
        'id': '1',
        'name': 'John Okafor',
        'image': 'https://via.placeholder.com/150?text=JO',
        'status': 'Active',
        'rating': 4.8,
        'deliveries': 256,
      },
      {
        'id': '2',
        'name': 'Chioma Adeyemi',
        'image': 'https://via.placeholder.com/150?text=CA',
        'status': 'Active',
        'rating': 4.9,
        'deliveries': 312,
      },
      {
        'id': '3',
        'name': 'Emeka Nwankwo',
        'image': 'https://via.placeholder.com/150?text=EN',
        'status': 'Offline',
        'rating': 4.7,
        'deliveries': 189,
      },
      {
        'id': '4',
        'name': 'Zainab Mohammed',
        'image': 'https://via.placeholder.com/150?text=ZM',
        'status': 'Active',
        'rating': 4.6,
        'deliveries': 224,
      },
      {
        'id': '5',
        'name': 'Ayodeji Balogun',
        'image': 'https://via.placeholder.com/150?text=AB',
        'status': 'Active',
        'rating': 4.8,
        'deliveries': 298,
      },
      {
        'id': '6',
        'name': 'Grace Okoro',
        'image': 'https://via.placeholder.com/150?text=GO',
        'status': 'Offline',
        'rating': 4.5,
        'deliveries': 156,
      },
    ];

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
                'Market Runners',
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
              Text(
                'Registered Runners',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:
                      isDark ? Colors.white : AppThemeData.brandMutedSteelBlue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${marketRunners.length} runners available',
                style: TextStyle(
                  fontSize: 14,
                  color:
                      isDark
                          ? AppThemeData.grey300
                          : AppThemeData.brandMutedSteelBlue,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: marketRunners.length,
                  itemBuilder: (context, index) {
                    final runner = marketRunners[index];
                    final isActive = runner['status'] == 'Active';

                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        if (!isActive) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'This runner is currently offline.',
                              ),
                            ),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    MarketRunnerBookingScreen(runner: runner),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              isDark ? AppThemeData.surfaceDark : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isDark
                                    ? AppThemeData.grey700
                                    : Colors.grey.shade300,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Profile Image
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppThemeData.brandPrimaryBlue,
                                border: Border.all(
                                  color: AppThemeData.brandPrimaryBlue,
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  runner['image'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.person,
                                          color: AppThemeData.brandPrimaryBlue,
                                          size: 30,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Runner Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          runner['name'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                isDark
                                                    ? Colors.white
                                                    : AppThemeData
                                                        .brandMutedSteelBlue,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              isActive
                                                  ? AppThemeData
                                                      .brandPrimaryBlue
                                                      .withOpacity(0.12)
                                                  : AppThemeData.grey500
                                                      .withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    isActive
                                                        ? AppThemeData
                                                            .brandPrimaryBlue
                                                        : AppThemeData.grey500,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              runner['status'],
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    isActive
                                                        ? AppThemeData
                                                            .brandPrimaryBlue
                                                        : AppThemeData.grey500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star_rounded,
                                            color: AppThemeData.warning400,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${runner['rating']} (${runner['deliveries']} deliveries)",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  isDark
                                                      ? AppThemeData.grey300
                                                      : Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
