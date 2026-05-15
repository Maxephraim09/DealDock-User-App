import 'package:customer/constant/constant.dart';
import 'package:customer/screen_ui/ecommarce/home_e_commerce_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/chat_screens/chat_board_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/home_screen/restaurant_list_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/profile_screen/profile_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/support_screen/support_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/gift_card/gift_card_screen.dart'
    show GiftCardScreen;
import 'package:customer/screen_ui/multi_vendor_service/wallet_screen/add_funds_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/wallet_screen/crypto_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/wallet_screen/transfer_screen.dart';
import 'package:customer/screen_ui/parcel_service/logistics_home_screen.dart';
import 'package:customer/screen_ui/pay_bills_service/pay_bills_screen.dart';
import 'package:customer/screen_ui/pay_bills_service/screens/exam_pin_screen.dart';
import 'package:customer/screen_ui/service_home_screen/betting_screen.dart';
import 'package:customer/screen_ui/auth_screens/login_screen.dart';
import 'package:customer/screen_ui/on_demand_service/market_runner_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/wallet_screen/wallet_screen.dart';
import 'package:customer/screen_ui/multi_vendor_service/wallet_screen/transaction_history_screen.dart';
import 'package:customer/screen_ui/profile_screen/create_pin_screen.dart';
import 'package:customer/service/biometric_service.dart';
import 'package:customer/screen_ui/profile_screen/reset_pin_screen.dart';
import 'package:customer/service/pin_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:customer/screen_ui/pay_bills_service/screens/airtime_screen.dart';
import 'package:customer/screen_ui/pay_bills_service/screens/data_screen.dart';
import 'package:customer/screen_ui/pay_bills_service/screens/electricity_screen.dart';
import 'package:customer/screen_ui/pay_bills_service/screens/tv_subscription_screen.dart';
import 'package:customer/theme_provider.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/utils/app_colors.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppThemeData.surfaceDark : AppThemeData.surface;
    final titleColor = isDark ? AppThemeData.grey50 : AppThemeData.grey900;
    final subtitleColor = isDark ? AppThemeData.grey300 : AppThemeData.grey600;
    final itemBackground = AppThemeData.brandPrimaryBlue.withOpacity(0.12);
    final userName = Constant.userModel?.fullName() ?? 'User';
    final userContact =
        Constant.userModel?.phoneNumber != null &&
                Constant.userModel!.phoneNumber!.isNotEmpty
            ? '${Constant.userModel?.countryCode ?? ''} ${Constant.userModel?.phoneNumber}'
            : Constant.userModel?.email ?? 'customer@example.com';

    final coreServices = <_MoreMenuItem>[
      _MoreMenuItem(
        title: 'Logistics',
        icon: Icons.local_shipping,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LogisticsHomeScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Restaurant',
        icon: Icons.restaurant,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RestaurantListScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Stores',
        icon: Icons.storefront,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomeECommerceScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Market Runner',
        icon: Icons.shopping_bag,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MarketRunnerScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Pay Bills',
        icon: Icons.receipt_long,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PayBillsScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Gift Cards',
        icon: Icons.card_giftcard,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GiftCardScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Crypto',
        icon: Icons.currency_bitcoin,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CryptoScreen()),
            ),
      ),
    ];

    final financialServices = <_MoreMenuItem>[
      _MoreMenuItem(
        title: 'Transfer',
        icon: Icons.swap_horiz,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TransferScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Wallet',
        icon: Icons.account_balance_wallet,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WalletScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Transaction History',
        icon: Icons.history,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TransactionHistoryScreen(),
              ),
            ),
      ),
      _MoreMenuItem(
        title: 'Add Money',
        icon: Icons.add_circle,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddFundsScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Withdraw',
        icon: Icons.payments,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ComingSoonScreen(title: 'Withdraw'),
              ),
            ),
      ),
    ];

    final billServices = <_MoreMenuItem>[
      _MoreMenuItem(
        title: 'Airtime',
        icon: Icons.phone_android,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AirtimeScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Data',
        icon: Icons.wifi,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DataScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'TV',
        icon: Icons.live_tv,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TvSubscriptionScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Electricity',
        icon: Icons.electrical_services,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ElectricityScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Betting',
        icon: Icons.sports_esports,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BettingScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Exam Pins',
        icon: Icons.school,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ExamPinScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Internet Services',
        icon: Icons.router,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PayBillsScreen()),
            ),
      ),
    ];

    final newFintechServices = <_MoreMenuItem>[
      _MoreMenuItem(
        title: 'Pharmacy',
        icon: Icons.medical_services,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ComingSoonScreen(title: 'Pharmacy'),
              ),
            ),
      ),
      _MoreMenuItem(
        title: 'Daily Needs',
        icon: Icons.shopping_cart,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ComingSoonScreen(title: 'Daily Needs'),
              ),
            ),
      ),
      _MoreMenuItem(
        title: 'Tickets',
        icon: Icons.event,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ComingSoonScreen(title: 'Tickets'),
              ),
            ),
      ),
      _MoreMenuItem(
        title: 'Travel & Hotel',
        icon: Icons.flight,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ComingSoonScreen(title: 'Travel & Hotel'),
              ),
            ),
      ),
      _MoreMenuItem(
        title: 'Loan / Credit',
        icon: Icons.credit_card,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ComingSoonScreen(title: 'Loan / Credit'),
              ),
            ),
      ),
      _MoreMenuItem(
        title: 'Savings',
        icon: Icons.savings,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ComingSoonScreen(title: 'Savings'),
              ),
            ),
      ),
      _MoreMenuItem(
        title: 'Insurance',
        icon: Icons.shield,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ComingSoonScreen(title: 'Insurance'),
              ),
            ),
      ),
      _MoreMenuItem(
        title: 'Government Payments',
        icon: Icons.account_balance,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PayBillsScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Transport & Toll',
        icon: Icons.traffic,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PayBillsScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Charity / Religious',
        icon: Icons.volunteer_activism,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PayBillsScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Solar / Utilities',
        icon: Icons.wb_sunny,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PayBillsScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Business Services',
        icon: Icons.business,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => const ComingSoonScreen(title: 'Business Services'),
              ),
            ),
      ),
    ];

    final supportServices = <_MoreMenuItem>[
      _MoreMenuItem(
        title: 'Profile',
        icon: Icons.person,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Help / Support',
        icon: Icons.help,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SupportScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Chat',
        icon: Icons.chat,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChatBoardScreen()),
            ),
      ),
      _MoreMenuItem(
        title: 'Logout',
        icon: Icons.logout,
        onTap: () async {
          try {
            await FirebaseAuth.instance.signOut();
            Constant.userModel = null;

            // Clear biometric login state
            await Preferences.setBiometricLoginEnabled(false);

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          } catch (e) {
            debugPrint('Logout error: $e');
          }
        },
      ),
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: AppThemeData.brandDeepBlue,
        title: const Text('More'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppThemeData.brandDeepBlue,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppThemeData.brandPrimaryBlue
                          .withOpacity(0.2),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi $userName',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            userContact,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _MoreSectionHeader(title: 'Core Services', color: titleColor),
              const SizedBox(height: 12),
              _MoreGrid(
                items: coreServices,
                backgroundColor: itemBackground,
                titleColor: titleColor,
                subtitleColor: subtitleColor,
              ),
              const SizedBox(height: 24),
              _MoreSectionHeader(
                title: 'Financial Services',
                color: titleColor,
              ),
              const SizedBox(height: 12),
              _MoreGrid(
                items: financialServices,
                backgroundColor: itemBackground,
                titleColor: titleColor,
                subtitleColor: subtitleColor,
              ),
              const SizedBox(height: 24),
              _MoreSectionHeader(title: 'Payments & Bills', color: titleColor),
              const SizedBox(height: 12),
              _MoreGrid(
                items: billServices,
                backgroundColor: itemBackground,
                titleColor: titleColor,
                subtitleColor: subtitleColor,
              ),
              const SizedBox(height: 24),
              _MoreSectionHeader(
                title: 'New Fintech Services',
                color: titleColor,
              ),
              const SizedBox(height: 12),
              _MoreGrid(
                items: newFintechServices,
                backgroundColor: itemBackground,
                titleColor: titleColor,
                subtitleColor: subtitleColor,
              ),
              const SizedBox(height: 24),
              _MoreSectionHeader(
                title: 'Support & Settings',
                color: titleColor,
              ),
              const SizedBox(height: 12),
              _MoreGrid(
                items: supportServices,
                backgroundColor: itemBackground,
                titleColor: titleColor,
                subtitleColor: subtitleColor,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreSectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const _MoreSectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color),
    );
  }
}

