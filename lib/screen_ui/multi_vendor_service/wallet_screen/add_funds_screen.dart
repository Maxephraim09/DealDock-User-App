import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/theme_controller.dart';
import 'package:customer/controllers/wallet_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/themes/text_field_widget.dart';
import 'package:customer/themes/show_toast_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddFundsScreen extends StatefulWidget {
  const AddFundsScreen({super.key});

  @override
  State<AddFundsScreen> createState() => _AddFundsScreenState();
}

class _AddFundsScreenState extends State<AddFundsScreen> {
  late final WalletController controller;
  final RxBool isBalanceHidden = false.obs;
  final NumberFormat _formatter = NumberFormat.decimalPattern();
  final TextEditingController cryptoAmountController = TextEditingController();
  String selectedCrypto = '';

  static const List<int> quickAmounts = [1000, 2000, 5000, 10000];

  static const Map<String, String> _onlinePaymentMethods = {
    'flutterWave': 'assets/images/flutterwave_logo.png',
    'payStack': 'assets/images/paystack.png',
  };

  static const Map<String, String> _cryptoAddresses = {
    'crypto_btc': '1BoatSLRHtKNngkdXEeobR76b53LETtpyT',
    'crypto_eth': '0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B',
    'crypto_usdt': 'TF9fQNgBpz2WUtLrPpHJ7H9iS1c4frgFYE',
    'crypto_bnb': 'bnb1q9z5r4vg7ql5r2gf0x8h9zjh5u6t3wylf3xh3h',
    'crypto_solana': '4sP1ng5pQax1s9K21y8kzS6MB9NBjpB7KQSPT51ZaGK8',
  };

  static const Map<String, String> _cryptoNames = {
    'crypto_btc': 'Bitcoin (BTC)',
    'crypto_eth': 'Ethereum (ETH)',
    'crypto_usdt': 'USDT',
    'crypto_bnb': 'BNB',
    'crypto_solana': 'Solana (SOL)',
  };

  @override
  void initState() {
    super.initState();
    controller = Get.put(WalletController());
    controller.selectedPaymentMethod.value = '';
    controller.topUpAmountController.value.text = '';
  }

  @override
  void dispose() {
    cryptoAmountController.dispose();
    super.dispose();
  }

  Future<void> _handleCryptoDeposit() async {
    final amountText = _cleanAmount(cryptoAmountController.text);
    if (selectedCrypto.isEmpty) {
      ShowToastDialog.showToast('Please select cryptocurrency'.tr);
      return;
    }
    if (amountText.isEmpty) {
      ShowToastDialog.showToast('Please enter amount'.tr);
      return;
    }

    final double amount = double.tryParse(amountText) ?? 0.0;
    if (amount <= 0) {
      ShowToastDialog.showToast('Please enter a valid amount'.tr);
      return;
    }

    final currency = _selectedCryptoSymbol(selectedCrypto);
    final walletAddress = _cryptoAddresses[selectedCrypto]!;
    final reference =
        'CRYPTO-${currency.toUpperCase()}-${DateTime.now().millisecondsSinceEpoch}';
    final bool created = await controller.createPendingCryptoTransaction(
      amount: amountText,
      cryptoCurrency: currency,
      walletAddress: walletAddress,
      paymentMethod: selectedCrypto,
      reference: reference,
    );
    if (created) {
      Get.to(
        () => CryptoDepositPendingScreen(
          currency: currency,
          amount: amountText,
          walletAddress: walletAddress,
          transactionReference: reference,
        ),
      );
    } else {
      ShowToastDialog.showToast('Unable to create crypto transaction'.tr);
    }
  }

  String _formatAmount(String value) {
    final digits = value.replaceAll(RegExp('[^0-9]'), '');
    if (digits.isEmpty) return '';
    return _formatter.format(int.parse(digits));
  }

  String _cleanAmount(String value) {
    return value.replaceAll(',', '').trim();
  }

  String _selectedCryptoName(String method) {
    return _cryptoNames[method] ?? 'Crypto';
  }

