import 'package:flutter/material.dart';

class PaymentOptionScreen extends StatelessWidget {
  final double amount;

  const PaymentOptionScreen({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Options'),
        backgroundColor: const Color(0xFF30588C),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          ListTile(
            leading: const Icon(
              Icons.account_balance_wallet,
              color: Color(0xFF30588C),
            ),
            title: const Text('Wallet Top-up'),
            subtitle: Text('Amount: ₦${amount.toStringAsFixed(2)}'),
            onTap: () {
              Navigator.pushNamed(context, '/addFunds');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.account_balance,
              color: Color(0xFF30588C),
            ),
            title: const Text('Bank Transfer'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.currency_bitcoin,
              color: Color(0xFF30588C),
            ),
            title: const Text('Crypto Payment'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
