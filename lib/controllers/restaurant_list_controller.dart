import 'package:customer/constant/constant.dart';
import 'package:customer/models/favourite_model.dart';
import 'package:customer/models/vendor_model.dart';
import '../service/fire_store_utils.dart';
import 'package:get/get.dart';

class RestaurantListController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<VendorModel> vendorList = <VendorModel>[].obs;
  RxList<VendorModel> vendorSearchList = <VendorModel>[].obs;

  RxString title = "Restaurants".obs;
  RxString emptyMessage = "No restaurants found".obs;
  RxString errorMessage = ''.obs;

  RxList<FavouriteModel> favouriteList = <FavouriteModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      vendorList.value = argumentData['vendorList'];
      vendorSearchList.value = argumentData['vendorList'];
      title.value = argumentData['title'] ?? "Restaurants";
      await getFavouriteRestaurant();
      isLoading.value = false;
    } else {
      // Fetch all restaurants for service navigation
      vendorList.clear();
      vendorSearchList.clear();
      errorMessage.value = '';
      isLoading.value = true;
      FireStoreUtils.getAllNearestRestaurant().listen(
        (event) {
          vendorList.value = event;
          vendorSearchList.value = event;
          getFavouriteRestaurant();
          isLoading.value = false;
        },
        onError: (error) {
          isLoading.value = false;
          errorMessage.value =
              'Failed to load restaurants. Please check your location permissions and try again.';
          print('Error loading restaurants: $error');
        },
      );

      Future.delayed(const Duration(seconds: 5), () {
        if (isLoading.value && errorMessage.value.isEmpty) {
          isLoading.value = false;
        }
      });
    }
  }

  Future<void> getFavouriteRestaurant() async {
    if (Constant.userModel != null) {
      await FireStoreUtils.getFavouriteRestaurant().then((value) {
        favouriteList.value = value;
      });
    }
  }

  @override
  void dispose() {
    vendorSearchList.clear();
    super.dispose();
  }
}
