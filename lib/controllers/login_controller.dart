import 'dart:convert';
import 'dart:math' as math;
import 'package:customer/screen_ui/auth_screens/verify_email_screen.dart';
import 'package:customer/screen_ui/location_enable_screens/location_permission_screen.dart';
import 'package:customer/service/email_verification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant/constant.dart';
import '../models/user_model.dart';
import '../screen_ui/auth_screens/login_screen.dart';
import '../screen_ui/auth_screens/sign_up_screen.dart';
import '../utils/preferences.dart';
import '../screen_ui/service_home_screen/service_list_screen.dart';
import '../service/fire_store_utils.dart';
import '../themes/show_toast_dialog.dart';
import '../utils/notification_service.dart';
import 'package:crypto/crypto.dart';

class LoginController extends GetxController {
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;

  /// Focus nodes
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  /// Loading indicator
  final RxBool isLoading = false.obs;

  RxBool passwordVisible = true.obs;

  Future<void> _saveSessionState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      Preferences.lastActiveTimeKey,
      DateTime.now().millisecondsSinceEpoch,
    );
    if (prefs.getInt(Preferences.sessionTimeoutMinutesKey) == null ||
        prefs.getInt(Preferences.sessionTimeoutMinutesKey) == 0) {
      await prefs.setInt(Preferences.sessionTimeoutMinutesKey, 60);
    }

    final email = FirebaseAuth.instance.currentUser?.email;
    if (email != null && email.isNotEmpty) {
      await Preferences.setLastLoginEmail(email);
    }
  }

  Future<void> _showSuccessAndNavigate({required String message}) async {
    ShowToastDialog.closeLoader();
    ShowToastDialog.showToast(message);
    await Future.delayed(const Duration(milliseconds: 800));

    await _saveSessionState();
    Get.offAll(() => const ServiceListScreen());
  }

  Future<void> loginWithEmail() async {
    final email = emailController.value.text.trim();
    final password = passwordController.value.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ShowToastDialog.showToast("Please enter a valid email address".tr);
      return;
    }

    if (password.isEmpty) {
      ShowToastDialog.showToast("Please enter your password".tr);
      return;
    }

    try {
      isLoading.value = true;
      ShowToastDialog.showLoader("Logging in...".tr);

      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userModel = await FireStoreUtils.getUserProfile(
        credential.user!.uid,
      );

      if (userModel != null && userModel.role == Constant.userRoleCustomer) {
        if (userModel.active == true) {
          // Check email verification for email/password accounts
          if (userModel.provider == 'email') {
            await FirebaseAuth.instance.currentUser?.reload();
            if (!(FirebaseAuth.instance.currentUser?.emailVerified ?? false)) {
              ShowToastDialog.closeLoader();
              Get.offAll(() => const VerifyEmailScreen());
              return;
            }
          }

          userModel.fcmToken = await NotificationService.getToken();
          await FireStoreUtils.updateUser(userModel);

          if (userModel.shippingAddress != null &&
              userModel.shippingAddress!.isNotEmpty) {
            final defaultAddress = userModel.shippingAddress!.firstWhere(
              (e) => e.isDefault == true,
              orElse: () => userModel.shippingAddress!.first,
            );

            Constant.selectedLocation = defaultAddress;

            await _showSuccessAndNavigate(message: "Login successful".tr);
          } else if (Preferences.getSkipLocation()) {
            await _showSuccessAndNavigate(message: "Login successful".tr);
          } else {
            await _saveSessionState();
            Get.offAll(() => const LocationPermissionScreen());
          }
        } else {
          await FirebaseAuth.instance.signOut();
          ShowToastDialog.showToast(
            "This user is disabled. Please contact admin.".tr,
          );
          Get.offAll(() => const LoginScreen());
        }
      } else {
        await FirebaseAuth.instance.signOut();
        ShowToastDialog.showToast(
          "This user does not exist in the customer app.".tr,
        );
        Get.offAll(() => const LoginScreen());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ShowToastDialog.showToast("No user found for that email.".tr);
      } else if (e.code == 'wrong-password') {
        ShowToastDialog.showToast("Wrong password provided.".tr);
      } else if (e.code == 'invalid-email') {
        ShowToastDialog.showToast("Invalid email.".tr);
      } else {
        ShowToastDialog.showToast(
          e.message?.tr ?? "Login failed. Please try again.".tr,
        );
      }
    } finally {
      isLoading.value = false;
      ShowToastDialog.closeLoader();
    }
  }

  Future<void> loginWithGoogle() async {
    ShowToastDialog.showLoader("please wait...".tr);
    final value = await signInWithGoogle();
    ShowToastDialog.closeLoader();

    if (value == null || value.user == null) {
      return;
    }

    final isNewUser = value.additionalUserInfo?.isNewUser ?? false;
    final userId = value.user!.uid;
    final email = value.user?.email;
    final displayName = value.user?.displayName;
    final firstName = displayName?.split(' ').first;
    final lastName = displayName?.split(' ').last;

    final userExists = await FireStoreUtils.userExistOrNot(userId);
    if (isNewUser && !userExists) {
      final userModel =
          UserModel()
            ..id = userId
            ..email = email
            ..firstName = firstName
            ..lastName = lastName
            ..provider = 'google';

      Get.off(
        const SignUpScreen(),
        arguments: {"userModel": userModel, "type": "google"},
      );
      return;
    }

    if (userExists) {
      final userModel = await FireStoreUtils.getUserProfile(userId);
      if (userModel == null || userModel.role != Constant.userRoleCustomer) {
        await FirebaseAuth.instance.signOut();
        ShowToastDialog.showToast(
          "This user does not exist in the customer app.".tr,
        );
        Get.offAll(() => const LoginScreen());
        return;
      }

      if (userModel.active != true) {
        await FirebaseAuth.instance.signOut();
        ShowToastDialog.showToast(
          "This user is disabled. Please contact admin.".tr,
        );
        Get.offAll(() => const LoginScreen());
        return;
      }

      userModel.fcmToken = await NotificationService.getToken();
      await FireStoreUtils.updateUser(userModel);

      if (userModel.shippingAddress != null &&
          userModel.shippingAddress!.isNotEmpty) {
        final defaultAddress = userModel.shippingAddress!.firstWhere(
          (e) => e.isDefault == true,
          orElse: () => userModel.shippingAddress!.first,
        );
        Constant.selectedLocation = defaultAddress;
        await _saveSessionState();
        await _showSuccessAndNavigate(message: "Login successful".tr);
        return;
      }

      if (Preferences.getSkipLocation()) {
        await _saveSessionState();
        await _showSuccessAndNavigate(message: "Login successful".tr);
        return;
      }

      await _saveSessionState();
      Get.offAll(() => const LocationPermissionScreen());
      return;
    }

    final newUserModel =
        UserModel()
          ..id = userId
          ..email = email
          ..firstName = firstName
          ..lastName = lastName
          ..provider = 'google';

    Get.off(
      const SignUpScreen(),
      arguments: {"userModel": newUserModel, "type": "google"},
    );
  }

  Future<void> loginWithApple() async {
    ShowToastDialog.showLoader("please wait...".tr);
    final value = await signInWithApple();
    ShowToastDialog.closeLoader();

    if (value == null) {
      return;
    }

    final map = value;
    final AuthorizationCredentialAppleID appleCredential =
        map['appleCredential'];
    final UserCredential userCredential = map['userCredential'];
    final user = userCredential.user;

    if (user == null) {
      ShowToastDialog.showToast(
        "Apple sign-in failed. No authenticated user.".tr,
      );
      return;
    }

    final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
    final userExists = await FireStoreUtils.userExistOrNot(user.uid);

    if (isNewUser && !userExists) {
      final userModel =
          UserModel()
            ..id = user.uid
            ..email = appleCredential.email ?? user.email
            ..firstName = appleCredential.givenName ?? ""
            ..lastName = appleCredential.familyName ?? ""
            ..provider = 'apple';

      Get.off(
        const SignUpScreen(),
        arguments: {"userModel": userModel, "type": "apple"},
      );
      return;
    }

    if (userExists) {
      final userModel = await FireStoreUtils.getUserProfile(user.uid);
      if (userModel == null || userModel.role != Constant.userRoleCustomer) {
        await FirebaseAuth.instance.signOut();
        ShowToastDialog.showToast(
          "This user does not exist in the customer app.".tr,
        );
        Get.offAll(() => const LoginScreen());
        return;
      }

      if (userModel.active != true) {
        await FirebaseAuth.instance.signOut();
        ShowToastDialog.showToast(
          "This user is disabled. Please contact admin.".tr,
        );
        Get.offAll(() => const LoginScreen());
        return;
      }

      userModel.fcmToken = await NotificationService.getToken();
      await FireStoreUtils.updateUser(userModel);

      if (userModel.shippingAddress != null &&
          userModel.shippingAddress!.isNotEmpty) {
        final defaultAddress = userModel.shippingAddress!.firstWhere(
          (e) => e.isDefault == true,
          orElse: () => userModel.shippingAddress!.first,
        );
        Constant.selectedLocation = defaultAddress;
        await _saveSessionState();
        await _showSuccessAndNavigate(message: "Login successful".tr);
        return;
      }

      if (Preferences.getSkipLocation()) {
        await _saveSessionState();
        await _showSuccessAndNavigate(message: "Login successful".tr);
        return;
      }

      await _saveSessionState();
      Get.offAll(() => const LocationPermissionScreen());
      return;
    }

    final userModel =
        UserModel()
          ..id = user.uid
          ..email = appleCredential.email ?? user.email
          ..firstName = appleCredential.givenName ?? ""
          ..lastName = appleCredential.familyName ?? ""
          ..provider = 'apple';

    Get.off(
      const SignUpScreen(),
      arguments: {"userModel": userModel, "type": "apple"},
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        ShowToastDialog.showToast("Google sign-in cancelled");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null && googleAuth.accessToken == null) {
        ShowToastDialog.showToast(
          "Google sign-in failed. Missing authentication tokens.".tr,
        );
        return null;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      return userCredential;
    } catch (e) {
      ShowToastDialog.showToast("Google sign-in failed: ${e.toString()}");
      return null;
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = math.Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Map<String, dynamic>?> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            nonce: nonce,
          );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        oauthCredential,
      );
      return {
        "appleCredential": appleCredential,
        "userCredential": userCredential,
      };
    } catch (e) {
      ShowToastDialog.showToast("Apple sign-in failed: ${e.toString()}".tr);
      return null;
    }
  }
}
