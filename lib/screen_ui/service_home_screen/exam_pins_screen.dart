import 'package:flutter/material.dart';
import 'package:customer/themes/app_them_data.dart';

class ExamPinsScreen extends StatelessWidget {
  const ExamPinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: AppThemeData.brandPrimaryBlue,
        title: const Text('Exam Pins'),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              title: const Text('WAEC'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('WAEC exam pins service')),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('NECO'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('NECO exam pins service')),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('JAMB'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('JAMB exam pins service')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
