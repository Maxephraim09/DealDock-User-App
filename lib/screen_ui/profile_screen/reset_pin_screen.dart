import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:customer/service/pin_service.dart';
import 'package:customer/service/pin_security_service.dart';
import 'package:customer/themes/show_toast_dialog.dart';

class ResetPinScreen extends StatefulWidget {
  const ResetPinScreen({super.key});

  @override
  State<ResetPinScreen> createState() => _ResetPinScreenState();
}

class _ResetPinScreenState extends State<ResetPinScreen> {
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  /// Validate PIN format (4 digits)
  bool _isValidPin(String pin) {
    final regex = RegExp(r'^[0-9]{4}$');
    return regex.hasMatch(pin);
  }

  /// Check for weak PIN patterns
  bool _isWeakPin(String pin) {
    final weakPatterns = [
      '1111',
      '1234',
      '0000',
      '2222',
      '3333',
      '4444',
      '5555',
      '6666',
      '7777',
      '8888',
      '9999',
    ];
    return weakPatterns.contains(pin);
  }

  /// Handle PIN reset
  Future<void> _handleResetPin() async {
    final newPin = _newPinController.text.trim();
    final confirmPin = _confirmPinController.text.trim();

    // Validation
    if (newPin.isEmpty || confirmPin.isEmpty) {
      ShowToastDialog.showToast("Please enter PIN in both fields");
      return;
    }

    if (!_isValidPin(newPin)) {
      ShowToastDialog.showToast("PIN must be exactly 4 digits");
      return;
    }

    if (_isWeakPin(newPin)) {
      ShowToastDialog.showToast(
        "PIN is too weak. Please choose a different PIN",
      );
      return;
    }

    if (newPin != confirmPin) {
      ShowToastDialog.showToast("PINs do not match");
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ShowToastDialog.showToast("Please login to reset PIN");
      return;
    }

    // Authorize first
    final security = PinSecurityService();
    final authorized = await security.authorize(context);
    if (!authorized) {
      ShowToastDialog.showToast("Authorization failed");
      return;
    }

    setState(() => _isLoading = true);

    try {
      bool success = await PinService.resetPin(newPin);

      if (!mounted) return;

      if (success) {
        ShowToastDialog.showToast("PIN reset successfully");
        Future.delayed(const Duration(milliseconds: 1500), () {
          Get.back(result: true);
        });
      } else {
        ShowToastDialog.showToast("Failed to reset PIN. Please try again.");
      }
    } catch (e) {
      if (mounted) {
        ShowToastDialog.showToast("An error occurred: $e");
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF30588C),
        title: const Text('Reset Transaction PIN'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _newPinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(labelText: "New PIN"),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _confirmPinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(labelText: "Confirm PIN"),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF30588C),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _isLoading ? null : _handleResetPin,
                child: Text(
                  _isLoading ? "Resetting..." : "Reset PIN",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