  String _selectedCryptoSymbol(String method) {
    if (method == 'crypto_btc') return 'BTC';
    if (method == 'crypto_eth') return 'ETH';
    if (method == 'crypto_usdt') return 'USDT';
    if (method == 'crypto_bnb') return 'BNB';
    if (method == 'crypto_solana') return 'SOL';
    return 'CRYPTO';
  }

  bool _isCryptoMethod(String method) {
    return method.startsWith('crypto_');
  }

  bool _isBankTransfer(String method) {
    return method == 'bankTransfer';
  }

  double get _minimumAmount {
    return double.tryParse(Constant.minimumAmountToDeposit) ?? 0.0;
  }

  Future<void> _copyToClipboard(String value, String label) async {
    await Clipboard.setData(ClipboardData(text: value));
    ShowToastDialog.showToast('$label copied');
  }

  Future<void> _handleAddFunds() async {
    final amountText = _cleanAmount(
      controller.topUpAmountController.value.text,
    );
    if (amountText.isEmpty) {
      ShowToastDialog.showToast('Please enter amount'.tr);
      return;
    }

    final double amount = double.tryParse(amountText) ?? 0.0;
    if (amount <= 0) {
      ShowToastDialog.showToast('Please enter a valid amount'.tr);
      return;
    }

    if (amount < _minimumAmount) {
      ShowToastDialog.showToast(
        '${'Please Enter minimum amount of'.tr} ${Constant.amountShow(amount: Constant.minimumAmountToDeposit)}',
      );
      return;
    }

    final selectedMethod = controller.selectedPaymentMethod.value;
    if (selectedMethod.isEmpty) {
      ShowToastDialog.showToast('Please select payment method'.tr);
      return;
    }

    if (_isCryptoMethod(selectedMethod)) {
      final currency = _selectedCryptoSymbol(selectedMethod);
      final walletAddress = _cryptoAddresses[selectedMethod]!;
      final reference =
          'CRYPTO-${currency.toUpperCase()}-${DateTime.now().millisecondsSinceEpoch}';
      final bool created = await controller.createPendingCryptoTransaction(
        amount: amountText,
        cryptoCurrency: currency,
        walletAddress: walletAddress,
        paymentMethod: selectedMethod,
        reference: reference,
      );
      if (created) {
        Get.to(
          () => CryptoDepositPendingScreen(
            currency: currency,
            amount: amountText,
            walletAddress: walletAddress,
            transactionReference: reference,
          ),
        );
      } else {
        ShowToastDialog.showToast('Unable to create crypto transaction'.tr);
      }
      return;
    }

    switch (selectedMethod) {
      case 'stripe':
        controller.stripeMakePayment(amount: amountText);
        break;
      case 'paypal':
        controller.paypalPaymentSheet(amountText, context);
        break;
      case 'payStack':
        controller.payStackPayment(amountText);
        break;
      case 'flutterWave':
        controller.flutterWaveInitiatePayment(
          context: context,
          amount: amountText,
        );
        break;
      case 'orangeMoney':
        controller.orangeMakePayment(amount: amountText, context: context);
        break;
      case 'bankTransfer':
        final bool created = await controller.createPendingCryptoTransaction(
          amount: amountText,
          cryptoCurrency: 'Bank Transfer',
          walletAddress: 'Manual transfer',
          paymentMethod: selectedMethod,
          reference: 'BANK-${DateTime.now().millisecondsSinceEpoch}',
        );
        if (created) {
          Get.to(() => BankTransferPendingScreen(amount: amountText));
        } else {
          ShowToastDialog.showToast('Unable to create transfer record'.tr);
        }
        break;
      default:
        ShowToastDialog.showToast(
          'This payment method is not supported yet'.tr,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.find<ThemeController>().isDark.value;
    return GetX<WalletController>(
      builder: (_) {
        return Scaffold(
          backgroundColor:
              isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
          appBar: AppBar(
            backgroundColor: AppThemeData.brandPrimaryBlue,
            title: Text(
              'Add Funds'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            leading: const BackButton(color: Colors.white),
            elevation: 0,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WalletSummaryCard(
                    balance:
                        double.tryParse(
                          controller.userModel.value.walletAmount?.toString() ??
                              '0.0',
                        ) ??
                        0.0,
                    hideBalance: isBalanceHidden,
                    currencySymbol: '₦',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  AmountInputField(
                    controller: controller.topUpAmountController.value,
                    currencySymbol: '₦',
                    hintText: '₦ Enter amount'.tr,
                    onChanged: (value) {
                      final formatted = _formatAmount(value);
                      if (formatted != value) {
                        controller.topUpAmountController.value.text = formatted;
                        controller.topUpAmountController.value.selection =
                            TextSelection.collapsed(offset: formatted.length);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        quickAmounts.map((amount) {
                          return QuickAmountButton(
                            amount: amount,
                            onTap: () {
                              final formatted = _formatter.format(amount);
                              controller.topUpAmountController.value.text =
                                  formatted;
                              controller
                                  .topUpAmountController
                                  .value
                                  .selection = TextSelection.collapsed(
                                offset: formatted.length,
                              );
                            },
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const SectionTitle(title: 'Payment Method'),
                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: isDark ? AppThemeData.grey900 : AppThemeData.surface,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          ..._onlinePaymentMethods.entries.map((entry) {
                            return PaymentMethodTile(
                              title:
                                  entry.key == 'payStack'
                                      ? 'Paystack'
                                      : 'Flutterwave',
                              iconAsset: entry.value,
                              value: entry.key,
                              groupValue:
                                  controller.selectedPaymentMethod.value,
                              onTap:
                                  () =>
                                      controller.selectedPaymentMethod.value =
                                          entry.key,
                              isDark: isDark,
                            );
                          }),
                          PaymentMethodTile(
                            title: 'Monnify',
                            iconAsset: '',
                            iconData: Icons.payment,
                            value: 'monnify',
                            groupValue: controller.selectedPaymentMethod.value,
                            onTap: () {
                              controller.selectedPaymentMethod.value =
                                  'monnify';
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => Scaffold(
                                        appBar: AppBar(
                                          title: const Text('Monnify'),
                                          backgroundColor:
                                              AppThemeData.brandPrimaryBlue,
                                        ),
                                        body: const Center(
                                          child: Text(
                                            'Monnify payment coming soon',
                                          ),
                                        ),
                                      ),
                                ),
                              );
                            },
                            isDark: isDark,
                          ),
                          PaymentMethodTile(
                            title: 'Bank Transfer',
                            iconAsset: '',
                            iconData: Icons.account_balance,
                            value: 'bankTransfer',
                            groupValue: controller.selectedPaymentMethod.value,
                            onTap:
                                () =>
                                    controller.selectedPaymentMethod.value =
                                        'bankTransfer',
                            isDark: isDark,
                          ),
                          Visibility(
                            visible:
                                controller.orangeMoneyModel.value.enable ==
                                true,
                            child: PaymentMethodTile(
                              title: 'Orange Money',
                              iconAsset: 'assets/images/orange_money.png',
                              value: 'orangeMoney',
                              groupValue:
                                  controller.selectedPaymentMethod.value,
                              onTap:
                                  () =>
                                      controller.selectedPaymentMethod.value =
                                          'orangeMoney',
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SectionTitle(title: 'Crypto Payment'),
                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: isDark ? AppThemeData.grey900 : AppThemeData.surface,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DropdownButtonFormField<String>(
                            value:
                                selectedCrypto.isEmpty ? null : selectedCrypto,
                            decoration: InputDecoration(
                              labelText: 'Cryptocurrency'.tr,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                            ),
                            hint: Text('Select Cryptocurrency'.tr),
                            items:
                                _cryptoNames.entries.map((entry) {
                                  return DropdownMenuItem(
                                    value: entry.key,
                                    child: Text(entry.value),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCrypto = value ?? '';
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFieldWidget(
                            title: 'Amount'.tr,
                            hintText: '₦ Enter amount'.tr,
                            controller: cryptoAmountController,
                            textInputType:
                                const TextInputType.numberWithOptions(
                                  decimal: false,
                                  signed: false,
                                ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            prefix: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '₦',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            onchange: (value) {
                              final formatted = _formatAmount(value);
                              if (formatted != value) {
                                cryptoAmountController.text = formatted;
                                cryptoAmountController
                                    .selection = TextSelection.collapsed(
                                  offset: formatted.length,
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          RoundedButtonFill(
                            title: 'Proceed'.tr,
                            color: AppThemeData.brandPrimaryBlue,
                            textColor: Colors.white,
                            onPress: _handleCryptoDeposit,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (selectedCrypto.isNotEmpty)
                    CryptoWalletWidget(
                      currency: _selectedCryptoName(selectedCrypto),
                      address: _cryptoAddresses[selectedCrypto]!,
                      onCopy:
                          () => _copyToClipboard(
                            _cryptoAddresses[selectedCrypto]!,
                            'Wallet address',
                          ),
                      note:
                          'Funds will reflect after blockchain confirmation'.tr,
                      isDark: isDark,
                    ),
                  const SizedBox(height: 16),
                  Obx(() {
                    final selectedMethod =
                        controller.selectedPaymentMethod.value;
                    if (_isBankTransfer(selectedMethod)) {
                      return BankTransferWidget(
                        onCopy:
                            () => _copyToClipboard(
                              '7088916857',
                              'Account number',
                            ),
                        isDark: isDark,
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: RoundedButtonFill(
              title: 'Add Funds'.tr,
              color: AppThemeData.brandPrimaryBlue,
              textColor: Colors.white,
              height: 5.5,
              onPress: _handleAddFunds,
            ),
          ),
        );
      },
    );
  }
}

class WalletSummaryCard extends StatelessWidget {
  final double balance;
  final RxBool hideBalance;
  final String currencySymbol;
  final bool isDark;

  const WalletSummaryCard({
    super.key,
    required this.balance,
    required this.hideBalance,
    required this.currencySymbol,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? AppThemeData.grey900 : AppThemeData.brandPrimaryBlue,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Current Balance'.tr,
                    style: const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.85),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => hideBalance.value = !hideBalance.value,
                  icon: Icon(
                    hideBalance.value ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              hideBalance.value
                  ? '****'.tr
                  : '$currencySymbol ${balance.toStringAsFixed(0)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AmountInputField extends StatelessWidget {
  final TextEditingController controller;
  final String currencySymbol;
  final String hintText;
  final ValueChanged<String> onChanged;

  const AmountInputField({
    super.key,
    required this.controller,
    required this.currencySymbol,
    this.hintText = '',
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      title: 'Amount'.tr,
      hintText: hintText.isNotEmpty ? hintText : 'Enter amount'.tr,
      controller: controller,
      textInputType: const TextInputType.numberWithOptions(
        decimal: false,
        signed: false,
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      prefix: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          currencySymbol,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      onchange: onChanged,
    );
  }
}

class QuickAmountButton extends StatelessWidget {
  final int amount;
  final VoidCallback onTap;

  const QuickAmountButton({
    super.key,
    required this.amount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppThemeData.surface,
          border: Border.all(color: AppThemeData.grey300),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          '₦${amount.toString()}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final String title;
  final String iconAsset;
  final IconData? iconData;
  final String value;
  final String groupValue;
  final VoidCallback onTap;
  final bool isDark;

  const PaymentMethodTile({
    super.key,
    required this.title,
    required this.iconAsset,
    this.iconData,
    required this.value,
    required this.groupValue,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected = groupValue == value;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (iconAsset.isNotEmpty)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color:
                      isDark ? AppThemeData.greyDark100 : AppThemeData.grey50,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(iconAsset, fit: BoxFit.contain),
                ),
              )
            else
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color:
                      isDark ? AppThemeData.greyDark100 : AppThemeData.grey100,
                ),
                child: Icon(
                  iconData ?? Icons.payment,
                  color: AppThemeData.brandPrimaryBlue,
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                ),
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color:
                  selected
                      ? AppThemeData.brandPrimaryBlue
                      : AppThemeData.grey500,
            ),
          ],
        ),
      ),
    );
  }
}

class CryptoWalletWidget extends StatelessWidget {
  final String currency;
  final String address;
  final VoidCallback onCopy;
  final String note;
  final bool isDark;

  const CryptoWalletWidget({
    super.key,
    required this.currency,
    required this.address,
    required this.onCopy,
    required this.note,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDark ? AppThemeData.grey900 : AppThemeData.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currency,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: QrImageView(
                data: address,
                version: QrVersions.auto,
                size: 180.0,
                backgroundColor: isDark ? AppThemeData.grey900 : Colors.white,
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                ),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDark ? AppThemeData.grey800 : AppThemeData.grey100,
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deposit Address',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(address, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          note,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppThemeData.grey500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      RoundedButtonFill(
                        title: 'Copy'.tr,
                        width: 28,
                        height: 4.8,
                        color: AppThemeData.brandPrimaryBlue,
                        textColor: Colors.white,
                        onPress: onCopy,
                      ),
                    ],
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

class BankTransferWidget extends StatelessWidget {
  final VoidCallback onCopy;
  final bool isDark;

  const BankTransferWidget({
    super.key,
    required this.onCopy,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDark ? AppThemeData.grey800 : Colors.grey.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bank Transfer',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Account Name: DealDock'),
          const SizedBox(height: 8),
          const Text('Bank: Opay'),
          const SizedBox(height: 8),
          const Text('Account Number: 7088916857'),
          const SizedBox(height: 16),
          RoundedButtonFill(
            title: 'Copy account number'.tr,
            width: double.infinity,
            height: 5.2,
            color: AppThemeData.brandPrimaryBlue,
            textColor: Colors.white,
            onPress: onCopy,
          ),
        ],
      ),
    );
  }
}

class BankDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const BankDetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.tr,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}

class CryptoDepositPendingScreen extends StatelessWidget {
  final String currency;
  final String amount;
  final String walletAddress;
  final String transactionReference;

  const CryptoDepositPendingScreen({
    super.key,
    required this.currency,
    required this.amount,
    required this.walletAddress,
    required this.transactionReference,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Get.find<ThemeController>().isDark.value;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeData.brandPrimaryBlue,
        title: Text('Deposit pending'.tr),
        leading: const BackButton(color: Colors.white),
      ),
      backgroundColor: isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Funds submitted'.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your $currency deposit is pending blockchain confirmation.'.tr,
                style: TextStyle(color: AppThemeData.grey500, fontSize: 15),
              ),
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Constant.amountShow(amount: amount),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Reference ID'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        transactionReference,
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Expected update after network confirmation.'.tr,
                        style: TextStyle(color: AppThemeData.grey500),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              RoundedButtonFill(
                title: 'Done'.tr,
                color: AppThemeData.brandPrimaryBlue,
                textColor: Colors.white,
                onPress: () {
                  Get.offAllNamed('/wallet');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BankTransferPendingScreen extends StatelessWidget {
  final String amount;

  const BankTransferPendingScreen({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    final isDark = Get.find<ThemeController>().isDark.value;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeData.brandPrimaryBlue,
        title: Text('Bank transfer pending'.tr),
        leading: const BackButton(color: Colors.white),
      ),
      backgroundColor: isDark ? AppThemeData.surfaceDark : AppThemeData.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manual transfer'.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your transfer record has been created. Please complete the bank transfer and wait for confirmation.'
                    .tr,
                style: TextStyle(color: AppThemeData.grey500, fontSize: 15),
              ),
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Constant.amountShow(amount: amount),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Bank transfers are verified manually and will be credited after confirmation.'
                            .tr,
                        style: TextStyle(color: AppThemeData.grey500),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              RoundedButtonFill(
                title: 'Close'.tr,
                color: AppThemeData.brandPrimaryBlue,
                textColor: Colors.white,
                onPress: () {
                  Get.offAllNamed('/wallet');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
