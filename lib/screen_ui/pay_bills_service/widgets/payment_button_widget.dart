import 'package:flutter/material.dart';
import 'package:customer/themes/app_them_data.dart';

class PaymentButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;

  const PaymentButtonWidget({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppThemeData.brandPrimaryBlue,
          disabledBackgroundColor: AppThemeData.brandPrimaryBlue.withValues(
            alpha: 0.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
