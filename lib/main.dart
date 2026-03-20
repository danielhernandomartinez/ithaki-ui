import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import 'router.dart';

void main() => runApp(const IthakiApp());

class IthakiApp extends StatelessWidget {
  const IthakiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ithaki',
      debugShowCheckedModeBanner: false,
      theme: IthakiTheme.light,
      routerConfig: IthakiRouter.router,
    );
  }
}
