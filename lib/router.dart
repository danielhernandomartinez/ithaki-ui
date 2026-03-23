import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
import 'screens/profile/profile_screen.dart';
import 'screens/profile/profile_basics_screen.dart';
import 'screens/profile/edit_skills_screen.dart';
import 'screens/profile/edit_competencies_screen.dart';
import 'screens/profile/edit_languages_screen.dart';
import 'screens/profile/edit_about_me_screen.dart';
import 'screens/profile/edit_job_preferences_screen.dart';
import 'screens/profile/work_experience_screen.dart';
import 'screens/profile/education_screen.dart';
import 'screens/settings/account_settings_screen.dart';
import 'screens/settings/notifications_screen.dart';

class IthakiRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
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
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/basics',
        builder: (context, state) => const ProfileBasicsScreen(),
      ),
      GoRoute(
        path: '/profile/skills',
        builder: (context, state) => const EditSkillsScreen(),
      ),
      GoRoute(
        path: '/profile/competencies',
        builder: (context, state) => const EditCompetenciesScreen(),
      ),
      GoRoute(
        path: '/profile/languages',
        builder: (context, state) => const EditLanguagesScreen(),
      ),
      GoRoute(
        path: '/profile/about-me',
        builder: (context, state) => const EditAboutMeScreen(),
      ),
      GoRoute(
        path: '/profile/job-preferences',
        builder: (context, state) => const EditJobPreferencesScreen(),
      ),
      GoRoute(
        path: '/profile/work-experience',
        builder: (context, state) => const WorkExperienceScreen(),
      ),
      GoRoute(
        path: '/profile/education',
        builder: (context, state) => const EducationScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const AccountSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
}
