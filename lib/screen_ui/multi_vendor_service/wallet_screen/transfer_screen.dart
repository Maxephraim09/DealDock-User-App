import 'package:flutter/material.dart';
import '../../../themes/app_them_data.dart';
import '../../../themes/round_button_fill.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final List<String> nigerianBanks = [
    'Access Bank',
    'Citibank Nigeria',
    'Ecobank Nigeria',
    'Fidelity Bank',
    'First Bank of Nigeria',
    'First City Monument Bank (FCMB)',
    'Globus Bank',
    'Guaranty Trust Bank (GTBank)',
    'Heritage Bank',
    'Keystone Bank',
    'Polaris Bank',
    'Providus Bank',
    'Stanbic IBTC Bank',
    'Standard Chartered Bank Nigeria',
    'Sterling Bank',
    'SunTrust Bank',
    'Titan Trust Bank',
    'Union Bank of Nigeria',
    'United Bank for Africa (UBA)',
    'Unity Bank',
    'Wema Bank',
    'Zenith Bank',
    'Opay',
    'PalmPay',
    'Kuda Bank',
    'Rubies Bank',
    'VFD Microfinance Bank',
    'Carbon (One Finance)',
    'ALAT by Wema',
  ];

  String? selectedBank;
  late final TextEditingController amountController;
  late final TextEditingController accountNumberController;
  late final TextEditingController accountNameController;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
    accountNumberController = TextEditingController();
    accountNameController = TextEditingController();
  }

  @override
  void dispose() {
    amountController.dispose();
    accountNumberController.dispose();
    accountNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer'),
        backgroundColor: AppThemeData.brandPrimaryBlue,
        iconTheme: const IconThemeData(color: AppThemeData.surface),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Transfer Money',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppThemeData.brandDeepBlue,
                ),
              ),
              const SizedBox(height: 20),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return nigerianBanks.where(
                    (bank) => bank.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    ),
                  );
                },
                onSelected: (String value) {
                  setState(() {
                    selectedBank = value;
                  });
                },
                fieldViewBuilder: (
                  BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted,
                ) {
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'Select Bank',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppThemeData.brandPrimaryBlue,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                },
                optionsViewBuilder: (
                  BuildContext context,
                  AutocompleteOnSelected<String> onSelected,
                  Iterable<String> options,
                ) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width - 32,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                onSelected(option);
                              },
                              child: ListTile(title: Text(option)),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: accountNumberController,
                decoration: InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppThemeData.brandPrimaryBlue,
                      width: 2,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: accountNameController,
                decoration: InputDecoration(
                  labelText: 'Account Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppThemeData.brandPrimaryBlue,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppThemeData.brandPrimaryBlue,
                      width: 2,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 40),
              RoundedButtonFill(
                title: 'Transfer',
                color: AppThemeData.brandPrimaryBlue,
                textColor: AppThemeData.surface,
                onPress: () {
                  if (selectedBank == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Please select a bank'),
                        backgroundColor: AppThemeData.danger300,
                      ),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Transfer initiated to $selectedBank'),
                      backgroundColor: AppThemeData.success400,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
