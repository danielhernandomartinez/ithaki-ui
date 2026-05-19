class AppConfig {
  const AppConfig._();

  static const apiBaseUrl = String.fromEnvironment('ITHAKI_API_BASE_URL');
  static const useMockData = bool.fromEnvironment('ITHAKI_USE_MOCK_DATA');

  /// Assessments API is not guaranteed to be available in all environments yet.
  /// Default to mock data unless explicitly disabled at build time.
  static const useMockAssessments = useMockData ||
      bool.fromEnvironment('ITHAKI_USE_MOCK_ASSESSMENTS', defaultValue: true);

  /// Temporarily hides assessment-related UI in the Profile/CV screens.
  static const showAssessmentsInProfile = bool.fromEnvironment(
    'ITHAKI_SHOW_ASSESSMENTS_IN_PROFILE',
    defaultValue: false,
  );

  /// Temporarily hides Career Assistant entry points in the Profile/CV screens.
  static const showCareerAssistantInProfile = bool.fromEnvironment(
    'ITHAKI_SHOW_CAREER_ASSISTANT_IN_PROFILE',
    defaultValue: false,
  );

  /// Temporarily hides the video introduction feature in profile screens.
  static const showVideoIntroductionInProfile = bool.fromEnvironment(
    'ITHAKI_SHOW_VIDEO_INTRODUCTION_IN_PROFILE',
    defaultValue: false,
  );

  static const bypassPhoneValidation = useMockData ||
      bool.fromEnvironment('ITHAKI_BYPASS_PHONE_VALIDATION');
}
