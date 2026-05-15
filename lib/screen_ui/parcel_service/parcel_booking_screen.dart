import 'package:customer/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/constant.dart';
import '../../controllers/theme_controller.dart';
import '../../models/user_model.dart';
import '../../themes/text_field_widget.dart';
import '../../widget/place_picker/location_picker_screen.dart';
import '../../widget/place_picker/selected_location_model.dart';
import '../location_enable_screens/address_list_screen.dart';
import 'parcel_summary_screen.dart';

class ParcelBookingScreen extends StatefulWidget {
  const ParcelBookingScreen({super.key});

  @override
  State<ParcelBookingScreen> createState() => _ParcelBookingScreenState();
}

class _ParcelBookingScreenState extends State<ParcelBookingScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form data
  ShippingAddress? pickupAddress;
  ShippingAddress? deliveryAddress;
  String parcelType = 'Document';
  double weight = 1.0;
  String description = '';
  String deliveryType = 'Send Now';
  DateTime? scheduledDateTime;

  final List<String> parcelTypes = [
    'Document',
    'Food',
    'Electronics',
    'Others',
  ];
  final List<String> deliveryTypes = ['Send Now', 'Schedule'];

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

    return Scaffold(
      backgroundColor: isDark ? AppThemeData.surfaceDark : AppThemeData.grey50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppThemeData.brandDeepBlue,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () => Get.back(),
                child: Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Book Parcel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pickup Location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppThemeData.brandMutedSteelBlue,
                  ),
                ),
                const SizedBox(height: 8),
                _buildAddressSelector(
                  address: pickupAddress,
                  hint: 'Select pickup address',
                  onTap: () => _selectPickupAddress(),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Delivery Location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppThemeData.brandMutedSteelBlue,
                  ),
                ),
                const SizedBox(height: 8),
                _buildAddressSelector(
                  address: deliveryAddress,
                  hint: 'Select delivery address',
                  onTap: () => _selectDeliveryAddress(),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Parcel Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppThemeData.brandMutedSteelBlue,
                  ),
                ),
                const SizedBox(height: 16),
                _buildParcelTypeDropdown(),
                const SizedBox(height: 16),
                _buildWeightInput(),
                const SizedBox(height: 16),
                _buildDescriptionInput(),
                const SizedBox(height: 24),
                const Text(
                  'Delivery Type',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppThemeData.brandMutedSteelBlue,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDeliveryTypeSelector(),
                const SizedBox(height: 32),
                _buildPriceEstimation(),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _proceedToSummary,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemeData.brandPrimaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Continue'.tr,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressSelector({
    required ShippingAddress? address,
    required String hint,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.location_on,
              color: AppThemeData.brandPrimaryBlue,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                address?.locality ?? hint,
                style: TextStyle(
                  fontSize: 16,
                  color: address != null ? Colors.black : Colors.grey,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildParcelTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: parcelType,
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: 'Parcel Type',
        ),
        items:
            parcelTypes.map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
        onChanged: (value) {
          setState(() {
            parcelType = value!;
          });
        },
      ),
    );
  }

  Widget _buildWeightInput() {
    return TextFieldWidget(
      title: 'Weight (kg)',
      hintText: 'Enter weight in kg',
      controller: TextEditingController(text: weight.toString()),
      textInputType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          weight = double.tryParse(value) ?? 1.0;
        });
      },
    );
  }

  Widget _buildDescriptionInput() {
    return TextFieldWidget(
      title: 'Description (Optional)',
      hintText: 'Enter parcel description',
      controller: TextEditingController(text: description),
      textInputType: TextInputType.multiline,
      maxLine: 3,
      onChanged: (value) {
        description = value;
      },
    );
  }

  Widget _buildDeliveryTypeSelector() {
    return Column(
      children: [
        Row(
          children:
              deliveryTypes.map((type) {
                final isSelected = deliveryType == type;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        deliveryType = type;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? AppThemeData.brandPrimaryBlue
                                : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isSelected
                                  ? AppThemeData.brandPrimaryBlue
                                  : Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            type == 'Schedule'
                                ? Icons.schedule
                                : Icons.flash_on,
                            color:
                                isSelected
                                    ? Colors.white
                                    : AppThemeData.brandPrimaryBlue,
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            type,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color:
                                  isSelected
                                      ? Colors.white
                                      : AppThemeData.brandMutedSteelBlue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            type == 'Schedule'
                                ? 'Pick date & time'
                                : 'Immediate',
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? Colors.white70 : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
        if (deliveryType == 'Schedule') ...[
          const SizedBox(height: 16),
          _buildScheduleDateTimePicker(),
        ],
      ],
    );
  }

  Widget _buildScheduleDateTimePicker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Schedule Delivery',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppThemeData.brandMutedSteelBlue,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              final selected = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 1)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
              );
              if (selected != null) {
                setState(() {
                  scheduledDateTime = selected;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: AppThemeData.brandPrimaryBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    scheduledDateTime != null
                        ? '${scheduledDateTime!.day}/${scheduledDateTime!.month}/${scheduledDateTime!.year}'
                        : 'Select Date',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppThemeData.brandMutedSteelBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              final selected = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (selected != null && scheduledDateTime != null) {
                setState(() {
                  scheduledDateTime = scheduledDateTime!.copyWith(
                    hour: selected.hour,
                    minute: selected.minute,
                  );
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: AppThemeData.brandPrimaryBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    scheduledDateTime != null
                        ? '${scheduledDateTime!.hour}:${scheduledDateTime!.minute.toString().padLeft(2, '0')}'
                        : 'Select Time',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppThemeData.brandMutedSteelBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceEstimation() {
    final basePrice = 1000.0; // Base price in Naira
    final weightMultiplier = weight * 200; // ₦200 per kg
    final expressMultiplier = deliveryType == 'Express' ? 1.5 : 1.0;
    final scheduleMultiplier = deliveryType == 'Schedule' ? 0.85 : 1.0;
    final total =
        (basePrice + weightMultiplier) * expressMultiplier * scheduleMultiplier;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Estimation',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppThemeData.brandMutedSteelBlue,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Base fee'),
              Text('₦${basePrice.toStringAsFixed(0)}'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Weight (${weight}kg)'),
              Text('₦${weightMultiplier.toStringAsFixed(0)}'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery (${deliveryType.toLowerCase()})'),
              Text(scheduleMultiplier == 1.0 ? 'Standard' : '-15%'),
            ],
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '₦${total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppThemeData.brandPrimaryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _selectPickupAddress() async {
    if (Constant.userModel != null) {
      final result = await Get.to(const AddressListScreen());
      if (result != null && result is ShippingAddress) {
        setState(() {
          pickupAddress = result;
        });
      }
    } else {
      // Handle guest user - use location picker
      final result = await Get.to(() => const LocationPickerScreen());
      if (result != null && result is SelectedLocationModel) {
        final address = ShippingAddress(
          addressAs: 'Pickup',
          locality: result.address?.toString() ?? 'Selected Location',
          location: UserLocation(
            latitude: result.latLng?.latitude ?? 0.0,
            longitude: result.latLng?.longitude ?? 0.0,
          ),
        );
        setState(() {
          pickupAddress = address;
        });
      }
    }
  }

  void _selectDeliveryAddress() async {
    if (Constant.userModel != null) {
      final result = await Get.to(const AddressListScreen());
      if (result != null && result is ShippingAddress) {
        setState(() {
          deliveryAddress = result;
        });
      }
    } else {
      // Handle guest user - use location picker
      final result = await Get.to(() => const LocationPickerScreen());
      if (result != null && result is SelectedLocationModel) {
        final address = ShippingAddress(
          addressAs: 'Delivery',
          locality: result.address?.toString() ?? 'Selected Location',
          location: UserLocation(
            latitude: result.latLng?.latitude ?? 0.0,
            longitude: result.latLng?.longitude ?? 0.0,
          ),
        );
        setState(() {
          deliveryAddress = address;
        });
      }
    }
  }

  void _proceedToSummary() {
    if (_formKey.currentState?.validate() ?? false) {
      if (pickupAddress == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select pickup address')),
        );
        return;
      }
      if (deliveryAddress == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select delivery address')),
        );
        return;
      }

      final parcelData = {
        'pickupAddress': pickupAddress,
        'deliveryAddress': deliveryAddress,
        'parcelType': parcelType,
        'weight': weight,
        'description': description,
        'deliveryType': deliveryType,
        'scheduledDateTime': scheduledDateTime,
        'estimatedPrice': _calculatePrice(),
      };

      Get.to(ParcelSummaryScreen(parcelData: parcelData));
    }
  }

  double _calculatePrice() {
    final basePrice = 1000.0;
    final weightMultiplier = weight * 200;
    final scheduleMultiplier = deliveryType == 'Schedule' ? 0.85 : 1.0;
    return (basePrice + weightMultiplier) * scheduleMultiplier;
  }
}
