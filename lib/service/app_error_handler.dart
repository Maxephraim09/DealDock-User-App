import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

/// Global error handler for the entire app
/// Prevents app crashes and provides user feedback
class AppErrorHandler {
  static void initialize() {
    // Handle Flutter errors
    FlutterError.onError = (FlutterErrorDetails details) {
      developer.log(
        'Flutter Error: ${details.exception}',
        error: details.exception,
        stackTrace: details.stack,
      );
      _showErrorDialog('An unexpected error occurred');
    };

    // Handle uncaught exceptions in zones
    PlatformDispatcher.instance.onError = (error, stack) {
      developer.log('Platform Error: $error', error: error, stackTrace: stack);
      _showErrorDialog('A critical error occurred');
      return true;
    };
  }

  /// Show error dialog to user
  static void _showErrorDialog(String message) {
    try {
      if (Get.isDialogOpen ?? false) return;

      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('OK')),
          ],
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      developer.log('Error showing dialog: $e');
    }
  }

  /// Handle API errors gracefully
  static String getErrorMessage(dynamic error) {
    if (error is String) return error;

    final errorString = error.toString();

    if (errorString.contains('SocketException')) {
      return 'Network error. Please check your connection.';
    } else if (errorString.contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    } else if (errorString.contains('FormatException')) {
      return 'Invalid response format.';
    } else if (errorString.contains('401')) {
      return 'Unauthorized. Please login again.';
    } else if (errorString.contains('403')) {
      return 'Access denied.';
    } else if (errorString.contains('404')) {
      return 'Resource not found.';
    } else if (errorString.contains('500')) {
      return 'Server error. Please try again later.';
    }

    return error.toString();
  }

  /// Log errors safely
  static void logError(String tag, dynamic error, [StackTrace? stackTrace]) {
    developer.log(
      '$tag: $error',
      error: error,
      stackTrace: stackTrace,
      name: 'AppError',
    );
  }

  /// Show loading with timeout protection
  static Future<T> withTimeout<T>(
    Future<T> future, {
    Duration timeout = const Duration(seconds: 30),
  }) {
    return future.timeout(
      timeout,
      onTimeout: () {
        EasyLoading.dismiss();
        throw TimeoutException('Request took too long');
      },
    );
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => message;
}
