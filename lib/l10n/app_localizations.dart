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
  /// **'Your name and phone number help teams contact you directly.'**
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

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for Now'**
  String get skipForNow;

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
  /// **'Here you can find job opportunities you\'ve been invited to explore. Review invitations from companies or organizations who found your profile interesting.'**
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
  /// **'When companies find your profile interesting\nthey will invite you here.'**
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
  /// **'On average, applications are reviewed within the first week. You can always ask me for help with your next steps.'**
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

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @appBarTitleIthaki.
  ///
  /// In en, this message translates to:
  /// **'Ithaki'**
  String get appBarTitleIthaki;

  /// No description provided for @profileAboutMeTitle.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get profileAboutMeTitle;

  /// No description provided for @profileSkillsTitle.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get profileSkillsTitle;

  /// No description provided for @hardSkillsTitle.
  ///
  /// In en, this message translates to:
  /// **'Hard Skills'**
  String get hardSkillsTitle;

  /// No description provided for @softSkillsTitle.
  ///
  /// In en, this message translates to:
  /// **'Soft Skills'**
  String get softSkillsTitle;

  /// No description provided for @competenciesTitle.
  ///
  /// In en, this message translates to:
  /// **'Competencies'**
  String get competenciesTitle;

  /// No description provided for @computerSkillsTitle.
  ///
  /// In en, this message translates to:
  /// **'Computer Skills'**
  String get computerSkillsTitle;

  /// No description provided for @drivingLicenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Driving License'**
  String get drivingLicenseTitle;

  /// No description provided for @licenseCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'License Category'**
  String get licenseCategoryTitle;

  /// No description provided for @editCompetenciesTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Competencies'**
  String get editCompetenciesTitle;

  /// No description provided for @editSkillsTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Skills'**
  String get editSkillsTitle;

  /// No description provided for @editLanguagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Languages'**
  String get editLanguagesTitle;

  /// No description provided for @editValuesTitle.
  ///
  /// In en, this message translates to:
  /// **'Values'**
  String get editValuesTitle;

  /// No description provided for @editAboutMeTitle.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get editAboutMeTitle;

  /// No description provided for @addBioOptional.
  ///
  /// In en, this message translates to:
  /// **'Add Bio (optional)'**
  String get addBioOptional;

  /// No description provided for @addVideoPresentationOptional.
  ///
  /// In en, this message translates to:
  /// **'Add Video Presentation (optional)'**
  String get addVideoPresentationOptional;

  /// No description provided for @uploadFile.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get uploadFile;

  /// No description provided for @pasteVideoUrlHere.
  ///
  /// In en, this message translates to:
  /// **'Paste video URL here'**
  String get pasteVideoUrlHere;

  /// No description provided for @noValuesAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No values added yet.'**
  String get noValuesAddedYet;

  /// No description provided for @profileMyFilesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Files'**
  String get profileMyFilesTitle;

  /// No description provided for @couldNotOpenVideoIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Could not open video introduction.'**
  String get couldNotOpenVideoIntroduction;

  /// No description provided for @openFileNoSource.
  ///
  /// In en, this message translates to:
  /// **'{fileName} has no file source to open.'**
  String openFileNoSource(String fileName);

  /// No description provided for @couldNotOpenFile.
  ///
  /// In en, this message translates to:
  /// **'Could not open {fileName}.'**
  String couldNotOpenFile(String fileName);

  /// No description provided for @openingFile.
  ///
  /// In en, this message translates to:
  /// **'Opening {fileName}'**
  String openingFile(String fileName);

  /// No description provided for @openCv.
  ///
  /// In en, this message translates to:
  /// **'Open CV'**
  String get openCv;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @editJobPreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Preferences'**
  String get editJobPreferencesTitle;

  /// No description provided for @positionLevelOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Position Level (optional)'**
  String get positionLevelOptionalLabel;

  /// No description provided for @selectLevel.
  ///
  /// In en, this message translates to:
  /// **'Select level'**
  String get selectLevel;

  /// No description provided for @profileEducationTitle.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get profileEducationTitle;

  /// No description provided for @profileEducationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add information about your educational background, degree, and field of study.'**
  String get profileEducationSubtitle;

  /// No description provided for @addEducation.
  ///
  /// In en, this message translates to:
  /// **'Add Education'**
  String get addEducation;

  /// No description provided for @editEducation.
  ///
  /// In en, this message translates to:
  /// **'Edit Education'**
  String get editEducation;

  /// No description provided for @institutionNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Institution Name'**
  String get institutionNameLabel;

  /// No description provided for @institutionNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. University of Athens'**
  String get institutionNameHint;

  /// No description provided for @fieldOfStudyLabel.
  ///
  /// In en, this message translates to:
  /// **'Field of Study'**
  String get fieldOfStudyLabel;

  /// No description provided for @fieldOfStudyHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Computer Science'**
  String get fieldOfStudyHint;

  /// No description provided for @degreeTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Degree Type'**
  String get degreeTypeLabel;

  /// No description provided for @selectDegree.
  ///
  /// In en, this message translates to:
  /// **'Select degree'**
  String get selectDegree;

  /// No description provided for @startDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDateLabel;

  /// No description provided for @endDateLabel.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDateLabel;

  /// No description provided for @mmYyyyHint.
  ///
  /// In en, this message translates to:
  /// **'MM-YYYY'**
  String get mmYyyyHint;

  /// No description provided for @currentlyStudyHere.
  ///
  /// In en, this message translates to:
  /// **'I currently study here'**
  String get currentlyStudyHere;

  /// No description provided for @profileWorkExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'Work Experience'**
  String get profileWorkExperienceTitle;

  /// No description provided for @profileWorkExperienceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add details about your previous roles and companies'**
  String get profileWorkExperienceSubtitle;

  /// No description provided for @addWorkExperience.
  ///
  /// In en, this message translates to:
  /// **'Add Work Experience'**
  String get addWorkExperience;

  /// No description provided for @editWorkExperience.
  ///
  /// In en, this message translates to:
  /// **'Edit Work Experience'**
  String get editWorkExperience;

  /// No description provided for @jobTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get jobTitleLabel;

  /// No description provided for @jobTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Software Engineer'**
  String get jobTitleHint;

  /// No description provided for @companyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyNameLabel;

  /// No description provided for @companyNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Acme Corp'**
  String get companyNameHint;

  /// No description provided for @experienceSummaryOptional.
  ///
  /// In en, this message translates to:
  /// **'Experience Summary (optional)'**
  String get experienceSummaryOptional;

  /// No description provided for @experienceSummaryHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your role and achievements...'**
  String get experienceSummaryHint;

  /// No description provided for @currentlyWorkHere.
  ///
  /// In en, this message translates to:
  /// **'I currently work here'**
  String get currentlyWorkHere;

  /// No description provided for @charactersCounter.
  ///
  /// In en, this message translates to:
  /// **'{current} / {max} symbols'**
  String charactersCounter(int current, int max);

  /// No description provided for @dateOfBirthLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirthLabel;

  /// No description provided for @yourFirstNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your first name'**
  String get yourFirstNameHint;

  /// No description provided for @yourLastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your last name'**
  String get yourLastNameHint;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select gender'**
  String get selectGender;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get selectCountry;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @selectStatus.
  ///
  /// In en, this message translates to:
  /// **'Select status'**
  String get selectStatus;

  /// No description provided for @relocationReadinessLabel.
  ///
  /// In en, this message translates to:
  /// **'Relocation Readiness'**
  String get relocationReadinessLabel;

  /// No description provided for @selectOption.
  ///
  /// In en, this message translates to:
  /// **'Select option'**
  String get selectOption;

  /// No description provided for @fileExceedsLimit.
  ///
  /// In en, this message translates to:
  /// **'File exceeds 5 MB limit'**
  String get fileExceedsLimit;

  /// No description provided for @leaveEditingTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave Editing?'**
  String get leaveEditingTitle;

  /// No description provided for @leaveEditingMessage.
  ///
  /// In en, this message translates to:
  /// **'All entered information will be lost if you leave this screen.'**
  String get leaveEditingMessage;

  /// No description provided for @leaveWithoutSaving.
  ///
  /// In en, this message translates to:
  /// **'Leave without saving'**
  String get leaveWithoutSaving;

  /// No description provided for @saveAndLeave.
  ///
  /// In en, this message translates to:
  /// **'Save and Leave'**
  String get saveAndLeave;

  /// No description provided for @highLabel.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get highLabel;

  /// No description provided for @genderInfoLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderInfoLabel;

  /// No description provided for @ageInfoLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageInfoLabel;

  /// No description provided for @locationInfoLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationInfoLabel;

  /// No description provided for @showFullCv.
  ///
  /// In en, this message translates to:
  /// **'Show full CV'**
  String get showFullCv;

  /// No description provided for @coverLetterTitle.
  ///
  /// In en, this message translates to:
  /// **'Cover Letter'**
  String get coverLetterTitle;

  /// No description provided for @screeningQuestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Screening Questions'**
  String get screeningQuestionsTitle;

  /// No description provided for @aboutCompanyTitle.
  ///
  /// In en, this message translates to:
  /// **'About the Company'**
  String get aboutCompanyTitle;

  /// No description provided for @teamTitle.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get teamTitle;

  /// No description provided for @companyProfile.
  ///
  /// In en, this message translates to:
  /// **'Company Profile'**
  String get companyProfile;

  /// No description provided for @typeCityToSearch.
  ///
  /// In en, this message translates to:
  /// **'Type city to search'**
  String get typeCityToSearch;

  /// No description provided for @experienceLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Experience Level'**
  String get experienceLevelLabel;

  /// No description provided for @workplaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Workplace'**
  String get workplaceLabel;

  /// No description provided for @selectWorkplace.
  ///
  /// In en, this message translates to:
  /// **'Select workplace'**
  String get selectWorkplace;

  /// No description provided for @selectJobType.
  ///
  /// In en, this message translates to:
  /// **'Select job type'**
  String get selectJobType;

  /// No description provided for @skillsDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the skills that best represent your qualifications and professional expertise.'**
  String get skillsDescription;

  /// No description provided for @addSkillHint.
  ///
  /// In en, this message translates to:
  /// **'Start typing to add a skill'**
  String get addSkillHint;

  /// No description provided for @errorLoadingSkills.
  ///
  /// In en, this message translates to:
  /// **'Error loading skills: {error}'**
  String errorLoadingSkills(String error);

  /// No description provided for @chooseValuesDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose up to {max} values that best represent what matters most to you professionally.'**
  String chooseValuesDescription(int max);

  /// No description provided for @videoIntroductionTitle.
  ///
  /// In en, this message translates to:
  /// **'Video Introduction'**
  String get videoIntroductionTitle;

  /// No description provided for @editAboutMeVideo.
  ///
  /// In en, this message translates to:
  /// **'Edit About Me & Video Introduction'**
  String get editAboutMeVideo;

  /// No description provided for @addAboutMeInformation.
  ///
  /// In en, this message translates to:
  /// **'Add About Me Information'**
  String get addAboutMeInformation;

  /// No description provided for @aboutMeEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a few words about yourself to help teams understand who you are and what you do.'**
  String get aboutMeEmptyDescription;

  /// No description provided for @addSkills.
  ///
  /// In en, this message translates to:
  /// **'Add Skills'**
  String get addSkills;

  /// No description provided for @addCompetencies.
  ///
  /// In en, this message translates to:
  /// **'Add Competencies'**
  String get addCompetencies;

  /// No description provided for @addLanguages.
  ///
  /// In en, this message translates to:
  /// **'Add Languages'**
  String get addLanguages;

  /// No description provided for @editLanguages.
  ///
  /// In en, this message translates to:
  /// **'Edit Languages'**
  String get editLanguages;

  /// No description provided for @languagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languagesTitle;

  /// No description provided for @aboutMeEditDescription.
  ///
  /// In en, this message translates to:
  /// **'Please provide some basic information about yourself. This helps us set up your profile and personalize your experience. You can add information later or update this anytime in Profile.'**
  String get aboutMeEditDescription;

  /// No description provided for @addBioDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a few words about yourself to help teams understand who you are and what you do. We recommend keeping it concise, avoiding unnecessary filler, and highlighting key skills and experience.'**
  String get addBioDescription;

  /// No description provided for @addVideoDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a short video to introduce yourself to teams, highlight your experience, and showcase your skills. A video helps you stand out among other candidates.'**
  String get addVideoDescription;

  /// No description provided for @uploadViaUrl.
  ///
  /// In en, this message translates to:
  /// **'Upload via URL'**
  String get uploadViaUrl;

  /// No description provided for @uploadInstructions.
  ///
  /// In en, this message translates to:
  /// **'tap button to browse (max 10 files, up to 5 MB\neach; supported formats: .pdf, .doc, .png, .jpg)'**
  String get uploadInstructions;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategory;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category {category}'**
  String categoryLabel(String category);

  /// No description provided for @iHaveGreekLicense.
  ///
  /// In en, this message translates to:
  /// **'I have Greek License'**
  String get iHaveGreekLicense;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @languageFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageFieldLabel;

  /// No description provided for @selectLanguageHint.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguageHint;

  /// No description provided for @searchLanguage.
  ///
  /// In en, this message translates to:
  /// **'Search language'**
  String get searchLanguage;

  /// No description provided for @loadingLanguages.
  ///
  /// In en, this message translates to:
  /// **'Loading languages...'**
  String get loadingLanguages;

  /// No description provided for @noLanguagesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No languages available right now.'**
  String get noLanguagesAvailable;

  /// No description provided for @proficiencyLevel.
  ///
  /// In en, this message translates to:
  /// **'Proficiency Level'**
  String get proficiencyLevel;

  /// No description provided for @addAnotherLanguage.
  ///
  /// In en, this message translates to:
  /// **'Add Another Language'**
  String get addAnotherLanguage;

  /// No description provided for @editJobsPreferences.
  ///
  /// In en, this message translates to:
  /// **'Edit Jobs Preferences'**
  String get editJobsPreferences;

  /// No description provided for @assessmentsResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Assessments results'**
  String get assessmentsResultsTitle;

  /// No description provided for @companyTabVacancies.
  ///
  /// In en, this message translates to:
  /// **'Vacancies'**
  String get companyTabVacancies;

  /// No description provided for @companyTabAboutCompany.
  ///
  /// In en, this message translates to:
  /// **'About Company'**
  String get companyTabAboutCompany;

  /// No description provided for @companyTabEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get companyTabEvents;

  /// No description provided for @companyTabPosts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get companyTabPosts;

  /// No description provided for @companyJobsFound.
  ///
  /// In en, this message translates to:
  /// **'{count} jobs found'**
  String companyJobsFound(int count);

  /// No description provided for @companyNoVacancies.
  ///
  /// In en, this message translates to:
  /// **'No open vacancies at this time.'**
  String get companyNoVacancies;

  /// No description provided for @saveJob.
  ///
  /// In en, this message translates to:
  /// **'Save Job'**
  String get saveJob;

  /// No description provided for @entryLevel.
  ///
  /// In en, this message translates to:
  /// **'Entry'**
  String get entryLevel;

  /// No description provided for @companyPerksTitle.
  ///
  /// In en, this message translates to:
  /// **'Perks & Benefits'**
  String get companyPerksTitle;

  /// No description provided for @companyGalleryTitle.
  ///
  /// In en, this message translates to:
  /// **'Company Gallery'**
  String get companyGalleryTitle;

  /// No description provided for @companyNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No upcoming events.'**
  String get companyNoEvents;

  /// No description provided for @companyEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Company Events'**
  String get companyEventsTitle;

  /// No description provided for @companyPostsTitle.
  ///
  /// In en, this message translates to:
  /// **'Company Posts'**
  String get companyPostsTitle;

  /// No description provided for @companyPostsFound.
  ///
  /// In en, this message translates to:
  /// **'{count} posts found'**
  String companyPostsFound(int count);

  /// No description provided for @companyNoPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No company posts yet.'**
  String get companyNoPostsYet;

  /// No description provided for @shareButton.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareButton;

  /// No description provided for @culturalMatchScore.
  ///
  /// In en, this message translates to:
  /// **'Cultural Match Score'**
  String get culturalMatchScore;

  /// No description provided for @culturalMatchDescription.
  ///
  /// In en, this message translates to:
  /// **'You and this company both chose your top 5 values and preferences. This score shows how closely they align.'**
  String get culturalMatchDescription;

  /// No description provided for @culturalMatchYouBothCareAbout.
  ///
  /// In en, this message translates to:
  /// **'You both care about:'**
  String get culturalMatchYouBothCareAbout;

  /// No description provided for @companyTeamEmployees.
  ///
  /// In en, this message translates to:
  /// **'{teamSize} employees'**
  String companyTeamEmployees(String teamSize);

  /// No description provided for @companyLabelMainOffice.
  ///
  /// In en, this message translates to:
  /// **'Main Office Location'**
  String get companyLabelMainOffice;

  /// No description provided for @companyLabelOtherLocations.
  ///
  /// In en, this message translates to:
  /// **'Other Locations'**
  String get companyLabelOtherLocations;

  /// No description provided for @companyLabelContactPhone.
  ///
  /// In en, this message translates to:
  /// **'Contact Phone'**
  String get companyLabelContactPhone;

  /// No description provided for @companyLabelWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get companyLabelWebsite;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @eventDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Details'**
  String get eventDetailsTitle;

  /// No description provided for @eventAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get eventAddressLabel;

  /// No description provided for @eventRegistrationLink.
  ///
  /// In en, this message translates to:
  /// **'Registration Link'**
  String get eventRegistrationLink;

  /// No description provided for @companyLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load company.'**
  String get companyLoadError;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @assessmentsRecommendedForYou.
  ///
  /// In en, this message translates to:
  /// **'Assessments recommended for you'**
  String get assessmentsRecommendedForYou;

  /// No description provided for @assessmentYourScore.
  ///
  /// In en, this message translates to:
  /// **'Your Score'**
  String get assessmentYourScore;

  /// No description provided for @assessmentLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get assessmentLevel;

  /// No description provided for @assessmentSkillBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Skill breakdown'**
  String get assessmentSkillBreakdown;

  /// No description provided for @assessmentKeyInsights.
  ///
  /// In en, this message translates to:
  /// **'Key insights'**
  String get assessmentKeyInsights;

  /// No description provided for @assessmentPreviousResults.
  ///
  /// In en, this message translates to:
  /// **'Previous results'**
  String get assessmentPreviousResults;

  /// No description provided for @assessmentYouImproving.
  ///
  /// In en, this message translates to:
  /// **'You improving!'**
  String get assessmentYouImproving;

  /// No description provided for @assessmentMeansForProfile.
  ///
  /// In en, this message translates to:
  /// **'What this means for your profile'**
  String get assessmentMeansForProfile;

  /// No description provided for @assessmentAboutThis.
  ///
  /// In en, this message translates to:
  /// **'About this assessment'**
  String get assessmentAboutThis;

  /// No description provided for @assessmentUsedFor.
  ///
  /// In en, this message translates to:
  /// **'What this assessment is used for'**
  String get assessmentUsedFor;

  /// No description provided for @assessmentBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'Before you start'**
  String get assessmentBeforeStart;

  /// No description provided for @assessmentApproxDuration.
  ///
  /// In en, this message translates to:
  /// **'Approximate Duration'**
  String get assessmentApproxDuration;

  /// No description provided for @assessmentQuestionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get assessmentQuestionsLabel;

  /// No description provided for @bannerNotSureJob.
  ///
  /// In en, this message translates to:
  /// **'Not sure how to find the right job?'**
  String get bannerNotSureJob;

  /// No description provided for @chatNewChat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get chatNewChat;

  /// No description provided for @chatSearchInChats.
  ///
  /// In en, this message translates to:
  /// **'Search in Chats'**
  String get chatSearchInChats;

  /// No description provided for @chatHistory.
  ///
  /// In en, this message translates to:
  /// **'Chat\'s History'**
  String get chatHistory;

  /// No description provided for @homeNeedRefresher.
  ///
  /// In en, this message translates to:
  /// **'Need a quick refresher?'**
  String get homeNeedRefresher;

  /// No description provided for @homeCvSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your CV Success'**
  String get homeCvSuccess;

  /// No description provided for @homeStatViews.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get homeStatViews;

  /// No description provided for @homeStatInvitations.
  ///
  /// In en, this message translates to:
  /// **'Invitations'**
  String get homeStatInvitations;

  /// No description provided for @homeStatApplicationsSent.
  ///
  /// In en, this message translates to:
  /// **'Applications Sent'**
  String get homeStatApplicationsSent;

  /// No description provided for @homeStatInterviews.
  ///
  /// In en, this message translates to:
  /// **'Interviews'**
  String get homeStatInterviews;

  /// No description provided for @homeRecommendedCourses.
  ///
  /// In en, this message translates to:
  /// **'Recommended Courses'**
  String get homeRecommendedCourses;

  /// No description provided for @homeLatestNews.
  ///
  /// In en, this message translates to:
  /// **'Latest News'**
  String get homeLatestNews;

  /// No description provided for @homeSmartJobRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Smart Job Recommendations'**
  String get homeSmartJobRecommendations;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @searchByJobTitle.
  ///
  /// In en, this message translates to:
  /// **'Search by job title'**
  String get searchByJobTitle;

  /// No description provided for @jobLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load job.'**
  String get jobLoadError;

  /// No description provided for @jobRemovedFromSaved.
  ///
  /// In en, this message translates to:
  /// **'Removed from saved jobs.'**
  String get jobRemovedFromSaved;

  /// No description provided for @jobSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Job has been saved! Check your saved jobs.'**
  String get jobSavedMessage;

  /// No description provided for @jobPostRemoved.
  ///
  /// In en, this message translates to:
  /// **'Job post has been removed'**
  String get jobPostRemoved;

  /// No description provided for @deadlineReminderSet.
  ///
  /// In en, this message translates to:
  /// **'Deadline Reminder has been set. We will notify you a week before the deadline'**
  String get deadlineReminderSet;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @jobPostedDate.
  ///
  /// In en, this message translates to:
  /// **'Posted {date}'**
  String jobPostedDate(String date);

  /// No description provided for @jobClosedLabel.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get jobClosedLabel;

  /// No description provided for @deadlineReminderLabel.
  ///
  /// In en, this message translates to:
  /// **'Deadline Reminder'**
  String get deadlineReminderLabel;

  /// No description provided for @reportLabel.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reportLabel;

  /// No description provided for @reminderSetNotification.
  ///
  /// In en, this message translates to:
  /// **'You have set a reminder for this job post'**
  String get reminderSetNotification;

  /// No description provided for @odysseaReviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Odyssea Review: '**
  String get odysseaReviewLabel;

  /// No description provided for @recommendedForYouLabel.
  ///
  /// In en, this message translates to:
  /// **'Recommended for you'**
  String get recommendedForYouLabel;

  /// No description provided for @tabAllJobs.
  ///
  /// In en, this message translates to:
  /// **'All Jobs'**
  String get tabAllJobs;

  /// No description provided for @tabSavedJobs.
  ///
  /// In en, this message translates to:
  /// **'Saved ({count})'**
  String tabSavedJobs(int count);

  /// No description provided for @sortingTitle.
  ///
  /// In en, this message translates to:
  /// **'Sorting'**
  String get sortingTitle;

  /// No description provided for @filtersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersTitle;

  /// No description provided for @resetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset Filters'**
  String get resetFilters;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @filterAllLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAllLabel;

  /// No description provided for @filterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get filterClear;

  /// No description provided for @applyFilter.
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get applyFilter;

  /// No description provided for @salaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salaryTitle;

  /// No description provided for @tillLabel.
  ///
  /// In en, this message translates to:
  /// **'Till'**
  String get tillLabel;

  /// No description provided for @reportJobTitle.
  ///
  /// In en, this message translates to:
  /// **'Report this job?'**
  String get reportJobTitle;

  /// No description provided for @selectReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Select Reason'**
  String get selectReasonHint;

  /// No description provided for @setReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a reminder'**
  String get setReminderTitle;

  /// No description provided for @applicationOpenTill.
  ///
  /// In en, this message translates to:
  /// **'Application open till:'**
  String get applicationOpenTill;

  /// No description provided for @whenShouldRemind.
  ///
  /// In en, this message translates to:
  /// **'When should we remind you?'**
  String get whenShouldRemind;

  /// No description provided for @reminderTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get reminderTomorrow;

  /// No description provided for @reminderTomorrowSub.
  ///
  /// In en, this message translates to:
  /// **'Reminder will be sent at this time tomorrow'**
  String get reminderTomorrowSub;

  /// No description provided for @reminderOneWeek.
  ///
  /// In en, this message translates to:
  /// **'In one week'**
  String get reminderOneWeek;

  /// No description provided for @reminderOneWeekSub.
  ///
  /// In en, this message translates to:
  /// **'Reminder will be sent at this time in one week'**
  String get reminderOneWeekSub;

  /// No description provided for @reminderOneDayBefore.
  ///
  /// In en, this message translates to:
  /// **'One day before the deadline'**
  String get reminderOneDayBefore;

  /// No description provided for @reminderOneDayBeforeSub.
  ///
  /// In en, this message translates to:
  /// **'Reminder will be sent one day before the deadline'**
  String get reminderOneDayBeforeSub;

  /// No description provided for @reminderCustomDate.
  ///
  /// In en, this message translates to:
  /// **'Pick a custom date'**
  String get reminderCustomDate;

  /// No description provided for @reminderCustomDateSub.
  ///
  /// In en, this message translates to:
  /// **'Pick a custom date for your reminder'**
  String get reminderCustomDateSub;

  /// No description provided for @selectDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Select the date'**
  String get selectDateLabel;

  /// No description provided for @selectTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Select the time'**
  String get selectTimeLabel;

  /// No description provided for @ddMmYyyyHint.
  ///
  /// In en, this message translates to:
  /// **'DD-MM-YYYY'**
  String get ddMmYyyyHint;

  /// No description provided for @reminderViaContactSub.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a reminder to:\n{contact}'**
  String reminderViaContactSub(String contact);

  /// No description provided for @reminderViaSmsWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'SMS / WhatsApp'**
  String get reminderViaSmsWhatsapp;

  /// No description provided for @changeEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get changeEmailTitle;

  /// No description provided for @newEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'New Email'**
  String get newEmailLabel;

  /// No description provided for @newEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new email'**
  String get newEmailHint;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @repeatNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat New Password'**
  String get repeatNewPasswordLabel;

  /// No description provided for @repeatNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Repeat your new password'**
  String get repeatNewPasswordHint;

  /// No description provided for @changePhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Phone Number'**
  String get changePhoneTitle;

  /// No description provided for @newPhoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'New Phone Number'**
  String get newPhoneNumberLabel;

  /// No description provided for @confirmAccountDeletion.
  ///
  /// In en, this message translates to:
  /// **'Confirm Account Deletion'**
  String get confirmAccountDeletion;

  /// No description provided for @typeDeleteToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Type \'delete\' to confirm'**
  String get typeDeleteToConfirm;

  /// No description provided for @enterDeleteHint.
  ///
  /// In en, this message translates to:
  /// **'Enter \"delete\"'**
  String get enterDeleteHint;

  /// No description provided for @deleteAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountButton;

  /// No description provided for @makeProfileInvisible.
  ///
  /// In en, this message translates to:
  /// **'Make your profile invisible?'**
  String get makeProfileInvisible;

  /// No description provided for @switchToLite.
  ///
  /// In en, this message translates to:
  /// **'Switch to Ithaki Lite?'**
  String get switchToLite;

  /// No description provided for @verificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verificationTitle;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @unsubscribe.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribe'**
  String get unsubscribe;

  /// No description provided for @noMoreJobInterests.
  ///
  /// In en, this message translates to:
  /// **'No more job interests available to add.'**
  String get noMoreJobInterests;

  /// No description provided for @roleMigrant.
  ///
  /// In en, this message translates to:
  /// **'Migrant'**
  String get roleMigrant;

  /// No description provided for @roleRefugee.
  ///
  /// In en, this message translates to:
  /// **'Refugee'**
  String get roleRefugee;

  /// No description provided for @roleAsylumSeeker.
  ///
  /// In en, this message translates to:
  /// **'Asylum Seeker'**
  String get roleAsylumSeeker;

  /// No description provided for @homeGreetingName.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}!'**
  String homeGreetingName(String name);

  /// No description provided for @homeGreetingNoName.
  ///
  /// In en, this message translates to:
  /// **'Hi!'**
  String get homeGreetingNoName;

  /// No description provided for @homeGreetingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here\'s a quick overview of your latest job matches, updates, and helpful tips to move your career forward.'**
  String get homeGreetingSubtitle;

  /// No description provided for @homeRestartProductTourSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restart the product tour whenever you want from Home.'**
  String get homeRestartProductTourSubtitle;

  /// No description provided for @homeRestartProductTour.
  ///
  /// In en, this message translates to:
  /// **'Restart Product Tour'**
  String get homeRestartProductTour;

  /// No description provided for @homeCareerAssistantBannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Career Assistant can help if you\'re not sure where to start!'**
  String get homeCareerAssistantBannerSubtitle;

  /// No description provided for @homeCoursesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Boost your skills with courses that help you grow faster and stay aligned with today\'s industry standards. Learn at your own pace and strengthen the experience on your profile.'**
  String get homeCoursesSubtitle;

  /// No description provided for @homeProfileCompleteYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile'**
  String get homeProfileCompleteYourProfile;

  /// No description provided for @homeProfileWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Ithaki!'**
  String get homeProfileWelcomeTitle;

  /// No description provided for @homeProfileFillMissing.
  ///
  /// In en, this message translates to:
  /// **'Fill in the missing information to unlock your full experience on the platform. A complete profile helps you get better job matches and more invitations.'**
  String get homeProfileFillMissing;

  /// No description provided for @homeProfileBenefitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Benefits of completing your profile'**
  String get homeProfileBenefitsTitle;

  /// No description provided for @homeProfileFillButton.
  ///
  /// In en, this message translates to:
  /// **'Fill Profile'**
  String get homeProfileFillButton;

  /// No description provided for @homeQuestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Have questions?'**
  String get homeQuestionsTitle;

  /// No description provided for @homeQuestionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let us help you!'**
  String get homeQuestionsSubtitle;

  /// No description provided for @homeQuestionsButton.
  ///
  /// In en, this message translates to:
  /// **'Book Call with Counselor'**
  String get homeQuestionsButton;

  /// No description provided for @assessmentStartNew.
  ///
  /// In en, this message translates to:
  /// **'Start New Assessment'**
  String get assessmentStartNew;

  /// No description provided for @assessmentsInProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Assessments in Progress ({count})'**
  String assessmentsInProgressTitle(int count);

  /// No description provided for @assessmentsInProgressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You have assessments in progress. Complete them to see your results.'**
  String get assessmentsInProgressSubtitle;

  /// No description provided for @assessmentsRecommendedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We recommend these assessments to help you validate your skills.'**
  String get assessmentsRecommendedSubtitle;

  /// No description provided for @assessmentsCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Completed Assessments'**
  String get assessmentsCompletedTitle;

  /// No description provided for @assessmentsCompletedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here are your completed assessments and results.'**
  String get assessmentsCompletedSubtitle;

  /// No description provided for @assessmentStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Start the Assessment'**
  String get assessmentStartTitle;

  /// No description provided for @assessmentStartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You are about to start the following assessment'**
  String get assessmentStartSubtitle;

  /// No description provided for @assessmentStartNow.
  ///
  /// In en, this message translates to:
  /// **'Start now'**
  String get assessmentStartNow;

  /// No description provided for @assessmentContinueTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue your assessment?'**
  String get assessmentContinueTitle;

  /// No description provided for @assessmentContinueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ve already started this assessment and have saved progress. Would you like to continue where you left off or start over?'**
  String get assessmentContinueSubtitle;

  /// No description provided for @assessmentStartOver.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get assessmentStartOver;

  /// No description provided for @assessmentSkillBreakdownSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This breakdown shows how your results are distributed across key skill areas.'**
  String get assessmentSkillBreakdownSubtitle;

  /// No description provided for @assessmentResultsConfirmSkills.
  ///
  /// In en, this message translates to:
  /// **'This result confirms your skills, which are reflected in your job applications on the platform.'**
  String get assessmentResultsConfirmSkills;

  /// No description provided for @assessmentShowInCV.
  ///
  /// In en, this message translates to:
  /// **'Show result in my CV'**
  String get assessmentShowInCV;

  /// No description provided for @assessmentHideFromCV.
  ///
  /// In en, this message translates to:
  /// **'Hide from CV'**
  String get assessmentHideFromCV;

  /// No description provided for @assessmentTakenLabel.
  ///
  /// In en, this message translates to:
  /// **'Taken: {date}'**
  String assessmentTakenLabel(String date);

  /// No description provided for @assessmentImprovingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your results show steady improvement in how you approach and resolve work-related problems.'**
  String get assessmentImprovingSubtitle;

  /// No description provided for @assessmentProcessingTitle.
  ///
  /// In en, this message translates to:
  /// **'Processing your results!'**
  String get assessmentProcessingTitle;

  /// No description provided for @assessmentProcessingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ve successfully completed the assessment. We\'re now generating your results — this will only take a moment.'**
  String get assessmentProcessingSubtitle;

  /// No description provided for @assessmentLeaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave this page?'**
  String get assessmentLeaveTitle;

  /// No description provided for @assessmentLeaveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re about to leave this assessment. Your progress will be saved automatically, and you can continue later.'**
  String get assessmentLeaveSubtitle;

  /// No description provided for @assessmentLeaveButton.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get assessmentLeaveButton;

  /// No description provided for @quizSelectOneAnswer.
  ///
  /// In en, this message translates to:
  /// **'Select only one answer'**
  String get quizSelectOneAnswer;

  /// No description provided for @quizSelectUpToAnswers.
  ///
  /// In en, this message translates to:
  /// **'Select up to {max} answers'**
  String quizSelectUpToAnswers(int max);

  /// No description provided for @quizSelectBestReflects.
  ///
  /// In en, this message translates to:
  /// **'Select the option that best reflects how you usually feel.'**
  String get quizSelectBestReflects;

  /// No description provided for @quizNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get quizNoResults;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @cvCouldNotLoadTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your CV.'**
  String get cvCouldNotLoadTitle;

  /// No description provided for @cvCouldNotLoadMessage.
  ///
  /// In en, this message translates to:
  /// **'Try refreshing your profile data and open it again.'**
  String get cvCouldNotLoadMessage;

  /// No description provided for @goToProfile.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile'**
  String get goToProfile;

  /// No description provided for @publishCv.
  ///
  /// In en, this message translates to:
  /// **'Publish CV'**
  String get publishCv;

  /// No description provided for @downloadCv.
  ///
  /// In en, this message translates to:
  /// **'Download CV'**
  String get downloadCv;

  /// No description provided for @cvDownloadSoon.
  ///
  /// In en, this message translates to:
  /// **'CV download will be available soon.'**
  String get cvDownloadSoon;

  /// No description provided for @returnToProfileSetup.
  ///
  /// In en, this message translates to:
  /// **'Return to Profile Setup'**
  String get returnToProfileSetup;

  /// No description provided for @publishedBadge.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get publishedBadge;

  /// No description provided for @draftModeBadge.
  ///
  /// In en, this message translates to:
  /// **'Draft Mode'**
  String get draftModeBadge;

  /// No description provided for @cvDraftReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'This is your CV - this is how companies see you.'**
  String get cvDraftReviewTitle;

  /// No description provided for @cvDraftReviewBody.
  ///
  /// In en, this message translates to:
  /// **'Please review all information carefully and make any necessary changes before publishing your CV.\nIf your CV is not published, companies will not be able to review it.\nYou can update your information anytime via Profile. Your CV will be updated automatically.'**
  String get cvDraftReviewBody;

  /// No description provided for @contactVisibilityNote.
  ///
  /// In en, this message translates to:
  /// **'Your contact details stay hidden until you apply for a job or accept an invitation.'**
  String get contactVisibilityNote;

  /// No description provided for @youBothShareSameValues.
  ///
  /// In en, this message translates to:
  /// **'You both share the same values'**
  String get youBothShareSameValues;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// No description provided for @greatJob.
  ///
  /// In en, this message translates to:
  /// **'Great Job!'**
  String get greatJob;

  /// No description provided for @cvLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Your CV Level:'**
  String get cvLevelLabel;

  /// No description provided for @strongLevel.
  ///
  /// In en, this message translates to:
  /// **'STRONG'**
  String get strongLevel;

  /// No description provided for @cvAssistantImprovementSummary.
  ///
  /// In en, this message translates to:
  /// **'The assistant found 4 areas you can improve to increase your chances of getting a job by about 15%.'**
  String get cvAssistantImprovementSummary;

  /// No description provided for @careerAssistantTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Career Assistant'**
  String get careerAssistantTitle;

  /// No description provided for @pathfinderName.
  ///
  /// In en, this message translates to:
  /// **'Pathfinder'**
  String get pathfinderName;

  /// No description provided for @pathfinderAdviceText.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m Pathfinder, your career assistant.\nI\'ve reviewed your profile and found a few quick improvements:\n\n- Critical: Your profile photo looks blurry. Upload a clear, professional one to make a stronger first impression.\n- Recommended: Add more detail to your work experience - specify what you built to show your real impact.\n- Minor: Record a short video intro. It helps teams connect with you and makes your profile stand out.\nThese small updates will noticeably boost your credibility and visibility.'**
  String get pathfinderAdviceText;

  /// No description provided for @askCareerPathHint.
  ///
  /// In en, this message translates to:
  /// **'Ask me about your career path...'**
  String get askCareerPathHint;

  /// No description provided for @leaveWithoutPublishingTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave without publishing?'**
  String get leaveWithoutPublishingTitle;

  /// No description provided for @leaveWithoutPublishingMessage.
  ///
  /// In en, this message translates to:
  /// **'If you leave this page, your CV will not be published and companies will not be able to review it. You can always publish it later from your profile, but we recommend publishing now to increase your chances of landing jobs.'**
  String get leaveWithoutPublishingMessage;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @workspaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get workspaceLabel;

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get levelLabel;

  /// No description provided for @desiredSalaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Desired Salary'**
  String get desiredSalaryLabel;

  /// No description provided for @jobPreferencesTabDescription.
  ///
  /// In en, this message translates to:
  /// **'This shows the job you are currently looking for. You can change this anytime.'**
  String get jobPreferencesTabDescription;

  /// No description provided for @preferencesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesSectionTitle;

  /// No description provided for @experienceAtCompany.
  ///
  /// In en, this message translates to:
  /// **'{role}  at  {company}'**
  String experienceAtCompany(String role, String company);

  /// No description provided for @educationAtInstitution.
  ///
  /// In en, this message translates to:
  /// **'{field}  at\n{institution}'**
  String educationAtInstitution(String field, String institution);

  /// No description provided for @periodWithDuration.
  ///
  /// In en, this message translates to:
  /// **'{start} - {end}  ({duration})'**
  String periodWithDuration(String start, String end, String duration);

  /// No description provided for @assessmentCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'{category} Assessment'**
  String assessmentCategoryLabel(String category);

  /// No description provided for @jobPreferencesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Your job preferences have been updated.'**
  String get jobPreferencesUpdated;

  /// No description provided for @updateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateButton;

  /// No description provided for @currentEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Email'**
  String get currentEmailLabel;

  /// No description provided for @updateEmailDescription.
  ///
  /// In en, this message translates to:
  /// **'Update your email address'**
  String get updateEmailDescription;

  /// No description provided for @deleteAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'To permanently delete your account, please type delete in the field below.\nThis action cannot be undone - all your data will be removed forever.'**
  String get deleteAccountDescription;

  /// No description provided for @communicationChannelTitle.
  ///
  /// In en, this message translates to:
  /// **'Communication Channel'**
  String get communicationChannelTitle;

  /// No description provided for @emailNewsletterTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Newsletter'**
  String get emailNewsletterTitle;

  /// No description provided for @emailNewsletterDescription.
  ///
  /// In en, this message translates to:
  /// **'Stay informed and make the most of your experience! Choose which types of updates and insights you\'d like to receive directly to your inbox.'**
  String get emailNewsletterDescription;

  /// No description provided for @newsletterActive.
  ///
  /// In en, this message translates to:
  /// **'(active)'**
  String get newsletterActive;

  /// No description provided for @newsletterInactive.
  ///
  /// In en, this message translates to:
  /// **'(inactive)'**
  String get newsletterInactive;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @settingsUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Settings updated successfully.'**
  String get settingsUpdatedSuccessfully;

  /// No description provided for @newsletterJobsTitle.
  ///
  /// In en, this message translates to:
  /// **'Jobs Recommendations'**
  String get newsletterJobsTitle;

  /// No description provided for @newsletterJobsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personalized job offers based on your skills and preferences'**
  String get newsletterJobsSubtitle;

  /// No description provided for @newsletterCareerTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Career Tips'**
  String get newsletterCareerTipsTitle;

  /// No description provided for @newsletterCareerTipsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Expert advice and resources to boost your professional growth'**
  String get newsletterCareerTipsSubtitle;

  /// No description provided for @newsletterEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Events & Webinars'**
  String get newsletterEventsTitle;

  /// No description provided for @newsletterEventsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming career events, workshops, and networking sessions'**
  String get newsletterEventsSubtitle;

  /// No description provided for @newsletterPlatformTitle.
  ///
  /// In en, this message translates to:
  /// **'Platform Updates'**
  String get newsletterPlatformTitle;

  /// No description provided for @newsletterPlatformSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New features, tools, and product improvements'**
  String get newsletterPlatformSubtitle;

  /// No description provided for @newsletterLearningTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning Opportunities'**
  String get newsletterLearningTitle;

  /// No description provided for @newsletterLearningSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Online courses and certifications to enhance your skills'**
  String get newsletterLearningSubtitle;

  /// No description provided for @uploadFilesTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Files'**
  String get uploadFilesTitle;

  /// No description provided for @uploadMore.
  ///
  /// In en, this message translates to:
  /// **'Upload More'**
  String get uploadMore;

  /// No description provided for @uploadFileInstructions.
  ///
  /// In en, this message translates to:
  /// **'Tap button to browse\n(max 10 files, up to 5 MB each;\nsupported: .pdf, .doc, .png, .jpg)'**
  String get uploadFileInstructions;

  /// No description provided for @documentUrlDescription.
  ///
  /// In en, this message translates to:
  /// **'Provide a link to a document to import it into the system.'**
  String get documentUrlDescription;

  /// No description provided for @documentUrlMustBeActive.
  ///
  /// In en, this message translates to:
  /// **'The link must be active and accessible without login.'**
  String get documentUrlMustBeActive;

  /// No description provided for @documentUrlSupportedFormats.
  ///
  /// In en, this message translates to:
  /// **'The document must be in a supported format (PDF, DOC, DOCX).'**
  String get documentUrlSupportedFormats;

  /// No description provided for @documentUrlCommonServices.
  ///
  /// In en, this message translates to:
  /// **'Common services: Google Drive, Dropbox, iCloud.'**
  String get documentUrlCommonServices;

  /// No description provided for @documentLinkHint.
  ///
  /// In en, this message translates to:
  /// **'Add Document\'s Link'**
  String get documentLinkHint;

  /// No description provided for @fileComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get fileComplete;

  /// No description provided for @fileUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get fileUploading;

  /// No description provided for @fileFallbackLabel.
  ///
  /// In en, this message translates to:
  /// **'FILE'**
  String get fileFallbackLabel;

  /// No description provided for @profileMenuMyProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profileMenuMyProfile;

  /// No description provided for @profileMenuMyCv.
  ///
  /// In en, this message translates to:
  /// **'My CV'**
  String get profileMenuMyCv;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @goToJobSearch.
  ///
  /// In en, this message translates to:
  /// **'Go to Job Search'**
  String get goToJobSearch;

  /// No description provided for @startProductTour.
  ///
  /// In en, this message translates to:
  /// **'Start Product Tour'**
  String get startProductTour;

  /// No description provided for @continueProductTour.
  ///
  /// In en, this message translates to:
  /// **'Continue Product Tour'**
  String get continueProductTour;

  /// No description provided for @skipAndClose.
  ///
  /// In en, this message translates to:
  /// **'Skip and Close'**
  String get skipAndClose;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @tourStepIndicator.
  ///
  /// In en, this message translates to:
  /// **'{current} Step / {total}'**
  String tourStepIndicator(int current, int total);

  /// No description provided for @tourReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re Ready!'**
  String get tourReadyTitle;

  /// No description provided for @tourReadyBody.
  ///
  /// In en, this message translates to:
  /// **'Now you know the main platform features. Complete your profile, take assessments, and apply for jobs that match you.'**
  String get tourReadyBody;

  /// No description provided for @tourWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Get You Started!'**
  String get tourWelcomeTitle;

  /// No description provided for @tourWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Here you can find a job that fits your skills and experience. Let\'s go step by step.'**
  String get tourWelcomeBody;

  /// No description provided for @tourSkipTitle.
  ///
  /// In en, this message translates to:
  /// **'Skip for now?'**
  String get tourSkipTitle;

  /// No description provided for @tourSkipBody.
  ///
  /// In en, this message translates to:
  /// **'You can always take the product tour later using the banner on the Home page.'**
  String get tourSkipBody;

  /// No description provided for @tourStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Get on Track!'**
  String get tourStep1Title;

  /// No description provided for @tourStep1Body.
  ///
  /// In en, this message translates to:
  /// **'Here you\'ll see jobs and courses selected for you, CV insights, and tools to help you start your job search.'**
  String get tourStep1Body;

  /// No description provided for @tourStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Find a Job'**
  String get tourStep2Title;

  /// No description provided for @tourStep2Body.
  ///
  /// In en, this message translates to:
  /// **'Search for jobs by name or choose from categories below. You can find work near your city, or set other parameters to find the job you need.'**
  String get tourStep2Body;

  /// No description provided for @tourStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Job Post'**
  String get tourStep3Title;

  /// No description provided for @tourStep3Body.
  ///
  /// In en, this message translates to:
  /// **'Each job card shows the main information - position, location, and salary. Tap the card to open full details and apply.'**
  String get tourStep3Body;

  /// No description provided for @tourStep4Title.
  ///
  /// In en, this message translates to:
  /// **'See how well this job fits for you'**
  String get tourStep4Title;

  /// No description provided for @tourStep4Body.
  ///
  /// In en, this message translates to:
  /// **'This part shows how well your experience and skills match the job. The higher the match, the better your chances.'**
  String get tourStep4Body;

  /// No description provided for @tourStep5Title.
  ///
  /// In en, this message translates to:
  /// **'Job Details'**
  String get tourStep5Title;

  /// No description provided for @tourStep5Body.
  ///
  /// In en, this message translates to:
  /// **'Read the full job description, requirements, and what the company offers before you apply.'**
  String get tourStep5Body;

  /// No description provided for @tourStep6Title.
  ///
  /// In en, this message translates to:
  /// **'Easy to Apply'**
  String get tourStep6Title;

  /// No description provided for @tourStep6Body.
  ///
  /// In en, this message translates to:
  /// **'Application is easy! Select your CV format and add a few words about yourself in the Cover Letter to increase your chances.'**
  String get tourStep6Body;

  /// No description provided for @tourStep7Title.
  ///
  /// In en, this message translates to:
  /// **'Track the Progress'**
  String get tourStep7Title;

  /// No description provided for @tourStep7Body.
  ///
  /// In en, this message translates to:
  /// **'Once you apply for a job, you can find your response in My Applications.'**
  String get tourStep7Body;

  /// No description provided for @tourStep8Title.
  ///
  /// In en, this message translates to:
  /// **'My Invitations'**
  String get tourStep8Title;

  /// No description provided for @tourStep8Body.
  ///
  /// In en, this message translates to:
  /// **'Companies can invite you directly. You can review relevant invitations from teams interested in your profile.'**
  String get tourStep8Body;

  /// No description provided for @tourStep9Title.
  ///
  /// In en, this message translates to:
  /// **'Get on Track!'**
  String get tourStep9Title;

  /// No description provided for @tourStep9Body.
  ///
  /// In en, this message translates to:
  /// **'You can open the invitation to read job details and accept the offer.'**
  String get tourStep9Body;

  /// No description provided for @tourStep10Title.
  ///
  /// In en, this message translates to:
  /// **'Build your Profile'**
  String get tourStep10Title;

  /// No description provided for @tourStep10Body.
  ///
  /// In en, this message translates to:
  /// **'Your profile shows your experience, skills, and contact info. A complete profile helps you get better job matches. You can edit or update it anytime.'**
  String get tourStep10Body;

  /// No description provided for @tourStep11Title.
  ///
  /// In en, this message translates to:
  /// **'Meet your Career Assistant'**
  String get tourStep11Title;

  /// No description provided for @tourStep11Body.
  ///
  /// In en, this message translates to:
  /// **'Pathfinder can help you improve your profile, find the right jobs, and answer your questions about work.'**
  String get tourStep11Body;

  /// No description provided for @tourStep12Title.
  ///
  /// In en, this message translates to:
  /// **'Learning Hub'**
  String get tourStep12Title;

  /// No description provided for @tourStep12Body.
  ///
  /// In en, this message translates to:
  /// **'Access courses and resources tailored to your career goals and the skills companies are looking for.'**
  String get tourStep12Body;

  /// No description provided for @tourStep13Title.
  ///
  /// In en, this message translates to:
  /// **'Get to know yourself better'**
  String get tourStep13Title;

  /// No description provided for @tourStep13Body.
  ///
  /// In en, this message translates to:
  /// **'Here you can take different assessments. Your results help highlight your strengths and working style.'**
  String get tourStep13Body;

  /// No description provided for @changePasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Change your password to keep your account secure'**
  String get changePasswordDescription;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Your password has been updated.'**
  String get passwordUpdated;

  /// No description provided for @currentPhoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Phone Number'**
  String get currentPhoneNumberLabel;

  /// No description provided for @makeProfileInvisibleDescription.
  ///
  /// In en, this message translates to:
  /// **'If you make your profile invisible, companies won\'t be able to find you in candidate searches. You\'ll still be able to apply for jobs you\'re interested in. You can change your profile visibility anytime in your account settings.'**
  String get makeProfileInvisibleDescription;

  /// No description provided for @makeProfileInvisibleButton.
  ///
  /// In en, this message translates to:
  /// **'Make Profile Invisible'**
  String get makeProfileInvisibleButton;

  /// No description provided for @switchLiteDescription.
  ///
  /// In en, this message translates to:
  /// **'The interface will become simpler and easier to use. We\'ll show you only the jobs that best match your job interests.\nYou can switch back to the full interface at any time.'**
  String get switchLiteDescription;

  /// No description provided for @switchLiteButton.
  ///
  /// In en, this message translates to:
  /// **'Switch to Ithaki Lite'**
  String get switchLiteButton;

  /// No description provided for @switchedToLite.
  ///
  /// In en, this message translates to:
  /// **'Switched to Ithaki Lite.'**
  String get switchedToLite;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @newValueLabel.
  ///
  /// In en, this message translates to:
  /// **'New {type}'**
  String newValueLabel(String type);

  /// No description provided for @codeSentToContact.
  ///
  /// In en, this message translates to:
  /// **'A 6-digit code was sent to your {contact}.'**
  String codeSentToContact(String contact);

  /// No description provided for @phoneViaSms.
  ///
  /// In en, this message translates to:
  /// **'phone via SMS'**
  String get phoneViaSms;

  /// No description provided for @changedEmail.
  ///
  /// In en, this message translates to:
  /// **'Your email has been changed.'**
  String get changedEmail;

  /// No description provided for @changedPhone.
  ///
  /// In en, this message translates to:
  /// **'Your phone number has been changed.'**
  String get changedPhone;

  /// No description provided for @jobReportedMessage.
  ///
  /// In en, this message translates to:
  /// **'Job post has been reported'**
  String get jobReportedMessage;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy Link'**
  String get copyLink;

  /// No description provided for @shareWhatsappSms.
  ///
  /// In en, this message translates to:
  /// **'Share WhatsApp/SMS'**
  String get shareWhatsappSms;

  /// No description provided for @shareInEmail.
  ///
  /// In en, this message translates to:
  /// **'Share in Email'**
  String get shareInEmail;

  /// No description provided for @shareOnLinkedIn.
  ///
  /// In en, this message translates to:
  /// **'Share on LinkedIn'**
  String get shareOnLinkedIn;

  /// No description provided for @industryLabel.
  ///
  /// In en, this message translates to:
  /// **'Industry'**
  String get industryLabel;

  /// No description provided for @travelLabel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travelLabel;

  /// No description provided for @reportJobDescription.
  ///
  /// In en, this message translates to:
  /// **'Reporting jobs helps us keep job postings at the highest quality levels.'**
  String get reportJobDescription;

  /// No description provided for @tellUsMoreOptional.
  ///
  /// In en, this message translates to:
  /// **'Tell us more (optional)'**
  String get tellUsMoreOptional;

  /// No description provided for @reportThisJobButton.
  ///
  /// In en, this message translates to:
  /// **'Report this Job'**
  String get reportThisJobButton;

  /// No description provided for @setReminderButton.
  ///
  /// In en, this message translates to:
  /// **'Set Reminder'**
  String get setReminderButton;

  /// No description provided for @reminderChoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'How would you like to be reminded?'**
  String get reminderChoiceTitle;

  /// No description provided for @reminderViaEmail.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a reminder via email'**
  String get reminderViaEmail;

  /// No description provided for @reminderViaSmsWhatsappGeneric.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a reminder via SMS/WhatsApp'**
  String get reminderViaSmsWhatsappGeneric;

  /// No description provided for @jobClosedButton.
  ///
  /// In en, this message translates to:
  /// **'Job Closed'**
  String get jobClosedButton;

  /// No description provided for @removeFromSaved.
  ///
  /// In en, this message translates to:
  /// **'Remove from Saved'**
  String get removeFromSaved;

  /// No description provided for @newFeatureBanner.
  ///
  /// In en, this message translates to:
  /// **'New on Ithaki! We just released a new feature that makes job search easier.'**
  String get newFeatureBanner;

  /// No description provided for @curiousWhyMatch.
  ///
  /// In en, this message translates to:
  /// **'Curious why you match this job?'**
  String get curiousWhyMatch;

  /// No description provided for @strongSkillsMatch.
  ///
  /// In en, this message translates to:
  /// **'It\'s a Strong skills\nMatch!'**
  String get strongSkillsMatch;

  /// No description provided for @goodSkillsMatch.
  ///
  /// In en, this message translates to:
  /// **'It\'s a Good skills\nMatch!'**
  String get goodSkillsMatch;

  /// No description provided for @partialSkillsMatch.
  ///
  /// In en, this message translates to:
  /// **'It\'s a Partial skills\nMatch!'**
  String get partialSkillsMatch;

  /// No description provided for @starterSkillsMatch.
  ///
  /// In en, this message translates to:
  /// **'It\'s a Starter skills\nMatch!'**
  String get starterSkillsMatch;

  /// No description provided for @deadlineBannerText.
  ///
  /// In en, this message translates to:
  /// **'This job has a deadline! Application\nopen till:'**
  String get deadlineBannerText;

  /// No description provided for @skillsRequired.
  ///
  /// In en, this message translates to:
  /// **'Skills required'**
  String get skillsRequired;

  /// No description provided for @aboutRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'About the role'**
  String get aboutRoleTitle;

  /// No description provided for @requirementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get requirementsTitle;

  /// No description provided for @niceToHaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Nice to have'**
  String get niceToHaveTitle;

  /// No description provided for @weOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'We offer'**
  String get weOfferTitle;

  /// No description provided for @shareJob.
  ///
  /// In en, this message translates to:
  /// **'Share Job'**
  String get shareJob;

  /// No description provided for @notInterested.
  ///
  /// In en, this message translates to:
  /// **'Not Interested'**
  String get notInterested;

  /// No description provided for @deleteReminder.
  ///
  /// In en, this message translates to:
  /// **'Delete Reminder'**
  String get deleteReminder;

  /// No description provided for @salaryRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Salary Range'**
  String get salaryRangeLabel;

  /// No description provided for @responsibilitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Responsibilities'**
  String get responsibilitiesTitle;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorMessage(String error);

  /// No description provided for @assessmentNotFound.
  ///
  /// In en, this message translates to:
  /// **'Assessment not found'**
  String get assessmentNotFound;

  /// No description provided for @testDetails.
  ///
  /// In en, this message translates to:
  /// **'Test Details'**
  String get testDetails;

  /// No description provided for @startTest.
  ///
  /// In en, this message translates to:
  /// **'Start Test'**
  String get startTest;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @inCv.
  ///
  /// In en, this message translates to:
  /// **'In CV'**
  String get inCv;

  /// No description provided for @showInCv.
  ///
  /// In en, this message translates to:
  /// **'Show in CV'**
  String get showInCv;

  /// No description provided for @questionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} questions'**
  String questionsCount(int count);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String durationMinutes(int count);

  /// No description provided for @rangeNumberSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select a number from {min} to {max}, where {min} means \"{minLabel}\" and {max} means \"{maxLabel}\".'**
  String rangeNumberSubtitle(
      int min, int max, String minLabel, String maxLabel);

  /// No description provided for @addJobInterestTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Job Interest'**
  String get addJobInterestTitle;

  /// No description provided for @searchCityTitle.
  ///
  /// In en, this message translates to:
  /// **'Search City'**
  String get searchCityTitle;

  /// No description provided for @typeCityHint.
  ///
  /// In en, this message translates to:
  /// **'Type a city name...'**
  String get typeCityHint;

  /// No description provided for @citySearchTypeMore.
  ///
  /// In en, this message translates to:
  /// **'Type at least 2 characters'**
  String get citySearchTypeMore;

  /// No description provided for @citySearchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No cities found'**
  String get citySearchNoResults;

  /// No description provided for @photoFileLimit.
  ///
  /// In en, this message translates to:
  /// **'5 MB max · PNG or JPG'**
  String get photoFileLimit;

  /// No description provided for @photoRecommendation.
  ///
  /// In en, this message translates to:
  /// **'We recommend a professional photo that clearly shows your face.'**
  String get photoRecommendation;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// No description provided for @replacePhoto.
  ///
  /// In en, this message translates to:
  /// **'Replace Photo'**
  String get replacePhoto;

  /// No description provided for @screeningQuestionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here are your answers to a few questions from the employer'**
  String get screeningQuestionsSubtitle;

  /// No description provided for @toJobDetails.
  ///
  /// In en, this message translates to:
  /// **'To Job Details'**
  String get toJobDetails;

  /// No description provided for @whatWeOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'What we offer'**
  String get whatWeOfferTitle;

  /// No description provided for @employeeReviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Employee Reviews'**
  String get employeeReviewsTitle;

  /// No description provided for @applyButton.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyButton;

  /// No description provided for @shareLabel.
  ///
  /// In en, this message translates to:
  /// **'Share:'**
  String get shareLabel;

  /// No description provided for @readArticle.
  ///
  /// In en, this message translates to:
  /// **'Read Article'**
  String get readArticle;

  /// No description provided for @chatGetStartedHint.
  ///
  /// In en, this message translates to:
  /// **'You can get started with an example below'**
  String get chatGetStartedHint;

  /// No description provided for @chatWithCareerAssistant.
  ///
  /// In en, this message translates to:
  /// **'Chat with your\nCareer Assistant'**
  String get chatWithCareerAssistant;

  /// No description provided for @chatHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can search across all your previous chats by keywords or phrases.'**
  String get chatHistorySubtitle;

  /// No description provided for @chatHistorySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Type a word or phrase to find messages...'**
  String get chatHistorySearchHint;

  /// No description provided for @chatHistoryToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get chatHistoryToday;

  /// No description provided for @chatHistoryLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get chatHistoryLast7Days;

  /// No description provided for @chatThinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking...'**
  String get chatThinking;

  /// No description provided for @chatSearchMessagesHint.
  ///
  /// In en, this message translates to:
  /// **'Search messages...'**
  String get chatSearchMessagesHint;

  /// No description provided for @culturalFitLabel.
  ///
  /// In en, this message translates to:
  /// **'Cultural Fit'**
  String get culturalFitLabel;

  /// No description provided for @savedJobsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} saved jobs'**
  String savedJobsCountLabel(String count);

  /// No description provided for @jobsFoundLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} jobs found'**
  String jobsFoundLabel(String count);

  /// No description provided for @noSavedJobsYet.
  ///
  /// In en, this message translates to:
  /// **'No saved jobs yet.'**
  String get noSavedJobsYet;

  /// No description provided for @notificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsLabel;

  /// No description provided for @notificationsScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here you can see all your news. Stay up to date with important updates.'**
  String get notificationsScreenSubtitle;

  /// No description provided for @notificationsUnreadCount.
  ///
  /// In en, this message translates to:
  /// **'You have {count} new notifications'**
  String notificationsUnreadCount(int count);

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @accountInformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformationTitle;

  /// No description provided for @accountInformationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your account details to keep your account secure and up to date.'**
  String get accountInformationSubtitle;

  /// No description provided for @profileVisibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Visibility'**
  String get profileVisibilityTitle;

  /// No description provided for @profileVisibleForEmployers.
  ///
  /// In en, this message translates to:
  /// **'Profile Visible for Employers'**
  String get profileVisibleForEmployers;

  /// No description provided for @profileHiddenFromEmployers.
  ///
  /// In en, this message translates to:
  /// **'Profile Hidden from Employers'**
  String get profileHiddenFromEmployers;

  /// No description provided for @profileVisibilityDescription.
  ///
  /// In en, this message translates to:
  /// **'Right now, employers can view your profile and send you invitations. If you prefer more privacy, you can hide your profile — it will only be visible when you apply to a job.'**
  String get profileVisibilityDescription;

  /// No description provided for @hideProfileFromEmployers.
  ///
  /// In en, this message translates to:
  /// **'Hide Profile from Employers'**
  String get hideProfileFromEmployers;

  /// No description provided for @showProfileToEmployers.
  ///
  /// In en, this message translates to:
  /// **'Show Profile to Employers'**
  String get showProfileToEmployers;

  /// No description provided for @digitalComfortTitle.
  ///
  /// In en, this message translates to:
  /// **'Digital Comfort'**
  String get digitalComfortTitle;

  /// No description provided for @digitalComfortExperienced.
  ///
  /// In en, this message translates to:
  /// **'You are experienced tech user'**
  String get digitalComfortExperienced;

  /// No description provided for @digitalComfortDescription.
  ///
  /// In en, this message translates to:
  /// **'You\'re using our full experience right now — perfect for confident tech users. If you ever want a simpler, easier interface, you can switch to the light version whenever you like.'**
  String get digitalComfortDescription;

  /// No description provided for @tryIthakiLite.
  ///
  /// In en, this message translates to:
  /// **'Try Ithaki Lite'**
  String get tryIthakiLite;

  /// No description provided for @deleteAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete an Account'**
  String get deleteAnAccount;

  /// No description provided for @deleteAccountTabDescription.
  ///
  /// In en, this message translates to:
  /// **'Permanently remove your account and all related data from the system. This action cannot be undone.'**
  String get deleteAccountTabDescription;
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
