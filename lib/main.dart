import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import 'providers/locale_provider.dart';
import 'providers/tour_provider.dart';
import 'router.dart';
import 'tour/tour_overlay.dart';

void main() => runApp(const ProviderScope(child: IthakiApp()));

class IthakiApp extends ConsumerWidget {
  const IthakiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final tourKeys = ref.watch(tourKeysProvider);

    return MaterialApp.router(
      title: 'Ithaki',
      debugShowCheckedModeBanner: false,
      theme: IthakiTheme.light,
      routerConfig: IthakiRouter.router,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('el'),
        Locale('ar'),
      ],
      builder: (context, child) => TourOverlay(
        keys: tourKeys,
        child: child!,
      ),
    );
  }
}
