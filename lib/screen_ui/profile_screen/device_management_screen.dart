import 'package:customer/controllers/theme_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceManagementScreen extends StatefulWidget {
  const DeviceManagementScreen({super.key});

  @override
  State<DeviceManagementScreen> createState() => _DeviceManagementScreenState();
}

class _DeviceManagementScreenState extends State<DeviceManagementScreen> {
  final List<Map<String, dynamic>> _devices = [
    {
      'id': '1',
      'name': 'iPhone 15 Pro',
      'type': 'Mobile',
      'location': 'Lagos, Nigeria',
      'lastActive': 'Now',
      'isCurrent': true,
      'trusted': true,
    },
    {
      'id': '2',
      'name': 'MacBook Pro',
      'type': 'Desktop',
      'location': 'Lagos, Nigeria',
      'lastActive': '2 hours ago',
      'isCurrent': false,
      'trusted': true,
    },
    {
      'id': '3',
      'name': 'Samsung Galaxy S23',
      'type': 'Mobile',
      'location': 'Abuja, Nigeria',
      'lastActive': '1 week ago',
      'isCurrent': false,
      'trusted': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeData.brandPrimaryBlue,
        title: const Text('Device Management'),
        elevation: 0,
      ),
      backgroundColor: isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppThemeData.brandPrimaryBlue,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage Your Devices',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Monitor and control devices that have access to your account. Remove suspicious devices immediately.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Devices List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                final device = _devices[index];
                return _buildDeviceCard(device, isDark);
              },
            ),
          ),

          // Security Tips
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.security, color: Colors.orange, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Security Tips',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color:
                                isDark
                                    ? AppThemeData.grey50
                                    : AppThemeData.grey900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '• Sign out from devices you no longer use\n• Enable two-factor authentication\n• Use strong, unique passwords',
                          style: TextStyle(
                            fontSize: 12,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(Map<String, dynamic> device, bool isDark) {
    IconData getDeviceIcon() {
      switch (device['type'].toLowerCase()) {
        case 'mobile':
          return Icons.smartphone;
        case 'desktop':
          return Icons.computer;
        case 'tablet':
          return Icons.tablet;
        default:
          return Icons.devices;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppThemeData.surfaceDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              device['isCurrent']
                  ? AppThemeData.brandPrimaryBlue
                  : (isDark ? AppThemeData.grey700 : AppThemeData.grey200),
          width: device['isCurrent'] ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Device Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppThemeData.brandPrimaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              getDeviceIcon(),
              color: AppThemeData.brandPrimaryBlue,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Device Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      device['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                            isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                      ),
                    ),
                    if (device['isCurrent']) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppThemeData.brandPrimaryBlue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Current',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${device['type']} • ${device['location']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppThemeData.grey300 : AppThemeData.grey600,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'Last active: ${device['lastActive']}',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            isDark
                                ? AppThemeData.grey400
                                : AppThemeData.grey500,
                      ),
                    ),
                    if (device['trusted']) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.verified, size: 14, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        'Trusted',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Actions
          if (!device['isCurrent'])
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'sign_out':
                    _signOutDevice(device['id']);
                    break;
                  case 'toggle_trust':
                    _toggleTrust(device['id']);
                    break;
                }
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(
                      value: 'sign_out',
                      child: Text('Sign Out'),
                    ),
                    PopupMenuItem(
                      value: 'toggle_trust',
                      child: Text(
                        device['trusted'] ? 'Remove Trust' : 'Mark as Trusted',
                      ),
                    ),
                  ],
              icon: Icon(
                Icons.more_vert,
                color: isDark ? AppThemeData.grey400 : AppThemeData.grey600,
              ),
            ),
        ],
      ),
    );
  }

  void _signOutDevice(String deviceId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sign Out Device'),
            content: const Text(
              'Are you sure you want to sign out from this device? You will need to log in again on that device.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _devices.removeWhere((device) => device['id'] == deviceId);
                  });
                  Get.back();
                  // TODO: Implement actual device sign out
                  Get.snackbar(
                    'Success',
                    'Device signed out successfully',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _toggleTrust(String deviceId) {
    setState(() {
      final device = _devices.firstWhere((d) => d['id'] == deviceId);
      device['trusted'] = !device['trusted'];
    });

    final device = _devices.firstWhere((d) => d['id'] == deviceId);
    Get.snackbar(
      'Success',
      device['trusted']
          ? 'Device marked as trusted'
          : 'Trust removed from device',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
