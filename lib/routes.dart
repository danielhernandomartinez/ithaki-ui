import 'models/profile_models.dart';

/// Centralized route paths — eliminates magic strings from navigation.
abstract final class Routes {
  // Auth
  static const root = '/';
  static const techComfort = '/tech-comfort';
  static const register = '/register';
  static const personalDetails = '/personal-details';
  static const verifyEmail = '/verify-email';
  static const chooseVerifyMethod = '/choose-verify-method';
  static const verifyOtp = '/verify-otp';
  static const verifyPhone = '/verify-phone';
  static const loginEmail = '/login-email';
  static const forgotPassword = '/forgot-password';
  static const resetLinkSent = '/reset-link-sent';
  static const resetPassword = '/reset-password';
  static const loginPhone = '/login-phone';
  static const welcome = '/welcome';

  // Setup
  static const setupLocation = '/setup/location';
  static const setupJobInterests = '/setup/job-interests';
  static const setupPreferences = '/setup/preferences';
  static const setupValues = '/setup/values';
  static const setupCommunication = '/setup/communication';

  // Core
  static const home = '/home';
  static const jobSearch = '/job-search';
  static const jobSearchDetail = '/job-search/:id';
  static String jobSearchDetailFor(String id) => '/job-search/$id';

  static const companyProfile = '/company/:id';
  static String companyProfileFor(String id) => '/company/$id';
  static const companyEventDetail = '/company/:id/events/:eventId';
  static String companyEventDetailFor(String id, String eventId) =>
      '/company/$id/events/$eventId';
  static const myApplications = '/applications';
  static const applicationDetail = '/applications/:id';
  static const jobDetail = '/applications/:id/job';
  static String jobDetailFor(String applicationId) =>
      '/applications/$applicationId/job';

  static const invitationJobDetail = '/invitations/:id/job';
  static String invitationJobDetailFor(String invitationId) =>
      '/invitations/$invitationId/job';

  // Profile
  static const profile = '/profile';
  static const cv = '/cv';
  static const profileBasics = '/profile/basics';
  static const profileSkills = '/profile/skills';
  static const profileCompetencies = '/profile/competencies';
  static const profileLanguages = '/profile/languages';
  static const profileAboutMe = '/profile/about-me';
  static const profileJobPreferences = '/profile/job-preferences';
  static const profileValues = '/profile/values';
  static const profileWorkExperience = '/profile/work-experience';
  static const profileWorkExperienceEdit = '/profile/work-experience/edit';
  static const profileEducation = '/profile/education';
  static const profileEducationEdit = '/profile/education/edit';

  // Settings
  static const settings = '/settings';
  static const settingsNotifications = '/settings/notifications';

  // Career Assistant
  static const careerAssistant = '/career-assistant';

  // Assessments
  static const assessments = '/assessments';
  static const assessmentDetail = '/assessments/:id';
  static String assessmentDetailFor(String id) => '/assessments/$id';
  static const assessmentQuiz = '/assessments/:id/quiz';
  static String assessmentQuizFor(String id) => '/assessments/$id/quiz';
  static const assessmentResults = '/assessments/:id/results';
  static String assessmentResultsFor(String id) => '/assessments/$id/results';

  // Debug (dev only)
  static const apiDiagnostics = '/debug/api-diagnostics';

  // Blog
  static const blogNews = '/blog';
  static const blogArticle = '/blog/:id';
  static String blogArticleFor(String id) => '/blog/$id';

  // -- Query-parameter helpers --

  static String applicationDetailFor(String id) => '/applications/$id';

  static String verifyOtpWith({required String method}) =>
      '$verifyOtp?method=$method';

  static String verifyPhoneWith({
    required String phone,
    required String method,
  }) =>
      '$verifyPhone?phone=${Uri.encodeComponent(phone)}&method=$method';
}

/// Type-safe extras for [Routes.profileWorkExperienceEdit].
class WorkExperienceEditExtra {
  final int? index;
  final WorkExperience? exp;
  const WorkExperienceEditExtra({this.index, this.exp});

  Map<String, dynamic> toMap() => {'index': index, 'exp': exp};

  factory WorkExperienceEditExtra.fromExtra(Object? extra) {
    final map = extra as Map<String, dynamic>?;
    return WorkExperienceEditExtra(
      index: map?['index'] as int?,
      exp: map?['exp'] as WorkExperience?,
    );
  }
}

/// Type-safe extras for [Routes.profileEducationEdit].
class EducationEditExtra {
  final int? index;
  final Education? edu;
  const EducationEditExtra({this.index, this.edu});

  Map<String, dynamic> toMap() => {'index': index, 'edu': edu};

  factory EducationEditExtra.fromExtra(Object? extra) {
    final map = extra as Map<String, dynamic>?;
    return EducationEditExtra(
      index: map?['index'] as int?,
      edu: map?['edu'] as Education?,
    );
  }
}
