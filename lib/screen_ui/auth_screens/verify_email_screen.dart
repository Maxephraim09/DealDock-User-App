import 'dart:async';
import 'package:customer/screen_ui/auth_screens/login_screen.dart';
import 'package:customer/screen_ui/location_enable_screens/location_permission_screen.dart';
import 'package:customer/screen_ui/service_home_screen/service_list_screen.dart';
import 'package:customer/service/email_verification_service.dart';
import 'package:customer/service/fire_store_utils.dart';
import 'package:customer/themes/show_toast_dialog.dart';
import 'package:customer/utils/app_colors.dart';
import 'package:customer/utils/preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final EmailVerificationService _verificationService =
      EmailVerificationService();
  bool _isLoading = false;
  DateTime? _lastSent;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (mounted) {
        final isVerified = await _verificationService.checkVerification();
        if (isVerified) {
          _navigateToHome();
        }
      }
    });
  }

  Future<void> _resendEmail() async {
    if (_lastSent != null &&
        DateTime.now().difference(_lastSent!) < const Duration(seconds: 60)) {
      ShowToastDialog.showToast("Please wait 60 seconds before resending");
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _verificationService.sendVerificationEmail();
      _lastSent = DateTime.now();
      ShowToastDialog.showToast("Verification email sent");
    } catch (e) {
      ShowToastDialog.showToast("Failed to send email: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _checkVerification() async {
    setState(() => _isLoading = true);
    try {
      final isVerified = await _verificationService.checkVerification();
      if (isVerified) {
        _navigateToHome();
      } else {
        ShowToastDialog.showToast(
          "Email not verified yet. Please check your inbox.",
        );
      }
    } catch (e) {
      ShowToastDialog.showToast(
        "Failed to check verification: ${e.toString()}",
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _navigateToHome() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      await _verificationService.signOut();
      Get.offAll(() => const LoginScreen());
      return;
    }

    await currentUser.reload();
    final refreshedUser = FirebaseAuth.instance.currentUser;
    if (refreshedUser == null) {
      await _verificationService.signOut();
      Get.offAll(() => const LoginScreen());
      return;
    }

    final userModel = await FireStoreUtils.getUserProfile(refreshedUser.uid);
    if (userModel == null) {
      await _verificationService.signOut();
      Get.offAll(() => const LoginScreen());
      return;
    }

    if (userModel.shippingAddress != null &&
        userModel.shippingAddress!.isNotEmpty) {
      Get.offAll(() => const ServiceListScreen());
      return;
    }

    if (Preferences.getSkipLocation()) {
      Get.offAll(() => const ServiceListScreen());
      return;
    }

    Get.offAll(() => const LocationPermissionScreen());
  }

  void _logout() async {
    await _verificationService.signOut();
    Get.offAll(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        backgroundColor: AppColors.brandPrimaryBlue,
        actions: [
          TextButton(
            onPressed: _logout,
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email, size: 80, color: AppColors.brandPrimaryBlue),
              const SizedBox(height: 24),
              Text(
                'Verify Your Email',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'We\'ve sent a verification email to your email address. Please check your inbox and click the verification link.',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: _checkVerification,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandPrimaryBlue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('I\'ve Verified My Email'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _resendEmail,
                      child: Text(
                        'Resend Verification Email',
                        style: TextStyle(color: AppColors.brandPrimaryBlue),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              Text(
                'Didn\'t receive the email? Check your spam folder.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white54 : Colors.black38,
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
