// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Ithaki';

  @override
  String get loginAction => 'Login';

  @override
  String get signUpAction => 'Sign Up';

  @override
  String get continueButton => 'Continue';

  @override
  String get skipButton => 'Skip';

  @override
  String get backButton => 'Back';

  @override
  String get goBack => 'Go Back';

  @override
  String get welcomeHeading => 'Welcome to Ithaki!\nLet\'s create an Account!';

  @override
  String get selectLanguageTitle => 'Select your Language';

  @override
  String get selectLanguageDescription =>
      'You can change the interface language at any time. All content, including the job description, your resume, and communication with consultants and the chatbot, will be in English.';

  @override
  String get languageLabel => 'Language';

  @override
  String get selectLanguagePlaceholder => 'Select your language';

  @override
  String get techComfortTitle => 'How comfortable are you with technology?';

  @override
  String get techComfortDescription =>
      'We\'ll use your answer to make the platform feel more comfortable for you.';

  @override
  String get techExperiencedLabel => 'I\'m Experienced';

  @override
  String get techExperiencedSubtitle =>
      'I feel comfortable using digital tools and enjoy exploring new technologies';

  @override
  String get techNewLabel => 'I\'m still new to this';

  @override
  String get techNewSubtitle =>
      'I\'m not into complex tools - I prefer when technology just works smoothly';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Repeat your password';

  @override
  String get passwordUpperLower =>
      'Includes one uppercase and one lowercase letter';

  @override
  String get passwordMinLength => 'At least 8 characters';

  @override
  String get passwordNumber => 'Includes at least one number';

  @override
  String get passwordSpecial =>
      'Includes one special character (like !@#\$%^&)';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get termsText =>
      'By continuing, you acknowledge that you have read and accepted our ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get andText => ' and ';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get personalDetailsHeading => 'Almost there!\nTell us about yourself';

  @override
  String get personalDetailsDescription =>
      'Your name and phone number help employers reach you directly.';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHint => 'Enter your Name';

  @override
  String get lastNameLabel => 'Last Name';

  @override
  String get lastNameHint => 'Enter your Last Name';

  @override
  String get verifyEmailHeading => 'Verify your email address';

  @override
  String get verifyEmailDescription =>
      'We\'ve sent a verification link to your email address.\nPlease check your inbox and follow the link to complete your account setup.';

  @override
  String get verifyEmailSpamHint =>
      'Didn\'t receive the email? Check your spam folder or resend it.';

  @override
  String get verifiedEmailButton => 'I\'ve verified my email';

  @override
  String get resendEmailLabel => 'Resend link via email';

  @override
  String get verifyPhoneHeading => 'Verify your phone number';

  @override
  String get verifyPhoneDescription =>
      'We\'ll send a verification code to your phone number. Choose how you\'d like to receive it.';

  @override
  String get selectMethodTitle => 'Select a method to receive the code';

  @override
  String get sendViaSms => 'Send secured code via SMS';

  @override
  String get sendViaWhatsapp => 'Send secured code via WhatsApp';

  @override
  String get rememberChoice => 'Remember my choice';

  @override
  String get verifyAccountTitle => 'Let\'s verify your Account';

  @override
  String get verifyAccountSubtitle =>
      'We\'ve sent a verification code to your phone number.';

  @override
  String get notYourPhone => 'This is not your phone?';

  @override
  String get resendCode => 'Resend code';

  @override
  String get loginHeading => 'Login to Ithaki Talent';

  @override
  String get loginSubtitle =>
      'Enter your phone number. We\'ll send you a code by SMS.';

  @override
  String loginVerifySubtitle(String phone) {
    return 'We\'ve sent a verification code to $phone.';
  }

  @override
  String get rememberMe => 'Remember me';

  @override
  String get sendCodeButton => 'Send Code';

  @override
  String get signInWithEmail => 'Sign in with Email';

  @override
  String get preferEmail => 'Prefer email? You can sign in with email instead.';

  @override
  String get signInWithPhone => 'Sign in with Phone';

  @override
  String get preferPhone => 'Prefer phone? You can sign in with phone instead.';

  @override
  String get signInButton => 'Sign In';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get forgotPasswordHeading => 'Forgot your password';

  @override
  String get forgotPasswordDescription =>
      'No worries. Enter your account\'s email address and we\'ll send you a link to reset your password.';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get sendResetLink => 'Send reset link';

  @override
  String get resetLinkSentHeading => 'Password reset link sent!';

  @override
  String get resetLinkSentDescription =>
      'Check your inbox. Email includes a secure link to create a new password. Didn\'t get the email?';

  @override
  String get resendResetLinkEmail => 'Resend reset link via email';

  @override
  String get sendResetViaWhatsapp => 'Send secured code via WhatsApp';

  @override
  String get welcomeModalHeading =>
      'Welcome on board!\nYour account is created and verified!';

  @override
  String get welcomeModalDescription =>
      'Let\'s go through a short setup so we can match you with the best job options.';

  @override
  String get skipForNow => 'Skip for Now';

  @override
  String get startSetup => 'Start Setup';

  @override
  String get ithakiLogo => 'Ithaki-logo';

  @override
  String get stepLocation => 'Location';

  @override
  String get stepJobInterests => 'Job Interests';

  @override
  String get stepPreferences => 'Preferences';

  @override
  String get stepValues => 'Values';

  @override
  String get stepCommunication => 'Communication';

  @override
  String get locationHeading => 'Location';

  @override
  String get locationDescription =>
      'Select a location to narrow down relevant job opportunities.';

  @override
  String get citizenshipLabel => 'Citizenship';

  @override
  String get citizenshipHint => 'Select a country or type to search';

  @override
  String get residenceLabel => 'Residence';

  @override
  String get residenceHint => 'Select a country or type to search';

  @override
  String get workAuthorizationLabel => 'Work Authorization';

  @override
  String get workAuthorizationHint => 'Select your status';

  @override
  String get relocationLabel => 'Relocation Readiness';

  @override
  String get relocationHint => 'Select your relocation preference';

  @override
  String get roleCitizen => 'Citizen';

  @override
  String get roleResident => 'Resident';

  @override
  String get roleWorkPermit => 'Work Permit';

  @override
  String get roleStudent => 'Student';

  @override
  String get roleFreelancer => 'Freelancer';

  @override
  String get roleJobSeeker => 'Job Seeker';

  @override
  String get roleExpat => 'Expat';

  @override
  String get relocationYes => 'Yes, ready to relocate';

  @override
  String get relocationNo => 'No, not looking to relocate';

  @override
  String get relocationOpen => 'Open to it';

  @override
  String get relocationRemote => 'Remote only';

  @override
  String get relocationWithinCountry => 'Within my country only';

  @override
  String get jobInterestsHeading => 'Job Interests';

  @override
  String get jobInterestsDescription =>
      'Select job types or fields that match your professional interests. You can add up to 5 different fields.';

  @override
  String get searchJobInterest => 'Search and add job interest';

  @override
  String get addAnotherJobInterest => 'Add Another Job Interest';

  @override
  String get selectJobInterest => 'Select Job Interest';

  @override
  String get preferencesHeading => 'Job Preferences';

  @override
  String get preferencesDescription =>
      'Set your desired salary, position level, contract type, and work format (remote, on-site, or hybrid) to help us match you with the most relevant opportunities.';

  @override
  String get positionLevelLabel => 'Position Level';

  @override
  String get positionLevelHint => 'Select your position level';

  @override
  String get jobTypeTitle => 'Job Type';

  @override
  String get jobTypeDescription =>
      'Choose the types of employment you\'re interested in. You can select more than one option.';

  @override
  String get workplaceFormatTitle => 'Workplace Format';

  @override
  String get workplaceFormatDescription =>
      'Select your preferred workplace formats. You can select more than one option.';

  @override
  String get positionIntern => 'Intern';

  @override
  String get positionJunior => 'Junior';

  @override
  String get positionMid => 'Mid-Level';

  @override
  String get positionSenior => 'Senior';

  @override
  String get positionLead => 'Lead';

  @override
  String get positionManager => 'Manager';

  @override
  String get positionDirector => 'Director';

  @override
  String get jobFullTime => 'Full-Time';

  @override
  String get jobPartTime => 'Part-Time';

  @override
  String get jobContract => 'Contract';

  @override
  String get jobFreelance => 'Freelance';

  @override
  String get jobInternship => 'Internship';

  @override
  String get workOnSite => 'On-site';

  @override
  String get workRemote => 'Remote';

  @override
  String get workHybrid => 'Hybrid';

  @override
  String get payMonthly => 'Monthly';

  @override
  String get payWeekly => 'Weekly';

  @override
  String get payYearly => 'Yearly';

  @override
  String get payHourly => 'Hourly';

  @override
  String get payDaily => 'Daily';

  @override
  String get valuesHeading => 'Values';

  @override
  String valuesDescription(int max) {
    return 'Pick the values that feel closest to you. You can choose up to $max.';
  }

  @override
  String get valueIntegrity => 'Integrity';

  @override
  String get valueResponsibility => 'Responsibility';

  @override
  String get valueTeamwork => 'Teamwork';

  @override
  String get valueRespect => 'Respect';

  @override
  String get valueGrowth => 'Growth & Learning';

  @override
  String get valueInnovation => 'Innovation';

  @override
  String get valueCreativity => 'Creativity';

  @override
  String get valueTransparency => 'Transparency';

  @override
  String get valueEmpathy => 'Empathy';

  @override
  String get valueAccountability => 'Accountability';

  @override
  String get valueWorkLifeBalance => 'Work-Life Balance';

  @override
  String get valueOpenCommunication => 'Open Communication';

  @override
  String get valueReliability => 'Reliability';

  @override
  String get valueAdaptability => 'Adaptability';

  @override
  String get valueProblemSolving => 'Problem-Solving';

  @override
  String get valueOwnership => 'Ownership';

  @override
  String get valueCustomerFocus => 'Customer Focus';

  @override
  String get valueAmbition => 'Ambition';

  @override
  String get valueInitiative => 'Initiative';

  @override
  String get valueCollaboration => 'Collaboration';

  @override
  String get communicationHeading => 'Communication';

  @override
  String get communicationDescription =>
      'Choose a channel to get notifications about new relevant job openings and responses to submitted applications. You can select multiple options and change them anytime.';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get sms => 'SMS';

  @override
  String get email => 'Email';

  @override
  String get receiveTips =>
      'Receive tips on job opportunities, information about courses, and upcoming events.';

  @override
  String get finishSetup => 'Finish Setup';

  @override
  String get searchHint => 'Search...';

  @override
  String get selectAction => 'Select';

  @override
  String get expectedPaymentLabel => 'Expected Payment';

  @override
  String get fromLabel => 'From';

  @override
  String get paymentTermTitle => 'Payment Term';

  @override
  String get paymentTermPlaceholder => 'Monthly';

  @override
  String get currencySymbol => '€';

  @override
  String get preferNotToSpecify => 'Prefer not to specify';

  @override
  String get selectCountryTitle => 'Select Country';

  @override
  String get phoneValidationError => 'Please enter correct phone number';

  @override
  String get phoneNumberLabel => 'Phone Number';
}
