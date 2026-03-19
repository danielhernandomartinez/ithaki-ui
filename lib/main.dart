import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import 'screens/login_phone_screen.dart';

void main() => runApp(const IthakiApp());

class IthakiApp extends StatelessWidget {
  const IthakiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ithaki',
      debugShowCheckedModeBanner: false,
      theme: IthakiTheme.light,
      home: const LoginPhoneScreen(),
    );
  }
}
