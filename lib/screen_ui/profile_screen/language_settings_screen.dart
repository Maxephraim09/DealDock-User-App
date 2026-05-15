import 'package:customer/controllers/theme_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  final List<Map<String, dynamic>> _languages = [
    {
      'code': 'en',
      'name': 'English',
      'nativeName': 'English',
      'flag': '🇺🇸',
      'isSelected': true,
    },
    {
      'code': 'ha',
      'name': 'Hausa',
      'nativeName': 'Hausa',
      'flag': '🇳🇬',
      'isSelected': false,
    },
    {
      'code': 'yo',
      'name': 'Yoruba',
      'nativeName': 'Yorùbá',
      'flag': '🇳🇬',
      'isSelected': false,
    },
    {
      'code': 'ig',
      'name': 'Igbo',
      'nativeName': 'Igbo',
      'flag': '🇳🇬',
      'isSelected': false,
    },
    {
      'code': 'fr',
      'name': 'French',
      'nativeName': 'Français',
      'flag': '🇫🇷',
      'isSelected': false,
    },
    {
      'code': 'ar',
      'name': 'Arabic',
      'nativeName': 'العربية',
      'flag': '🇸🇦',
      'isSelected': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('selected_language') ?? 'en';
    setState(() {
      for (var lang in _languages) {
        lang['isSelected'] = lang['code'] == savedLanguage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDark.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeData.brandPrimaryBlue,
        title: const Text('Language Settings'),
        elevation: 0,
      ),
      backgroundColor: isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppThemeData.brandPrimaryBlue,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Your Language',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select your preferred language for the best experience. Changes will apply immediately.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Language List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                final language = _languages[index];
                return _buildLanguageOption(language, isDark);
              },
            ),
          ),

          // Info Section
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppThemeData.surfaceDarkCard : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppThemeData.grey700 : AppThemeData.grey200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppThemeData.brandPrimaryBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Language Support',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                            isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoItem(
                  '🌍',
                  'Regional Languages',
                  'We support major Nigerian languages to serve our diverse community better.',
                  isDark,
                ),
                const SizedBox(height: 8),
                _buildInfoItem(
                  '⚡',
                  'Instant Changes',
                  'Language changes apply immediately without requiring an app restart.',
                  isDark,
                ),
                const SizedBox(height: 8),
                _buildInfoItem(
                  '🔄',
                  'More Languages Coming',
                  'We\'re working on adding more languages based on user demand.',
                  isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(Map<String, dynamic> language, bool isDark) {
    final isSelected = language['isSelected'];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppThemeData.surfaceDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isSelected
                  ? AppThemeData.brandPrimaryBlue
                  : (isDark ? AppThemeData.grey700 : AppThemeData.grey200),
          width: isSelected ? 2 : 1,
        ),
        boxShadow:
            isSelected
                ? [
                  BoxShadow(
                    color: AppThemeData.brandPrimaryBlue.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                : null,
      ),
      child: ListTile(
        onTap: () => _selectLanguage(language['code']),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  isSelected
                      ? AppThemeData.brandPrimaryBlue
                      : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(language['flag'], style: const TextStyle(fontSize: 20)),
          ),
        ),
        title: Text(
          language['name'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
          ),
        ),
        subtitle: Text(
          language['nativeName'],
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppThemeData.grey400 : AppThemeData.grey600,
          ),
        ),
        trailing:
            isSelected
                ? Icon(
                  Icons.check_circle,
                  color: AppThemeData.brandPrimaryBlue,
                  size: 24,
                )
                : Icon(
                  Icons.radio_button_unchecked,
                  color: isDark ? AppThemeData.grey600 : AppThemeData.grey400,
                  size: 24,
                ),
      ),
    );
  }

  Widget _buildInfoItem(
    String emoji,
    String title,
    String description,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppThemeData.grey400 : AppThemeData.grey600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _selectLanguage(String languageCode) async {
    // Update selection
    setState(() {
      for (var lang in _languages) {
        lang['isSelected'] = lang['code'] == languageCode;
      }
    });

    // Save to preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', languageCode);

    // Show success message
    Get.snackbar(
      'Language Updated',
      'Language changed to ${_languages.firstWhere((lang) => lang['code'] == languageCode)['name']}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    // TODO: Implement actual language switching
    // This would typically involve:
    // 1. Updating Get.locale
    // 2. Reloading app strings
    // 3. Updating app state
  }
}
