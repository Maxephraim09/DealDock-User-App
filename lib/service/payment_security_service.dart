import 'package:customer/service/biometric_service.dart';
import 'package:customer/service/pin_service.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentSecurityService {
  static final BiometricService biometric = BiometricService();

  static Future<bool> authorize(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final bool biometricEnabled =
        prefs.getBool(Preferences.biometricEnabledKey) ?? false;

    if (biometricEnabled) {
      final available = await biometric.isAvailable();
      if (available) {
        final result = await biometric.authenticate(
          reason: 'Authorize transaction',
        );
        if (result.success) {
          return true;
        }
      }
    }

    final pinExists = await PinService.pinExists();
    if (!pinExists) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Transaction PIN not set. Please set a PIN to continue.',
            ),
          ),
        );
      }
      return false;
    }

    final TextEditingController pinController = TextEditingController();

    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('Confirm Transaction'),
          content: TextField(
            controller: pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 4,
            decoration: const InputDecoration(
              labelText: 'Enter Transaction PIN',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF30588C),
              ),
              onPressed: () async {
                final pin = pinController.text.trim();
                if (pin.length == 4) {
                  final valid = await PinService.verifyPin(pin);
                  if (valid) {
                    Navigator.pop(context, true);
                    return;
                  }
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid PIN. Please try again.'),
                    ),
                  );
                }
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
