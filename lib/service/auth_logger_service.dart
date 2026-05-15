import 'package:flutter/foundation.dart';

/// Structured logging service for authentication events and errors
/// Provides consistent logging format for debugging and monitoring
class AuthLoggerService {
  static const String _tag = '[AuthLogger]';

  /// Log authentication events with structured data
  static void logEvent({
    required String event,
    required String userId,
    String? errorCode,
    String? errorMessage,
    String? context,
    Map<String, dynamic>? metadata,
  }) {
    final logData = {
      'timestamp': DateTime.now().toIso8601String(),
      'event': event,
      'userId': userId,
      'errorCode': errorCode,
      'errorMessage': errorMessage,
      'context': context,
      'metadata': metadata,
    };

    debugPrint('$_tag EVENT: $logData');
  }

  /// Log authentication errors with stack traces
  static void logError({
    required String operation,
    required String userId,
    required Object error,
    StackTrace? stackTrace,
    String? context,
  }) {
    final logData = {
      'timestamp': DateTime.now().toIso8601String(),
      'operation': operation,
      'userId': userId,
      'error': error.toString(),
      'stackTrace': stackTrace?.toString(),
      'context': context,
    };

    debugPrint('$_tag ERROR: $logData');
  }

  /// Log biometric authentication attempts
  static void logBiometricAttempt({
    required String userId,
    required bool success,
    String? errorCode,
    String? errorMessage,
    String? failureType,
  }) {
    logEvent(
      event: 'biometric_attempt',
      userId: userId,
      errorCode: errorCode,
      errorMessage: errorMessage,
      metadata: {'success': success, 'failureType': failureType},
    );
  }

  /// Log login attempts
  static void logLoginAttempt({
    required String userId,
    required String method,
    required bool success,
    String? errorCode,
    String? errorMessage,
  }) {
    logEvent(
      event: 'login_attempt',
      userId: userId,
      errorCode: errorCode,
      errorMessage: errorMessage,
      metadata: {'method': method, 'success': success},
    );
  }

  /// Log session validation events
  static void logSessionValidation({
    required String userId,
    required bool valid,
    String? reason,
    String? context,
  }) {
    logEvent(
      event: 'session_validation',
      userId: userId,
      context: context,
      metadata: {'valid': valid, 'reason': reason},
    );
  }

  /// Log logout events
  static void logLogout({
    required String userId,
    required String reason,
    String? context,
  }) {
    logEvent(
      event: 'logout',
      userId: userId,
      context: context,
      metadata: {'reason': reason},
    );
  }

  /// Log app lifecycle events
  static void logAppLifecycle({
    required String event,
    String? userId,
    String? context,
  }) {
    final logData = {
      'timestamp': DateTime.now().toIso8601String(),
      'event': event,
      'userId': userId ?? 'unknown',
      'context': context,
    };

    debugPrint('$_tag LIFECYCLE: $logData');
  }
}
