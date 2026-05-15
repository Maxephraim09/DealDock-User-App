import 'package:customer/themes/app_them_data.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor:
            isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
        ),
        titleTextStyle: TextStyle(
          fontFamily: AppThemeData.semiBold,
          fontSize: 18,
          color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
        ),
      ),
      backgroundColor: isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.notifications_active_outlined,
                size: 72,
                color:
                    isDark
                        ? AppThemeData.brandPrimaryBlue
                        : AppThemeData.brandPrimaryBlue,
              ),
              const SizedBox(height: 18),
              Text(
                'No notifications yet',
                style: TextStyle(
                  fontFamily: AppThemeData.semiBold,
                  fontSize: 20,
                  color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Check back later for payment updates, offers, and alerts.',
                style: TextStyle(
                  fontFamily: AppThemeData.medium,
                  fontSize: 14,
                  color: isDark ? AppThemeData.grey400 : AppThemeData.grey600,
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
