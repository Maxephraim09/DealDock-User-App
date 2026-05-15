import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/themes/app_them_data.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: AppThemeData.brandPrimaryBlue,
        title: const Text('Transaction History'),
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
                  Icons.receipt_long,
                  size: 72,
                  color: AppThemeData.brandPrimaryBlue,
                ),
                const SizedBox(height: 16),
                Text(
                  'Transaction History'.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppThemeData.grey900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'View all your past transactions and account activity here.'
                      .tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
