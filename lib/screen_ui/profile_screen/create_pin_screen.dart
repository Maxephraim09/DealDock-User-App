import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:customer/service/pin_service.dart';
import 'package:customer/service/pin_security_service.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/themes/show_toast_dialog.dart';
import 'package:customer/controllers/theme_controller.dart';

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  bool _obscurePin = true;
  bool _obscureConfirmPin = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
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

  /// Handle PIN creation
  Future<void> _handleCreatePin() async {
    final pin = _pinController.text.trim();
    final confirmPin = _confirmPinController.text.trim();

    // Validation
    if (pin.isEmpty || confirmPin.isEmpty) {
      ShowToastDialog.showToast("Please enter PIN in both fields");
      return;
    }

    if (!_isValidPin(pin)) {
      ShowToastDialog.showToast("PIN must be exactly 4 digits");
      return;
    }

    if (_isWeakPin(pin)) {
      ShowToastDialog.showToast(
        "PIN is too weak. Please choose a different PIN",
      );
      return;
    }

    if (pin != confirmPin) {
      ShowToastDialog.showToast("PINs do not match");
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ShowToastDialog.showToast("Please login to create PIN");
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
      bool success = await PinService.createPin(pin);

      if (!mounted) return;

      if (success) {
        ShowToastDialog.showToast("PIN created successfully");
        Future.delayed(const Duration(milliseconds: 1500), () {
          Get.back(result: true);
        });
      } else {
        ShowToastDialog.showToast("Failed to create PIN. Please try again.");
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
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeData.brandPrimaryBlue,
        title: const Text('Create Transaction PIN'),
        elevation: 0,
      ),
      backgroundColor: isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppThemeData.brandPrimaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Secure Your Account",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Create a 4-digit PIN for secure transactions",
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // PIN Input Field
            Text(
              "Enter PIN",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _pinController,
              obscureText: _obscurePin,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textInputAction: TextInputAction.next,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: "••••",
                counterText: "",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppThemeData.brandPrimaryBlue,
                    width: 2,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePin ? Icons.visibility_off : Icons.visibility,
                    color: AppThemeData.brandPrimaryBlue,
                  ),
                  onPressed: () {
                    setState(() => _obscurePin = !_obscurePin);
                  },
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
              ),
            ),
            const SizedBox(height: 24),

            // Confirm PIN Field
            Text(
              "Confirm PIN",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmPinController,
              obscureText: _obscureConfirmPin,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textInputAction: TextInputAction.done,
              enabled: !_isLoading,
              onSubmitted: (_) => _handleCreatePin(),
              decoration: InputDecoration(
                hintText: "••••",
                counterText: "",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppThemeData.brandPrimaryBlue,
                    width: 2,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPin
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppThemeData.brandPrimaryBlue,
                  ),
                  onPressed: () {
                    setState(() => _obscureConfirmPin = !_obscureConfirmPin);
                  },
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
              ),
            ),
            const SizedBox(height: 32),

            // Info Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Your PIN must be 4 digits. Keep it secure and never share it with anyone.",
                      style: TextStyle(fontSize: 12, color: Colors.blue[900]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Create Button
            RoundedButtonFill(
              title: _isLoading ? "Creating..." : "Create PIN",
              color: AppThemeData.brandPrimaryBlue,
              textColor: Colors.white,
              onPress: _isLoading ? null : _handleCreatePin,
            ),
          ],
        ),
      ),
    );
  }
}
