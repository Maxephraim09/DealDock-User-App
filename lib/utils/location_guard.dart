import 'package:customer/constant/constant.dart';
import 'package:customer/screen_ui/location_enable_screens/location_permission_screen.dart';
import 'package:customer/utils/preferences.dart';
import 'package:get/get.dart';

class LocationGuard {
  /// Ensures the user has selected or saved a location before allowing service navigation.
  /// Users may bypass the initial app entry step via skip_location, but service actions
  /// still require a valid address and will redirect to LocationPermissionScreen.
  static Future<bool> ensureLocationForService() async {
    final hasSelectedLocation =
        Constant.selectedLocation.getFullAddress().isNotEmpty;
    final hasSavedAddress =
        Constant.userModel?.shippingAddress?.isNotEmpty ?? false;

    if (hasSelectedLocation || hasSavedAddress) {
      return true;
    }

    // Clear skip marker for service use so that user is prompted to add location.
    await Preferences.setSkipLocation(false);
    Get.offAll(() => const LocationPermissionScreen());
    return false;
  }
}
