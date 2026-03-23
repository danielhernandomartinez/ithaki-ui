import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/auth/select_language_screen.dart';
import 'screens/auth/tech_comfort_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/personal_details_screen.dart';
import 'screens/auth/verify_email_screen.dart';
import 'screens/auth/choose_verify_method_screen.dart';
import 'screens/auth/verify_otp_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/login_email_screen.dart';
import 'screens/auth/reset_link_sent_screen.dart';
import 'screens/auth/login_phone_screen.dart';
import 'screens/auth/welcome_modal_screen.dart';
import 'screens/setup/location_screen.dart';
import 'screens/setup/job_interests_screen.dart';
import 'screens/setup/preferences_screen.dart';
import 'screens/setup/values_screen.dart';
import 'screens/setup/communication_screen.dart';
import 'screens/home/home_screen.dart';

class IthakiRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SelectLanguageScreen(),
      ),
      GoRoute(
        path: '/tech-comfort',
        builder: (context, state) => const TechComfortScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/personal-details',
        builder: (context, state) => const PersonalDetailsScreen(),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      GoRoute(
        path: '/choose-verify-method',
        builder: (context, state) => const ChooseVerifyMethodScreen(),
      ),
      GoRoute(
        path: '/verify-otp',
        builder: (context, state) {
          final method = state.uri.queryParameters['method'] ?? 'sms';
          return VerifyOtpScreen(method: method);
        },
      ),
      GoRoute(
        path: '/verify-phone',
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          final method = state.uri.queryParameters['method'] ?? 'sms';
          return VerifyOtpScreen(
            method: method,
            title: 'Login to Ithaki Talent',
            subtitle: "We've sent a verification code to $phone.",
            backLabel: 'This is not your phone?',
            backRoute: '/login-phone',
            actionLabel: 'Sign Up',
            actionRoute: '/',
            successRoute: '/home',
          );
        },
      ),
      GoRoute(
        path: '/login-email',
        builder: (context, state) => const LoginEmailScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-link-sent',
        builder: (context, state) => const ResetLinkSentScreen(),
      ),
      GoRoute(
        path: '/login-phone',
        builder: (context, state) => const LoginPhoneScreen(),
      ),
      GoRoute(
        path: '/welcome',
        pageBuilder: (context, state) => CustomTransitionPage(
          opaque: false,
          barrierColor: Colors.black54,
          child: const WelcomeModalScreen(),
          transitionsBuilder: (context, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: '/setup/location',
        builder: (context, state) => const LocationScreen(),
      ),
      GoRoute(
        path: '/setup/job-interests',
        builder: (context, state) => const JobInterestsScreen(),
      ),
      GoRoute(
        path: '/setup/preferences',
        builder: (context, state) => const PreferencesScreen(),
      ),
      GoRoute(
        path: '/setup/values',
        builder: (context, state) => const ValuesScreen(),
      ),
      GoRoute(
        path: '/setup/communication',
        builder: (context, state) => const CommunicationScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
