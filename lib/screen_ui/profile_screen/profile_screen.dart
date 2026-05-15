import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/constant.dart';
import '../../service/biometric_service.dart';
import '../../controllers/my_profile_controller.dart';
import '../../theme_provider.dart';
import '../../themes/app_them_data.dart';
import '../../utils/app_colors.dart';
import '../../utils/preferences.dart';
import '../location_enable_screens/address_list_screen.dart';
import '../multi_vendor_service/chat_screens/chat_board_screen.dart';
import '../multi_vendor_service/order_list_screen/order_screen.dart';
import '../multi_vendor_service/wallet_screen/wallet_screen.dart';
import 'payment_methods_screen.dart';
import 'change_password_screen.dart';
import 'create_pin_screen.dart';
import 'reset_pin_screen.dart';
import 'device_management_screen.dart';
import 'add_payment_method_screen.dart';
import 'faq_screen.dart';
import 'help_center_screen.dart';
import 'language_settings_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';
import 'about_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final MyProfileController _myProfileController = Get.put(
    MyProfileController(),
  );

  bool _isBalanceVisible = true;
  bool _isBiometricsEnabled = false; // Default to false
  bool _isNotificationsEnabled = true;
  bool _isAuthenticatingBiometric = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    setState(() {
      _isBiometricsEnabled = Preferences.biometricLoginEnabled();
      _isNotificationsEnabled =
          Preferences.pref.getBool('notifications_enabled') ?? true;
    });
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  Future<void> _toggleBiometrics(bool value) async {
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
          if (!mounted) return;
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result.failureType == BiometricFailureType.userCancelled
                    ? 'Fingerprint authentication cancelled'
                    : result.errorMessage ??
                        'Fingerprint authentication failed',
              ),
            ),
          );
          return;
        }
      }

      await Preferences.setBiometricLoginEnabled(value);
      if (mounted) {
        setState(() {
          _isBiometricsEnabled = value;
        });
      }
    } finally {
      final wasMounted = mounted;
      if (wasMounted) {
        setState(() {
          _isAuthenticatingBiometric = false;
        });
      }
    }
  }

  void _toggleNotifications(bool value) async {
    setState(() {
      _isNotificationsEnabled = value;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Header
              Obx(() {
                final user = Constant.userModel;
                if (user == null) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("No user data loaded"),
                    ),
                  );
                }
                return ProfileHeaderWidget(
                  fullName: user.fullName(),
                  contactText:
                      user.phoneNumber != null
                          ? '${user.countryCode ?? ''} ${user.phoneNumber}'
                          : 'Not provided',
                  kycLevel:
                      user.isDocumentVerify == true ? 'Verified' : 'Unverified',
                  profileImageUrl: user.profilePictureURL,
                );
              }),
              const SizedBox(height: 16),

              // Wallet Summary
              Obx(() {
                final walletAmount = Constant.userModel?.walletAmount ?? 0.0;
                return WalletCardWidget(
                  balance: walletAmount.toStringAsFixed(2),
                  isVisible: _isBalanceVisible,
                  onToggleVisibility: _toggleBalanceVisibility,
                  onTap: () => Get.to(() => const WalletScreen()),
                );
              }),
              const SizedBox(height: 24),

              // Quick Actions
              const SectionHeaderWidget(title: 'Quick Actions'),
              const SizedBox(height: 12),
              ActionGridWidget(
                onOrdersTap: () => Get.to(() => const OrderScreen()),
                onWalletTap: () => Get.to(() => const WalletScreen()),
                onAddressesTap: () => Get.to(() => const AddressListScreen()),
                onSupportTap: () => Get.to(() => ChatBoardScreen()),
              ),
              const SizedBox(height: 24),

              // Service Management
              const SectionHeaderWidget(title: 'Service Management'),
              const SizedBox(height: 12),
              ServiceManagementSection(
                onManageAddresses:
                    () => Get.to(() => const AddressListScreen()),
                onOrderHistory: () => Get.to(() => const OrderScreen()),
                onPaymentMethods:
                    () => Get.to(() => const PaymentMethodsScreen()),
              ),
              const SizedBox(height: 24),

              // Security Settings
              const SectionHeaderWidget(title: 'Security Settings'),
              const SizedBox(height: 12),
              SecuritySettingsSection(
                isBiometricsEnabled: _isBiometricsEnabled,
                isNotificationsEnabled: _isNotificationsEnabled,
                onBiometricsToggle: _toggleBiometrics,
                onNotificationsToggle: _toggleNotifications,
              ),
              const SizedBox(height: 24),

              // Payment Methods
              const SectionHeaderWidget(title: 'Payment Methods'),
              const SizedBox(height: 12),
              PaymentMethodsSection(
                onAddMethod: () => Get.to(() => const AddPaymentMethodScreen()),
              ),
              const SizedBox(height: 24),

              // Rewards & Benefits
              const SectionHeaderWidget(title: 'Rewards & Benefits'),
              const SizedBox(height: 12),
              const RewardsSection(),
              const SizedBox(height: 24),

              // Support & Help
              const SectionHeaderWidget(title: 'Support & Help'),
              const SizedBox(height: 12),
              SupportSection(
                onContactSupport: () => Get.to(() => ChatBoardScreen()),
                onFAQ: () => Get.to(() => const FAQScreen()),
                onHelpCenter: () => Get.to(() => const HelpCenterScreen()),
              ),
              const SizedBox(height: 24),

              // Preferences
              const SectionHeaderWidget(title: 'Preferences'),
              const SizedBox(height: 12),
              PreferencesSection(
                isDarkMode: _myProfileController.isDarkModeSwitch.value,
                onDarkModeToggle: _myProfileController.toggleDarkMode,
              ),
              const SizedBox(height: 24),

              // Legal & Compliance
              const SectionHeaderWidget(title: 'Legal & Compliance'),
              const SizedBox(height: 12),
              LegalSection(
                onPrivacyPolicy:
                    () => Get.to(() => const PrivacyPolicyScreen()),
                onTermsOfService:
                    () => Get.to(() => const TermsOfServiceScreen()),
                onAbout: () => Get.to(() => const AboutScreen()),
              ),
              const SizedBox(height: 24),

              // Logout
              LogoutButtonWidget(
                onLogout: () async {
                  await FirebaseAuth.instance.signOut();
                  Get.offAllNamed('/login'); // Adjust route as needed
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// PROFILE HEADER WIDGET
class ProfileHeaderWidget extends StatelessWidget {
  final String fullName;
  final String contactText;
  final String kycLevel;
  final String? profileImageUrl;

  const ProfileHeaderWidget({
    super.key,
    required this.fullName,
    required this.contactText,
    required this.kycLevel,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppThemeData.surfaceDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppThemeData.greyDark700 : AppThemeData.grey100,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppThemeData.brandPrimaryBlue.withValues(alpha: 26),
            ),
            child:
                profileImageUrl != null && profileImageUrl!.isNotEmpty
                    ? ClipOval(
                      child: Image.network(
                        profileImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Icon(
                              Icons.person,
                              color: AppThemeData.brandPrimaryBlue,
                              size: 30,
                            ),
                      ),
                    )
                    : Icon(
                      Icons.person,
                      color: AppThemeData.brandPrimaryBlue,
                      size: 30,
                    ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi ${fullName.isNotEmpty ? fullName : 'User'}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppThemeData.brandMutedSteelBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Builder(
                  builder: (context) {
                    final isDark =
                        Theme.of(context).brightness == Brightness.dark;
                    return Text(
                      fullName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color:
                            isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  contactText,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppThemeData.brandMutedSteelBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        kycLevel == 'Verified'
                            ? AppThemeData.success100
                            : AppThemeData.warning100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    kycLevel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color:
                          kycLevel == 'Verified'
                              ? AppThemeData.success600
                              : AppThemeData.warning600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.edit, color: AppThemeData.brandPrimaryBlue, size: 20),
        ],
      ),
    );
  }
}

// WALLET CARD WIDGET
class WalletCardWidget extends StatelessWidget {
  final String balance;
  final bool isVisible;
  final VoidCallback onToggleVisibility;
  final VoidCallback onTap;

  const WalletCardWidget({
    super.key,
    required this.balance,
    required this.isVisible,
    required this.onToggleVisibility,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppThemeData.brandPrimaryBlue, AppThemeData.brandDeepBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Wallet Balance',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: onToggleVisibility,
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isVisible ? '₦ $balance' : '₦ ••••••',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white.withValues(alpha: 204),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 204),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// SECTION HEADER WIDGET
class SectionHeaderWidget extends StatelessWidget {
  final String title;

  const SectionHeaderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
      ),
    );
  }
}

// ACTION GRID WIDGET
class ActionGridWidget extends StatelessWidget {
  final VoidCallback onOrdersTap;
  final VoidCallback onWalletTap;
  final VoidCallback onAddressesTap;
  final VoidCallback onSupportTap;

  const ActionGridWidget({
    super.key,
    required this.onOrdersTap,
    required this.onWalletTap,
    required this.onAddressesTap,
    required this.onSupportTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppThemeData.surfaceDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppThemeData.greyDark700 : AppThemeData.grey100,
        ),
      ),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _ActionCard(
            icon: Icons.receipt_long,
            title: 'Orders',
            onTap: onOrdersTap,
          ),
          _ActionCard(
            icon: Icons.account_balance_wallet,
            title: 'Wallet',
            onTap: onWalletTap,
          ),
          _ActionCard(
            icon: Icons.location_on,
            title: 'Addresses',
            onTap: onAddressesTap,
          ),
          _ActionCard(
            icon: Icons.support_agent,
            title: 'Support',
            onTap: onSupportTap,
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppThemeData.surfaceDark : AppThemeData.grey50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppThemeData.brandPrimaryBlue, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SERVICE MANAGEMENT SECTION
class ServiceManagementSection extends StatelessWidget {
  final VoidCallback onManageAddresses;
  final VoidCallback onOrderHistory;
  final VoidCallback onPaymentMethods;

  const ServiceManagementSection({
    super.key,
    required this.onManageAddresses,
    required this.onOrderHistory,
    required this.onPaymentMethods,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsTileWidget(
          icon: Icons.location_on_outlined,
          title: 'Manage Addresses',
          subtitle: 'Add, edit, or remove delivery addresses',
          onTap: onManageAddresses,
        ),
        SettingsTileWidget(
          icon: Icons.history,
          title: 'Order History',
          subtitle: 'View all your past orders',
          onTap: onOrderHistory,
        ),
        SettingsTileWidget(
          icon: Icons.payment,
          title: 'Payment Methods',
          subtitle: 'Manage cards and bank accounts',
          onTap: onPaymentMethods,
        ),
      ],
    );
  }
}

// SECURITY SETTINGS SECTION
class SecuritySettingsSection extends StatelessWidget {
  final bool isBiometricsEnabled;
  final bool isNotificationsEnabled;
  final ValueChanged<bool> onBiometricsToggle;
  final ValueChanged<bool> onNotificationsToggle;

  const SecuritySettingsSection({
    super.key,
    required this.isBiometricsEnabled,
    required this.isNotificationsEnabled,
    required this.onBiometricsToggle,
    required this.onNotificationsToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Transaction PIN Management
        SettingsTileWidget(
          icon: Icons.lock,
          title: 'Create Transaction PIN',
          subtitle: 'Set a 4-digit PIN for secure transactions',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreatePinScreen()),
            );
          },
        ),
        SettingsTileWidget(
          icon: Icons.refresh,
          title: 'Reset Transaction PIN',
          subtitle: 'Reset PIN with email verification',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ResetPinScreen()),
            );
          },
        ),
        // Change Password
        SettingsTileWidget(
          icon: Icons.vpn_key_outlined,
          title: 'Change Password',
          subtitle: 'Update your account password',
          onTap: () => Get.to(() => const ChangePasswordScreen()),
        ),
        // Biometric Authentication
        SettingsTileWidget(
          icon: Icons.fingerprint,
          title: 'Biometric Authentication',
          subtitle: 'Use fingerprint or face unlock',
          trailing: Switch(
            value: isBiometricsEnabled,
            activeThumbColor: AppThemeData.brandPrimaryBlue,
            onChanged: onBiometricsToggle,
          ),
        ),
        // Push Notifications
        SettingsTileWidget(
          icon: Icons.notifications_outlined,
          title: 'Push Notifications',
          subtitle: 'Receive order and payment alerts',
          trailing: Switch(
            value: isNotificationsEnabled,
            activeThumbColor: AppThemeData.brandPrimaryBlue,
            onChanged: onNotificationsToggle,
          ),
        ),
        // Device Management
        SettingsTileWidget(
          icon: Icons.devices,
          title: 'Device Management',
          subtitle: 'Review active devices',
          onTap: () => Get.to(() => const DeviceManagementScreen()),
        ),
      ],
    );
  }
}

