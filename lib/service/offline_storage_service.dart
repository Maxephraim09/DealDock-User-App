import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'dart:developer' as developer;

/// Service to manage offline-first local storage using Hive
/// Stores user data, wallet balance, services list, cart items, transaction history
class OfflineStorageService {
  static const String _userBoxName = 'user_data';
  static const String _walletBoxName = 'wallet_data';
  static const String _servicesBoxName = 'services_cache';
  static const String _cartBoxName = 'cart_items';
  static const String _transactionBoxName = 'transactions';
  static const String _appCacheBoxName = 'app_cache';

  static late Box<dynamic> _userBox;
  static late Box<dynamic> _walletBox;
  static late Box<dynamic> _servicesBox;
  static late Box<dynamic> _cartBox;
  static late Box<dynamic> _transactionBox;
  static late Box<dynamic> _cacheBox;

  /// Initialize Hive boxes - call once in main.dart
  static Future<void> initialize() async {
    await Hive.initFlutter();

    try {
      _userBox = await Hive.openBox(_userBoxName);
      _walletBox = await Hive.openBox(_walletBoxName);
      _servicesBox = await Hive.openBox(_servicesBoxName);
      _cartBox = await Hive.openBox(_cartBoxName);
      _transactionBox = await Hive.openBox(_transactionBoxName);
      _cacheBox = await Hive.openBox(_appCacheBoxName);

      developer.log('Hive boxes initialized successfully');
    } catch (e) {
      developer.log('Error initializing Hive: $e');
      rethrow;
    }
  }

  // ========== USER DATA ==========

  /// Save user profile locally
  static Future<void> saveUserProfile(Map<String, dynamic> userData) async {
    try {
      await _userBox.put('user_profile', jsonEncode(userData));
      developer.log('User profile saved locally');
    } catch (e) {
      developer.log('Error saving user profile: $e');
    }
  }

