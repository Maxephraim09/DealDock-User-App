import 'package:flutter/material.dart';
import 'package:customer/themes/app_them_data.dart';

class BettingScreen extends StatelessWidget {
  const BettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: AppThemeData.brandPrimaryBlue,
        title: const Text('Betting'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sports_esports,
                  size: 72,
                  color: AppThemeData.brandPrimaryBlue,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Betting Service',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppThemeData.grey900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Place your bets and manage your gaming activities here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppThemeData.brandMutedSteelBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
