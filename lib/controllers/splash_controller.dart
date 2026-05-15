import 'dart:async';
import 'package:customer/constant/constant.dart';
import 'package:customer/screen_ui/maintenance_mode_screen/maintenance_mode_screen.dart';
import 'package:customer/screen_ui/service_home_screen/service_list_screen.dart';
import 'package:customer/utils/notification_service.dart';
import 'package:customer/utils/preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../screen_ui/auth_screens/login_screen.dart';
import '../screen_ui/location_enable_screens/location_permission_screen.dart';
import '../screen_ui/on_boarding_screen/on_boarding_screen.dart';
import '../service/fire_store_utils.dart';

class SplashController extends GetxController {
  static const String _tag = '[SplashController]';

  @override
  void onInit() {
    // Initial splash delay before routing logic
    Timer(const Duration(seconds: 3), () => redirectScreen());
    super.onInit();
  }

  Future<void> redirectScreen() async {
    try {
      debugPrint('$_tag Starting route decision...');

      // Check if app is in maintenance mode
      if (Constant.isMaintenanceModeForCustomer == true) {
        debugPrint('$_tag Routing to maintenance screen');
        Get.offAll(const MaintenanceModeScreen());
        return;
      }

      // Check if onboarding is complete
      final isOnboardingComplete = Preferences.getBoolean(
        Preferences.isFinishOnBoardingKey,
      );
      if (!isOnboardingComplete) {
        debugPrint('$_tag Onboarding not complete, showing onboarding screen');
        Get.offAll(const OnboardingScreen());
        return;
      }

      // Session logic: Check Firebase authentication and preferences
      await _handleAuthenticatedSession();
    } catch (e, stackTrace) {
      debugPrint('$_tag Unexpected error in redirectScreen: $e');
      debugPrint('$_tag StackTrace: $stackTrace');
      // Fallback to login on any error
      Get.offAll(const LoginScreen());
    }
  }

  /// Handle routing for authenticated users with session validation
  Future<void> _handleAuthenticatedSession() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      debugPrint('$_tag Firebase user check: ${firebaseUser?.uid ?? 'null'}');

      // No Firebase session exists
      if (firebaseUser == null) {
        debugPrint('$_tag No Firebase auth session, routing to login');
        await FirebaseAuth.instance.signOut();
        Get.offAll(const LoginScreen());
        return;
      }

      // Check session override flags
      final requireLoginOnRestart = Preferences.requireLoginOnRestart();
      if (requireLoginOnRestart) {
        debugPrint('$_tag Require login on restart flag set, clearing session');
        await FirebaseAuth.instance.signOut();
        await Preferences.clearSessionData();
        Get.offAll(() => const LoginScreen());
        return;
      }

      // Check session timeout
      final autoLogoutEnabled = Preferences.autoLogoutEnabled();
      if (autoLogoutEnabled && Preferences.isSessionExpired()) {
        debugPrint('$_tag Session expired, logging out');
        await FirebaseAuth.instance.signOut();
        await Preferences.clearSessionData();
        Get.offAll(() => const LoginScreen());
        return;
      }

      // Check if biometric login is enabled - if so, show login screen
      // (biometric prompt will be handled in LoginScreen initState)
      final biometricEnabled = Preferences.biometricLoginEnabled();
      if (biometricEnabled) {
        debugPrint('$_tag Biometric login enabled, routing to login screen');
        Get.offAll(() => const LoginScreen());
        return;
      }

      // Validate user still exists in Firestore
      debugPrint('$_tag Validating user exists in Firestore...');
      final userExists = await FireStoreUtils.userExistOrNot(firebaseUser.uid);
      if (!userExists) {
        debugPrint('$_tag User not found in Firestore, logging out');
        await FirebaseAuth.instance.signOut();
        Get.offAll(const LoginScreen());
        return;
      }

      // Update session timestamp
      await Preferences.updateLastActiveTime();

      // Fetch user profile and validate
      debugPrint('$_tag Fetching user profile from Firestore...');
      final userModel = await FireStoreUtils.getUserProfile(firebaseUser.uid);

      if (userModel == null) {
        debugPrint('$_tag User profile is null, logging out');
        await FirebaseAuth.instance.signOut();
        Get.offAll(const LoginScreen());
        return;
      }

      // Check if user role and status are valid
      if (userModel.role != Constant.userRoleCustomer) {
        debugPrint('$_tag Invalid user role: ${userModel.role}');
        await FirebaseAuth.instance.signOut();
        Get.offAll(const LoginScreen());
        return;
      }

      if (userModel.active != true) {
        debugPrint('$_tag User account is disabled');
        await FirebaseAuth.instance.signOut();
        Get.offAll(const LoginScreen());
        return;
      }

      // Update FCM token and user data
      try {
        userModel.fcmToken = await NotificationService.getToken();
        await FireStoreUtils.updateUser(userModel);
        debugPrint('$_tag Updated user profile with FCM token');
      } catch (e) {
        debugPrint('$_tag Error updating user profile: $e');
      }

      // Route to appropriate screen based on address status
      if (userModel.shippingAddress != null &&
          userModel.shippingAddress!.isNotEmpty) {
        debugPrint('$_tag User has saved address, routing to service list');
        final defaultAddress = userModel.shippingAddress!.firstWhere(
          (e) => e.isDefault == true,
          orElse: () => userModel.shippingAddress!.first,
        );
        Constant.selectedLocation = defaultAddress;
        Get.offAll(() => const ServiceListScreen());
        return;
      }

      // Check if user skipped location setup
      if (Preferences.getSkipLocation()) {
        debugPrint('$_tag User skipped location, routing to service list');
        Get.offAll(() => const ServiceListScreen());
        return;
      }

      // User needs to set location
      debugPrint(
        '$_tag User needs to set location, routing to permission screen',
      );
      Get.offAll(() => const LocationPermissionScreen());
    } catch (e, stackTrace) {
      debugPrint('$_tag Error in authenticated session handling: $e');
      debugPrint('$_tag StackTrace: $stackTrace');
      // Fallback to login on any error
      Get.offAll(const LoginScreen());
    }
  }
}