  /// Get cached user profile
  static Map<String, dynamic>? getUserProfile() {
    try {
      final data = _userBox.get('user_profile');
      if (data == null) return null;
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (e) {
      developer.log('Error retrieving user profile: $e');
      return null;
    }
  }

  /// Save auth token for offline persistence
  static Future<void> saveAuthToken(String token) async {
    try {
      await _userBox.put('auth_token', token);
    } catch (e) {
      developer.log('Error saving auth token: $e');
    }
  }

  /// Get cached auth token
  static String? getAuthToken() {
    try {
      return _userBox.get('auth_token') as String?;
    } catch (e) {
      return null;
    }
  }

  // ========== WALLET DATA ==========

  /// Save wallet balance (last known state)
  static Future<void> saveWalletBalance(
    double balance,
    DateTime lastUpdated,
  ) async {
    try {
      final data = {
        'balance': balance,
        'lastUpdated': lastUpdated.toIso8601String(),
      };
      await _walletBox.put('balance', jsonEncode(data));
    } catch (e) {
      developer.log('Error saving wallet balance: $e');
    }
  }

  /// Get last known wallet balance
  static Map<String, dynamic>? getWalletBalance() {
    try {
      final data = _walletBox.get('balance');
      if (data == null) return null;
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (e) {
      developer.log('Error retrieving wallet balance: $e');
      return null;
    }
  }

  // ========== SERVICES LIST (CACHE) ==========

  /// Cache services list for offline access
  static Future<void> cacheServicesList(List<dynamic> services) async {
    try {
      await _servicesBox.put('services_list', jsonEncode(services));
      await _servicesBox.put(
        'services_updated',
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      developer.log('Error caching services: $e');
    }
  }

  /// Get cached services list
  static List<dynamic>? getCachedServicesList() {
    try {
      final data = _servicesBox.get('services_list');
      if (data == null) return null;
      return jsonDecode(data) as List<dynamic>;
    } catch (e) {
      developer.log('Error retrieving cached services: $e');
      return null;
    }
  }

  /// Get services cache timestamp
  static DateTime? getServicesCacheTime() {
    try {
      final timestamp = _servicesBox.get('services_updated') as String?;
      if (timestamp == null) return null;
      return DateTime.parse(timestamp);
    } catch (e) {
      return null;
    }
  }

  // ========== CART ITEMS ==========

  /// Save cart items for offline persistence
  static Future<void> saveCartItems(List<dynamic> items) async {
    try {
      await _cartBox.put('cart_items', jsonEncode(items));
      await _cartBox.put('cart_updated', DateTime.now().toIso8601String());
    } catch (e) {
      developer.log('Error saving cart items: $e');
    }
  }

  /// Get cached cart items
  static List<dynamic>? getCartItems() {
    try {
      final data = _cartBox.get('cart_items');
      if (data == null) return null;
      return jsonDecode(data) as List<dynamic>;
    } catch (e) {
      developer.log('Error retrieving cart items: $e');
      return null;
    }
  }

  /// Check if cart has pending changes
  static bool hasCartChanges() {
    return _cartBox.get('cart_items') != null;
  }

  /// Clear cart after sync
  static Future<void> clearCart() async {
    try {
      await _cartBox.delete('cart_items');
      await _cartBox.delete('cart_updated');
    } catch (e) {
      developer.log('Error clearing cart: $e');
    }
  }

  // ========== TRANSACTION HISTORY ==========

  /// Cache transaction history
  static Future<void> cacheTransactionHistory(
    List<dynamic> transactions,
  ) async {
    try {
      await _transactionBox.put(
        'transaction_history',
        jsonEncode(transactions),
      );
      await _transactionBox.put(
        'transactions_updated',
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      developer.log('Error caching transactions: $e');
    }
  }

  /// Get cached transaction history
  static List<dynamic>? getCachedTransactionHistory() {
    try {
      final data = _transactionBox.get('transaction_history');
      if (data == null) return null;
      return jsonDecode(data) as List<dynamic>;
    } catch (e) {
      developer.log('Error retrieving cached transactions: $e');
      return null;
    }
  }

  // ========== GENERIC CACHE (API RESPONSES) ==========

  /// Cache any API response with TTL
  static Future<void> cacheData(
    String key,
    dynamic data, {
    Duration ttl = const Duration(hours: 24),
  }) async {
    try {
      final cacheData = {
        'data': jsonEncode(data),
        'timestamp': DateTime.now().toIso8601String(),
        'ttl': ttl.inSeconds,
      };
      await _cacheBox.put(key, jsonEncode(cacheData));
    } catch (e) {
      developer.log('Error caching data for $key: $e');
    }
  }

  /// Get cached data if not expired
  static dynamic getCachedData(String key) {
    try {
      final cacheEntry = _cacheBox.get(key);
      if (cacheEntry == null) return null;

      final decoded = jsonDecode(cacheEntry) as Map<String, dynamic>;
      final timestamp = DateTime.parse(decoded['timestamp'] as String);
      final ttl = Duration(seconds: decoded['ttl'] as int);

      // Check if cache expired
      if (DateTime.now().difference(timestamp) > ttl) {
        _cacheBox.delete(key); // Clean up expired cache
        return null;
      }

      return jsonDecode(decoded['data']);
    } catch (e) {
      developer.log('Error retrieving cached data for $key: $e');
      return null;
    }
  }

  /// Clear all cache
  static Future<void> clearAllCache() async {
    try {
      await _cacheBox.clear();
      developer.log('All cache cleared');
    } catch (e) {
      developer.log('Error clearing cache: $e');
    }
  }

  /// Clear expired cache
  static Future<void> clearExpiredCache() async {
    try {
      final expiredKeys = <String>[];

      for (var key in _cacheBox.keys) {
        final cacheEntry = _cacheBox.get(key);
        if (cacheEntry != null) {
          try {
            final decoded = jsonDecode(cacheEntry) as Map<String, dynamic>;
            final timestamp = DateTime.parse(decoded['timestamp'] as String);
            final ttl = Duration(seconds: decoded['ttl'] as int);

            if (DateTime.now().difference(timestamp) > ttl) {
              expiredKeys.add(key);
            }
          } catch (e) {
            expiredKeys.add(key);
          }
        }
      }

      for (var key in expiredKeys) {
        await _cacheBox.delete(key);
      }

      developer.log('Expired cache cleared: ${expiredKeys.length} entries');
    } catch (e) {
      developer.log('Error clearing expired cache: $e');
    }
  }

  /// Get cache statistics
  static Map<String, int> getCacheStats() {
    return {
      'users': _userBox.length,
      'wallet': _walletBox.length,
      'services': _servicesBox.length,
      'cart': _cartBox.length,
      'transactions': _transactionBox.length,
      'appCache': _cacheBox.length,
    };
  }

  /// Backup all local data (for debugging)
  static Map<String, dynamic> backupAllData() {
    return {
      'user': _userBox.toMap(),
      'wallet': _walletBox.toMap(),
      'services': _servicesBox.toMap(),
      'cart': _cartBox.toMap(),
      'transactions': _transactionBox.toMap(),
      'cache': _cacheBox.toMap(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Close all boxes (call in app termination)
  static Future<void> closeAllBoxes() async {
    try {
      await _userBox.close();
      await _walletBox.close();
      await _servicesBox.close();
      await _cartBox.close();
      await _transactionBox.close();
      await _cacheBox.close();
      developer.log('All Hive boxes closed');
    } catch (e) {
      developer.log('Error closing boxes: $e');
    }
  }
}