// SUPPORT SECTION
class SupportSection extends StatelessWidget {
  final VoidCallback onContactSupport;
  final VoidCallback onFAQ;
  final VoidCallback onHelpCenter;

  const SupportSection({
    super.key,
    required this.onContactSupport,
    required this.onFAQ,
    required this.onHelpCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsTileWidget(
          icon: Icons.support_agent,
          title: 'Contact Support',
          subtitle: 'Get help from our support team',
          onTap: onContactSupport,
        ),
        SettingsTileWidget(
          icon: Icons.help_outline,
          title: 'FAQ',
          subtitle: 'Find answers to common questions',
          onTap: onFAQ,
        ),
        SettingsTileWidget(
          icon: Icons.library_books,
          title: 'Help Center',
          subtitle: 'Browse our knowledge base',
          onTap: onHelpCenter,
        ),
      ],
    );
  }
}

// PREFERENCES SECTION
class PreferencesSection extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeToggle;

  const PreferencesSection({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsTileWidget(
          icon: Icons.dark_mode_outlined,
          title: 'Dark Mode',
          subtitle: 'Switch between light and dark themes',
          trailing: Switch(
            value: context.watch<ThemeProvider>().isDarkMode,
            activeThumbColor: Theme.of(context).primaryColor,
            onChanged: (_) => context.read<ThemeProvider>().toggleTheme(),
          ),
        ),
        SettingsTileWidget(
          icon: Icons.language,
          title: 'Language',
          subtitle: 'Choose your preferred language',
          onTap: () => Get.to(() => const LanguageSettingsScreen()),
        ),
      ],
    );
  }
}

