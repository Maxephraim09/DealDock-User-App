import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/controllers/theme_controller.dart';
import 'package:customer/themes/show_toast_dialog.dart';

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({super.key});

  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

    return Scaffold(
      backgroundColor: isDark ? AppThemeData.surfaceDark : AppThemeData.grey50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF2E608C),
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
                'Cryptocurrency',
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
      body: Column(
        children: [
          // Tab Selection
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppThemeData.surfaceDark : Colors.white,
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
                _selectedTabIndex == 0
                    ? const _BuyCryptoContent()
                    : const _SellCryptoContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index, bool isDark) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
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

class _BuyCryptoContent extends StatelessWidget {
  const _BuyCryptoContent();

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 80,
            color: const Color(0xFF30588C).withValues(alpha: 0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF3D5A73),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Crypto buying feature is being prepared',
            style: TextStyle(
              fontSize: 16,
              color:
                  isDark
                      ? AppThemeData.grey300
                      : const Color(0xFF3D5A73).withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _SellCryptoContent extends StatefulWidget {
  const _SellCryptoContent();

  @override
  State<_SellCryptoContent> createState() => _SellCryptoContentState();
}

class _SellCryptoContentState extends State<_SellCryptoContent> {
  final List<Map<String, String>> cryptocurrencies = [
    {'name': 'Bitcoin', 'symbol': 'BTC', 'icon': '₿'},
    {'name': 'Ethereum', 'symbol': 'ETH', 'icon': 'Ξ'},
    {'name': 'Tether', 'symbol': 'USDT', 'icon': '₮'},
  ];

  String? selectedCrypto;
  final amountController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _handleSellCrypto() {
    if (selectedCrypto == null) {
      ShowToastDialog.showToast('Please select a cryptocurrency'.tr);
      return;
    }
    if (amountController.text.isEmpty) {
      ShowToastDialog.showToast('Please enter amount'.tr);
      return;
    }

    final amount = double.tryParse(amountController.text) ?? 0.0;
    if (amount <= 0) {
      ShowToastDialog.showToast('Please enter a valid amount'.tr);
      return;
    }

    // Process sell
    ShowToastDialog.showToast(
      'Processing sale of $amount $selectedCrypto...'.tr,
    );

    amountController.clear();
    selectedCrypto = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sell Cryptocurrency',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF3D5A73),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Cryptocurrency'.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppThemeData.grey50 : const Color(0xFF3D5A73),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? AppThemeData.grey900 : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppThemeData.grey700 : Colors.grey.shade300,
                ),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedCrypto,
                hint: Text(
                  'Choose a cryptocurrency'.tr,
                  style: TextStyle(
                    color: isDark ? AppThemeData.grey400 : Colors.grey,
                  ),
                ),
                underline: const SizedBox(),
                items:
                    cryptocurrencies.map((crypto) {
                      return DropdownMenuItem<String>(
                        value: crypto['symbol'],
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(
                                  0xFF30588C,
                                ).withValues(alpha: 0.1),
                              ),
                              child: Center(
                                child: Text(
                                  crypto['icon']!,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF30588C),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  crypto['name']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isDark
                                            ? Colors.white
                                            : const Color(0xFF3D5A73),
                                  ),
                                ),
                                Text(
                                  crypto['symbol']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        isDark
                                            ? AppThemeData.grey400
                                            : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCrypto = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Amount to Sell'.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppThemeData.grey50 : const Color(0xFF3D5A73),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? AppThemeData.grey900 : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppThemeData.grey700 : Colors.grey.shade300,
                ),
              ),
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF3D5A73),
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  hintStyle: TextStyle(
                    color: isDark ? AppThemeData.grey400 : Colors.grey,
                  ),
                  border: InputBorder.none,
                  suffixText: selectedCrypto ?? '',
                  suffixStyle: TextStyle(
                    color: const Color(0xFF30588C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSellCrypto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF30588C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Proceed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF30588C).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF30588C).withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: const Color(0xFF30588C),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Exchange rates are updated in real-time'.tr,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF30588C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
