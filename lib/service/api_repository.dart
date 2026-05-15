import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'offline_storage_service.dart';
import 'network_service.dart';
import 'app_error_handler.dart';
import 'dio_client.dart';
import 'dart:developer' as developer;

/// Generic API repository pattern to separate data layer from UI
/// Handles offline fallback, caching, and network-aware operations
abstract class BaseRepository {
  /// Make API call with offline fallback and caching
  Future<T?> apiCall<T>({
    required Future<T> Function() apiFunction,
    required String cacheKey,
    Duration cacheDuration = const Duration(hours: 1),
    bool forceRefresh = false,
  }) async {
    try {
      // Get network service
      final networkService = NetworkService();

      // If online and not forced to use cache, fetch fresh data
      if (networkService.isOnline.value && !forceRefresh) {
        EasyLoading.show(status: 'Loading...');
        try {
          final result = await AppErrorHandler.withTimeout(apiFunction());
          EasyLoading.dismiss();

          // Cache the successful result
          if (result != null) {
            await OfflineStorageService.cacheData(
              cacheKey,
              result,
              ttl: cacheDuration,
            );
          }

          return result;
        } catch (e) {
          EasyLoading.dismiss();
          developer.log('API call failed: $e');

          // Try to use cached data as fallback
          final cached = OfflineStorageService.getCachedData(cacheKey);
          if (cached != null) {
            developer.log('Using cached data for $cacheKey');
            return cached as T?;
          }

          // If no cache, throw error
          throw AppErrorHandler.getErrorMessage(e);
        }
      } else {
        // Offline - use cached data
        EasyLoading.show(status: 'Using cached data...');
        final cached = OfflineStorageService.getCachedData(cacheKey);
        EasyLoading.dismiss();

        if (cached != null) {
          developer.log('Using cached data for $cacheKey (offline)');
          return cached as T?;
        } else {
          throw 'No cached data available for offline mode';
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      AppErrorHandler.logError('Repository', e);
      rethrow;
    }
  }

  /// Safe API call with error handling (no UI dialogs)
  Future<T?> safeApiCall<T>({required Future<T> Function() apiFunction}) async {
    try {
      return await apiFunction();
    } catch (e) {
      developer.log('Safe API call error: $e');
      return null;
    }
  }

  /// Debounced API call (prevents rapid repeated calls)
  static DateTime? _lastCallTime;
  static String? _lastCallKey;

  Future<T?> debouncedApiCall<T>({
    required Future<T> Function() apiFunction,
    String callKey = 'default',
    Duration debounce = const Duration(milliseconds: 500),
  }) async {
    final now = DateTime.now();

    if (_lastCallKey == callKey &&
        _lastCallTime != null &&
        now.difference(_lastCallTime!) < debounce) {
      developer.log('Debounced API call for $callKey');
      return null;
    }

    _lastCallTime = now;
    _lastCallKey = callKey;

    try {
      return await apiFunction();
    } catch (e) {
      developer.log('Debounced API call error: $e');
      rethrow;
    }
  }
}

/// Example: Wallet Repository
class WalletRepository extends BaseRepository {
  static const String _walletCacheKey = 'wallet_balance';

  /// Get wallet balance with caching
  Future<Map<String, dynamic>?> getWalletBalance() {
    return apiCall<Map<String, dynamic>>(
      apiFunction: () async {
        final response = await DioClient.get(
          'https://api.example.com/wallet/balance',
        );
        return response as Map<String, dynamic>;
      },
      cacheKey: _walletCacheKey,
      cacheDuration: const Duration(minutes: 5),
    );
  }

  /// Add money to wallet (don't cache)
  Future<Map<String, dynamic>?> addMoney(double amount, String paymentMethod) {
    return safeApiCall(
      apiFunction: () async {
        final response = await DioClient.post(
          'https://api.example.com/wallet/add-money',
          data: {'amount': amount, 'paymentMethod': paymentMethod},
        );
        // Invalidate cache after successful transaction
        await OfflineStorageService.clearAllCache();
        return response as Map<String, dynamic>;
      },
    );
  }
}

/// Example: Services Repository
class ServicesRepository extends BaseRepository {
  static const String _servicesCacheKey = 'services_list';

  /// Get available services with caching
  Future<List<dynamic>?> getServices({bool forceRefresh = false}) {
    return apiCall<List<dynamic>>(
      apiFunction: () async {
        final response = await DioClient.get(
          'https://api.example.com/services',
        );
        return response as List<dynamic>;
      },
      cacheKey: _servicesCacheKey,
      cacheDuration: const Duration(hours: 1),
      forceRefresh: forceRefresh,
    );
  }

  /// Search services with debounce
  Future<List<dynamic>?> searchServices(String query) {
    return debouncedApiCall(
      apiFunction: () async {
        final response = await DioClient.get(
          'https://api.example.com/services/search',
          queryParameters: {'q': query},
        );
        return response as List<dynamic>;
      },
      callKey: 'search_services_$query',
      debounce: const Duration(milliseconds: 800),
    );
  }
}

/// Example: Orders Repository
class OrdersRepository extends BaseRepository {
  static const String _ordersCacheKey = 'orders_list';

  /// Get user orders with pagination caching
  Future<List<dynamic>?> getOrders({int page = 1, int pageSize = 10}) {
    return apiCall<List<dynamic>>(
      apiFunction: () async {
        final response = await DioClient.get(
          'https://api.example.com/orders',
          queryParameters: {'page': page, 'pageSize': pageSize},
        );
        return response as List<dynamic>;
      },
      cacheKey: '${_ordersCacheKey}_page_$page',
      cacheDuration: const Duration(minutes: 30),
    );
  }

  /// Submit new order
  Future<Map<String, dynamic>?> submitOrder(Map<String, dynamic> orderData) {
    return safeApiCall(
      apiFunction: () async {
        final response = await DioClient.post(
          'https://api.example.com/orders',
          data: orderData,
        );
        // Invalidate cache after new order
        await OfflineStorageService.clearAllCache();
        return response as Map<String, dynamic>;
      },
    );
  }
}

/// Example: Cart Repository (with offline support)
class CartRepository extends BaseRepository {
  /// Get cart items (from local storage primarily)
  Future<List<dynamic>?> getCartItems() async {
    // Try local storage first
    final localCart = OfflineStorageService.getCartItems();
    if (localCart != null) return localCart;

    // If no local cart, try API
    return safeApiCall(
      apiFunction: () async {
        final response = await DioClient.get('https://api.example.com/cart');
        return response as List<dynamic>;
      },
    );
  }

  /// Save cart items locally
  Future<void> saveCartItems(List<dynamic> items) {
    return OfflineStorageService.saveCartItems(items);
  }

  /// Sync cart to server (when online)
  Future<bool> syncCart() async {
    final networkService = NetworkService();
    if (!networkService.isOnline.value) {
      developer.log('Cannot sync cart - offline');
      return false;
    }

    try {
      final cartItems = OfflineStorageService.getCartItems();
      if (cartItems == null) return true;

      await DioClient.post(
        'https://api.example.com/cart/sync',
        data: {'items': cartItems},
      );

      await OfflineStorageService.clearCart();
      return true;
    } catch (e) {
      developer.log('Cart sync failed: $e');
      return false;
    }
  }
}

/// Example: User Repository
class UserRepository extends BaseRepository {
  /// Get user profile with caching
  Future<Map<String, dynamic>?> getUserProfile() {
    return apiCall<Map<String, dynamic>>(
      apiFunction: () async {
        final response = await DioClient.get(
          'https://api.example.com/user/profile',
        );
        return response as Map<String, dynamic>;
      },
      cacheKey: 'user_profile',
      cacheDuration: const Duration(hours: 2),
    );
  }

  /// Update user profile
  Future<Map<String, dynamic>?> updateUserProfile(
    Map<String, dynamic> updates,
  ) {
    return safeApiCall(
      apiFunction: () async {
        final response = await DioClient.put(
          'https://api.example.com/user/profile',
          data: updates,
        );
        // Invalidate profile cache
        await OfflineStorageService.clearAllCache();
        return response as Map<String, dynamic>;
      },
    );
  }
}
