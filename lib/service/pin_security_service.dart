import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/preferences.dart';
import 'biometric_service.dart';

class PinSecurityService {
  final BiometricService biometric = BiometricService();

  Future<bool> authorize(BuildContext context) async {
    final biometricEnabled = Preferences.biometricLoginEnabled();

    // Try biometric first
    if (biometricEnabled) {
      final available = await biometric.isAvailable();
      if (available) {
        final result = await biometric.authenticate(
          reason: "Verify identity to continue",
        );
        if (result.success) return true;
      }
    }

    // Fallback to password
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) {
            final controller = TextEditingController();
            return AlertDialog(
              title: const Text("Verify Password"),
              content: TextField(
                controller: controller,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Enter Password"),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF30588C),
                  ),
                  onPressed: () async {
                    final navigator = Navigator.of(dialogContext);
                    final messenger = ScaffoldMessenger.of(dialogContext);
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      navigator.pop(false);
                      return;
                    }

                    try {
                      final credential = EmailAuthProvider.credential(
                        email: user.email!,
                        password: controller.text.trim(),
                      );

                      await user.reauthenticateWithCredential(credential);
                      navigator.pop(true);
                    } catch (e) {
                      messenger.showSnackBar(
                        const SnackBar(content: Text("Invalid password")),
                      );
                    }
                  },
                  child: const Text(
                    "Verify",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
