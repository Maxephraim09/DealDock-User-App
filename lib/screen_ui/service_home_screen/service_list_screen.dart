import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/service_list_controller.dart';
import 'package:customer/controllers/theme_controller.dart';
import 'package:customer/models/currency_model.dart';
import 'package:customer/models/section_model.dart';
import 'package:customer/screen_ui/multi_vendor_service/order_list_screen/order_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/profile_screen/profile_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/cart_screen/cart_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/scan_qrcode_screen/scan_qr_code_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/search_screen/search_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/wallet_screen/crypto_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/wallet_screen/add_funds_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/notification_screen/notification_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/support_screen/support_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/wallet_screen/transfer_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/wallet_screen/transaction_history_screen.dart';
import 'package:customer/screen_ui/service_home_screen/more_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/home_screen/restaurant_list_screen.dart';
import 'package:customer/screen_ui/parcel_service/logistics_home_screen.dart';
import 'package:customer/screen_ui/ecommarce/home_e_commerce_screen.dart';
import 'package:customer/screen_ui/on_demand_service/market_runner_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/gift_card/gift_card_screen.dart'
    show GiftCardScreen;
import 'package:customer/screen_ui/pay_bills_service/screens/airtime_screen.dart';
import 'package:customer/screen_ui/pay_bills_service/screens/data_screen.dart';
import 'package:customer/screen_ui/pay_bills_service/screens/tv_subscription_screen.dart';
import 'package:customer/screen_ui/pay_bills_service/screens/electricity_screen.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:customer/screen_ui/pay_bills_service/pay_bills_screen.dart';
import 'package:customer/utils/location_guard.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ServiceHomeContent(),
    const OrderScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(() {
      final isDark = themeController.isDark.value;
      return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavWidget(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          isDark: isDark,
        ),
      );
    });
  }
}

class ServiceHomeContent extends StatelessWidget {
  const ServiceHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(() {
      final isDark = themeController.isDark.value;
      return GetX<ServiceListController>(
        init: ServiceListController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor:
                isDark ? AppThemeData.surfaceDark : const Color(0xFFF7F9FC),
            body: SafeArea(
              child:
                  controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ScrollingNotificationBanner(isDark: isDark),
                            const SizedBox(height: 10),
                            HeaderWidget(isDark: isDark),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: WalletCardWidget(
                                currency: controller.currencyData,
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(height: 16),
                            QuickActionWidget(isDark: isDark),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: ServiceGridWidget(
                                controller: controller,
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: AdsCardWidget(),
                            ),
                            if (controller.serviceListBanner.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              PromoBannerWidget(
                                banners: controller.serviceListBanner,
                              ),
                            ],
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: RecentActivityWidget(isDark: isDark),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
            ),
          );
        },
      );
    });
  }
}

class ScrollingNotificationBanner extends StatefulWidget {
  final bool isDark;

  const ScrollingNotificationBanner({super.key, required this.isDark});

  @override
  State<ScrollingNotificationBanner> createState() =>
      _ScrollingNotificationBannerState();
}

