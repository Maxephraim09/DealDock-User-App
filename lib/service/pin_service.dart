import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// PIN Management Service
/// Handles all transaction PIN operations with SharedPreferences
class PinService {
  static const String _pinKey = "transaction_pin";
  static const String _pinAttemptKey = "pin_attempts";
  static const String _pinLockedUntilKey = "pin_locked_until";
  static const int _maxAttempts = 5;
  static const int _lockoutDurationMinutes = 15;

  /// Hash PIN using SHA-256
  static String _hashPin(String pin) {
    return sha256.convert(utf8.encode(pin)).toString();
  }

  /// Create a new transaction PIN
  static Future<bool> createPin(String pin) async {
    try {
      // Validate PIN format
      if (!_isValidPin(pin)) {
        return false;
      }

      // Reject weak patterns
      if (_isWeakPin(pin)) {
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      final hashedPin = _hashPin(pin);
      await prefs.setString(_pinKey, hashedPin);
      // Reset attempts on successful PIN creation
      await prefs.setInt(_pinAttemptKey, 0);
      return true;
    } catch (e) {
      print("Error creating PIN: $e");
      return false;
    }
  }

  /// Verify transaction PIN
  static Future<bool> verifyPin(String pin) async {
    try {
      // Check if account is locked
      if (await _isAccountLocked()) {
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      final storedHashedPin = prefs.getString(_pinKey);

      if (storedHashedPin == null) {
        return false; // No PIN set
      }

      final inputHashedPin = _hashPin(pin);

      if (storedHashedPin == inputHashedPin) {
        // Correct PIN - reset attempts
        await prefs.setInt(_pinAttemptKey, 0);
        return true;
      } else {
        // Incorrect PIN - increment attempts
        int attempts = prefs.getInt(_pinAttemptKey) ?? 0;
        attempts++;

        if (attempts >= _maxAttempts) {
          // Lock account
          final lockTime = DateTime.now().add(
            Duration(minutes: _lockoutDurationMinutes),
          );
          await prefs.setInt(
            _pinLockedUntilKey,
            lockTime.millisecondsSinceEpoch,
          );
          await prefs.setInt(_pinAttemptKey, 0);
        } else {
          await prefs.setInt(_pinAttemptKey, attempts);
        }

        return false;
      }
    } catch (e) {
      print("Error verifying PIN: $e");
      return false;
    }
  }

  /// Check if PIN exists
  static Future<bool> pinExists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_pinKey);
    } catch (e) {
      print("Error checking PIN existence: $e");
      return false;
    }
  }

  /// Update PIN
  static Future<bool> updatePin(String oldPin, String newPin) async {
    try {
      // Verify old PIN first
      bool isValid = await verifyPin(oldPin);
      if (!isValid) {
        return false;
      }

      // Validate new PIN format
      if (!_isValidPin(newPin)) {
        return false;
      }

      // Reject weak patterns for new PIN
      if (_isWeakPin(newPin)) {
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      final hashedNewPin = _hashPin(newPin);
      await prefs.setString(_pinKey, hashedNewPin);
      return true;
    } catch (e) {
      print("Error updating PIN: $e");
      return false;
    }
  }

  /// Reset PIN (after email verification)
  static Future<bool> resetPin(String newPin) async {
    try {
      // Validate new PIN format
      if (!_isValidPin(newPin)) {
        return false;
      }

      // Reject weak patterns
      if (_isWeakPin(newPin)) {
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      final hashedNewPin = _hashPin(newPin);
      await prefs.setString(_pinKey, hashedNewPin);
      // Reset attempts
      await prefs.setInt(_pinAttemptKey, 0);
      // Clear lockout
      await prefs.remove(_pinLockedUntilKey);
      return true;
    } catch (e) {
      print("Error resetting PIN: $e");
      return false;
    }
  }

  /// Get remaining attempts before lockout
  static Future<int> getRemainingAttempts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int attempts = prefs.getInt(_pinAttemptKey) ?? 0;
      return _maxAttempts - attempts;
    } catch (e) {
      print("Error getting remaining attempts: $e");
      return _maxAttempts;
    }
  }

  /// Check if account is locked
  static Future<bool> _isAccountLocked() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? lockedUntil = prefs.getInt(_pinLockedUntilKey);

      if (lockedUntil == null) {
        return false; // Not locked
      }

      final lockTime = DateTime.fromMillisecondsSinceEpoch(lockedUntil);
      if (DateTime.now().isAfter(lockTime)) {
        // Lock period expired
        await prefs.remove(_pinLockedUntilKey);
        await prefs.setInt(_pinAttemptKey, 0);
        return false;
      }

      return true;
    } catch (e) {
      print("Error checking account lock: $e");
      return false;
    }
  }

  /// Get remaining lockout time in seconds
  static Future<int> getRemainingLockoutTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? lockedUntil = prefs.getInt(_pinLockedUntilKey);

      if (lockedUntil == null) {
        return 0;
      }

      final lockTime = DateTime.fromMillisecondsSinceEpoch(lockedUntil);
      final remaining = lockTime.difference(DateTime.now()).inSeconds;
      return remaining > 0 ? remaining : 0;
    } catch (e) {
      print("Error getting lockout time: $e");
      return 0;
    }
  }

  /// Validate PIN format (4 digits)
  static bool _isValidPin(String pin) {
    final regex = RegExp(r'^[0-9]{4}$');
    return regex.hasMatch(pin);
  }

  /// Check for weak PIN patterns
  static bool _isWeakPin(String pin) {
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

  /// Delete PIN (for account deletion or reset)
  static Future<bool> deletePin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_pinKey);
      await prefs.remove(_pinAttemptKey);
      await prefs.remove(_pinLockedUntilKey);
      return true;
    } catch (e) {
      print("Error deleting PIN: $e");
      return false;
    }
  }
}
