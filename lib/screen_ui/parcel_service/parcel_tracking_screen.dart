import 'package:customer/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/constant.dart';
import '../../controllers/theme_controller.dart';

class ParcelTrackingScreen extends StatelessWidget {
  final String trackingCode;
  final Map<String, dynamic> parcelData;

  const ParcelTrackingScreen({
    super.key,
    required this.trackingCode,
    required this.parcelData,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

    // Mock status - in real app this would come from backend
    const currentStatus =
        'Picked up'; // Pending, Picked up, In transit, Delivered

    return Scaffold(
      backgroundColor: isDark ? AppThemeData.surfaceDark : AppThemeData.grey50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppThemeData.brandPrimaryBlue,
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
                'Track Parcel',
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
              // Tracking Code Display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Tracking Code',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppThemeData.brandMutedSteelBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      trackingCode,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppThemeData.brandPrimaryBlue,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Status Timeline
              const Text(
                'Delivery Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppThemeData.brandMutedSteelBlue,
                ),
              ),
              const SizedBox(height: 16),
              _buildStatusTimeline(currentStatus),

              const SizedBox(height: 24),

              // Parcel Details
              const Text(
                'Parcel Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppThemeData.brandMutedSteelBlue,
                ),
              ),
              const SizedBox(height: 16),
              _buildParcelDetailsCard(),

              const SizedBox(height: 24),

              // Rider Info (if applicable)
              if (currentStatus != 'Pending' &&
                  currentStatus != 'Delivered') ...[
                const Text(
                  'Rider Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppThemeData.brandMutedSteelBlue,
                  ),
                ),
                const SizedBox(height: 16),
                _buildRiderInfoCard(),
              ],

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Call rider functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Calling rider...')),
                        );
                      },
                      icon: const Icon(Icons.phone, color: Colors.white),
                      label: const Text('Call Rider'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemeData.brandPrimaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Navigate to support
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Opening support chat...'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.support_agent),
                      label: const Text('Support'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppThemeData.brandPrimaryBlue),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTimeline(String currentStatus) {
    final statuses = ['Pending', 'Picked up', 'In transit', 'Delivered'];
    final currentIndex = statuses.indexOf(currentStatus);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children:
            statuses.asMap().entries.map((entry) {
              final index = entry.key;
              final status = entry.value;
              final isCompleted = index <= currentIndex;
              final isCurrent = index == currentIndex;

              return Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isCompleted
                              ? AppThemeData.brandPrimaryBlue
                              : Colors.grey.shade300,
                      border:
                          isCurrent
                              ? Border.all(
                                color: AppThemeData.brandPrimaryBlue,
                                width: 2,
                              )
                              : null,
                    ),
                    child:
                        isCompleted
                            ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            )
                            : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            isCurrent ? FontWeight.w600 : FontWeight.normal,
                        color:
                            isCompleted
                                ? AppThemeData.brandPrimaryBlue
                                : Colors.grey,
                      ),
                    ),
                  ),
                  if (isCurrent) ...[
                    const Spacer(),
                    Text(
                      'Current',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppThemeData.brandPrimaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildParcelDetailsCard() {
    final parcelType = parcelData['parcelType'] as String;
    final weight = parcelData['weight'] as double;
    final description = parcelData['description'] as String;
    final deliveryType = parcelData['deliveryType'] as String;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.inventory,
                color: AppThemeData.brandPrimaryBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '$parcelType • ${weight}kg',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppThemeData.brandMutedSteelBlue,
                ),
              ),
            ],
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: AppThemeData.brandMutedSteelBlue,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.local_shipping,
                color: AppThemeData.brandPrimaryBlue,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Delivery: $deliveryType',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppThemeData.brandMutedSteelBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiderInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade200,
            child: const Icon(
              Icons.person,
              color: AppThemeData.brandPrimaryBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppThemeData.brandMutedSteelBlue,
                  ),
                ),
                const Text(
                  'Rider ID: RD12345',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const Text(
                      ' 4.8',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Estimated arrival',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Text(
                '15 mins',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppThemeData.brandPrimaryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
