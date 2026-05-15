import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const isFinishOnBoardingKey = "isFinishOnBoardingKey";
  static const isLogin = "isLogin";
  static const accessToken = "accessToken";
  static const userData = "userData";
  static const themKey = "themKey";
  static const languageCodeKey = 'languageCodeKey';
  static const skipLocationKey = 'skip_location';
  static const skipLocationLegacyKey = 'skipLocation';
  static const requireLoginOnRestartKey = 'require_login_on_restart';
  static const passwordFreeLoginKey = 'password_free_login';
  static const autoLogoutEnabledKey = 'auto_logout_enabled';
  static const biometricEnabledKey = 'biometric_enabled';
  static const lastLoginEmailKey = 'last_login_email';
  static const sessionTimeoutMinutesKey = 'session_timeout_minutes';
  static const lastActiveTimeKey = 'last_active_time';
  static const zipcode = 'zipcode';
  static const foodDeliveryType = "foodDeliveryType";
  static const payFastSettings = "payFastSettings";
  static const mercadoPago = "MercadoPago";
  static const paypalSettings = "paypalSettings";
  static const stripeSettings = "stripeSettings";
  static const flutterWave = "flutterWave";
  static const payStack = "payStack";
  static const paytmSettings = "PaytmSettings";
  static const walletSettings = "walletSettings";
  static const razorpaySettings = "razorpaySettings";
  static const codSettings = "CODSettings";
  static const midTransSettings = "midTransSettings";
  static const orangeMoneySettings = "orangeMoneySettings";
  static const xenditSettings = "xenditSettings";

  static late SharedPreferences pref;

  static Future<void> initPref() async {
    pref = await SharedPreferences.getInstance();
  }

  /// Get boolean safely, fallback if stored value is string
  static bool getBoolean(String key) {
    final value = pref.get(key);
    if (value is bool) return value;
    if (value is String) {
      final lower = value.toLowerCase();
      if (lower == 'true' || lower == 'false') {
        return lower == 'true';
      }
      // fallback for old string values such as "Dark"/"Light"
      return lower == "dark";
    }
    return false;
  }

  static Future<void> setBoolean(String key, bool value) async {
    await pref.setBool(key, value);
  }

  static bool requireLoginOnRestart() {
    return getBoolean(requireLoginOnRestartKey);
  }

  static Future<void> setRequireLoginOnRestart(bool value) async {
    await setBoolean(requireLoginOnRestartKey, value);
  }

  static bool passwordFreeLogin() {
    return getBoolean(passwordFreeLoginKey);
  }

  static Future<void> setPasswordFreeLogin(bool value) async {
    await setBoolean(passwordFreeLoginKey, value);
  }

  static bool biometricLoginEnabled() {
    return getBoolean(biometricEnabledKey);
  }

  static Future<void> setBiometricLoginEnabled(bool value) async {
    await setBoolean(biometricEnabledKey, value);
  }

  static String lastLoginEmail() {
    return getString(lastLoginEmailKey);
  }

  static Future<void> setLastLoginEmail(String value) async {
    await setString(lastLoginEmailKey, value);
  }

  static Future<void> clearLastLoginEmail() async {
    await pref.remove(lastLoginEmailKey);
  }

  static bool autoLogoutEnabled() {
    return getBoolean(autoLogoutEnabledKey);
  }

  static Future<void> setAutoLogoutEnabled(bool value) async {
    await setBoolean(autoLogoutEnabledKey, value);
  }

  static int getSessionTimeoutMinutes() {
    return getInt(sessionTimeoutMinutesKey) == 0
        ? 60
        : getInt(sessionTimeoutMinutesKey);
  }

  static Future<void> setSessionTimeoutMinutes(int value) async {
    await setInt(sessionTimeoutMinutesKey, value);
  }

  static bool isSessionExpired() {
    final lastActive = pref.getInt(lastActiveTimeKey) ?? 0;
    final timeout = getSessionTimeoutMinutes();
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - lastActive) > (timeout * 60 * 1000);
  }

  static Future<void> updateLastActiveTime() async {
    await setInt(lastActiveTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  static bool getSkipLocation() {
    if (pref.containsKey(skipLocationKey)) {
      return getBoolean(skipLocationKey);
    }
    if (pref.containsKey(skipLocationLegacyKey)) {
      return getBoolean(skipLocationLegacyKey);
    }
    return false;
  }

  static Future<void> setSkipLocation(bool value) async {
    await setBoolean(skipLocationKey, value);
    await pref.setBool(skipLocationLegacyKey, value);
  }

  static String getString(String key, {String? defaultValue}) {
    return pref.getString(key) ?? defaultValue ?? "";
  }

  static Future<void> setString(String key, String value) async {
    await pref.setString(key, value);
  }

  static int getInt(String key) {
    return pref.getInt(key) ?? 0;
  }

  static Future<void> setInt(String key, int value) async {
    await pref.setInt(key, value);
  }

  static Future<void> clearSessionData() async {
    // Clear all session-related flags and data on logout
    // This ensures complete cleanup and prevents auth state leakage

    // Clear login flags
    await pref.remove('is_logged_in');
    await pref.remove(isLogin);

    // Clear session timing
    await setInt(lastActiveTimeKey, 0);

    // Clear biometric state - CRITICAL for security
    await setBoolean(biometricEnabledKey, false);

    // Clear password-free login flag
    await setBoolean(passwordFreeLoginKey, false);

    // Keep last login email for friendly fallback when the user returns.
    // This does not unlock the account by itself.
    // await clearLastLoginEmail(); // intentionally retained for remembered identity

    // Clear PIN session state if it exists
    await pref.remove('pin_session_authorized');
    await pref.remove('pin_session_timestamp');

    // Clear authentication tokens/data
    await pref.remove(accessToken);
    await pref.remove(userData);
  }

  static Future<void> clearSharPreference() async {
    await pref.clear();
  }

  static Future<void> clearKeyData(String key) async {
    await pref.remove(key);
  }
}
