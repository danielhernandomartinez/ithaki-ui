import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import 'providers/locale_provider.dart';
import 'routes.dart';
import 'providers/tour_provider.dart';
import 'router.dart';
import 'services/api_client.dart';
import 'tour/tour_overlay.dart';

const _nativeConfigChannel = MethodChannel('ithaki/config');

Future<String?> _loadGoogleServerClientId() async {
  try {
    final clientId =
        await _nativeConfigChannel.invokeMethod<String>('googleServerClientId');
    final trimmed = clientId?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  } catch (e) {
    debugPrint('[GoogleSignIn] load serverClientId failed: $e');
    return null;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    const googleClientIdFromDefine = String.fromEnvironment('GOOGLE_CLIENT_ID');
    final googleClientId =
        googleClientIdFromDefine.isNotEmpty ? googleClientIdFromDefine : null;
    await GoogleSignIn.instance.initialize(
      serverClientId: googleClientId ?? await _loadGoogleServerClientId(),
    );
  } catch (e) {
    debugPrint('[GoogleSignIn] initialize failed: $e');
  }
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exceptionAsString()}');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Unhandled error: $error\n$stack');
    return true;
  };
  runApp(ProviderScope(
    overrides: [
      sessionExpiredHandlerProvider.overrideWithValue(
        () => IthakiRouter.navigatorKey.currentContext?.go(Routes.root),
      ),
    ],
    child: const IthakiApp(),
  ));
}

class IthakiApp extends ConsumerWidget {
  const IthakiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider).value;
    final tourKeys = ref.watch(tourKeysProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Ithaki',
      debugShowCheckedModeBanner: false,
      theme: IthakiTheme.light,
      routerConfig: router,
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
        Locale('es'),
      ],
      builder: (context, child) => TourOverlay(
        keys: tourKeys,
        child: child!,
      ),
    );
  }
}
