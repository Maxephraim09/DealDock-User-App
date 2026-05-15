import 'package:customer/screen_ui/auth_screens/login_screen.dart';
import 'package:customer/screen_ui/splash_screen/splash_screen.dart';
import 'package:customer/service/biometric_service.dart';
import 'package:customer/service/fire_store_utils.dart';
import 'package:customer/service/localization_service.dart';
import 'package:customer/theme_provider.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/easy_loading_config.dart';
import 'package:customer/utils/app_colors.dart';
import 'package:customer/utils/preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'controllers/global_setting_controller.dart';
import 'controllers/theme_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'default',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Preferences.initPref();

  Get.put(ThemeController());
  await configEasyLoading();

  runApp(
    ChangeNotifierProvider(create: (_) => ThemeProvider(), child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _handleAppResume();
    }
  }

  Future<void> _handleAppResume() async {
    const tag = '[AppResume]';
    debugPrint('$tag App resumed from background');

    try {
      // Check forced logout flag
      final requireLoginOnRestart = Preferences.getBoolean(
        Preferences.requireLoginOnRestartKey,
      );
      if (requireLoginOnRestart) {
        debugPrint('$tag Forced logout flag set, clearing session');
        await FirebaseAuth.instance.signOut();
        await Preferences.clearSessionData();
        if (mounted) Get.offAll(() => const LoginScreen());
        return;
      }

      // Check auto-logout by session timeout
      final autoLogoutEnabled = Preferences.getBoolean(
        Preferences.autoLogoutEnabledKey,
      );
      if (autoLogoutEnabled && Preferences.isSessionExpired()) {
        debugPrint('$tag Session expired, logging out');
        await FirebaseAuth.instance.signOut();
        await Preferences.clearSessionData();
        if (mounted) Get.offAll(() => const LoginScreen());
        return;
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        debugPrint('$tag No Firebase user on resume');
        return;
      }

      // Refresh Firebase auth state and verify user still exists
      debugPrint('$tag Reloading user from Firebase...');
      try {
        await currentUser.reload();
        debugPrint('$tag User reload successful');
      } catch (e) {
        debugPrint('$tag User reload failed: $e');
        await FirebaseAuth.instance.signOut();
        await Preferences.clearSessionData();
        if (mounted) Get.offAll(() => const LoginScreen());
        return;
      }

      // Verify user still exists in Firestore
      debugPrint('$tag Validating user profile in Firestore...');
      final userProfile = await FireStoreUtils.getUserProfile(currentUser.uid);
      if (userProfile == null) {
        debugPrint('$tag User profile missing from Firestore');
        await FirebaseAuth.instance.signOut();
        await Preferences.clearSessionData();
        if (mounted) Get.offAll(() => const LoginScreen());
        return;
      }

      // Check if user account is still active
      if (userProfile.active != true) {
        debugPrint('$tag User account disabled');
        await FirebaseAuth.instance.signOut();
        await Preferences.clearSessionData();
        if (mounted) Get.offAll(() => const LoginScreen());
        return;
      }

      debugPrint('$tag User session validated, updating timestamp');
      await Preferences.updateLastActiveTime();

      // Handle biometric login flow if enabled
      final biometricLoginEnabled = Preferences.biometricLoginEnabled();
      if (biometricLoginEnabled) {
        if (BiometricService.isAuthenticating) {
          debugPrint(
            '$tag Biometric login already in progress, skipping resume-triggered prompt',
          );
          return;
        }

        debugPrint('$tag Biometric login enabled, checking device support...');
        final biometric = BiometricService();
        final availabilityResult = await biometric.checkAvailability();

        if (!availabilityResult.success) {
          debugPrint(
            '$tag Biometric not available after resume: ${availabilityResult.errorCode}',
          );
          // Device no longer supports biometric, disable flag
          await Preferences.setBiometricLoginEnabled(false);
          return;
        }

        debugPrint('$tag Attempting biometric authentication on resume...');
        final authResult = await biometric.authenticate(
          reason: 'Authenticate to continue',
        );

        if (!authResult.success) {
          debugPrint(
            '$tag Biometric auth failed on resume: ${authResult.errorCode}',
          );
          // Don't auto-logout for biometric failures, just end the authentication
          // User can re-login with password if needed
          return;
        }

        debugPrint('$tag Biometric authentication successful on resume');
      }
    } catch (e, stackTrace) {
      debugPrint('$tag Unexpected error during app resume: $e');
      debugPrint('$tag StackTrace: $stackTrace');
      // Don't force logout on unexpected errors, just log and continue
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return SafeArea(
          bottom: true,
          top: false,
          child: EasyLoading.init()(context, child),
        );
      },
      translations: LocalizationService(),
      locale: LocalizationService.locale,
      fallbackLocale: LocalizationService.locale,
      themeMode: context.watch<ThemeProvider>().themeMode,
      theme: ThemeData(
        primaryColor: AppColors.brandPrimaryBlue,
        scaffoldBackgroundColor: AppThemeData.surface,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppThemeData.grey900),
          bodyMedium: TextStyle(color: AppThemeData.grey900),
          bodySmall: TextStyle(color: AppThemeData.grey900),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.brandDeepBlue,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppThemeData.surface,
          selectedItemColor: AppColors.brandPrimaryBlue,
          unselectedItemColor: AppThemeData.grey600,
          selectedLabelStyle: TextStyle(
            fontFamily: AppThemeData.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: AppThemeData.bold,
            fontSize: 12,
          ),
          type: BottomNavigationBarType.fixed,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.brandPrimaryBlue,
        scaffoldBackgroundColor: AppThemeData.backgroundDark,
        canvasColor: AppThemeData.backgroundDark,
        cardColor: AppThemeData.surfaceDarkCard,
        dividerColor: AppThemeData.greyDark700,
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            color: AppThemeData.grey50.withValues(alpha: 230),
          ),
          bodyMedium: TextStyle(
            color: AppThemeData.grey50.withValues(alpha: 217),
          ),
          titleLarge: TextStyle(
            color: AppThemeData.grey50.withValues(alpha: 242),
          ),
          labelLarge: TextStyle(
            color: AppThemeData.grey50.withValues(alpha: 230),
          ),
        ),
        colorScheme: ColorScheme.dark(
          primary: AppColors.brandPrimaryBlue,
          onPrimary: Colors.white,
          secondary: AppThemeData.brandMutedSteelBlue,
          onSecondary: Colors.white,
          surface: AppThemeData.backgroundDark,
          onSurface: AppThemeData.grey50,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppThemeData.surfaceDark,
          foregroundColor: AppThemeData.grey50,
          iconTheme: IconThemeData(color: AppThemeData.grey50),
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppThemeData.surfaceDark,
          selectedItemColor: AppColors.brandPrimaryBlue,
          unselectedItemColor: AppThemeData.grey300,
          selectedLabelStyle: const TextStyle(
            fontFamily: AppThemeData.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: AppThemeData.bold,
            fontSize: 12,
          ),
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home: GetBuilder<GlobalSettingController>(
        init: GlobalSettingController(),
        builder: (context) {
          return const SplashScreen();
        },
      ),
    );
  }
}
