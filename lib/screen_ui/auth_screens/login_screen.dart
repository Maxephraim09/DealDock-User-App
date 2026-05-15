import 'dart:io';

import 'package:customer/screen_ui/auth_screens/sign_up_screen.dart';
import 'package:customer/screen_ui/location_enable_screens/location_permission_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../constant/constant.dart';
import '../../service/biometric_service.dart';
import '../../service/fire_store_utils.dart';
import '../../service/notification_service.dart';
import '../../service/pin_service.dart';
import 'package:customer/screen_ui/auth_screens/verify_email_screen.dart';
import '../../themes/app_them_data.dart';
import '../../themes/round_button_fill.dart';
import '../../themes/text_field_widget.dart';
import '../../utils/app_colors.dart';
import '../../utils/preferences.dart';
import 'package:get/get.dart';
import '../../screen_ui/service_home_screen/service_list_screen.dart';
import 'forgot_password_screen.dart';
import 'mobile_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool _showBiometricPrompt = false;
  bool _biometricEnabled = false;
  bool _biometricAvailable = false;
  bool _biometricAutoPrompted = false;
  bool _biometricAutoPromptInProgress = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadSavedSessionState();
      await _initializeBiometricState();
    });
  }

  Future<void> _loadSavedSessionState() async {
    final lastLoginEmail = Preferences.lastLoginEmail();
    if (lastLoginEmail.isNotEmpty) {
      debugPrint('[LoginScreen] Loaded saved login email: $lastLoginEmail');
      // Pre-populate email field if controller is available
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        final loginController = Get.find<LoginController>();
        loginController.emailController.value.text = lastLoginEmail;
      }
    }
    final biometricEnabled = Preferences.biometricLoginEnabled();
    if (mounted && biometricEnabled) {
      setState(() {
        _biometricEnabled = true;
      });
    }
  }

  Future<void> _initializeBiometricState() async {
    final biometricEnabled = Preferences.biometricLoginEnabled();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || !biometricEnabled) {
      debugPrint(
        '[LoginScreen] Biometric login not initialized: enabled=$biometricEnabled, user=$user',
      );
      return;
    }

    final biometric = BiometricService();
    final availabilityResult = await biometric.checkAvailability();

    if (!availabilityResult.success) {
      debugPrint(
        '[LoginScreen] Biometric unavailable on login screen: ${availabilityResult.errorCode}',
      );
      if (availabilityResult.failureType ==
              BiometricFailureType.deviceNotSupported ||
          availabilityResult.failureType ==
              BiometricFailureType.noBiometricsEnrolled ||
          availabilityResult.failureType ==
              BiometricFailureType.biometricNotAvailable) {
        await Preferences.setBiometricLoginEnabled(false);
        if (mounted) {
          setState(() {
            _biometricEnabled = false;
            _biometricAvailable = false;
          });
        }
      }
      return;
    }

    if (!mounted) return;
    setState(() {
      _biometricEnabled = true;
      _biometricAvailable = true;
    });

    await _autoPromptBiometricLogin(user);
  }

  Future<void> _autoPromptBiometricLogin(User user) async {
    if (_biometricAutoPrompted || _biometricAutoPromptInProgress) {
      debugPrint('[LoginScreen] Biometric prompt already handled');
      return;
    }

    if (BiometricService.isAuthenticating) {
      debugPrint('[LoginScreen] Biometric authentication already in progress');
      return;
    }

    _biometricAutoPrompted = true;
    _biometricAutoPromptInProgress = true;

    if (!mounted) return;
    setState(() {
      _showBiometricPrompt = true;
    });

    final biometric = BiometricService();
    final authResult = await biometric.authenticate(
      reason: 'Login with your fingerprint',
    );

    if (!mounted) return;
    setState(() {
      _showBiometricPrompt = false;
      _biometricAutoPromptInProgress = false;
    });

    if (authResult.success) {
      debugPrint('[LoginScreen] Biometric authentication successful');
      await _navigateAfterBiometric(user);
      return;
    }

    _showBiometricFailure(authResult);
  }

  Future<void> _attemptFingerprintLogin() async {
    if (BiometricService.isAuthenticating) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometric authentication is already in progress'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No signed-in user available for fingerprint login'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    final biometric = BiometricService();
    final authResult = await biometric.authenticate(
      reason: 'Login with fingerprint',
    );

    if (authResult.success) {
      await _navigateAfterBiometric(user);
      return;
    }

    _showBiometricFailure(authResult);
  }

  void _showBiometricFailure(BiometricResult authResult) {
    if (!mounted) return;

    final message =
        authResult.failureType == BiometricFailureType.userCancelled
            ? 'Fingerprint authentication cancelled'
            : authResult.errorMessage ?? 'Fingerprint authentication failed';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: AppThemeData.danger300,
      ),
    );
  }

  Future<void> _navigateAfterBiometric(User user) async {
    try {
      await user.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;
      if (refreshedUser == null) {
        debugPrint('Firebase user became null after reload');
        await FirebaseAuth.instance.signOut();
        return;
      }

      final userModel = await FireStoreUtils.getUserProfile(refreshedUser.uid);
      if (userModel == null) {
        debugPrint('Biometric login failed: user profile missing');
        await FirebaseAuth.instance.signOut();
        return;
      }

      if (userModel.role != Constant.userRoleCustomer ||
          userModel.active != true) {
        debugPrint('Biometric login failed: user not active or invalid role');
        await FirebaseAuth.instance.signOut();
        return;
      }

      if (userModel.provider == 'email' && !refreshedUser.emailVerified) {
        if (mounted) {
          Get.offAll(() => const VerifyEmailScreen());
        }
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
        if (mounted) {
          Get.offAll(() => const ServiceListScreen());
        }
        return;
      }

      if (Preferences.getSkipLocation()) {
        if (mounted) {
          Get.offAll(() => const ServiceListScreen());
        }
        return;
      }

      if (mounted) {
        Get.offAll(() => const LocationPermissionScreen());
      }
    } catch (e, stack) {
      debugPrint('Biometric login navigation error: $e');
      debugPrint('$stack');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<LoginController>(
      init: LoginController(),
      builder: (controller) {
        final themeController = Get.find<ThemeController>();
        final isDark = themeController.isDark.value;
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            actions: [
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  Get.to(() => LocationPermissionScreen());
                },
                child: Row(
                  children: [
                    Text(
                      "Skip".tr,
                      style: TextStyle(color: AppColors.brandPrimaryBlue),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.brandPrimaryBlue,
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_showBiometricPrompt) ...[
                            const SizedBox(height: 20),
                            Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.fingerprint,
                                    size: 60,
                                    color: const Color(0xFF30588C),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Authenticating with Fingerprint...",
                                    style: AppThemeData.boldTextStyle(
                                      fontSize: 18,
                                      color:
                                          isDark
                                              ? AppThemeData.greyDark900
                                              : AppThemeData.grey900,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF30588C),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _showBiometricPrompt = false;
                                      });
                                    },
                                    child: Text(
                                      "Use Password Instead",
                                      style: AppThemeData.mediumTextStyle(
                                        color: AppThemeData.info400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 52,
                                  height: 1,
                                  color:
                                      isDark
                                          ? AppThemeData.greyDark400
                                          : AppThemeData.grey300,
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  "or".tr,
                                  style: AppThemeData.regularTextStyle(
                                    color:
                                        isDark
                                            ? AppThemeData.greyDark900
                                            : AppThemeData.grey900.withValues(
                                              alpha: 0.60,
                                            ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Container(
                                  width: 52,
                                  height: 1,
                                  color:
                                      isDark
                                          ? AppThemeData.greyDark400
                                          : AppThemeData.grey300,
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                          ],
                          const SizedBox(height: 20),
                          Center(
                            child: Image.asset(
                              'assets/icons/dealdock_logo.png',
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFieldWidget(
                            title: "Email Address*".tr,
                            hintText: "jerome014@gmail.com",
                            controller: controller.emailController.value,
                            focusNode: controller.emailFocusNode,
                          ),
                          const SizedBox(height: 15),
                          TextFieldWidget(
                            title: "Password*".tr,
                            hintText: "Enter password".tr,
                            controller: controller.passwordController.value,
                            obscureText: controller.passwordVisible.value,
                            focusNode: controller.passwordFocusNode,
                            suffix: Padding(
                              padding: const EdgeInsets.all(12),
                              child: InkWell(
                                onTap: () {
                                  controller.passwordVisible.value =
                                      !controller.passwordVisible.value;
                                },
                                child:
                                    controller.passwordVisible.value
                                        ? SvgPicture.asset(
                                          "assets/icons/ic_password_show.svg",
                                          colorFilter: ColorFilter.mode(
                                            isDark
                                                ? AppThemeData.grey300
                                                : AppThemeData.grey600,
                                            BlendMode.srcIn,
                                          ),
                                        )
                                        : SvgPicture.asset(
                                          "assets/icons/ic_password_close.svg",
                                          colorFilter: ColorFilter.mode(
                                            isDark
                                                ? AppThemeData.grey300
                                                : AppThemeData.grey600,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed:
                                    () => Get.to(
                                      () => const ForgotPasswordScreen(),
                                    ),
                                child: Text(
                                  "Forgot Password?".tr,
                                  style: AppThemeData.semiBoldTextStyle(
                                    color: AppThemeData.info400,
                                  ),
                                ),
                              ),
                              if (_biometricEnabled &&
                                  _biometricAvailable &&
                                  FirebaseAuth.instance.currentUser != null)
                                TextButton.icon(
                                  onPressed: _attemptFingerprintLogin,
                                  icon: Icon(
                                    Icons.fingerprint,
                                    color: AppColors.brandPrimaryBlue,
                                    size: 20,
                                  ),
                                  label: Text(
                                    "Fingerprint",
                                    style: TextStyle(
                                      color: AppColors.brandPrimaryBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          RoundedButtonFill(
                            title: "Log in".tr,
                            onPress: controller.loginWithEmail,
                            color: const Color(0xFF30588C),
                            textColor:
                                isDark
                                    ? AppThemeData.surfaceDark
                                    : AppThemeData.surface,
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 52,
                                height: 1,
                                color:
                                    isDark
                                        ? AppThemeData.greyDark400
                                        : AppThemeData.grey300,
                              ),
                              const SizedBox(width: 15),
                              Text(
                                "or continue with".tr,
                                style: AppThemeData.regularTextStyle(
                                  color:
                                      isDark
                                          ? AppThemeData.greyDark900
                                          : AppThemeData.grey900.withValues(
                                            alpha: 0.60,
                                          ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Container(
                                width: 52,
                                height: 1,
                                color:
                                    isDark
                                        ? AppThemeData.greyDark400
                                        : AppThemeData.grey300,
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          RoundedButtonFill(
                            title: "Mobile number".tr,
                            onPress:
                                () => Get.to(() => const MobileLoginScreen()),
                            isRight: false,
                            isCenter: true,
                            icon: Icon(
                              Icons.mobile_friendly_outlined,
                              size: 20,
                              color: isDark ? AppThemeData.greyDark900 : null,
                            ),
                            //Image.asset(AppAssets.icMessage, width: 20, height: 18, color: isDark ? AppThemeData.greyDark900 : null),
                            color:
                                isDark
                                    ? AppThemeData.greyDark400
                                    : AppThemeData.grey300,
                            textColor:
                                isDark
                                    ? AppThemeData.greyDark900
                                    : AppThemeData.grey900,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: RoundedButtonFill(
                                  title: "with Google".tr,
                                  textColor:
                                      isDark
                                          ? AppThemeData.grey100
                                          : AppThemeData.grey900,
                                  color:
                                      isDark
                                          ? AppThemeData.grey900
                                          : AppThemeData.grey100,
                                  icon: SvgPicture.asset(
                                    "assets/icons/ic_google.svg",
                                  ),
                                  isRight: false,
                                  isCenter: true,
                                  onPress: () async {
                                    controller.loginWithGoogle();
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Platform.isIOS
                                  ? Expanded(
                                    child: RoundedButtonFill(
                                      title: "with Apple".tr,
                                      isCenter: true,
                                      textColor:
                                          isDark
                                              ? AppThemeData.grey100
                                              : AppThemeData.grey900,
                                      color:
                                          isDark
                                              ? AppThemeData.grey900
                                              : AppThemeData.grey100,
                                      icon: SvgPicture.asset(
                                        "assets/icons/ic_apple.svg",
                                      ),
                                      isRight: false,
                                      onPress: () async {
                                        controller.loginWithApple();
                                      },
                                    ),
                                  )
                                  : const SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          text: "Didn't have an account?".tr,
                          style: AppThemeData.mediumTextStyle(
                            color:
                                isDark
                                    ? AppThemeData.greyDark900
                                    : AppThemeData.grey900,
                          ),
                          children: [
                            TextSpan(
                              text: "Sign up".tr,
                              style: AppThemeData.mediumTextStyle(
                                color: AppThemeData.ecommerce300,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.offAll(() => const SignUpScreen());
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
