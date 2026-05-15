import 'package:flutter/material.dart';

class ReceivePackageScreen extends StatefulWidget {
  const ReceivePackageScreen({super.key});

  @override
  _ReceivePackageScreenState createState() => _ReceivePackageScreenState();
}

class _ReceivePackageScreenState extends State<ReceivePackageScreen> {
  final TextEditingController codeController = TextEditingController();
  bool isLoading = false;

  Future<bool> verifyOrderCode(String code) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return code.isNotEmpty;
  }

  Future<void> markOrderAsDelivered(String code) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // TODO: update order status in DB using the code.
  }

  Future<void> _confirmDelivery() async {
    final String code = codeController.text.trim();
    if (code.isEmpty) return;

    setState(() => isLoading = true);

    final bool isValid = await verifyOrderCode(code);

    if (isValid) {
      await markOrderAsDelivered(code);

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Success'),
              content: const Text('Package confirmed as delivered'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Invalid Code'),
              content: const Text('Please enter a valid order code'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receive Package'),
        backgroundColor: const Color(0xFF30588C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Enter Order Code', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                hintText: 'Enter unique order code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF30588C),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: isLoading ? null : _confirmDelivery,
              child:
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Confirm Delivery'),
            ),
          ],
        ),
      ),
    );
  }
}
