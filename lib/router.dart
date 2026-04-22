import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'config/app_config.dart';
import 'repositories/profile/profile_local_store.dart';
import 'screens/auth/select_language_screen.dart';
import 'routes.dart';
import 'screens/auth/tech_comfort_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/personal_details_screen.dart';
import 'screens/auth/verify_email_screen.dart';
import 'screens/auth/choose_verify_method_screen.dart';
import 'screens/auth/verify_otp_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/login_email_screen.dart';
import 'screens/auth/reset_link_sent_screen.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/auth/login_phone_screen.dart';
import 'screens/auth/welcome_modal_screen.dart';
import 'screens/setup/location_screen.dart';
import 'screens/setup/job_interests_screen.dart';
import 'screens/setup/preferences_screen.dart';
import 'screens/setup/values_screen.dart';
import 'screens/setup/communication_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/job_search/job_search_screen.dart';
import 'screens/job_search/job_search_detail_screen.dart';
import 'screens/company/company_profile_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/profile_basics_screen.dart';
import 'screens/profile/edit_skills_screen.dart';
import 'screens/profile/edit_competencies_screen.dart';
import 'screens/profile/edit_languages_screen.dart';
import 'screens/profile/edit_about_me_screen.dart';
import 'screens/profile/edit_job_preferences_screen.dart';
import 'screens/profile/edit_values_screen.dart';
import 'screens/profile/work_experience_screen.dart';
import 'screens/profile/education_screen.dart';
import 'screens/settings/account_settings_screen.dart';
import 'screens/applications/my_applications_screen.dart';
import 'screens/applications/application_details_screen.dart';
import 'screens/applications/job_detail_screen.dart';
import 'screens/blog/blog_news_screen.dart';
import 'screens/blog/blog_article_screen.dart';
import 'screens/career_assistant/career_assistant_screen.dart';
import 'screens/assessments/my_assessments_screen.dart';
import 'screens/assessments/assessment_detail_screen.dart';
import 'screens/assessments/assessment_quiz_screen.dart';
import 'screens/assessments/assessment_results_screen.dart';

class IthakiRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static const _storage = FlutterSecureStorage();

  // Routes that are accessible without phone verification.
  static const _unguardedRoutes = {
    Routes.root,
    Routes.techComfort,
    Routes.register,
    Routes.personalDetails,
    Routes.verifyEmail,
    Routes.chooseVerifyMethod,
    Routes.verifyOtp,
    Routes.verifyPhone,
    Routes.loginEmail,
    Routes.loginPhone,
    Routes.forgotPassword,
    Routes.resetLinkSent,
    Routes.resetPassword,
    // Blog is public content — no phone verification required.
    Routes.blogNews,
    Routes.blogArticle,
  };

  static Future<String?> _redirect(BuildContext context, GoRouterState state) async {
    if (AppConfig.useMockData) return null;

    final token = await _storage.read(key: 'jwt_token');
    if (token == null || token.isEmpty) return null;

    if (_unguardedRoutes.contains(state.matchedLocation)) return null;

    final phoneVerified = await ProfileLocalStore.loadPhoneVerified();
    // null = pre-existing session before this feature — don't block.
    if (phoneVerified != false) return null;

    return Routes.verifyOtp;
  }

  static final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: Routes.root,
    redirect: _redirect,
    routes: [
      GoRoute(
        path: Routes.root,
        builder: (context, state) => const SelectLanguageScreen(),
      ),
      GoRoute(
        path: Routes.techComfort,
        builder: (context, state) => const TechComfortScreen(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.personalDetails,
        builder: (context, state) => const PersonalDetailsScreen(),
      ),
      GoRoute(
        path: Routes.verifyEmail,
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      GoRoute(
        path: Routes.chooseVerifyMethod,
        builder: (context, state) => const ChooseVerifyMethodScreen(),
      ),
      GoRoute(
        path: Routes.verifyOtp,
        builder: (context, state) {
          final method = state.uri.queryParameters['method'] ?? 'sms';
          return VerifyOtpScreen(method: method);
        },
      ),
      GoRoute(
        path: Routes.verifyPhone,
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          final method = state.uri.queryParameters['method'] ?? 'sms';
          return VerifyOtpScreen(
            method: method,
            title: 'Login to Ithaki Talent',
            subtitle: "We've sent a verification code to $phone.",
            backLabel: 'This is not your phone?',
            backRoute: Routes.loginPhone,
            actionLabel: 'Sign Up',
            actionRoute: Routes.root,
            successRoute: Routes.home,
          );
        },
      ),
      GoRoute(
        path: Routes.loginEmail,
        builder: (context, state) => const LoginEmailScreen(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: Routes.resetLinkSent,
        builder: (context, state) => const ResetLinkSentScreen(),
      ),
      GoRoute(
        path: Routes.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: Routes.loginPhone,
        builder: (context, state) => const LoginPhoneScreen(),
      ),
      GoRoute(
        path: Routes.welcome,
        pageBuilder: (context, state) => CustomTransitionPage(
          opaque: false,
          barrierColor: Colors.black54,
          child: const WelcomeModalScreen(),
          transitionsBuilder: (context, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: Routes.setupLocation,
        builder: (context, state) => const LocationScreen(),
      ),
      GoRoute(
        path: Routes.setupJobInterests,
        builder: (context, state) => const JobInterestsScreen(),
      ),
      GoRoute(
        path: Routes.setupPreferences,
        builder: (context, state) => const PreferencesScreen(),
      ),
      GoRoute(
        path: Routes.setupValues,
        builder: (context, state) => const ValuesScreen(),
      ),
      GoRoute(
        path: Routes.setupCommunication,
        builder: (context, state) => const CommunicationScreen(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.jobSearch,
        builder: (context, state) => const JobSearchScreen(),
      ),
      GoRoute(
        path: Routes.jobSearchDetail,
        builder: (context, state) => JobSearchDetailScreen(
          jobId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: Routes.companyProfile,
        builder: (context, state) => CompanyProfileScreen(
          companyId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: Routes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: Routes.profileBasics,
        builder: (context, state) => const ProfileBasicsScreen(),
      ),
      GoRoute(
        path: Routes.profileSkills,
        builder: (context, state) => const EditSkillsScreen(),
      ),
      GoRoute(
        path: Routes.profileCompetencies,
        builder: (context, state) => const EditCompetenciesScreen(),
      ),
      GoRoute(
        path: Routes.profileLanguages,
        builder: (context, state) => const EditLanguagesScreen(),
      ),
      GoRoute(
        path: Routes.profileAboutMe,
        builder: (context, state) => const EditAboutMeScreen(),
      ),
      GoRoute(
        path: Routes.profileJobPreferences,
        builder: (context, state) => const EditJobPreferencesScreen(),
      ),
      GoRoute(
        path: Routes.profileWorkExperience,
        builder: (context, state) => const WorkExperienceScreen(),
      ),
      GoRoute(
        path: Routes.profileWorkExperienceEdit,
        builder: (context, state) {
          final extra = WorkExperienceEditExtra.fromExtra(state.extra);
          return WorkExperienceFormScreen(
            editIndex: extra.index,
            initial: extra.exp,
          );
        },
      ),
      GoRoute(
        path: Routes.profileEducation,
        builder: (context, state) => const EducationScreen(),
      ),
      GoRoute(
        path: Routes.profileValues,
        builder: (context, state) => const EditValuesScreen(),
      ),
      GoRoute(
        path: Routes.profileEducationEdit,
        builder: (context, state) {
          final extra = EducationEditExtra.fromExtra(state.extra);
          return EducationFormScreen(
            editIndex: extra.index,
            initial: extra.edu,
          );
        },
      ),
      GoRoute(
        path: Routes.myApplications,
        builder: (context, state) => const MyApplicationsScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return ApplicationDetailsScreen(applicationId: id);
            },
          ),
          GoRoute(
            path: ':id/job',
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return JobDetailScreen(applicationId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: Routes.invitationJobDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return JobDetailScreen(applicationId: id, isInvitation: true);
        },
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.settingsNotifications,
        builder: (context, state) => const SettingsScreen(initialTab: 1),
      ),
      GoRoute(
        path: Routes.careerAssistant,
        builder: (context, state) => const CareerAssistantScreen(),
      ),
      GoRoute(
        path: Routes.assessments,
        builder: (context, state) => const MyAssessmentsScreen(),
      ),
      GoRoute(
        path: Routes.assessmentDetail,
        builder: (context, state) => AssessmentDetailScreen(
          assessmentId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: Routes.assessmentQuiz,
        builder: (context, state) => AssessmentQuizScreen(
          assessmentId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: Routes.assessmentResults,
        builder: (context, state) => AssessmentResultsScreen(
          assessmentId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: Routes.blogNews,
        builder: (context, state) => const BlogNewsScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return BlogArticleScreen(articleId: id);
            },
          ),
        ],
      ),
    ],
  );
}
