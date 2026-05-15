import 'package:customer/constant/assets.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/on_boarding_controller.dart';
import '../../themes/app_them_data.dart';
import '../../utils/network_image_widget.dart';
import '../../utils/preferences.dart';
import '../auth_screens/login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<OnboardingController>(
      init: OnboardingController(),
      builder: (controller) {
        final pageCount = 3; // Fixed to 3 slides
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(AppAssets.onBoardingBG, fit: BoxFit.cover),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.topRight,
                        child: RichText(
                          text: TextSpan(
                            style: AppThemeData.regularTextStyle(fontSize: 14),
                            children: [
                              TextSpan(
                                text: "${controller.currentPage.value + 1}",
                                style: AppThemeData.regularTextStyle(
                                  color: AppThemeData.grey800,
                                ),
                              ),
                              TextSpan(
                                text: "/$pageCount",
                                style: AppThemeData.regularTextStyle(
                                  color: AppThemeData.grey400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: PageView.builder(
                          controller: controller.pageController,
                          onPageChanged: controller.onPageChanged,
                          itemCount: pageCount,
                          itemBuilder: (context, index) {
                            const slideImages = [
                              'assets/images/onboarding_screen_slide1.png',
                              'assets/images/onboarding_screen_slide2.png',
                              'assets/images/onboarding_screen_slide3.png',
                            ];
                            const slideTexts = [
                              'Welcome to DealDock',
                              'Your all in one app',
                              'Shop with over 100 vendors across',
                            ];
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  slideImages[index],
                                  height: 220,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: Text(
                                    slideTexts[index],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      controller.currentPage.value == pageCount - 1
                          ? RoundedButtonFill(
                            title: "Let’s Get Started".tr,
                            onPress: () {
                              _finish();
                            },
                            color: AppThemeData.brandPrimaryBlue,
                            textColor: AppThemeData.grey50,
                          )
                          : Row(
                            children: [
                              Expanded(
                                child: RoundedButtonFill(
                                  title: "Skip".tr,
                                  onPress: () => _finish(),
                                  color: AppThemeData.brandPrimaryBlue,
                                  textColor: AppThemeData.grey50,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: RoundedButtonFill(
                                  title: "Next".tr,
                                  onPress: () {
                                    controller.nextPage();
                                  },
                                  color: AppThemeData.brandPrimaryBlue,
                                  textColor: AppThemeData.grey50,
                                ),
                              ),
                            ],
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _finish() async {
    await Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
    Get.offAll(() => const LoginScreen());
  }
}
