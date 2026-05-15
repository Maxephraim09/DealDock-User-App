// IMPLEMENTATION GUIDE: PROFILE SECURITY FEATURES
// ================================================
// This file shows how to integrate PIN verification with payment flows

import 'package:customer/service/pin_service.dart';
import 'package:flutter/material.dart';

// ============================================
// EXAMPLE 1: PIN VERIFICATION BEFORE PAYMENT
// ============================================
// Use this pattern before processing any payment:

Future<bool> verifyTransactionPin(BuildContext context) async {
  final TextEditingController pinController = TextEditingController();
  bool verified = false;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Enter Transaction PIN'),
              content: TextField(
                controller: pinController,
                obscureText: true,
                maxLength: 4,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '••••',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    bool isValid = await PinService.verifyPin(
                      pinController.text,
                    );
                    if (isValid) {
                      verified = true;
                      Navigator.pop(context);
                    } else {
                      int remaining = await PinService.getRemainingAttempts();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Invalid PIN. $remaining attempts remaining',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Verify'),
                ),
              ],
            );
          },
        ),
  );

  return verified;
}

// ============================================
// EXAMPLE 2: INTEGRATED PAYMENT FLOW
// ============================================
// Call this before openCheckout or wallet deduction:

Future<void> processSecurePayment({
  required BuildContext context,
  required Function() onPaymentApproved,
  required String amount,
}) async {
  // Step 1: Check if PIN exists
  bool pinExists = await PinService.pinExists();

  if (!pinExists) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please set Transaction PIN first')),
    );
    return;
  }

  // Step 2: Request PIN verification
  bool verified = await verifyTransactionPin(context);

  if (verified) {
    // Step 3: Proceed with payment
    onPaymentApproved();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment cancelled: PIN verification failed'),
      ),
    );
  }
}

// ============================================
// EXAMPLE 3: CART CHECKOUT WITH PIN VERIFICATION
// ============================================
// In cart_screen.dart or similar payment screens:

/*
  } else if (controller.selectedPaymentMethod.value == PaymentGateway.razorpay.name) {
    // Verify PIN before initiating payment
    bool pinVerified = await verifyTransactionPin(context);
    
    if (!pinVerified) {
      ShowToastDialog.showToast("PIN verification failed");
      controller.isOrderPlaced.value = false;
      return;
    }

    // Proceed with Razorpay
    RazorPayController().createOrderRazorPay(
      amount: double.parse(controller.totalAmount.value.toString()),
      razorpayModel: controller.razorPayModel.value,
    ).then((value) {
      if (value == null) {
        Get.back();
        ShowToastDialog.showToast("Something went wrong");
      } else {
        CreateRazorPayOrderModel result = value;
        controller.openCheckout(
          amount: controller.totalAmount.value.toString(),
          orderId: result.id,
        );
      }
    });
  }
*/

// ============================================
// EXAMPLE 4: WALLET PAYMENT WITH PIN
// ============================================
// Before deducting from wallet:

/*
  if (controller.selectedPaymentMethod.value == PaymentGateway.wallet.name) {
    // First verify balance
    if (double.parse(userModel.value.walletAmount.toString()) < totalAmount.value) {
      ShowToastDialog.showToast("Insufficient wallet balance");
      return;
    }

    // Then verify PIN
    bool pinVerified = await verifyTransactionPin(context);
    
    if (!pinVerified) {
      ShowToastDialog.showToast("PIN verification failed");
      controller.isOrderPlaced.value = false;
      return;
    }

    // Deduct from wallet
    controller.placeOrder();
  }
*/

// ============================================
// PIN SERVICE QUICK REFERENCE
// ================================================

/*
// CREATE PIN
await PinService.createPin("1234");

// VERIFY PIN
bool isValid = await PinService.verifyPin("1234");

// CHECK IF PIN EXISTS
bool exists = await PinService.pinExists();

// UPDATE PIN (requires old PIN verification)
bool success = await PinService.updatePin("1234", "5678");

// RESET PIN (after email verification)
await PinService.resetPin("9999");

// GET REMAINING ATTEMPTS
int remaining = await PinService.getRemainingAttempts();

// GET LOCKOUT TIME (in seconds)
int lockoutSeconds = await PinService.getRemainingLockoutTime();

// DELETE PIN
await PinService.deletePin();

// SECURITY RULES:
// - Max 5 failed attempts before 15-minute lockout
// - PIN must be exactly 4 digits
// - PIN is stored in SharedPreferences
// - Attempts and lockout times are tracked
*/

// ============================================
// PROFILE SCREEN INTEGRATION
// ================================================
// The SecuritySettingsSection now includes:
//
// 1. Create Transaction PIN
//    - Opens CreatePinScreen
//    - Allows user to set initial 4-digit PIN
//
// 2. Reset Transaction PIN
//    - Opens ResetPinScreen
//    - Requires email verification via Firebase
//    - Two-step process: Email → Set New PIN
//
// 3. Change Password
//    - Opens ChangePasswordScreen (existing)
//    - Reauthenticates with current password
//    - Updates Firebase password
//
// 4. Biometric Authentication
//    - Toggle for fingerprint/face unlock
//    - Stored in SharedPreferences
//
// 5. Push Notifications
//    - Toggle for notification preferences
//
// 6. Device Management
//    - View active devices

// ============================================
// SECURITY IMPLEMENTATION NOTES
// ================================================

/*
FEATURES IMPLEMENTED:

✅ Transaction PIN Creation (4 digits)
  - Validation: exactly 4 numeric digits
  - Stored securely in SharedPreferences
  - Success confirmation dialog

✅ PIN Verification (with lockout)
  - Max 5 failed attempts
  - 15-minute auto-lockout after exceeded attempts
  - Remaining attempts tracking

✅ PIN Reset (with email verification)
  - Two-step process:
    1. Send password reset email (Firebase)
    2. User confirms email, sets new PIN
  - Clears lockout status on successful reset
  - Resets attempt counter

✅ Change Password (Firebase)
  - Reauthentication required
  - Validates current password
  - Updates Firebase authentication
  - Error handling for all auth exceptions

✅ Security Lockout
  - Automatic 15-minute lockout after 5 failed attempts
  - Lockout time tracking
  - Auto-unlock when time expires
  - Remaining lockout time calculation

NOT BREAKING:
  - Existing change password flow unchanged
  - Biometric toggle still functional
  - All navigation preserved
  - No changes to payment flows (yet)
  - All existing features intact

NEXT STEPS (when ready):
  - Wrap payment functions with PIN verification
  - Add PIN requirement toggle in settings
  - Integrate with wallet transactions
  - Add PIN change after successful payment
*/
