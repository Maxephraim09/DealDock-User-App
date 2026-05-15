import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:async';

/// Service to detect and monitor network connectivity
/// Shows snackbar when connection changes
class NetworkService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  final RxBool isOnline = true.obs;
  final RxString connectionStatus = 'Online'.obs;

  @override
  void onInit() {
    super.onInit();
    _initConnectivityListener();
    _checkInitialConnection();
  }

  /// Initialize real-time connectivity listener
  void _initConnectivityListener() {
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _updateConnectionStatus(result);
    });
  }

  /// Check initial connection state
  Future<void> _checkInitialConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      isOnline.value = false;
    }
  }

  /// Update connection status and show user feedback
  void _updateConnectionStatus(List<ConnectivityResult> result) {
    final wasOnline = isOnline.value;

    // Check if any connection is available
    isOnline.value =
        result.isNotEmpty && !result.contains(ConnectivityResult.none);

    if (wasOnline && !isOnline.value) {
      // Went offline
      connectionStatus.value = 'Offline';
      _showOfflineMessage();
    } else if (!wasOnline && isOnline.value) {
      // Came back online
      connectionStatus.value = 'Online';
      _showOnlineMessage();
    }
  }

  /// Show offline notification
  void _showOfflineMessage() {
    try {
      Get.showSnackbar(
        GetSnackBar(
          title: 'Offline',
          message: 'No internet connection. Using cached data.',
          icon: const Icon(Icons.wifi_off, color: Colors.white),
          backgroundColor: const Color(0xFFE74C3C),
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          snackPosition: SnackPosition.TOP,
        ),
      );
    } catch (e) {
      // Silently fail if snackbar can't be shown
    }
  }

  /// Show online notification
  void _showOnlineMessage() {
    try {
      Get.showSnackbar(
        GetSnackBar(
          title: 'Back Online',
          message: 'Syncing data...',
          icon: const Icon(Icons.wifi, color: Colors.white),
          backgroundColor: const Color(0xFF27AE60),
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          snackPosition: SnackPosition.TOP,
        ),
      );
    } catch (e) {
      // Silently fail if snackbar can't be shown
    }
  }

  /// Manual connectivity check with error handling
  Future<bool> checkConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result.isNotEmpty && !result.contains(ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }

  /// Wait until connection is available
  Future<void> waitForConnection({
    Duration timeout = const Duration(minutes: 5),
  }) async {
    final startTime = DateTime.now();

    while (!isOnline.value) {
      if (DateTime.now().difference(startTime) > timeout) {
        throw Exception('Connection timeout');
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