// LEGAL SECTION
class LegalSection extends StatelessWidget {
  final VoidCallback onPrivacyPolicy;
  final VoidCallback onTermsOfService;
  final VoidCallback onAbout;

  const LegalSection({
    super.key,
    required this.onPrivacyPolicy,
    required this.onTermsOfService,
    required this.onAbout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsTileWidget(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          subtitle: 'Learn how we protect your data',
          onTap: onPrivacyPolicy,
        ),
        SettingsTileWidget(
          icon: Icons.description_outlined,
          title: 'Terms of Service',
          subtitle: 'Read our terms and conditions',
          onTap: onTermsOfService,
        ),
        SettingsTileWidget(
          icon: Icons.info_outline,
          title: 'About',
          subtitle: 'App version and information',
          onTap: onAbout,
        ),
      ],
    );
  }
}

// SETTINGS TILE WIDGET
class SettingsTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const SettingsTileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppThemeData.surfaceDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppThemeData.greyDark700 : AppThemeData.grey100,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppThemeData.brandPrimaryBlue.withValues(alpha: 26),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppThemeData.brandPrimaryBlue, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppThemeData.greyDark300 : AppThemeData.grey600,
          ),
        ),
        trailing:
            trailing ??
            (onTap != null
                ? Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isDark ? AppThemeData.grey400 : AppThemeData.grey500,
                )
                : null),
        onTap: onTap,
      ),
    );
  }
}

