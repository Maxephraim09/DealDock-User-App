import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/gift_card_controller.dart';
import 'package:customer/models/gift_cards_model.dart';
import 'package:customer/screen_ui/multi_vendor_service/gift_card/redeem_gift_card_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/gift_card/select_gift_payment_screen.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/themes/text_field_widget.dart';
import 'package:customer/utils/network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../controllers/theme_controller.dart';
import '../../../themes/show_toast_dialog.dart';
import 'history_gift_card.dart';
import 'buy_gift_card_screen.dart';

class GiftCardScreen extends StatefulWidget {
  const GiftCardScreen({super.key});

  @override
  State<GiftCardScreen> createState() => _GiftCardScreenState();
}

class _GiftCardScreenState extends State<GiftCardScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          "Gift Card".tr,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontFamily: AppThemeData.medium,
            fontSize: 16,
            color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.to(const HistoryGiftCard());
            },
            child: SvgPicture.asset("assets/icons/ic_history.svg"),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              Get.to(const RedeemGiftCardScreen());
            },
            child: SvgPicture.asset("assets/icons/ic_redeem.svg"),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // Tab Selection
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppThemeData.grey700 : Colors.grey.shade200,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(child: _buildTabButton('Buy', 0, isDark)),
                const SizedBox(width: 12),
                Expanded(child: _buildTabButton('Sell', 1, isDark)),
              ],
            ),
          ),
          // Tab Content
          Expanded(
            child:
                _selectedTabIndex == 1
                    ? const _SellGiftCardContent()
                    : Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index, bool isDark) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          // Navigate to BuyGiftCardScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BuyGiftCardScreen()),
          );
        } else {
          setState(() {
            _selectedTabIndex = index;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF30588C) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? const Color(0xFF30588C)
                    : (isDark ? AppThemeData.grey700 : Colors.grey.shade300),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color:
                  isSelected
                      ? Colors.white
                      : (isDark
                          ? AppThemeData.grey300
                          : const Color(0xFF3D5A73)),
            ),
          ),
        ),
      ),
    );
  }
}

class _SellGiftCardContent extends StatelessWidget {
  const _SellGiftCardContent();

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

    // Mock gift card data for sell
    final giftCardsForSell = [
      {
        'id': '1',
        'name': 'iTunes',
        'image': 'https://via.placeholder.com/150?text=iTunes',
      },
      {
        'id': '2',
        'name': 'Google Play',
        'image': 'https://via.placeholder.com/150?text=GooglePlay',
      },
      {
        'id': '3',
        'name': 'Amazon',
        'image': 'https://via.placeholder.com/150?text=Amazon',
      },
      {
        'id': '4',
        'name': 'PlayStation',
        'image': 'https://via.placeholder.com/150?text=PSN',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sell Your Gift Cards'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppThemeData.grey50 : const Color(0xFF3D5A73),
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: giftCardsForSell.length,
              itemBuilder: (context, index) {
                final giftCard = giftCardsForSell[index];
                return GestureDetector(
                  onTap: () {
                    _showSellFlowDialog(context, giftCard, isDark);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isDark
                                ? AppThemeData.grey700
                                : Colors.grey.shade200,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(
                              0xFF30588C,
                            ).withValues(alpha: 0.1),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              giftCard['image']!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.card_giftcard,
                                  color: const Color(0xFF30588C),
                                  size: 40,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          giftCard['name']!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color:
                                isDark ? Colors.white : const Color(0xFF3D5A73),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to sell'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppThemeData.grey400 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSellFlowDialog(
    BuildContext context,
    Map<String, String> giftCard,
    bool isDark,
  ) {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppThemeData.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Sell ${giftCard['name']}'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF3D5A73),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Enter Amount'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color:
                          isDark
                              ? AppThemeData.grey50
                              : const Color(0xFF3D5A73),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter amount',
                      prefixText: '₦ ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor:
                          isDark ? AppThemeData.grey900 : Colors.grey.shade100,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (amountController.text.isEmpty) {
                          ShowToastDialog.showToast(
                            'Please enter an amount'.tr,
                          );
                          return;
                        }
                        ShowToastDialog.showToast(
                          'Processing your ${giftCard['name']} sale...'.tr,
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF30588C),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Proceed',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF30588C)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: const Color(0xFF30588C),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
