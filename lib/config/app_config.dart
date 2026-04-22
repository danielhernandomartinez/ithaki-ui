class AppConfig {
  const AppConfig._();

  static const apiBaseUrl = String.fromEnvironment('ITHAKI_API_BASE_URL');
  static const useMockData = bool.fromEnvironment('ITHAKI_USE_MOCK_DATA');
  static const shouldUseMockData = useMockData || apiBaseUrl == '';
  static const bypassPhoneValidation =
      shouldUseMockData ||
      bool.fromEnvironment('ITHAKI_BYPASS_PHONE_VALIDATION');
}
