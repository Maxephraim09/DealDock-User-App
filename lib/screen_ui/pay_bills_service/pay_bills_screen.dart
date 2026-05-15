import 'package:flutter/material.dart';
import 'package:customer/screen_ui/pay_bills_service/widgets/service_card_widget.dart';
import 'package:customer/screen_ui/pay_bills_service/screens/airtime_screen.dart';
import 'package:customer/screen_ui/pay_bills_service/screens/data_screen.dart';
import 'package:customer/screen_ui/pay_bills_service/screens/tv_subscription_screen.dart';
import 'package:customer/screen_ui/pay_bills_service/screens/electricity_screen.dart';
import 'package:customer/screen_ui/pay_bills_service/screens/exam_pin_screen.dart';
import 'package:customer/themes/app_them_data.dart';

class PayBillsScreen extends StatelessWidget {
  const PayBillsScreen({super.key});

  void _navigateToBillScreen(BuildContext context, String service) {
    Widget screen;
    switch (service) {
      case 'airtime':
        screen = const AirtimeScreen();
        break;
      case 'data':
        screen = const DataScreen();
        break;
      case 'tv':
        screen = const TvSubscriptionScreen();
        break;
      case 'electricity':
        screen = const ElectricityScreen();
        break;
      case 'exam':
        screen = const ExamPinScreen();
        break;
      case 'betting':
      case 'financial':
      case 'loan':
      case 'government':
      case 'travel':
      case 'religious':
      case 'transport':
      case 'ticketing':
      case 'solar':
      case 'products':
      case 'paychoices':
        screen = _buildComingSoonScreen(context, service);
        break;
      default:
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Widget _buildComingSoonScreen(BuildContext context, String serviceName) {
    return Scaffold(
      backgroundColor: AppThemeData.grey50,
      appBar: AppBar(
        backgroundColor: AppThemeData.brandDeepBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          serviceName.replaceAll('_', ' ').toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 80,
              color: AppThemeData.brandPrimaryBlue.withOpacity(0.3),
            ),
            const SizedBox(height: 20),
            Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppThemeData.brandMutedSteelBlue,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'This service is being prepared for you',
              style: TextStyle(
                fontSize: 16,
                color: AppThemeData.brandMutedSteelBlue.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final services = [
      {'icon': Icons.phone_android, 'title': 'Airtime', 'key': 'airtime'},
      {'icon': Icons.wifi, 'title': 'Data', 'key': 'data'},
      {'icon': Icons.tv, 'title': 'TV', 'key': 'tv'},
      {'icon': Icons.flash_on, 'title': 'Electricity', 'key': 'electricity'},
      {'icon': Icons.school, 'title': 'Exam Pins', 'key': 'exam'},
      {'icon': Icons.sports_soccer, 'title': 'Betting', 'key': 'betting'},
      {
        'icon': Icons.trending_up,
        'title': 'Financial Services',
        'key': 'financial',
      },
      {'icon': Icons.credit_card, 'title': 'Credit & Loan', 'key': 'loan'},
      {
        'icon': Icons.admin_panel_settings,
        'title': 'Government Payment',
        'key': 'government',
      },
      {'icon': Icons.flight, 'title': 'Travel & Hotel', 'key': 'travel'},
      {'icon': Icons.church, 'title': 'Religious', 'key': 'religious'},
      {
        'icon': Icons.directions_car,
        'title': 'Transport & Toll',
        'key': 'transport',
      },
      {
        'icon': Icons.confirmation_number,
        'title': 'Ticketing',
        'key': 'ticketing',
      },
      {'icon': Icons.sunny, 'title': 'Solar', 'key': 'solar'},
      {
        'icon': Icons.shopping_bag,
        'title': 'Products & Services',
        'key': 'products',
      },
      {'icon': Icons.payment, 'title': 'Pay Choices', 'key': 'paychoices'},
    ];

    return Scaffold(
      backgroundColor: AppThemeData.grey50,
      appBar: AppBar(
        backgroundColor: AppThemeData.brandDeepBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pay Bills',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select a service to pay',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppThemeData.brandMutedSteelBlue,
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return ServiceCardWidget(
                    icon: service['icon'] as IconData,
                    title: service['title'] as String,
                    onTap:
                        () => _navigateToBillScreen(
                          context,
                          service['key'] as String,
                        ),
                  );
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