// PAYMENT METHODS SECTION
class PaymentMethodsSection extends StatelessWidget {
  final VoidCallback onAddMethod;

  const PaymentMethodsSection({super.key, required this.onAddMethod});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppThemeData.surfaceDarkCard : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? AppThemeData.greyDark700 : AppThemeData.grey100,
            ),
          ),
          child: Column(
            children: [
              PaymentMethodCard(
                title: 'Standard Bank',
                details: 'Savings Account • 0123456789',
                icon: Icons.account_balance,
              ),
              const SizedBox(height: 12),
              PaymentMethodCard(
                title: 'Visa Classic',
                details: '•••• 1245 • Exp 10/28',
                icon: Icons.credit_card,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: onAddMethod,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppThemeData.brandPrimaryBlue,
            side: const BorderSide(color: Color(0x5230588C)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: const Text(
            'Add New Payment Method',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class PaymentMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String details;

  const PaymentMethodCard({
    super.key,
    required this.icon,
    required this.title,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0x1430588C),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: AppThemeData.brandPrimaryBlue, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                details,
                style: TextStyle(
                  fontSize: 13,
                  color:
                      isDark ? AppThemeData.greyDark300 : AppThemeData.grey600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// REWARDS SECTION
class RewardsSection extends StatelessWidget {
  const RewardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: _RewardCard(
                title: 'Cashback',
                value: '₦ 1,250',
                icon: Icons.local_offer_outlined,
                backgroundColor: AppThemeData.brandPrimaryBlue,
                textColor: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _RewardCard(
                title: 'Referral',
                value: '3 active invites',
                icon: Icons.group_outlined,
                backgroundColor: AppThemeData.grey100,
                textColor: AppThemeData.brandMutedSteelBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RewardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? backgroundColor;
  final Color textColor;

  const _RewardCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBackground =
        backgroundColor == AppThemeData.grey100 && isDark
            ? AppThemeData.surfaceDarkCard
            : backgroundColor;
    final bgColor =
        effectiveBackground ??
        (isDark ? AppThemeData.surfaceDark : AppThemeData.grey50);
    final effectiveTextColor =
        isDark && textColor == AppThemeData.brandMutedSteelBlue
            ? AppThemeData.grey50
            : textColor;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: effectiveTextColor),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: effectiveTextColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: effectiveTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// LOGOUT BUTTON
class LogoutButtonWidget extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutButtonWidget({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onLogout,
      icon: Icon(Icons.logout, color: AppColors.brandPrimaryBlue),
      label: Text(
        'Logout',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.brandPrimaryBlue,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColors.brandPrimaryBlue),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}
