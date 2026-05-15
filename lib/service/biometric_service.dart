import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

/// Structured result for biometric authentication operations
class BiometricResult {
  final bool success;
  final String? errorCode;
  final String? errorMessage;
  final BiometricFailureType? failureType;

  BiometricResult({
    required this.success,
    this.errorCode,
    this.errorMessage,
    this.failureType,
  });

  @override
  String toString() =>
      'BiometricResult(success: $success, error: $errorCode, type: $failureType)';
}

/// Types of biometric failures for granular error handling
enum BiometricFailureType {
  deviceNotSupported,
  noBiometricsEnrolled,
  userCancelled,
  userFallback,
  biometricNotAvailable,
  authenticationFailed,
  other,
}

/// Production-grade biometric service with comprehensive error handling
class BiometricService {
  static const String _tag = '[BiometricService]';
  static bool _isAuthenticating = false;
  final LocalAuthentication _auth = LocalAuthentication();

  /// Returns true when a biometric authentication request is already in progress.
  static bool get isAuthenticating => _isAuthenticating;

  /// Check if device supports biometric authentication
  /// Returns true only if: device supports + biometric available + enrolled
  Future<BiometricResult> checkAvailability() async {
    try {
      debugPrint('$_tag Checking biometric availability...');

      // Check if device supports biometric
      final isDeviceSupported = await _auth.isDeviceSupported();
      if (!isDeviceSupported) {
        debugPrint('$_tag Device does not support biometric');
        return BiometricResult(
          success: false,
          errorCode: 'DEVICE_NOT_SUPPORTED',
          errorMessage: 'This device does not support biometric authentication',
          failureType: BiometricFailureType.deviceNotSupported,
        );
      }

      // Check if can check biometrics
      final canCheckBiometrics = await _auth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        debugPrint('$_tag Cannot check biometrics on this device');
        return BiometricResult(
          success: false,
          errorCode: 'BIOMETRIC_UNAVAILABLE',
          errorMessage: 'Biometric check unavailable on this device',
          failureType: BiometricFailureType.biometricNotAvailable,
        );
      }

      // Check if biometrics are enrolled
      final availableBiometrics = await _auth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        debugPrint('$_tag No biometrics enrolled on device');
        return BiometricResult(
          success: false,
          errorCode: 'NO_BIOMETRICS_ENROLLED',
          errorMessage:
              'No fingerprints, face, or iris enrolled on this device',
          failureType: BiometricFailureType.noBiometricsEnrolled,
        );
      }

      debugPrint('$_tag Biometric available: $availableBiometrics');
      return BiometricResult(success: true);
    } catch (e, stackTrace) {
      debugPrint('$_tag Availability check error: $e');
      debugPrint('$_tag StackTrace: $stackTrace');
      return BiometricResult(
        success: false,
        errorCode: 'AVAILABILITY_CHECK_FAILED',
        errorMessage: 'Failed to check biometric availability: $e',
        failureType: BiometricFailureType.other,
      );
    }
  }

  /// Authenticate user with biometric
  /// Returns structured result with specific error information
  Future<BiometricResult> authenticate({String reason = 'Authenticate'}) async {
    if (_isAuthenticating) {
      debugPrint(
        '$_tag Authentication already in progress, ignoring duplicate request',
      );
      return BiometricResult(
        success: false,
        errorCode: 'AUTH_IN_PROGRESS',
        errorMessage: 'Biometric authentication already in progress',
        failureType: BiometricFailureType.other,
      );
    }

    _isAuthenticating = true;
    try {
      debugPrint('$_tag Starting biometric authentication...');
      debugPrint('$_tag Reason: $reason');

      // First check availability
      final availabilityCheck = await checkAvailability();
      if (!availabilityCheck.success) {
        debugPrint(
          '$_tag Availability check failed: ${availabilityCheck.errorCode}',
        );
        return availabilityCheck;
      }

      // Perform authentication
      final isAuthenticated = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      if (isAuthenticated) {
        debugPrint('$_tag Authentication successful');
        return BiometricResult(success: true);
      } else {
        debugPrint('$_tag Authentication failed (returned false)');
        return BiometricResult(
          success: false,
          errorCode: 'AUTHENTICATION_FAILED',
          errorMessage: 'Biometric authentication failed',
          failureType: BiometricFailureType.authenticationFailed,
        );
      }
    } catch (e, stackTrace) {
      final errorMessage = e.toString();
      debugPrint('$_tag Authentication error: $errorMessage');
      debugPrint('$_tag StackTrace: $stackTrace');

      // Attempt to categorize error from message
      BiometricFailureType failureType = BiometricFailureType.other;

      if (errorMessage.contains('NotAvailable')) {
        failureType = BiometricFailureType.biometricNotAvailable;
      } else if (errorMessage.contains('NotEnrolled')) {
        failureType = BiometricFailureType.noBiometricsEnrolled;
      } else if (errorMessage.contains('LockedOut') ||
          errorMessage.contains('PermanentlyLockedOut')) {
        failureType = BiometricFailureType.authenticationFailed;
      } else if (errorMessage.contains('UserCanceled')) {
        failureType = BiometricFailureType.userCancelled;
        debugPrint('$_tag User cancelled biometric prompt');
      } else if (errorMessage.contains('GoToSettingsButton')) {
        failureType = BiometricFailureType.userFallback;
      }

      return BiometricResult(
        success: false,
        errorCode: errorMessage.split(' ').first,
        errorMessage: errorMessage,
        failureType: failureType,
      );
    } finally {
      _isAuthenticating = false;
    }
  }

  /// Legacy method for backward compatibility (deprecated)
  /// Use checkAvailability() and authenticate() instead
  @Deprecated('Use checkAvailability() and authenticate() instead')
  Future<bool> isAvailable() async {
    final result = await checkAvailability();
    return result.success;
  }
}
