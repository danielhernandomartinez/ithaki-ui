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
  /// **'Add a few words about yourself to help employers understand who you are and what you do.'**
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

  String get companyTabVacancies;
  String get companyTabAboutCompany;
  String get companyTabEvents;
  String get companyTabPosts;
  String companyJobsFound(int count);
  String get companyNoVacancies;
  String get saveJob;
  String get entryLevel;
  String get companyPerksTitle;
  String get companyGalleryTitle;
  String get companyNoEvents;
  String get companyEventsTitle;
  String get companyPostsTitle;
  String companyPostsFound(int count);
  String get companyNoPostsYet;
  String get shareButton;
  String get culturalMatchScore;
  String get culturalMatchDescription;
  String get culturalMatchYouBothCareAbout;
  String companyTeamEmployees(String teamSize);
  String get companyLabelMainOffice;
  String get companyLabelOtherLocations;
  String get companyLabelContactPhone;
  String get companyLabelWebsite;
  String get notAvailable;
  String get eventDetailsTitle;
  String get eventAddressLabel;
  String get eventRegistrationLink;
  String get companyLoadError;
  String get tryAgain;

  String get assessmentsRecommendedForYou;
  String get assessmentYourScore;
  String get assessmentLevel;
  String get assessmentSkillBreakdown;
  String get assessmentKeyInsights;
  String get assessmentPreviousResults;
  String get assessmentYouImproving;
  String get assessmentMeansForProfile;
  String get assessmentAboutThis;
  String get assessmentUsedFor;
  String get assessmentBeforeStart;
  String get assessmentApproxDuration;
  String get assessmentQuestionsLabel;
  String get bannerNotSureJob;
  String get chatNewChat;
  String get chatSearchInChats;
  String get chatHistory;
  String get homeNeedRefresher;
  String get homeCvSuccess;
  String get homeStatViews;
  String get homeStatInvitations;
  String get homeStatApplicationsSent;
  String get homeStatInterviews;
  String get homeRecommendedCourses;
  String get homeLatestNews;
  String get homeSmartJobRecommendations;
  String get viewAll;
  String get searchByJobTitle;
  String get jobLoadError;
  String get jobRemovedFromSaved;
  String get jobSavedMessage;
  String get jobPostRemoved;
  String get deadlineReminderSet;
  String get readMore;
  String jobPostedDate(String date);
  String get jobClosedLabel;
  String get deadlineReminderLabel;
  String get reportLabel;
  String get reminderSetNotification;
  String get odysseaReviewLabel;
  String get recommendedForYouLabel;
  String get tabAllJobs;
  String tabSavedJobs(int count);
  String get sortingTitle;
  String get filtersTitle;
  String get resetFilters;
  String get applyFilters;
  String get filterAllLabel;
  String get filterClear;
  String get applyFilter;
  String get salaryTitle;
  String get tillLabel;
  String get reportJobTitle;
  String get selectReasonHint;
  String get setReminderTitle;
  String get applicationOpenTill;
  String get whenShouldRemind;
  String get reminderTomorrow;
  String get reminderTomorrowSub;
  String get reminderOneWeek;
  String get reminderOneWeekSub;
  String get reminderOneDayBefore;
  String get reminderOneDayBeforeSub;
  String get reminderCustomDate;
  String get reminderCustomDateSub;
  String get selectDateLabel;
  String get selectTimeLabel;
  String get ddMmYyyyHint;
  String reminderViaContactSub(String contact);
  String get reminderViaSmsWhatsapp;
  String get changeEmailTitle;
  String get newEmailLabel;
  String get newEmailHint;
  String get changePasswordTitle;
  String get repeatNewPasswordLabel;
  String get repeatNewPasswordHint;
  String get changePhoneTitle;
  String get newPhoneNumberLabel;
  String get confirmAccountDeletion;
  String get typeDeleteToConfirm;
  String get enterDeleteHint;
  String get deleteAccountButton;
  String get makeProfileInvisible;
  String get switchToLite;
  String get verificationTitle;
  String get pushNotifications;
  String get unsubscribe;
  String get noMoreJobInterests;
  String get roleMigrant;
  String get roleRefugee;
  String get roleAsylumSeeker;
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