class _MoreGrid extends StatelessWidget {
  final List<_MoreMenuItem> items;
  final Color backgroundColor;
  final Color titleColor;
  final Color subtitleColor;

  const _MoreGrid({
    required this.items,
    required this.backgroundColor,
    required this.titleColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 10,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return _MoreTile(
          title: item.title,
          icon: item.icon,
          backgroundColor: backgroundColor,
          titleColor: titleColor,
          onTap: item.onTap,
        );
      },
    );
  }
}

class _MoreTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color titleColor;
  final VoidCallback onTap;

  const _MoreTile({
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppThemeData.brandPrimaryBlue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppThemeData.brandPrimaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: titleColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreMenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _MoreMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class ComingSoonScreen extends StatelessWidget {
  final String title;

  const ComingSoonScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppThemeData.brandDeepBlue,
      ),
      body: Center(
        child: Text(
          'Coming Soon',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometricEnabled = false;
  bool _requireLoginOnRestart = false;
  bool _passwordFreeLogin = false;
  bool _autoLogoutEnabled = false;
  bool _pinExists = false;
  bool _isAuthenticatingBiometric = false;

  @override
  void initState() {
    super.initState();
    _loadSettingValues();
  }

  Future<void> _loadSettingValues() async {
    final prefs = await SharedPreferences.getInstance();
    final pinExists = await PinService.pinExists();
    final biometricEnabled = Preferences.biometricLoginEnabled();
    final requireLoginOnRestart =
        prefs.getBool(Preferences.requireLoginOnRestartKey) ?? false;
    final passwordFreeLogin =
        prefs.getBool(Preferences.passwordFreeLoginKey) ?? false;
    final autoLogoutEnabled =
        prefs.getBool(Preferences.autoLogoutEnabledKey) ?? false;

    if (!mounted) return;
    setState(() {
      _biometricEnabled = biometricEnabled;
      _requireLoginOnRestart = requireLoginOnRestart;
      _passwordFreeLogin = passwordFreeLogin;
      _autoLogoutEnabled = autoLogoutEnabled;
      _pinExists = pinExists;
    });

    if (prefs.getInt(Preferences.sessionTimeoutMinutesKey) == null ||
        prefs.getInt(Preferences.sessionTimeoutMinutesKey) == 0) {
      await prefs.setInt(Preferences.sessionTimeoutMinutesKey, 60);
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    if (_isAuthenticatingBiometric || BiometricService.isAuthenticating) {
      return;
    }

    setState(() {
      _isAuthenticatingBiometric = true;
    });

    try {
      if (value) {
        final biometric = BiometricService();
        final availabilityResult = await biometric.checkAvailability();
        if (!availabilityResult.success) {
          await Preferences.setBiometricLoginEnabled(false);
          if (!mounted) return;
          setState(() {
            _biometricEnabled = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                availabilityResult.errorMessage ?? 'Fingerprint not available',
              ),
            ),
          );
          return;
        }

        final result = await biometric.authenticate(
          reason: 'Enable fingerprint login',
        );

        if (!result.success) {
          if (!mounted) return;
          setState(() {
            _biometricEnabled = false;
          });
          final message =
              result.failureType == BiometricFailureType.userCancelled
                  ? 'Fingerprint authentication cancelled'
                  : result.errorMessage ?? 'Fingerprint authentication failed';
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
          return;
        }
      }

      await Preferences.setBiometricLoginEnabled(value);

      if (!value && _passwordFreeLogin) {
        await Preferences.setPasswordFreeLogin(false);
      }

      if (mounted) {
        setState(() {
          _biometricEnabled = value;
          if (!value) {
            _passwordFreeLogin = false;
          }
        });
      }

      if (value && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fingerprint login enabled successfully'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticatingBiometric = false;
        });
      }
    }
  }

  Future<void> _toggleRequireLoginOnRestart(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Preferences.requireLoginOnRestartKey, value);
    setState(() {
      _requireLoginOnRestart = value;
    });
  }

  Future<void> _togglePasswordFreeLogin(bool value) async {
    if (value && !_biometricEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Enable fingerprint login before password-free login.',
            ),
          ),
        );
      }
      return;
    }

    await Preferences.setPasswordFreeLogin(value);
    if (mounted) {
      setState(() {
        _passwordFreeLogin = value;
      });
    }
  }

  Future<void> _toggleAutoLogoutEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Preferences.autoLogoutEnabledKey, value);
    setState(() {
      _autoLogoutEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppThemeData.brandPrimaryBlue,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: context.watch<ThemeProvider>().isDarkMode,
                onChanged: (_) => context.read<ThemeProvider>().toggleTheme(),
                activeColor: AppColors.brandPrimaryBlue,
              ),
            ),
            SwitchListTile(
              title: const Text('Login again on app restart'),
              subtitle: const Text('Require password when the app is reopened'),
              value: _requireLoginOnRestart,
              onChanged: _toggleRequireLoginOnRestart,
              activeColor: AppColors.brandPrimaryBlue,
            ),
            SwitchListTile(
              title: const Text('Password-free login (Fingerprint)'),
              subtitle: const Text('Use biometrics instead of password'),
              value: _passwordFreeLogin,
              onChanged: _togglePasswordFreeLogin,
              activeColor: AppColors.brandPrimaryBlue,
            ),
            SwitchListTile(
              title: const Text('Logout after 60 minutes'),
              subtitle: const Text('Automatically require login after timeout'),
              value: _autoLogoutEnabled,
              onChanged: _toggleAutoLogoutEnabled,
              activeColor: AppColors.brandPrimaryBlue,
            ),
            const Divider(height: 32),
            SwitchListTile(
              title: const Text('Enable Fingerprint Login'),
              value: _biometricEnabled,
              onChanged: _isAuthenticatingBiometric ? null : _toggleBiometric,
              activeColor: AppColors.brandPrimaryBlue,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'PIN Management',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Manage your transaction PIN settings and reset securely.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Create Transaction PIN'),
              subtitle: Text(
                _pinExists
                    ? 'Change your existing 4-digit transaction PIN'
                    : 'Set up a 4-digit transaction PIN',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreatePinScreen()),
                );
                if (result == true) {
                  _loadSettingValues();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Reset Transaction PIN'),
              subtitle: const Text('Reset PIN with email verification'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ResetPinScreen()),
                );
                if (result == true) {
                  _loadSettingValues();
                }
              },
            ),
            const SizedBox(height: 12),
            const Divider(height: 32),
            ListTile(title: const Text('Language')),
          ],
        ),
      ),
    );
  }
}