class _ScrollingNotificationBannerState
    extends State<ScrollingNotificationBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  static const String _message =
      'System maintenance scheduled for Sunday 2AM – 4AM';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bannerColor = AppThemeData.brandPrimaryBlue.withOpacity(0.08);
    final textColor = AppThemeData.brandPrimaryBlue;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bannerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final textStyle = TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            );
            final textPainter = TextPainter(
              text: TextSpan(text: _message, style: textStyle),
              maxLines: 1,
              textDirection: Directionality.of(context),
            )..layout();
            final textWidth = textPainter.width;
            const gapWidth = 48.0;
            final totalWidth = textWidth + gapWidth;

            return SizedBox(
              height: 28,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final dx = -(_controller.value * totalWidth);
                  return Transform.translate(
                    offset: Offset(dx, 0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: textWidth,
                          child: Text(
                            _message,
                            style: textStyle,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            softWrap: false,
                          ),
                        ),
                        const SizedBox(width: gapWidth),
                        SizedBox(
                          width: textWidth,
                          child: Text(
                            _message,
                            style: textStyle,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            softWrap: false,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final bool isDark;

  const HeaderWidget({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = AppThemeData.brandPrimaryBlue;
    return Container(
      height: 110,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: textColor.withOpacity(0.12),
                  backgroundImage:
                      Constant.userModel?.profilePictureURL != null
                          ? NetworkImage(Constant.userModel!.profilePictureURL!)
                          : const AssetImage(
                                'assets/images/user_placeholder.png',
                              )
                              as ImageProvider,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome,',
                    style: TextStyle(
                      color: textColor.withOpacity(0.85),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    Constant.userModel?.fullName() ?? 'User',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(const SearchScreen());
                },
                child: Icon(Icons.search, size: 22, color: textColor),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Get.to(const NotificationScreen());
                },
                child: Icon(Icons.notifications, size: 22, color: textColor),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Get.to(const SupportScreen());
                },
                child: Icon(Icons.support_agent, size: 22, color: textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WalletCardWidget extends StatefulWidget {
  final Rx<CurrencyModel> currency;
  final bool isDark;

  const WalletCardWidget({
    super.key,
    required this.currency,
    required this.isDark,
  });

  @override
  State<WalletCardWidget> createState() => _WalletCardWidgetState();
}

class _WalletCardWidgetState extends State<WalletCardWidget> {
  bool isBalanceVisible = true;

  String _maskAccountNumber(String accountNumber) {
    final cleaned = accountNumber.trim();
    if (cleaned.length < 7) {
      return cleaned;
    }
    final firstThree = cleaned.substring(0, 3);
    final lastTwo = cleaned.substring(cleaned.length - 2);
    return '$firstThree*****$lastTwo';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final double balance = (Constant.userModel?.walletAmount ?? 0.0).toDouble();
    final nairaFormat = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    );
    final balanceText = nairaFormat.format(balance);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppThemeData.brandPrimaryBlue,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? AppThemeData.grey900.withOpacity(0.18)
                    : AppThemeData.grey200.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Balance',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isBalanceVisible = !isBalanceVisible;
                  });
                },
                icon: Icon(
                  isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            isBalanceVisible ? balanceText : '••••••',
            style: const TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Acct No: ${_maskAccountNumber(Constant.userModel?.userBankDetails?.accountNumber ?? '7088916857')}',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _walletAction(
                icon: Icons.add,
                label: "Add Money",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddFundsScreen()),
                  );
                },
              ),
              _walletAction(
                icon: Icons.swap_horiz,
                label: "Transfer",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TransferScreen()),
                  );
                },
              ),
              _walletAction(
                icon: Icons.history,
                label: "History",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TransactionHistoryScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _walletAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class AdsCardWidget extends StatelessWidget {
  const AdsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final promoItems = [
      {
        'title': 'Get 20% Cashback',
        'subtitle': 'Pay with wallet and save more',
        'button': 'Use Now',
      },
      {
        'title': 'Free Delivery',
        'subtitle': 'On selected services today',
        'button': 'Shop Now',
      },
    ];

    return SizedBox(
      height: 110,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.92),
        itemCount: promoItems.length,
        itemBuilder: (context, index) {
          final item = promoItems[index];
          return Container(
            margin: EdgeInsets.only(
              right: index == promoItems.length - 1 ? 0 : 12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF3D5A73), Color(0xFF30588C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item['title'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['subtitle'] as String,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (await LocationGuard.ensureLocationForService()) {
                      Get.to(() => const PayBillsScreen());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    item['button'] as String,
                    style: TextStyle(
                      color: AppThemeData.brandPrimaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class QuickActionWidget extends StatelessWidget {
  final bool isDark;

  const QuickActionWidget({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionItem(context, Icons.phone_android, 'Airtime', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AirtimeScreen()),
            );
          }),
          _buildActionItem(context, Icons.wifi, 'Data', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DataScreen()),
            );
          }),
          _buildActionItem(context, Icons.tv, 'TV', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TvSubscriptionScreen()),
            );
          }),
          _buildActionItem(context, Icons.flash_on, 'Electricity', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ElectricityScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () async {
        if (await LocationGuard.ensureLocationForService()) {
          onTap();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isDark ? AppThemeData.grey900 : Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color:
                      isDark
                          ? AppThemeData.grey900.withOpacity(0.18)
                          : AppThemeData.grey200.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color:
                  isDark ? AppThemeData.grey50 : AppThemeData.brandPrimaryBlue,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color:
                  isDark
                      ? AppThemeData.grey50
                      : AppThemeData.brandMutedSteelBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceGridWidget extends StatelessWidget {
  final ServiceListController controller;
  final bool isDark;

  const ServiceGridWidget({
    super.key,
    required this.controller,
    required this.isDark,
  });

  static const List<Map<String, dynamic>> services = [
    {
      'name': 'Logistics',
      'icon': Icons.local_shipping,
      'type': 'parcel_delivery',
    },
    {
      'name': 'Restaurant',
      'icon': Icons.restaurant,
      'type': 'delivery-service',
    },
    {'name': 'Stores', 'icon': Icons.storefront, 'type': 'ecommerce-service'},
    {
      'name': 'Market Runner',
      'icon': Icons.shopping_bag,
      'type': 'ondemand-service',
    },
    {
      'name': 'Crypto',
      'icon': Icons.currency_bitcoin,
      'type': 'ecommerce-service',
    },
    {
      'name': 'Gift Card',
      'icon': Icons.card_giftcard,
      'type': 'ecommerce-service',
    },
    {'name': 'Pay Bills', 'icon': Icons.receipt, 'type': 'delivery-service'},
    {'name': 'More', 'icon': Icons.more_horiz, 'type': 'ondemand-service'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color:
                isDark ? AppThemeData.grey50 : AppThemeData.brandMutedSteelBlue,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.95,
          children:
              services
                  .map(
                    (service) =>
                        _buildServiceCard(service, controller, context),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildServiceCard(
    Map<String, dynamic> service,
    ServiceListController controller,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () async {
        if (!await LocationGuard.ensureLocationForService()) {
          return;
        }

        switch (service['name']) {
          case 'Restaurant':
            Get.to(const RestaurantListScreen());
            break;
          case 'Logistics':
            Get.to(const LogisticsHomeScreen());
            break;
          case 'Stores':
            Get.to(const HomeECommerceScreen());
            break;
          case 'Market Runner':
            Get.to(const MarketRunnerScreen());
            break;
          case 'Crypto':
            Get.to(const CryptoScreen());
            break;
          case 'Gift Card':
            Get.to(const GiftCardScreen());
            break;
          case 'Pay Bills':
            Get.to(const PayBillsScreen());
            break;
          case 'More':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MoreScreen()),
            );
            break;
          default:
            final section = controller.sectionList.firstWhere(
              (s) => s.serviceTypeFlag == service['type'],
              orElse: () => SectionModel(),
            );
            if (section.id != null) {
              controller.onServiceTap(Get.context!, section);
            }
            break;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppThemeData.grey900 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  isDark
                      ? AppThemeData.grey900.withOpacity(0.18)
                      : AppThemeData.grey200.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              service['icon'],
              size: 32,
              color: AppThemeData.brandPrimaryBlue,
            ),
            const SizedBox(height: 8),
            Text(
              service['name'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color:
                    isDark
                        ? AppThemeData.grey50
                        : AppThemeData.brandMutedSteelBlue,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class PromoBannerWidget extends StatelessWidget {
  final List<dynamic> banners;

  const PromoBannerWidget({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: banners.length,
          itemBuilder: (context, index) {
            final banner = banners[index];
            return Container(
              width: 280,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(banner['photo'] ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RecentActivityWidget extends StatelessWidget {
  final bool isDark;

  const RecentActivityWidget({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color:
                isDark ? AppThemeData.grey50 : AppThemeData.brandMutedSteelBlue,
          ),
        ),
        const SizedBox(height: 16),
        // Placeholder for recent activities
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: isDark ? AppThemeData.grey900 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color:
                    isDark
                        ? AppThemeData.grey900.withOpacity(0.18)
                        : AppThemeData.grey200.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(child: Text('Recent orders and transactions')),
        ),
      ],
    );
  }
}

class BottomNavWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isDark;

  const BottomNavWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: isDark ? AppThemeData.grey900 : Colors.white,
      selectedItemColor: AppThemeData.brandPrimaryBlue,
      unselectedItemColor:
          isDark ? AppThemeData.grey400 : AppThemeData.brandMutedSteelBlue,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: 'Orders',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
