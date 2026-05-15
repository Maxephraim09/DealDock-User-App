import 'package:customer/controllers/theme_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/show_toast_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'General';

  final List<String> _categories = [
    'General',
    'App Crash',
    'Payment Issue',
    'Order Problem',
    'Account Issue',
    'Feature Request',
    'Other',
  ];

  @override
  void dispose() {
    _issueController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_issueController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      ShowToastDialog.showToast('Please fill in all fields'.tr);
      return;
    }

    // Here you would typically send the report to your backend
    // For now, just show a success message
    ShowToastDialog.showToast('Issue reported successfully'.tr);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<ThemeController>(
      builder: (controller) {
        final isDark = controller.isDark.value;
        return Scaffold(
          backgroundColor:
              isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
          appBar: AppBar(
            backgroundColor:
                isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
              ),
              onPressed: () => Get.back(),
            ),
            title: Text(
              'Report Issue'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF30588C),
                          const Color(0xFF2E608C).withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Report an Issue'.tr,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Help us improve by reporting any issues you encounter.'
                              .tr,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Category dropdown
                  Text(
                    'Category'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color:
                          isDark ? AppThemeData.grey900 : AppThemeData.grey50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isDark
                                ? AppThemeData.grey800
                                : AppThemeData.grey200,
                      ),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      underline: const SizedBox(),
                      dropdownColor:
                          isDark ? AppThemeData.grey900 : Colors.white,
                      style: TextStyle(
                        color:
                            isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                      ),
                      items:
                          _categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Issue title
                  Text(
                    'Issue Title'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _issueController,
                    decoration: InputDecoration(
                      hintText: 'Brief description of the issue'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor:
                          isDark ? AppThemeData.grey900 : AppThemeData.grey50,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Description'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText:
                          'Please provide detailed information about the issue'
                              .tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor:
                          isDark ? AppThemeData.grey900 : AppThemeData.grey50,
                    ),
                    maxLines: 5,
                    maxLength: 500,
                  ),
                  const SizedBox(height: 24),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF30588C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Submit Report'.tr,
                        style: const TextStyle(
                          fontSize: 16,
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
      },
    );
  }
}
