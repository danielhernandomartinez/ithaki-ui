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
