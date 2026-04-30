import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('el'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Ithaki'**
  String get appTitle;

  /// No description provided for @loginAction.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginAction;

  /// No description provided for @signUpAction.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpAction;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @skipButton.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipButton;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @welcomeHeading.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Ithaki!\nLet\'s create an Account!'**
  String get welcomeHeading;

  /// No description provided for @selectLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Select your Language'**
  String get selectLanguageTitle;

  /// No description provided for @selectLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'You can change the interface language at any time. All content, including the job description, your resume, and communication with consultants and the chatbot, will be in English.'**
  String get selectLanguageDescription;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @selectLanguagePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select your language'**
  String get selectLanguagePlaceholder;

  /// No description provided for @techComfortTitle.
  ///
  /// In en, this message translates to:
  /// **'How comfortable are you with technology?'**
  String get techComfortTitle;

  /// No description provided for @techComfortDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'ll use your answer to make the platform feel more comfortable for you.'**
  String get techComfortDescription;

  /// No description provided for @techExperiencedLabel.
  ///
  /// In en, this message translates to:
  /// **'I\'m Experienced'**
  String get techExperiencedLabel;

  /// No description provided for @techExperiencedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I feel comfortable using digital tools and enjoy exploring new technologies'**
  String get techExperiencedSubtitle;

  /// No description provided for @techNewLabel.
  ///
  /// In en, this message translates to:
  /// **'I\'m still new to this'**
  String get techNewLabel;

  /// No description provided for @techNewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I\'m not into complex tools - I prefer when technology just works smoothly'**
  String get techNewSubtitle;

  /// No description provided for @userTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Select your account type'**
  String get userTypeTitle;

  /// No description provided for @userTypeDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the option that best describes you to continue with registration.'**
  String get userTypeDescription;

  /// No description provided for @userTypeJobSeekerLabel.
  ///
  /// In en, this message translates to:
  /// **'I\'m a Job Seeker'**
  String get userTypeJobSeekerLabel;

  /// No description provided for @userTypeJobSeekerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re looking for job opportunities. Create a talent profile to apply for jobs and connect with employers.'**
  String get userTypeJobSeekerSubtitle;

  /// No description provided for @userTypeEmployerLabel.
  ///
  /// In en, this message translates to:
  /// **'We are an Employer or NGO'**
  String get userTypeEmployerLabel;

  /// No description provided for @userTypeEmployerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re looking for talent or coordinating candidates. Create an organization account to post jobs and manage applications.'**
  String get userTypeEmployerSubtitle;

  /// No description provided for @employerTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Select your account type'**
  String get employerTypeTitle;

  /// No description provided for @employerTypeDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the option that best describes your organization to continue with registration.'**
  String get employerTypeDescription;

  /// No description provided for @employerCompanyLabel.
  ///
  /// In en, this message translates to:
  /// **'We are Employer Company'**
  String get employerCompanyLabel;

  /// No description provided for @employerCompanySubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re looking for skilled professionals to join your team. Create a company account to post jobs, manage applications, and connect with top talent.'**
  String get employerCompanySubtitle;

  /// No description provided for @employerNgoLabel.
  ///
  /// In en, this message translates to:
  /// **'We are Non-Profit Organization'**
  String get employerNgoLabel;

  /// No description provided for @employerNgoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re making social impact through meaningful projects. Create an organization account to coordinate your dedicated candidates and grow your community.'**
  String get employerNgoSubtitle;

  /// No description provided for @workEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Work Email'**
  String get workEmailLabel;

  /// No description provided for @employerSetupAdminTab.
  ///
  /// In en, this message translates to:
  /// **'Admin Details'**
  String get employerSetupAdminTab;

  /// No description provided for @employerSetupCompanyTab.
  ///
  /// In en, this message translates to:
  /// **'Company Details'**
  String get employerSetupCompanyTab;

  /// No description provided for @employerSetupContactsTab.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get employerSetupContactsTab;

  /// No description provided for @employerSetupBrandingTab.
  ///
  /// In en, this message translates to:
  /// **'Profile & Branding'**
  String get employerSetupBrandingTab;

  /// No description provided for @employerAdminHeading.
  ///
  /// In en, this message translates to:
  /// **'Account created'**
  String get employerAdminHeading;

  /// No description provided for @employerAdminDescription.
  ///
  /// In en, this message translates to:
  /// **'Great! Profile setup is next — let\'s make candidates search easier and faster.'**
  String get employerAdminDescription;

  /// No description provided for @adminRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get adminRoleLabel;

  /// No description provided for @adminRoleHint.
  ///
  /// In en, this message translates to:
  /// **'Select your Role'**
  String get adminRoleHint;

  /// No description provided for @employerCompanyHeading.
  ///
  /// In en, this message translates to:
  /// **'Company Details'**
  String get employerCompanyHeading;

  /// No description provided for @employerCompanyDescription.
  ///
  /// In en, this message translates to:
  /// **'Add core information about your business. Make sure these details match your company\'s legal documents.'**
  String get employerCompanyDescription;

  /// No description provided for @legalCompanyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Legal Company Name'**
  String get legalCompanyNameLabel;

  /// No description provided for @legalCompanyNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter legal company Name'**
  String get legalCompanyNameHint;

  /// No description provided for @businessIndustryLabel.
  ///
  /// In en, this message translates to:
  /// **'Business Industry'**
  String get businessIndustryLabel;

  /// No description provided for @businessIndustryHint.
  ///
  /// In en, this message translates to:
  /// **'Select your business industry'**
  String get businessIndustryHint;

  /// No description provided for @companySizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Company Size'**
  String get companySizeLabel;

  /// No description provided for @companySizeHint.
  ///
  /// In en, this message translates to:
  /// **'Select your company size'**
  String get companySizeHint;

  /// No description provided for @employerContactsHeading.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get employerContactsHeading;

  /// No description provided for @employerContactsDescription.
  ///
  /// In en, this message translates to:
  /// **'Share contact details for communication and verification purposes.'**
  String get employerContactsDescription;

  /// No description provided for @registeredAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Registered Address'**
  String get registeredAddressLabel;

  /// No description provided for @registeredAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter registered Address'**
  String get registeredAddressHint;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @cityHint.
  ///
  /// In en, this message translates to:
  /// **'Select city or start typing'**
  String get cityHint;

  /// No description provided for @contactEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact Email'**
  String get contactEmailLabel;

  /// No description provided for @contactEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get contactEmailHint;

  /// No description provided for @contactEmailHelper.
  ///
  /// In en, this message translates to:
  /// **'Contact email for candidates'**
  String get contactEmailHelper;

  /// No description provided for @contactPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact Phone Number'**
  String get contactPhoneLabel;

  /// No description provided for @contactPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+30 XXX XXX XX XX'**
  String get contactPhoneHint;

  /// No description provided for @contactPhoneHelper.
  ///
  /// In en, this message translates to:
  /// **'Contact phone for candidates'**
  String get contactPhoneHelper;

  /// No description provided for @companyWebsiteLabel.
  ///
  /// In en, this message translates to:
  /// **'Company Website (optional)'**
  String get companyWebsiteLabel;

  /// No description provided for @companyWebsiteHint.
  ///
  /// In en, this message translates to:
  /// **'Enter company website'**
  String get companyWebsiteHint;

  /// No description provided for @employerBrandingHeading.
  ///
  /// In en, this message translates to:
  /// **'Profile & Branding'**
  String get employerBrandingHeading;

  /// No description provided for @employerBrandingDescription.
  ///
  /// In en, this message translates to:
  /// **'Add your logo and company details to complete your profile. You can update this anytime in Profile Settings.'**
  String get employerBrandingDescription;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for Now'**
  String get skipForNow;

  /// No description provided for @uploadPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhotoLabel;

  /// No description provided for @uploadPhotoDescription.
  ///
  /// In en, this message translates to:
  /// **'Upload a square logo (PNG, JPG, JPEG, or SVG) up to 2 MB, at least 400x400 px, preferably with a transparent background.'**
  String get uploadPhotoDescription;

  /// No description provided for @aboutCompanyLabel.
  ///
  /// In en, this message translates to:
  /// **'About Company'**
  String get aboutCompanyLabel;

  /// No description provided for @aboutCompanyDescription.
  ///
  /// In en, this message translates to:
  /// **'Describe your company\'s mission, values, and main activities in a few sentences.'**
  String get aboutCompanyDescription;

  /// No description provided for @aboutCompanyHint.
  ///
  /// In en, this message translates to:
  /// **'Add company description'**
  String get aboutCompanyHint;

  /// No description provided for @employerValuesDescription.
  ///
  /// In en, this message translates to:
  /// **'Select up to 5 values that best reflect your company culture. We use them to match you with like-minded talents. You can update this anytime in Profile Settings.'**
  String get employerValuesDescription;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Repeat your password'**
  String get confirmPasswordHint;

  /// No description provided for @passwordUpperLower.
  ///
  /// In en, this message translates to:
  /// **'Includes one uppercase and one lowercase letter'**
  String get passwordUpperLower;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordNumber.
  ///
  /// In en, this message translates to:
  /// **'Includes at least one number'**
  String get passwordNumber;

  /// No description provided for @passwordSpecial.
  ///
  /// In en, this message translates to:
  /// **'Includes one special character (like !@#\$%^&)'**
  String get passwordSpecial;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @termsText.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you acknowledge that you have read and accepted our '**
  String get termsText;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @andText.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get andText;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @personalDetailsHeading.
  ///
  /// In en, this message translates to:
  /// **'Almost there!\nTell us about yourself'**
  String get personalDetailsHeading;

  /// No description provided for @personalDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'Your name and phone number help employers reach you directly.'**
  String get personalDetailsDescription;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your Name'**
  String get nameHint;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameLabel;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your Last Name'**
  String get lastNameHint;

  /// No description provided for @verifyEmailHeading.
  ///
  /// In en, this message translates to:
  /// **'Verify your email address'**
  String get verifyEmailHeading;

  /// No description provided for @verifyEmailDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification link to your email address.\nPlease check your inbox and follow the link to complete your account setup.'**
  String get verifyEmailDescription;

  /// No description provided for @verifyEmailSpamHint.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the email? Check your spam folder or resend it.'**
  String get verifyEmailSpamHint;

  /// No description provided for @verifiedEmailButton.
  ///
  /// In en, this message translates to:
  /// **'I\'ve verified my email'**
  String get verifiedEmailButton;

  /// No description provided for @resendEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Resend link via email'**
  String get resendEmailLabel;

  /// No description provided for @verifyPhoneHeading.
  ///
  /// In en, this message translates to:
  /// **'Verify your phone number'**
  String get verifyPhoneHeading;

  /// No description provided for @verifyPhoneDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a verification code to your phone number. Choose how you\'d like to receive it.'**
  String get verifyPhoneDescription;

  /// No description provided for @selectMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a method to receive the code'**
  String get selectMethodTitle;

  /// No description provided for @sendViaSms.
  ///
  /// In en, this message translates to:
  /// **'Send secured code via SMS'**
  String get sendViaSms;

  /// No description provided for @sendViaWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Send secured code via WhatsApp'**
  String get sendViaWhatsapp;

  /// No description provided for @rememberChoice.
  ///
  /// In en, this message translates to:
  /// **'Remember my choice'**
  String get rememberChoice;

  /// No description provided for @verifyAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s verify your Account'**
  String get verifyAccountTitle;

  /// No description provided for @verifyAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification code to your phone number.'**
  String get verifyAccountSubtitle;

  /// No description provided for @notYourPhone.
  ///
  /// In en, this message translates to:
  /// **'This is not your phone?'**
  String get notYourPhone;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @loginHeading.
  ///
  /// In en, this message translates to:
  /// **'Login to Ithaki Talent'**
  String get loginHeading;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number. We\'ll send you a code by SMS.'**
  String get loginSubtitle;

  /// No description provided for @loginVerifySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification code to {phone}.'**
  String loginVerifySubtitle(String phone);

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @sendCodeButton.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCodeButton;

  /// No description provided for @signInWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Email'**
  String get signInWithEmail;

  /// No description provided for @preferEmail.
  ///
  /// In en, this message translates to:
  /// **'Prefer email? You can sign in with email instead.'**
  String get preferEmail;

  /// No description provided for @signInWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Phone'**
  String get signInWithPhone;

  /// No description provided for @preferPhone.
  ///
  /// In en, this message translates to:
  /// **'Prefer phone? You can sign in with phone instead.'**
  String get preferPhone;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordHeading.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password'**
  String get forgotPasswordHeading;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'No worries. Enter your account\'s email address and we\'ll send you a link to reset your password.'**
  String get forgotPasswordDescription;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get sendResetLink;

  /// No description provided for @resetLinkSentHeading.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent!'**
  String get resetLinkSentHeading;

  /// No description provided for @resetLinkSentDescription.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox. Email includes a secure link to create a new password. Didn\'t get the email?'**
  String get resetLinkSentDescription;

  /// No description provided for @resendResetLinkEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend reset link via email'**
  String get resendResetLinkEmail;

  /// No description provided for @sendResetViaWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Send secured code via WhatsApp'**
  String get sendResetViaWhatsapp;

  /// No description provided for @resetPasswordHeading.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get resetPasswordHeading;

  /// No description provided for @resetPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Final step. Create a new password to secure your account.'**
  String get resetPasswordDescription;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordLabel;

  /// No description provided for @newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get newPasswordHint;

  /// No description provided for @confirmNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new Password'**
  String get confirmNewPasswordLabel;

  /// No description provided for @confirmNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get confirmNewPasswordHint;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordButton;

  /// No description provided for @welcomeModalHeading.
  ///
  /// In en, this message translates to:
  /// **'Welcome on board!\nYour account is created and verified!'**
  String get welcomeModalHeading;

  /// No description provided for @welcomeModalDescription.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go through a short setup so we can match you with the best job options.'**
  String get welcomeModalDescription;

  /// No description provided for @startSetup.
  ///
  /// In en, this message translates to:
  /// **'Start Setup'**
  String get startSetup;

  /// No description provided for @ithakiLogo.
  ///
  /// In en, this message translates to:
  /// **'Ithaki-logo'**
  String get ithakiLogo;

  /// No description provided for @stepLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get stepLocation;

  /// No description provided for @stepJobInterests.
  ///
  /// In en, this message translates to:
  /// **'Job Interests'**
  String get stepJobInterests;

  /// No description provided for @stepPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get stepPreferences;

  /// No description provided for @stepValues.
  ///
  /// In en, this message translates to:
  /// **'Values'**
  String get stepValues;

  /// No description provided for @stepCommunication.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get stepCommunication;

  /// No description provided for @locationHeading.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationHeading;

  /// No description provided for @locationDescription.
  ///
  /// In en, this message translates to:
  /// **'Select a location to narrow down relevant job opportunities.'**
  String get locationDescription;

  /// No description provided for @citizenshipLabel.
  ///
  /// In en, this message translates to:
  /// **'Citizenship'**
  String get citizenshipLabel;

  /// No description provided for @citizenshipHint.
  ///
  /// In en, this message translates to:
  /// **'Select a country or type to search'**
  String get citizenshipHint;

  /// No description provided for @residenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Residence'**
  String get residenceLabel;

  /// No description provided for @residenceHint.
  ///
  /// In en, this message translates to:
  /// **'Select a country or type to search'**
  String get residenceHint;

  /// No description provided for @workAuthorizationLabel.
  ///
  /// In en, this message translates to:
  /// **'Work Authorization'**
  String get workAuthorizationLabel;

  /// No description provided for @workAuthorizationHint.
  ///
  /// In en, this message translates to:
  /// **'Select your status'**
  String get workAuthorizationHint;

  /// No description provided for @relocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Relocation Readiness'**
  String get relocationLabel;

  /// No description provided for @relocationHint.
  ///
  /// In en, this message translates to:
  /// **'Select your relocation preference'**
  String get relocationHint;

  /// No description provided for @roleCitizen.
  ///
  /// In en, this message translates to:
  /// **'Citizen'**
  String get roleCitizen;

  /// No description provided for @roleResident.
  ///
  /// In en, this message translates to:
  /// **'Resident'**
  String get roleResident;

  /// No description provided for @roleWorkPermit.
  ///
  /// In en, this message translates to:
  /// **'Work Permit'**
  String get roleWorkPermit;

  /// No description provided for @roleStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get roleStudent;

  /// No description provided for @roleFreelancer.
  ///
  /// In en, this message translates to:
  /// **'Freelancer'**
  String get roleFreelancer;

  /// No description provided for @roleJobSeeker.
  ///
  /// In en, this message translates to:
  /// **'Job Seeker'**
  String get roleJobSeeker;

  /// No description provided for @roleExpat.
  ///
  /// In en, this message translates to:
  /// **'Expat'**
  String get roleExpat;

  /// No description provided for @relocationYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, ready to relocate'**
  String get relocationYes;

  /// No description provided for @relocationNo.
  ///
  /// In en, this message translates to:
  /// **'No, not looking to relocate'**
  String get relocationNo;

  /// No description provided for @relocationOpen.
  ///
  /// In en, this message translates to:
  /// **'Open to it'**
  String get relocationOpen;

  /// No description provided for @relocationRemote.
  ///
  /// In en, this message translates to:
  /// **'Remote only'**
  String get relocationRemote;

  /// No description provided for @relocationWithinCountry.
  ///
  /// In en, this message translates to:
  /// **'Within my country only'**
  String get relocationWithinCountry;

  /// No description provided for @jobInterestsHeading.
  ///
  /// In en, this message translates to:
  /// **'Job Interests'**
  String get jobInterestsHeading;

  /// No description provided for @jobInterestsDescription.
  ///
  /// In en, this message translates to:
  /// **'Select job types or fields that match your professional interests. You can add up to 5 different fields.'**
  String get jobInterestsDescription;

  /// No description provided for @searchJobInterest.
  ///
  /// In en, this message translates to:
  /// **'Search and add job interest'**
  String get searchJobInterest;

  /// No description provided for @addAnotherJobInterest.
  ///
  /// In en, this message translates to:
  /// **'Add Another Job Interest'**
  String get addAnotherJobInterest;

  /// No description provided for @selectJobInterest.
  ///
  /// In en, this message translates to:
  /// **'Select Job Interest'**
  String get selectJobInterest;

  /// No description provided for @preferencesHeading.
  ///
  /// In en, this message translates to:
  /// **'Job Preferences'**
  String get preferencesHeading;

  /// No description provided for @preferencesDescription.
  ///
  /// In en, this message translates to:
  /// **'Set your desired salary, position level, contract type, and work format (remote, on-site, or hybrid) to help us match you with the most relevant opportunities.'**
  String get preferencesDescription;

  /// No description provided for @positionLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Position Level'**
  String get positionLevelLabel;

  /// No description provided for @positionLevelHint.
  ///
  /// In en, this message translates to:
  /// **'Select your position level'**
  String get positionLevelHint;

  /// No description provided for @jobTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Type'**
  String get jobTypeTitle;

  /// No description provided for @jobTypeDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the types of employment you\'re interested in. You can select more than one option.'**
  String get jobTypeDescription;

  /// No description provided for @workplaceFormatTitle.
  ///
  /// In en, this message translates to:
  /// **'Workplace Format'**
  String get workplaceFormatTitle;

  /// No description provided for @workplaceFormatDescription.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred workplace formats. You can select more than one option.'**
  String get workplaceFormatDescription;

  /// No description provided for @positionIntern.
  ///
  /// In en, this message translates to:
  /// **'Intern'**
  String get positionIntern;

  /// No description provided for @positionJunior.
  ///
  /// In en, this message translates to:
  /// **'Junior'**
  String get positionJunior;

  /// No description provided for @positionMid.
  ///
  /// In en, this message translates to:
  /// **'Mid-Level'**
  String get positionMid;

  /// No description provided for @positionSenior.
  ///
  /// In en, this message translates to:
  /// **'Senior'**
  String get positionSenior;

  /// No description provided for @positionLead.
  ///
  /// In en, this message translates to:
  /// **'Lead'**
  String get positionLead;

  /// No description provided for @positionManager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get positionManager;

  /// No description provided for @positionDirector.
  ///
  /// In en, this message translates to:
  /// **'Director'**
  String get positionDirector;

  /// No description provided for @jobFullTime.
  ///
  /// In en, this message translates to:
  /// **'Full-Time'**
  String get jobFullTime;

  /// No description provided for @jobPartTime.
  ///
  /// In en, this message translates to:
  /// **'Part-Time'**
  String get jobPartTime;

  /// No description provided for @jobContract.
  ///
  /// In en, this message translates to:
  /// **'Contract'**
  String get jobContract;

  /// No description provided for @jobFreelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get jobFreelance;

  /// No description provided for @jobInternship.
  ///
  /// In en, this message translates to:
  /// **'Internship'**
  String get jobInternship;

  /// No description provided for @workOnSite.
  ///
  /// In en, this message translates to:
  /// **'On-site'**
  String get workOnSite;

  /// No description provided for @workRemote.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get workRemote;

  /// No description provided for @workHybrid.
  ///
  /// In en, this message translates to:
  /// **'Hybrid'**
  String get workHybrid;

  /// No description provided for @payMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get payMonthly;

  /// No description provided for @payWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get payWeekly;

  /// No description provided for @payYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get payYearly;

  /// No description provided for @payHourly.
  ///
  /// In en, this message translates to:
  /// **'Hourly'**
  String get payHourly;

  /// No description provided for @payDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get payDaily;

  /// No description provided for @valuesHeading.
  ///
  /// In en, this message translates to:
  /// **'Values'**
  String get valuesHeading;

  /// No description provided for @valuesDescription.
  ///
  /// In en, this message translates to:
  /// **'Pick the values that feel closest to you. You can choose up to {max}.'**
  String valuesDescription(int max);

  /// No description provided for @valueIntegrity.
  ///
  /// In en, this message translates to:
  /// **'Integrity'**
  String get valueIntegrity;

  /// No description provided for @valueResponsibility.
  ///
  /// In en, this message translates to:
  /// **'Responsibility'**
  String get valueResponsibility;

  /// No description provided for @valueTeamwork.
  ///
  /// In en, this message translates to:
  /// **'Teamwork'**
  String get valueTeamwork;

  /// No description provided for @valueRespect.
  ///
  /// In en, this message translates to:
  /// **'Respect'**
  String get valueRespect;

  /// No description provided for @valueGrowth.
  ///
  /// In en, this message translates to:
  /// **'Growth & Learning'**
  String get valueGrowth;

  /// No description provided for @valueInnovation.
  ///
  /// In en, this message translates to:
  /// **'Innovation'**
  String get valueInnovation;

  /// No description provided for @valueCreativity.
  ///
  /// In en, this message translates to:
  /// **'Creativity'**
  String get valueCreativity;

  /// No description provided for @valueTransparency.
  ///
  /// In en, this message translates to:
  /// **'Transparency'**
  String get valueTransparency;

  /// No description provided for @valueEmpathy.
  ///
  /// In en, this message translates to:
  /// **'Empathy'**
  String get valueEmpathy;

  /// No description provided for @valueAccountability.
  ///
  /// In en, this message translates to:
  /// **'Accountability'**
  String get valueAccountability;

  /// No description provided for @valueWorkLifeBalance.
  ///
  /// In en, this message translates to:
  /// **'Work-Life Balance'**
  String get valueWorkLifeBalance;

  /// No description provided for @valueOpenCommunication.
  ///
  /// In en, this message translates to:
  /// **'Open Communication'**
  String get valueOpenCommunication;

  /// No description provided for @valueReliability.
  ///
  /// In en, this message translates to:
  /// **'Reliability'**
  String get valueReliability;

  /// No description provided for @valueAdaptability.
  ///
  /// In en, this message translates to:
  /// **'Adaptability'**
  String get valueAdaptability;

  /// No description provided for @valueProblemSolving.
  ///
  /// In en, this message translates to:
  /// **'Problem-Solving'**
  String get valueProblemSolving;

  /// No description provided for @valueOwnership.
  ///
  /// In en, this message translates to:
  /// **'Ownership'**
  String get valueOwnership;

  /// No description provided for @valueCustomerFocus.
  ///
  /// In en, this message translates to:
  /// **'Customer Focus'**
  String get valueCustomerFocus;

  /// No description provided for @valueAmbition.
  ///
  /// In en, this message translates to:
  /// **'Ambition'**
  String get valueAmbition;

  /// No description provided for @valueInitiative.
  ///
  /// In en, this message translates to:
  /// **'Initiative'**
  String get valueInitiative;

  /// No description provided for @valueCollaboration.
  ///
  /// In en, this message translates to:
  /// **'Collaboration'**
  String get valueCollaboration;

  /// No description provided for @communicationHeading.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get communicationHeading;

  /// No description provided for @communicationDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose a channel to get notifications about new relevant job openings and responses to submitted applications. You can select multiple options and change them anytime.'**
  String get communicationDescription;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @sms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get sms;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @receiveTips.
  ///
  /// In en, this message translates to:
  /// **'Receive tips on job opportunities, information about courses, and upcoming events.'**
  String get receiveTips;

  /// No description provided for @finishSetup.
  ///
  /// In en, this message translates to:
  /// **'Finish Setup'**
  String get finishSetup;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;

  /// No description provided for @selectAction.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectAction;

  /// No description provided for @expectedPaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Expected Payment'**
  String get expectedPaymentLabel;

  /// No description provided for @fromLabel.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromLabel;

  /// No description provided for @paymentTermTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Term'**
  String get paymentTermTitle;

  /// No description provided for @paymentTermPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get paymentTermPlaceholder;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'€'**
  String get currencySymbol;

  /// No description provided for @preferNotToSpecify.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to specify'**
  String get preferNotToSpecify;

  /// No description provided for @selectCountryTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountryTitle;

  /// No description provided for @phoneValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please enter correct phone number'**
  String get phoneValidationError;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @myApplicationsTabLabel.
  ///
  /// In en, this message translates to:
  /// **'My Applications'**
  String get myApplicationsTabLabel;

  /// No description provided for @myApplicationsTabDescription.
  ///
  /// In en, this message translates to:
  /// **'Track all the jobs you\'ve applied for and see their current status. You can also review invitations you\'ve accepted or find past applications in your archive.'**
  String get myApplicationsTabDescription;

  /// No description provided for @myApplicationsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load applications.'**
  String get myApplicationsLoadError;

  /// No description provided for @myApplicationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No applications yet'**
  String get myApplicationsEmptyTitle;

  /// No description provided for @myApplicationsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Jobs you apply for will appear here\nso you can track their status.'**
  String get myApplicationsEmptySubtitle;

  /// No description provided for @myInvitationsTabLabel.
  ///
  /// In en, this message translates to:
  /// **'My Invitations ({count})'**
  String myInvitationsTabLabel(int count);

  /// No description provided for @draftsTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get draftsTabLabel;

  /// No description provided for @archiveTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archiveTabLabel;

  /// No description provided for @invitationsTabDescription.
  ///
  /// In en, this message translates to:
  /// **'Here you can find job opportunities you\'ve been invited to explore. Review job invitations from employers or organizations who found your profile interesting.'**
  String get invitationsTabDescription;

  /// No description provided for @invitationsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load invitations.'**
  String get invitationsLoadError;

  /// No description provided for @invitationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No invitations yet'**
  String get invitationsEmptyTitle;

  /// No description provided for @invitationsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'When employers find your profile interesting\nthey will invite you here.'**
  String get invitationsEmptySubtitle;

  /// No description provided for @draftsTabDescription.
  ///
  /// In en, this message translates to:
  /// **'Here you can find applications you started but haven\'t submitted yet. Continue where you left off or discard them.'**
  String get draftsTabDescription;

  /// No description provided for @draftsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load drafts.'**
  String get draftsLoadError;

  /// No description provided for @draftsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No drafts yet'**
  String get draftsEmptyTitle;

  /// No description provided for @draftsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Applications you start but don\'t submit\nwill appear here.'**
  String get draftsEmptySubtitle;

  /// No description provided for @archiveTabDescription.
  ///
  /// In en, this message translates to:
  /// **'Here you can find all declined invitations and closed applications. They\'re stored for your reference and can be viewed anytime.'**
  String get archiveTabDescription;

  /// No description provided for @archiveEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing in your archive'**
  String get archiveEmptyTitle;

  /// No description provided for @archiveEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Declined invitations and closed applications\nwill be stored here.'**
  String get archiveEmptySubtitle;

  /// No description provided for @invitationDeclinedLabel.
  ///
  /// In en, this message translates to:
  /// **'Invitation declined'**
  String get invitationDeclinedLabel;

  /// No description provided for @viewJobDetails.
  ///
  /// In en, this message translates to:
  /// **'View Job Details'**
  String get viewJobDetails;

  /// No description provided for @dismissInvite.
  ///
  /// In en, this message translates to:
  /// **'Dismiss Invite'**
  String get dismissInvite;

  /// No description provided for @declinedConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get declinedConfirmed;

  /// No description provided for @viewJob.
  ///
  /// In en, this message translates to:
  /// **'View Job'**
  String get viewJob;

  /// No description provided for @dismissBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'This invitation will be moved to Archive'**
  String get dismissBannerTitle;

  /// No description provided for @dismissBannerCountdown.
  ///
  /// In en, this message translates to:
  /// **'Auto-confirms in 5 seconds'**
  String get dismissBannerCountdown;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @invitationDismissedToast.
  ///
  /// In en, this message translates to:
  /// **'Invitation dismissed and moved to Archive'**
  String get invitationDismissedToast;

  /// No description provided for @invitationDeclinedToast.
  ///
  /// In en, this message translates to:
  /// **'Invitation declined and moved to Archive'**
  String get invitationDeclinedToast;

  /// No description provided for @careerAssistantBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Don\'t know what to do next?'**
  String get careerAssistantBannerTitle;

  /// No description provided for @careerAssistantBannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'On average, employers review applications within the first week. You can always ask me for help with your next steps.'**
  String get careerAssistantBannerSubtitle;

  /// No description provided for @askCareerAssistant.
  ///
  /// In en, this message translates to:
  /// **'Ask Career Assistant'**
  String get askCareerAssistant;

  /// No description provided for @blogNewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Blog & News'**
  String get blogNewsTitle;

  /// No description provided for @blogNewsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover career tips, interview guides, and platform updates.'**
  String get blogNewsSubtitle;

  /// No description provided for @blogSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for articles and topics'**
  String get blogSearchHint;

  /// No description provided for @blogAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get blogAllCategories;

  /// No description provided for @blogRelatedArticles.
  ///
  /// In en, this message translates to:
  /// **'Related Articles'**
  String get blogRelatedArticles;

  /// No description provided for @blogDiscoverAll.
  ///
  /// In en, this message translates to:
  /// **'Discover All News'**
  String get blogDiscoverAll;

  /// No description provided for @blogArticleNotFound.
  ///
  /// In en, this message translates to:
  /// **'Article not found.'**
  String get blogArticleNotFound;

  /// No description provided for @blogArticleBy.
  ///
  /// In en, this message translates to:
  /// **'By {author}'**
  String blogArticleBy(String author);

  /// No description provided for @cardAppliedWithCv.
  ///
  /// In en, this message translates to:
  /// **'You applied with your Ithaki CV'**
  String get cardAppliedWithCv;

  /// No description provided for @cardJobClosed.
  ///
  /// In en, this message translates to:
  /// **'Job is closed.'**
  String get cardJobClosed;

  /// No description provided for @continueApplication.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueApplication;

  /// No description provided for @viewApplication.
  ///
  /// In en, this message translates to:
  /// **'View Application'**
  String get viewApplication;

  /// No description provided for @applySheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to apply for this role?'**
  String get applySheetTitle;

  /// No description provided for @applySheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Make sure your talent profile details are up to date before submitting your application. You can also upload your CV.'**
  String get applySheetSubtitle;

  /// No description provided for @applyOptionIthakiCvTitle.
  ///
  /// In en, this message translates to:
  /// **'Use Ithaki CV'**
  String get applyOptionIthakiCvTitle;

  /// No description provided for @applyOptionIthakiCvSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your saved CV and profile details to apply.'**
  String get applyOptionIthakiCvSubtitle;

  /// No description provided for @applyOptionUploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload your CV'**
  String get applyOptionUploadTitle;

  /// No description provided for @applyOptionUploadSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload a new file (PDF or DOC) to apply.'**
  String get applyOptionUploadSubtitle;

  /// No description provided for @applyNow.
  ///
  /// In en, this message translates to:
  /// **'Apply Now'**
  String get applyNow;

  /// No description provided for @declineSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Decline Invitation'**
  String get declineSheetTitle;

  /// No description provided for @declineSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to decline this invitation?'**
  String get declineSheetSubtitle;

  /// No description provided for @declineReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Please select a reason'**
  String get declineReasonLabel;

  /// No description provided for @declineReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Select reason'**
  String get declineReasonHint;

  /// No description provided for @declineReasonNotInterested.
  ///
  /// In en, this message translates to:
  /// **'Not interested in this position'**
  String get declineReasonNotInterested;

  /// No description provided for @declineReasonFoundJob.
  ///
  /// In en, this message translates to:
  /// **'Already found a job'**
  String get declineReasonFoundJob;

  /// No description provided for @declineReasonSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary doesn\'t match my expectations'**
  String get declineReasonSalary;

  /// No description provided for @declineReasonLocation.
  ///
  /// In en, this message translates to:
  /// **'Location doesn\'t work for me'**
  String get declineReasonLocation;

  /// No description provided for @declineReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get declineReasonOther;

  /// No description provided for @declineButton.
  ///
  /// In en, this message translates to:
  /// **'Decline Invite'**
  String get declineButton;

  /// No description provided for @declinedButton.
  ///
  /// In en, this message translates to:
  /// **'✓  Declined'**
  String get declinedButton;

  /// No description provided for @jobDetailNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'We could not find job details for this application yet.'**
  String get jobDetailNotFoundMessage;

  /// No description provided for @backToApplications.
  ///
  /// In en, this message translates to:
  /// **'Back to Applications'**
  String get backToApplications;

  /// No description provided for @acceptInviteAndApply.
  ///
  /// In en, this message translates to:
  /// **'Accept Invite and Apply'**
  String get acceptInviteAndApply;

  /// No description provided for @jobDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Details'**
  String get jobDetailsTitle;

  /// No description provided for @dashboardGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}!'**
  String dashboardGreeting(String name);

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here you can track your job posts, review candidates, and monitor overall hiring activity.'**
  String get dashboardSubtitle;

  /// No description provided for @dashboardStatPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Stat will be shown here.'**
  String get dashboardStatPlaceholder;

  /// No description provided for @dashboardActiveJobPosts.
  ///
  /// In en, this message translates to:
  /// **'Active Job Posts'**
  String get dashboardActiveJobPosts;

  /// No description provided for @dashboardArchivedJobPosts.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get dashboardArchivedJobPosts;

  /// No description provided for @dashboardApplications.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get dashboardApplications;

  /// No description provided for @dashboardInvitations.
  ///
  /// In en, this message translates to:
  /// **'Invitations'**
  String get dashboardInvitations;

  /// No description provided for @dashboardHideStats.
  ///
  /// In en, this message translates to:
  /// **'Hide Stats'**
  String get dashboardHideStats;

  /// No description provided for @dashboardShowStats.
  ///
  /// In en, this message translates to:
  /// **'Show Stats'**
  String get dashboardShowStats;

  /// No description provided for @jobPostsTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Posts'**
  String get jobPostsTitle;

  /// No description provided for @jobPostsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage all your job posts in one place, where you can easily create new openings, update existing ones, track their performance, and keep your hiring process organized and efficient.'**
  String get jobPostsEmptyDescription;

  /// No description provided for @createJobPost.
  ///
  /// In en, this message translates to:
  /// **'Create Job Post'**
  String get createJobPost;

  /// No description provided for @searchByJobTitle.
  ///
  /// In en, this message translates to:
  /// **'Search by job title'**
  String get searchByJobTitle;

  /// No description provided for @dashboardJobPostsCount.
  ///
  /// In en, this message translates to:
  /// **'You have {count} job posts'**
  String dashboardJobPostsCount(int count);

  /// No description provided for @dashboardNoJobPosts.
  ///
  /// In en, this message translates to:
  /// **'No job posts yet — create one and find your perfect candidate faster!'**
  String get dashboardNoJobPosts;

  /// No description provided for @jobStatusPublished.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get jobStatusPublished;

  /// No description provided for @jobStatusBoosted.
  ///
  /// In en, this message translates to:
  /// **'Boosted'**
  String get jobStatusBoosted;

  /// No description provided for @jobStatusPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get jobStatusPaused;

  /// No description provided for @jobStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get jobStatusDraft;

  /// No description provided for @jobStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get jobStatusClosed;

  /// No description provided for @jobStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get jobStatusExpired;

  /// No description provided for @jobStatusPendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get jobStatusPendingApproval;

  /// No description provided for @jobActionDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get jobActionDetails;

  /// No description provided for @jobActionAiMatcher.
  ///
  /// In en, this message translates to:
  /// **'AI Matcher'**
  String get jobActionAiMatcher;

  /// No description provided for @jobActionBoost.
  ///
  /// In en, this message translates to:
  /// **'Boost'**
  String get jobActionBoost;

  /// No description provided for @jobActionPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get jobActionPause;

  /// No description provided for @jobActionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get jobActionClose;

  /// No description provided for @jobActionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get jobActionDelete;

  /// No description provided for @jobActionPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get jobActionPublish;

  /// No description provided for @jobActionPublishAgain.
  ///
  /// In en, this message translates to:
  /// **'Publish Again'**
  String get jobActionPublishAgain;

  /// No description provided for @jobDetailPosted.
  ///
  /// In en, this message translates to:
  /// **'Posted {date}'**
  String jobDetailPosted(String date);

  /// No description provided for @jobDetailBoostedTill.
  ///
  /// In en, this message translates to:
  /// **'Boosted till {date}'**
  String jobDetailBoostedTill(String date);

  /// No description provided for @jobDetailOpenFullInfo.
  ///
  /// In en, this message translates to:
  /// **'Open full Information'**
  String get jobDetailOpenFullInfo;

  /// No description provided for @jobDetailHideFullInfo.
  ///
  /// In en, this message translates to:
  /// **'Hide full Information'**
  String get jobDetailHideFullInfo;

  /// No description provided for @jobDetailLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get jobDetailLocation;

  /// No description provided for @jobDetailJobType.
  ///
  /// In en, this message translates to:
  /// **'Job Type'**
  String get jobDetailJobType;

  /// No description provided for @jobDetailIndustry.
  ///
  /// In en, this message translates to:
  /// **'Industry'**
  String get jobDetailIndustry;

  /// No description provided for @jobDetailSalaryRange.
  ///
  /// In en, this message translates to:
  /// **'Salary Range'**
  String get jobDetailSalaryRange;

  /// No description provided for @jobDetailWorkplace.
  ///
  /// In en, this message translates to:
  /// **'Workplace'**
  String get jobDetailWorkplace;

  /// No description provided for @jobDetailExperienceLevel.
  ///
  /// In en, this message translates to:
  /// **'Experience Level'**
  String get jobDetailExperienceLevel;

  /// No description provided for @jobDetailLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get jobDetailLanguage;

  /// No description provided for @jobDetailViews.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get jobDetailViews;

  /// No description provided for @jobDetailCandidates.
  ///
  /// In en, this message translates to:
  /// **'Candidates'**
  String get jobDetailCandidates;

  /// No description provided for @jobDetailApplications.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get jobDetailApplications;

  /// No description provided for @jobDetailYouHaveCandidates.
  ///
  /// In en, this message translates to:
  /// **'You have {count} Candidates'**
  String jobDetailYouHaveCandidates(int count);

  /// No description provided for @jobDetailCloseJob.
  ///
  /// In en, this message translates to:
  /// **'Close Job'**
  String get jobDetailCloseJob;

  /// No description provided for @jobDetailEditJobPost.
  ///
  /// In en, this message translates to:
  /// **'Edit Job Post'**
  String get jobDetailEditJobPost;

  /// No description provided for @jobDetailPausePublication.
  ///
  /// In en, this message translates to:
  /// **'Pause Publication'**
  String get jobDetailPausePublication;

  /// No description provided for @jobDetailDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get jobDetailDelete;

  /// No description provided for @candidateStatusNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get candidateStatusNew;

  /// No description provided for @candidateStatusViewed.
  ///
  /// In en, this message translates to:
  /// **'Viewed'**
  String get candidateStatusViewed;

  /// No description provided for @candidateStatusShortlisted.
  ///
  /// In en, this message translates to:
  /// **'Shortlisted'**
  String get candidateStatusShortlisted;

  /// No description provided for @candidateStatusDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get candidateStatusDeclined;

  /// No description provided for @matchStrengthStrong.
  ///
  /// In en, this message translates to:
  /// **'STRONG MATCH'**
  String get matchStrengthStrong;

  /// No description provided for @matchStrengthGood.
  ///
  /// In en, this message translates to:
  /// **'GOOD MATCH'**
  String get matchStrengthGood;

  /// No description provided for @matchStrengthWeak.
  ///
  /// In en, this message translates to:
  /// **'WEAK MATCH'**
  String get matchStrengthWeak;

  /// No description provided for @aiMatcherTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Matcher'**
  String get aiMatcherTitle;

  /// No description provided for @aiMatcherSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Analyze your job post and instantly get the most relevant candidates based on skills, experience, and fit.'**
  String get aiMatcherSubtitle;

  /// No description provided for @aiMatcherFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get aiMatcherFilters;

  /// No description provided for @aiMatcherCandidatesFound.
  ///
  /// In en, this message translates to:
  /// **'{count} Candidates found'**
  String aiMatcherCandidatesFound(int count);

  /// No description provided for @aiMatcherAllSent.
  ///
  /// In en, this message translates to:
  /// **'You\'ve sent invites to all best-matching candidates. We recommend using the AI Matcher regularly so you don\'t miss top candidates.'**
  String get aiMatcherAllSent;

  /// No description provided for @aiMatcherSendInvitation.
  ///
  /// In en, this message translates to:
  /// **'Send Invitation'**
  String get aiMatcherSendInvitation;

  /// No description provided for @editJobPostTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Job Post'**
  String get editJobPostTitle;

  /// No description provided for @editJobPostSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can edit any section if needed — and if everything looks correct, go ahead and publish it.'**
  String get editJobPostSubtitle;

  /// No description provided for @editJobStepBasics.
  ///
  /// In en, this message translates to:
  /// **'Job Basics'**
  String get editJobStepBasics;

  /// No description provided for @editJobStepSkills.
  ///
  /// In en, this message translates to:
  /// **'Skills Required'**
  String get editJobStepSkills;

  /// No description provided for @editJobStepDescription.
  ///
  /// In en, this message translates to:
  /// **'Job Description'**
  String get editJobStepDescription;

  /// No description provided for @editJobStepPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get editJobStepPreferences;

  /// No description provided for @editJobStepReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get editJobStepReview;

  /// No description provided for @editJobBasicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Basics'**
  String get editJobBasicsTitle;

  /// No description provided for @editJobBasicsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Provide the core details of the position to help candidates understand the role at a glance.'**
  String get editJobBasicsSubtitle;

  /// No description provided for @editJobPostNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Job Post Name'**
  String get editJobPostNameLabel;

  /// No description provided for @editJobIndustryLabel.
  ///
  /// In en, this message translates to:
  /// **'Industry'**
  String get editJobIndustryLabel;

  /// No description provided for @editJobLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get editJobLocationLabel;

  /// No description provided for @editJobExperienceLabel.
  ///
  /// In en, this message translates to:
  /// **'Experience Level'**
  String get editJobExperienceLabel;

  /// No description provided for @editJobTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Job Type'**
  String get editJobTypeLabel;

  /// No description provided for @editJobWorkplaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Workplace Type'**
  String get editJobWorkplaceLabel;

  /// No description provided for @editJobSalaryFromLabel.
  ///
  /// In en, this message translates to:
  /// **'Salary From'**
  String get editJobSalaryFromLabel;

  /// No description provided for @editJobSalaryToLabel.
  ///
  /// In en, this message translates to:
  /// **'Salary To'**
  String get editJobSalaryToLabel;

  /// No description provided for @editJobSetSalaryRange.
  ///
  /// In en, this message translates to:
  /// **'Set Salary Range'**
  String get editJobSetSalaryRange;

  /// No description provided for @editJobPaymentTermLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Term'**
  String get editJobPaymentTermLabel;

  /// No description provided for @editJobSetDeadline.
  ///
  /// In en, this message translates to:
  /// **'Set the deadline for applications'**
  String get editJobSetDeadline;

  /// No description provided for @editJobContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get editJobContinue;

  /// No description provided for @editJobBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get editJobBack;

  /// No description provided for @editJobPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish Job post'**
  String get editJobPublish;

  /// No description provided for @editJobSkillsTitle.
  ///
  /// In en, this message translates to:
  /// **'Skills Required'**
  String get editJobSkillsTitle;

  /// No description provided for @editJobSkillsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add the required skills for this role by typing them one by one and selecting from the dropdown, or enter multiple skills separated by commas.'**
  String get editJobSkillsSubtitle;

  /// No description provided for @editJobAiSkillsSuggestions.
  ///
  /// In en, this message translates to:
  /// **'AI Skills Suggestions'**
  String get editJobAiSkillsSuggestions;

  /// No description provided for @editJobSkillInputHint.
  ///
  /// In en, this message translates to:
  /// **'Start typing to add a skill'**
  String get editJobSkillInputHint;

  /// No description provided for @editJobLanguagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Languages skills Required'**
  String get editJobLanguagesTitle;

  /// No description provided for @editJobLanguagesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Specify the languages needed for this role and the expected proficiency level.'**
  String get editJobLanguagesSubtitle;

  /// No description provided for @editJobAddLanguage.
  ///
  /// In en, this message translates to:
  /// **'+ Add Another Language'**
  String get editJobAddLanguage;

  /// No description provided for @editJobLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get editJobLanguageLabel;

  /// No description provided for @editJobProficiencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Proficiency Level'**
  String get editJobProficiencyLabel;

  /// No description provided for @editJobCompetenciesTitle.
  ///
  /// In en, this message translates to:
  /// **'Competencies'**
  String get editJobCompetenciesTitle;

  /// No description provided for @editJobCompetenciesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Indicate any additional requirements to clarify expectations and help identify candidates who meet the practical needs of the role.'**
  String get editJobCompetenciesSubtitle;

  /// No description provided for @editJobDrivingLicence.
  ///
  /// In en, this message translates to:
  /// **'Driving Licence Required'**
  String get editJobDrivingLicence;

  /// No description provided for @editJobDrivingLicenceCategory.
  ///
  /// In en, this message translates to:
  /// **'Driving Licence Category'**
  String get editJobDrivingLicenceCategory;

  /// No description provided for @editJobDescriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Post Creation'**
  String get editJobDescriptionTitle;

  /// No description provided for @editJobPreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get editJobPreferencesTitle;

  /// No description provided for @editJobCoverLetterTitle.
  ///
  /// In en, this message translates to:
  /// **'Cover Letter'**
  String get editJobCoverLetterTitle;

  /// No description provided for @editJobCoverLetterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cover letters help you better understand motivation and communication skills. Candidates will be asked to add it when applying.'**
  String get editJobCoverLetterSubtitle;

  /// No description provided for @editJobRequireCoverLetter.
  ///
  /// In en, this message translates to:
  /// **'Require a cover letter from candidates'**
  String get editJobRequireCoverLetter;

  /// No description provided for @editJobAdditionalQuestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Additional Questions'**
  String get editJobAdditionalQuestionsTitle;

  /// No description provided for @editJobAdditionalQuestionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add additional questions to learn more about candidates before the interview. This step is optional. We recommend adding up to 5 questions.'**
  String get editJobAdditionalQuestionsSubtitle;

  /// No description provided for @editJobAddScreeningQuestions.
  ///
  /// In en, this message translates to:
  /// **'Add Screening Questions'**
  String get editJobAddScreeningQuestions;

  /// No description provided for @editJobReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get editJobReviewTitle;

  /// No description provided for @editJobPublishedDate.
  ///
  /// In en, this message translates to:
  /// **'Publish Date'**
  String get editJobPublishedDate;

  /// No description provided for @editJobEditBasics.
  ///
  /// In en, this message translates to:
  /// **'Edit Job Basics'**
  String get editJobEditBasics;

  /// No description provided for @editJobEditSkills.
  ///
  /// In en, this message translates to:
  /// **'Edit Skills'**
  String get editJobEditSkills;

  /// No description provided for @editJobEditDescription.
  ///
  /// In en, this message translates to:
  /// **'Edit Job Description'**
  String get editJobEditDescription;

  /// No description provided for @editJobEditPreferences.
  ///
  /// In en, this message translates to:
  /// **'Edit Preferences'**
  String get editJobEditPreferences;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'el', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
