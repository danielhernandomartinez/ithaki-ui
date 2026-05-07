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
      'Your name and phone number help teams contact you directly.';

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
  String get resetPasswordHeading => 'Reset your password';

  @override
  String get resetPasswordDescription =>
      'Final step. Create a new password to secure your account.';

  @override
  String get newPasswordLabel => 'New Password';

  @override
  String get newPasswordHint => 'Enter your new password';

  @override
  String get confirmNewPasswordLabel => 'Confirm new Password';

  @override
  String get confirmNewPasswordHint => 'Enter your new password';

  @override
  String get resetPasswordButton => 'Reset Password';

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

  @override
  String get myApplicationsTabLabel => 'My Applications';

  @override
  String get myApplicationsTabDescription =>
      'Track all the jobs you\'ve applied for and see their current status. You can also review invitations you\'ve accepted or find past applications in your archive.';

  @override
  String get myApplicationsLoadError => 'Failed to load applications.';

  @override
  String get myApplicationsEmptyTitle => 'No applications yet';

  @override
  String get myApplicationsEmptySubtitle =>
      'Jobs you apply for will appear here\nso you can track their status.';

  @override
  String myInvitationsTabLabel(int count) {
    return 'My Invitations ($count)';
  }

  @override
  String get draftsTabLabel => 'Drafts';

  @override
  String get archiveTabLabel => 'Archive';

  @override
  String get invitationsTabDescription =>
      'Here you can find job opportunities you\'ve been invited to explore. Review invitations from companies or organizations who found your profile interesting.';

  @override
  String get invitationsLoadError => 'Failed to load invitations.';

  @override
  String get invitationsEmptyTitle => 'No invitations yet';

  @override
  String get invitationsEmptySubtitle =>
      'When companies find your profile interesting\nthey will invite you here.';

  @override
  String get draftsTabDescription =>
      'Here you can find applications you started but haven\'t submitted yet. Continue where you left off or discard them.';

  @override
  String get draftsLoadError => 'Failed to load drafts.';

  @override
  String get draftsEmptyTitle => 'No drafts yet';

  @override
  String get draftsEmptySubtitle =>
      'Applications you start but don\'t submit\nwill appear here.';

  @override
  String get archiveTabDescription =>
      'Here you can find all declined invitations and closed applications. They\'re stored for your reference and can be viewed anytime.';

  @override
  String get archiveEmptyTitle => 'Nothing in your archive';

  @override
  String get archiveEmptySubtitle =>
      'Declined invitations and closed applications\nwill be stored here.';

  @override
  String get invitationDeclinedLabel => 'Invitation declined';

  @override
  String get viewJobDetails => 'View Job Details';

  @override
  String get dismissInvite => 'Dismiss Invite';

  @override
  String get declinedConfirmed => 'Declined';

  @override
  String get viewJob => 'View Job';

  @override
  String get dismissBannerTitle => 'This invitation will be moved to Archive';

  @override
  String get dismissBannerCountdown => 'Auto-confirms in 5 seconds';

  @override
  String get undo => 'Undo';

  @override
  String get invitationDismissedToast =>
      'Invitation dismissed and moved to Archive';

  @override
  String get invitationDeclinedToast =>
      'Invitation declined and moved to Archive';

  @override
  String get careerAssistantBannerTitle => 'Don\'t know what to do next?';

  @override
  String get careerAssistantBannerSubtitle =>
      'On average, applications are reviewed within the first week. You can always ask me for help with your next steps.';

  @override
  String get askCareerAssistant => 'Ask Career Assistant';

  @override
  String get blogNewsTitle => 'Blog & News';

  @override
  String get blogNewsSubtitle =>
      'Discover career tips, interview guides, and platform updates.';

  @override
  String get blogSearchHint => 'Search for articles and topics';

  @override
  String get blogAllCategories => 'All';

  @override
  String get blogRelatedArticles => 'Related Articles';

  @override
  String get blogDiscoverAll => 'Discover All News';

  @override
  String get blogArticleNotFound => 'Article not found.';

  @override
  String blogArticleBy(String author) {
    return 'By $author';
  }

  @override
  String get cardAppliedWithCv => 'You applied with your Ithaki CV';

  @override
  String get cardJobClosed => 'Job is closed.';

  @override
  String get continueApplication => 'Continue';

  @override
  String get viewApplication => 'View Application';

  @override
  String get applySheetTitle => 'Ready to apply for this role?';

  @override
  String get applySheetSubtitle =>
      'Make sure your talent profile details are up to date before submitting your application. You can also upload your CV.';

  @override
  String get applyOptionIthakiCvTitle => 'Use Ithaki CV';

  @override
  String get applyOptionIthakiCvSubtitle =>
      'Use your saved CV and profile details to apply.';

  @override
  String get applyOptionUploadTitle => 'Upload your CV';

  @override
  String get applyOptionUploadSubtitle =>
      'Upload a new file (PDF or DOC) to apply.';

  @override
  String get applyNow => 'Apply Now';

  @override
  String get declineSheetTitle => 'Decline Invitation';

  @override
  String get declineSheetSubtitle =>
      'Are you sure you want to decline this invitation?';

  @override
  String get declineReasonLabel => 'Please select a reason';

  @override
  String get declineReasonHint => 'Select reason';

  @override
  String get declineReasonNotInterested => 'Not interested in this position';

  @override
  String get declineReasonFoundJob => 'Already found a job';

  @override
  String get declineReasonSalary => 'Salary doesn\'t match my expectations';

  @override
  String get declineReasonLocation => 'Location doesn\'t work for me';

  @override
  String get declineReasonOther => 'Other';

  @override
  String get declineButton => 'Decline Invite';

  @override
  String get declinedButton => '✓  Declined';

  @override
  String get jobDetailNotFoundMessage =>
      'We could not find job details for this application yet.';

  @override
  String get backToApplications => 'Back to Applications';

  @override
  String get acceptInviteAndApply => 'Accept Invite and Apply';

  @override
  String get jobDetailsTitle => 'Job Details';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get open => 'Open';

  @override
  String get delete => 'Delete';

  @override
  String get appBarTitleIthaki => 'Ithaki';

  @override
  String get profileAboutMeTitle => 'About Me';

  @override
  String get profileSkillsTitle => 'Skills';

  @override
  String get hardSkillsTitle => 'Hard Skills';

  @override
  String get softSkillsTitle => 'Soft Skills';

  @override
  String get competenciesTitle => 'Competencies';

  @override
  String get computerSkillsTitle => 'Computer Skills';

  @override
  String get drivingLicenseTitle => 'Driving License';

  @override
  String get licenseCategoryTitle => 'License Category';

  @override
  String get editCompetenciesTitle => 'Edit Competencies';

  @override
  String get editSkillsTitle => 'Edit Skills';

  @override
  String get editLanguagesTitle => 'Edit Languages';

  @override
  String get editValuesTitle => 'Values';

  @override
  String get editAboutMeTitle => 'About Me';

  @override
  String get addBioOptional => 'Add Bio (optional)';

  @override
  String get addVideoPresentationOptional =>
      'Add Video Presentation (optional)';

  @override
  String get uploadFile => 'Upload File';

  @override
  String get pasteVideoUrlHere => 'Paste video URL here';

  @override
  String get noValuesAddedYet => 'No values added yet.';

  @override
  String get profileMyFilesTitle => 'My Files';

  @override
  String get couldNotOpenVideoIntroduction =>
      'Could not open video introduction.';

  @override
  String openFileNoSource(String fileName) {
    return '$fileName has no file source to open.';
  }

  @override
  String couldNotOpenFile(String fileName) {
    return 'Could not open $fileName.';
  }

  @override
  String openingFile(String fileName) {
    return 'Opening $fileName';
  }

  @override
  String get openCv => 'Open CV';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get editJobPreferencesTitle => 'Job Preferences';

  @override
  String get positionLevelOptionalLabel => 'Position Level (optional)';

  @override
  String get selectLevel => 'Select level';

  @override
  String get profileEducationTitle => 'Education';

  @override
  String get profileEducationSubtitle =>
      'Add information about your educational background, degree, and field of study.';

  @override
  String get addEducation => 'Add Education';

  @override
  String get editEducation => 'Edit Education';

  @override
  String get institutionNameLabel => 'Institution Name';

  @override
  String get institutionNameHint => 'e.g. University of Athens';

  @override
  String get fieldOfStudyLabel => 'Field of Study';

  @override
  String get fieldOfStudyHint => 'e.g. Computer Science';

  @override
  String get degreeTypeLabel => 'Degree Type';

  @override
  String get selectDegree => 'Select degree';

  @override
  String get startDateLabel => 'Start Date';

  @override
  String get endDateLabel => 'End Date';

  @override
  String get mmYyyyHint => 'MM-YYYY';

  @override
  String get currentlyStudyHere => 'I currently study here';

  @override
  String get profileWorkExperienceTitle => 'Work Experience';

  @override
  String get profileWorkExperienceSubtitle =>
      'Add details about your previous roles and companies';

  @override
  String get addWorkExperience => 'Add Work Experience';

  @override
  String get editWorkExperience => 'Edit Work Experience';

  @override
  String get jobTitleLabel => 'Job Title';

  @override
  String get jobTitleHint => 'e.g. Software Engineer';

  @override
  String get companyNameLabel => 'Company Name';

  @override
  String get companyNameHint => 'e.g. Acme Corp';

  @override
  String get experienceSummaryOptional => 'Experience Summary (optional)';

  @override
  String get experienceSummaryHint => 'Describe your role and achievements...';

  @override
  String get currentlyWorkHere => 'I currently work here';

  @override
  String charactersCounter(int current, int max) {
    return '$current / $max symbols';
  }

  @override
  String get dateOfBirthLabel => 'Date of Birth';

  @override
  String get yourFirstNameHint => 'Your first name';

  @override
  String get yourLastNameHint => 'Your last name';

  @override
  String get genderLabel => 'Gender';

  @override
  String get selectGender => 'Select gender';

  @override
  String get selectCountry => 'Select country';

  @override
  String get statusLabel => 'Status';

  @override
  String get selectStatus => 'Select status';

  @override
  String get relocationReadinessLabel => 'Relocation Readiness';

  @override
  String get selectOption => 'Select option';

  @override
  String get fileExceedsLimit => 'File exceeds 5 MB limit';

  @override
  String get leaveEditingTitle => 'Leave Editing?';

  @override
  String get leaveEditingMessage =>
      'All entered information will be lost if you leave this screen.';

  @override
  String get leaveWithoutSaving => 'Leave without saving';

  @override
  String get saveAndLeave => 'Save and Leave';

  @override
  String get highLabel => 'High';

  @override
  String get genderInfoLabel => 'Gender';

  @override
  String get ageInfoLabel => 'Age';

  @override
  String get locationInfoLabel => 'Location';

  @override
  String get showFullCv => 'Show full CV';

  @override
  String get coverLetterTitle => 'Cover Letter';

  @override
  String get screeningQuestionsTitle => 'Screening Questions';

  @override
  String get aboutCompanyTitle => 'About the Company';

  @override
  String get teamTitle => 'Team';

  @override
  String get companyProfile => 'Company Profile';

  @override
  String get typeCityToSearch => 'Type city to search';

  @override
  String get experienceLevelLabel => 'Experience Level';

  @override
  String get workplaceLabel => 'Workplace';

  @override
  String get selectWorkplace => 'Select workplace';

  @override
  String get selectJobType => 'Select job type';

  @override
  String get skillsDescription =>
      'Select the skills that best represent your qualifications and professional expertise.';

  @override
  String get addSkillHint => 'Start typing to add a skill';

  @override
  String errorLoadingSkills(String error) {
    return 'Error loading skills: $error';
  }

  @override
  String chooseValuesDescription(int max) {
    return 'Choose up to $max values that best represent what matters most to you professionally.';
  }

  @override
  String get videoIntroductionTitle => 'Video Introduction';

  @override
  String get editAboutMeVideo => 'Edit About Me & Video Introduction';

  @override
  String get addAboutMeInformation => 'Add About Me Information';

  @override
  String get aboutMeEmptyDescription =>
      'Add a few words about yourself to help teams understand who you are and what you do.';

  @override
  String get addSkills => 'Add Skills';

  @override
  String get addCompetencies => 'Add Competencies';

  @override
  String get addLanguages => 'Add Languages';

  @override
  String get editLanguages => 'Edit Languages';

  @override
  String get languagesTitle => 'Languages';

  @override
  String get aboutMeEditDescription =>
      'Please provide some basic information about yourself. This helps us set up your profile and personalize your experience. You can add information later or update this anytime in Profile.';

  @override
  String get addBioDescription =>
      'Add a few words about yourself to help teams understand who you are and what you do. We recommend keeping it concise, avoiding unnecessary filler, and highlighting key skills and experience.';

  @override
  String get addVideoDescription =>
      'Add a short video to introduce yourself to teams, highlight your experience, and showcase your skills. A video helps you stand out among other candidates.';

  @override
  String get uploadViaUrl => 'Upload via URL';

  @override
  String get uploadInstructions =>
      'tap button to browse (max 10 files, up to 5 MB\neach; supported formats: .pdf, .doc, .png, .jpg)';

  @override
  String get selectCategory => 'Select category';

  @override
  String categoryLabel(String category) {
    return 'Category $category';
  }

  @override
  String get iHaveGreekLicense => 'I have Greek License';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageFieldLabel => 'Language';

  @override
  String get selectLanguageHint => 'Select language';

  @override
  String get searchLanguage => 'Search language';

  @override
  String get loadingLanguages => 'Loading languages...';

  @override
  String get noLanguagesAvailable => 'No languages available right now.';

  @override
  String get proficiencyLevel => 'Proficiency Level';

  @override
  String get addAnotherLanguage => 'Add Another Language';

  @override
  String get editJobsPreferences => 'Edit Jobs Preferences';

  @override
  String get assessmentsResultsTitle => 'Assessments results';

  @override
  String get companyTabVacancies => 'Vacancies';

  @override
  String get companyTabAboutCompany => 'About Company';

  @override
  String get companyTabEvents => 'Events';

  @override
  String get companyTabPosts => 'Posts';

  @override
  String companyJobsFound(int count) {
    return '$count jobs found';
  }

  @override
  String get companyNoVacancies => 'No open vacancies at this time.';

  @override
  String get saveJob => 'Save Job';

  @override
  String get entryLevel => 'Entry';

  @override
  String get companyPerksTitle => 'Perks & Benefits';

  @override
  String get companyGalleryTitle => 'Company Gallery';

  @override
  String get companyNoEvents => 'No upcoming events.';

  @override
  String get companyEventsTitle => 'Company Events';

  @override
  String get companyPostsTitle => 'Company Posts';

  @override
  String companyPostsFound(int count) {
    return '$count posts found';
  }

  @override
  String get companyNoPostsYet => 'No company posts yet.';

  @override
  String get shareButton => 'Share';

  @override
  String get culturalMatchScore => 'Cultural Match Score';

  @override
  String get culturalMatchDescription =>
      'You and this company both chose your top 5 values and preferences. This score shows how closely they align.';

  @override
  String get culturalMatchYouBothCareAbout => 'You both care about:';

  @override
  String companyTeamEmployees(String teamSize) {
    return '$teamSize employees';
  }

  @override
  String get companyLabelMainOffice => 'Main Office Location';

  @override
  String get companyLabelOtherLocations => 'Other Locations';

  @override
  String get companyLabelContactPhone => 'Contact Phone';

  @override
  String get companyLabelWebsite => 'Website';

  @override
  String get notAvailable => 'N/A';

  @override
  String get eventDetailsTitle => 'Event Details';

  @override
  String get eventAddressLabel => 'Address';

  @override
  String get eventRegistrationLink => 'Registration Link';

  @override
  String get companyLoadError => 'Could not load company.';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get assessmentsRecommendedForYou => 'Assessments recommended for you';

  @override
  String get assessmentYourScore => 'Your Score';

  @override
  String get assessmentLevel => 'Level';

  @override
  String get assessmentSkillBreakdown => 'Skill breakdown';

  @override
  String get assessmentKeyInsights => 'Key insights';

  @override
  String get assessmentPreviousResults => 'Previous results';

  @override
  String get assessmentYouImproving => 'You improving!';

  @override
  String get assessmentMeansForProfile => 'What this means for your profile';

  @override
  String get assessmentAboutThis => 'About this assessment';

  @override
  String get assessmentUsedFor => 'What this assessment is used for';

  @override
  String get assessmentBeforeStart => 'Before you start';

  @override
  String get assessmentApproxDuration => 'Approximate Duration';

  @override
  String get assessmentQuestionsLabel => 'Questions';

  @override
  String get bannerNotSureJob => 'Not sure how to find the right job?';

  @override
  String get chatNewChat => 'New Chat';

  @override
  String get chatSearchInChats => 'Search in Chats';

  @override
  String get chatHistory => 'Chat\'s History';

  @override
  String get homeNeedRefresher => 'Need a quick refresher?';

  @override
  String get homeCvSuccess => 'Your CV Success';

  @override
  String get homeStatViews => 'Views';

  @override
  String get homeStatInvitations => 'Invitations';

  @override
  String get homeStatApplicationsSent => 'Applications Sent';

  @override
  String get homeStatInterviews => 'Interviews';

  @override
  String get homeRecommendedCourses => 'Recommended Courses';

  @override
  String get homeLatestNews => 'Latest News';

  @override
  String get homeSmartJobRecommendations => 'Smart Job Recommendations';

  @override
  String get viewAll => 'View All';

  @override
  String get searchByJobTitle => 'Search by job title';

  @override
  String get jobLoadError => 'Could not load job.';

  @override
  String get jobRemovedFromSaved => 'Removed from saved jobs.';

  @override
  String get jobSavedMessage => 'Job has been saved! Check your saved jobs.';

  @override
  String get jobPostRemoved => 'Job post has been removed';

  @override
  String get deadlineReminderSet =>
      'Deadline Reminder has been set. We will notify you a week before the deadline';

  @override
  String get readMore => 'Read more';

  @override
  String jobPostedDate(String date) {
    return 'Posted $date';
  }

  @override
  String get jobClosedLabel => 'Closed';

  @override
  String get deadlineReminderLabel => 'Deadline Reminder';

  @override
  String get reportLabel => 'Report';

  @override
  String get reminderSetNotification =>
      'You have set a reminder for this job post';

  @override
  String get odysseaReviewLabel => 'Odyssea Review: ';

  @override
  String get recommendedForYouLabel => 'Recommended for you';

  @override
  String get tabAllJobs => 'All Jobs';

  @override
  String tabSavedJobs(int count) {
    return 'Saved ($count)';
  }

  @override
  String get sortingTitle => 'Sorting';

  @override
  String get filtersTitle => 'Filters';

  @override
  String get resetFilters => 'Reset Filters';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get filterAllLabel => 'All';

  @override
  String get filterClear => 'Clear';

  @override
  String get applyFilter => 'Apply Filter';

  @override
  String get salaryTitle => 'Salary';

  @override
  String get tillLabel => 'Till';

  @override
  String get reportJobTitle => 'Report this job?';

  @override
  String get selectReasonHint => 'Select Reason';

  @override
  String get setReminderTitle => 'Set a reminder';

  @override
  String get applicationOpenTill => 'Application open till:';

  @override
  String get whenShouldRemind => 'When should we remind you?';

  @override
  String get reminderTomorrow => 'Tomorrow';

  @override
  String get reminderTomorrowSub =>
      'Reminder will be sent at this time tomorrow';

  @override
  String get reminderOneWeek => 'In one week';

  @override
  String get reminderOneWeekSub =>
      'Reminder will be sent at this time in one week';

  @override
  String get reminderOneDayBefore => 'One day before the deadline';

  @override
  String get reminderOneDayBeforeSub =>
      'Reminder will be sent one day before the deadline';

  @override
  String get reminderCustomDate => 'Pick a custom date';

  @override
  String get reminderCustomDateSub => 'Pick a custom date for your reminder';

  @override
  String get selectDateLabel => 'Select the date';

  @override
  String get selectTimeLabel => 'Select the time';

  @override
  String get ddMmYyyyHint => 'DD-MM-YYYY';

  @override
  String reminderViaContactSub(String contact) {
    return 'We\'ll send a reminder to:\n$contact';
  }

  @override
  String get reminderViaSmsWhatsapp => 'SMS / WhatsApp';

  @override
  String get changeEmailTitle => 'Change Email';

  @override
  String get newEmailLabel => 'New Email';

  @override
  String get newEmailHint => 'Enter new email';

  @override
  String get changePasswordTitle => 'Change Password';

  @override
  String get repeatNewPasswordLabel => 'Repeat New Password';

  @override
  String get repeatNewPasswordHint => 'Repeat your new password';

  @override
  String get changePhoneTitle => 'Change Phone Number';

  @override
  String get newPhoneNumberLabel => 'New Phone Number';

  @override
  String get confirmAccountDeletion => 'Confirm Account Deletion';

  @override
  String get typeDeleteToConfirm => 'Type \'delete\' to confirm';

  @override
  String get enterDeleteHint => 'Enter \"delete\"';

  @override
  String get deleteAccountButton => 'Delete Account';

  @override
  String get makeProfileInvisible => 'Make your profile invisible?';

  @override
  String get switchToLite => 'Switch to Ithaki Lite?';

  @override
  String get verificationTitle => 'Verification';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get unsubscribe => 'Unsubscribe';

  @override
  String get noMoreJobInterests => 'No more job interests available to add.';

  @override
  String get roleMigrant => 'Migrant';

  @override
  String get roleRefugee => 'Refugee';

  @override
  String get roleAsylumSeeker => 'Asylum Seeker';

  @override
  String homeGreetingName(String name) {
    return 'Hi, $name!';
  }

  @override
  String get homeGreetingNoName => 'Hi!';

  @override
  String get homeGreetingSubtitle =>
      'Here\'s a quick overview of your latest job matches, updates, and helpful tips to move your career forward.';

  @override
  String get homeRestartProductTourSubtitle =>
      'Restart the product tour whenever you want from Home.';

  @override
  String get homeRestartProductTour => 'Restart Product Tour';

  @override
  String get homeCareerAssistantBannerSubtitle =>
      'Career Assistant can help if you\'re not sure where to start!';

  @override
  String get homeCoursesSubtitle =>
      'Boost your skills with courses that help you grow faster and stay aligned with today\'s industry standards. Learn at your own pace and strengthen the experience on your profile.';

  @override
  String get homeProfileCompleteYourProfile => 'Complete your profile';

  @override
  String get homeProfileWelcomeTitle => 'Welcome to Ithaki!';

  @override
  String get homeProfileFillMissing =>
      'Fill in the missing information to unlock your full experience on the platform. A complete profile helps you get better job matches and more invitations.';

  @override
  String get homeProfileBenefitsTitle => 'Benefits of completing your profile';

  @override
  String get homeProfileFillButton => 'Fill Profile';

  @override
  String get homeQuestionsTitle => 'Have questions?';

  @override
  String get homeQuestionsSubtitle => 'Let us help you!';

  @override
  String get homeQuestionsButton => 'Book Call with Counselor';

  @override
  String get assessmentStartNew => 'Start New Assessment';

  @override
  String assessmentsInProgressTitle(int count) {
    return 'Assessments in Progress ($count)';
  }

  @override
  String get assessmentsInProgressSubtitle =>
      'You have assessments in progress. Complete them to see your results.';

  @override
  String get assessmentsRecommendedSubtitle =>
      'We recommend these assessments to help you validate your skills.';

  @override
  String get assessmentsCompletedTitle => 'Your Completed Assessments';

  @override
  String get assessmentsCompletedSubtitle =>
      'Here are your completed assessments and results.';

  @override
  String get assessmentStartTitle => 'Start the Assessment';

  @override
  String get assessmentStartSubtitle =>
      'You are about to start the following assessment';

  @override
  String get assessmentStartNow => 'Start now';

  @override
  String get assessmentContinueTitle => 'Continue your assessment?';

  @override
  String get assessmentContinueSubtitle =>
      'You\'ve already started this assessment and have saved progress. Would you like to continue where you left off or start over?';

  @override
  String get assessmentStartOver => 'Start over';

  @override
  String get assessmentSkillBreakdownSubtitle =>
      'This breakdown shows how your results are distributed across key skill areas.';

  @override
  String get assessmentResultsConfirmSkills =>
      'This result confirms your skills, which are reflected in your job applications on the platform.';

  @override
  String get assessmentShowInCV => 'Show result in my CV';

  @override
  String get assessmentHideFromCV => 'Hide from CV';

  @override
  String assessmentTakenLabel(String date) {
    return 'Taken: $date';
  }

  @override
  String get assessmentImprovingSubtitle =>
      'Your results show steady improvement in how you approach and resolve work-related problems.';

  @override
  String get assessmentProcessingTitle => 'Processing your results!';

  @override
  String get assessmentProcessingSubtitle =>
      'You\'ve successfully completed the assessment. We\'re now generating your results — this will only take a moment.';

  @override
  String get assessmentLeaveTitle => 'Leave this page?';

  @override
  String get assessmentLeaveSubtitle =>
      'You\'re about to leave this assessment. Your progress will be saved automatically, and you can continue later.';

  @override
  String get assessmentLeaveButton => 'Leave';

  @override
  String get quizSelectOneAnswer => 'Select only one answer';

  @override
  String quizSelectUpToAnswers(int max) {
    return 'Select up to $max answers';
  }

  @override
  String get quizSelectBestReflects =>
      'Select the option that best reflects how you usually feel.';

  @override
  String get quizNoResults => 'No results found';

  @override
  String get edit => 'Edit';

  @override
  String get present => 'Present';

  @override
  String get cvCouldNotLoadTitle => 'Couldn\'t load your CV.';

  @override
  String get cvCouldNotLoadMessage =>
      'Try refreshing your profile data and open it again.';

  @override
  String get goToProfile => 'Go to Profile';

  @override
  String get publishCv => 'Publish CV';

  @override
  String get downloadCv => 'Download CV';

  @override
  String get cvDownloadSoon => 'CV download will be available soon.';

  @override
  String get returnToProfileSetup => 'Return to Profile Setup';

  @override
  String get publishedBadge => 'Published';

  @override
  String get draftModeBadge => 'Draft Mode';

  @override
  String get cvDraftReviewTitle =>
      'This is your CV - this is how companies see you.';

  @override
  String get cvDraftReviewBody =>
      'Please review all information carefully and make any necessary changes before publishing your CV.\nIf your CV is not published, companies will not be able to review it.\nYou can update your information anytime via Profile. Your CV will be updated automatically.';

  @override
  String get contactVisibilityNote =>
      'Your contact details stay hidden until you apply for a job or accept an invitation.';

  @override
  String get youBothShareSameValues => 'You both share the same values';

  @override
  String get learnMore => 'Learn More';

  @override
  String get greatJob => 'Great Job!';

  @override
  String get cvLevelLabel => 'Your CV Level:';

  @override
  String get strongLevel => 'STRONG';

  @override
  String get cvAssistantImprovementSummary =>
      'The assistant found 4 areas you can improve to increase your chances of getting a job by about 15%.';

  @override
  String get careerAssistantTitle => 'Your Career Assistant';

  @override
  String get pathfinderName => 'Pathfinder';

  @override
  String get pathfinderAdviceText =>
      'Hi! I\'m Pathfinder, your career assistant.\nI\'ve reviewed your profile and found a few quick improvements:\n\n- Critical: Your profile photo looks blurry. Upload a clear, professional one to make a stronger first impression.\n- Recommended: Add more detail to your work experience - specify what you built to show your real impact.\n- Minor: Record a short video intro. It helps teams connect with you and makes your profile stand out.\nThese small updates will noticeably boost your credibility and visibility.';

  @override
  String get askCareerPathHint => 'Ask me about your career path...';

  @override
  String get leaveWithoutPublishingTitle => 'Leave without publishing?';

  @override
  String get leaveWithoutPublishingMessage =>
      'If you leave this page, your CV will not be published and companies will not be able to review it. You can always publish it later from your profile, but we recommend publishing now to increase your chances of landing jobs.';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get workspaceLabel => 'Workspace';

  @override
  String get levelLabel => 'Level';

  @override
  String get desiredSalaryLabel => 'Desired Salary';

  @override
  String get jobPreferencesTabDescription =>
      'This shows the job you are currently looking for. You can change this anytime.';

  @override
  String get preferencesSectionTitle => 'Preferences';

  @override
  String experienceAtCompany(String role, String company) {
    return '$role  at  $company';
  }

  @override
  String educationAtInstitution(String field, String institution) {
    return '$field  at\n$institution';
  }

  @override
  String periodWithDuration(String start, String end, String duration) {
    return '$start - $end  ($duration)';
  }

  @override
  String assessmentCategoryLabel(String category) {
    return '$category Assessment';
  }

  @override
  String get jobPreferencesUpdated => 'Your job preferences have been updated.';

  @override
  String get updateButton => 'Update';

  @override
  String get currentEmailLabel => 'Current Email';

  @override
  String get updateEmailDescription => 'Update your email address';

  @override
  String get deleteAccountDescription =>
      'To permanently delete your account, please type delete in the field below.\nThis action cannot be undone - all your data will be removed forever.';

  @override
  String get communicationChannelTitle => 'Communication Channel';

  @override
  String get emailNewsletterTitle => 'Email Newsletter';

  @override
  String get emailNewsletterDescription =>
      'Stay informed and make the most of your experience! Choose which types of updates and insights you\'d like to receive directly to your inbox.';

  @override
  String get newsletterActive => '(active)';

  @override
  String get newsletterInactive => '(inactive)';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get settingsUpdatedSuccessfully => 'Settings updated successfully.';

  @override
  String get newsletterJobsTitle => 'Jobs Recommendations';

  @override
  String get newsletterJobsSubtitle =>
      'Personalized job offers based on your skills and preferences';

  @override
  String get newsletterCareerTipsTitle => 'Career Tips';

  @override
  String get newsletterCareerTipsSubtitle =>
      'Expert advice and resources to boost your professional growth';

  @override
  String get newsletterEventsTitle => 'Events & Webinars';

  @override
  String get newsletterEventsSubtitle =>
      'Upcoming career events, workshops, and networking sessions';

  @override
  String get newsletterPlatformTitle => 'Platform Updates';

  @override
  String get newsletterPlatformSubtitle =>
      'New features, tools, and product improvements';

  @override
  String get newsletterLearningTitle => 'Learning Opportunities';

  @override
  String get newsletterLearningSubtitle =>
      'Online courses and certifications to enhance your skills';

  @override
  String get uploadFilesTitle => 'Upload Files';

  @override
  String get uploadMore => 'Upload More';

  @override
  String get uploadFileInstructions =>
      'Tap button to browse\n(max 10 files, up to 5 MB each;\nsupported: .pdf, .doc, .png, .jpg)';

  @override
  String get documentUrlDescription =>
      'Provide a link to a document to import it into the system.';

  @override
  String get documentUrlMustBeActive =>
      'The link must be active and accessible without login.';

  @override
  String get documentUrlSupportedFormats =>
      'The document must be in a supported format (PDF, DOC, DOCX).';

  @override
  String get documentUrlCommonServices =>
      'Common services: Google Drive, Dropbox, iCloud.';

  @override
  String get documentLinkHint => 'Add Document\'s Link';

  @override
  String get fileComplete => 'Complete';

  @override
  String get fileUploading => 'Uploading...';

  @override
  String get fileFallbackLabel => 'FILE';

  @override
  String get profileMenuMyProfile => 'My Profile';

  @override
  String get profileMenuMyCv => 'My CV';

  @override
  String get logOut => 'Log Out';

  @override
  String get goToJobSearch => 'Go to Job Search';

  @override
  String get startProductTour => 'Start Product Tour';

  @override
  String get continueProductTour => 'Continue Product Tour';

  @override
  String get skipAndClose => 'Skip and Close';

  @override
  String get finish => 'Finish';

  @override
  String get nextButton => 'Next';

  @override
  String tourStepIndicator(int current, int total) {
    return '$current Step / $total';
  }

  @override
  String get tourReadyTitle => 'You\'re Ready!';

  @override
  String get tourReadyBody =>
      'Now you know the main platform features. Complete your profile, take assessments, and apply for jobs that match you.';

  @override
  String get tourWelcomeTitle => 'Let\'s Get You Started!';

  @override
  String get tourWelcomeBody =>
      'Here you can find a job that fits your skills and experience. Let\'s go step by step.';

  @override
  String get tourSkipTitle => 'Skip for now?';

  @override
  String get tourSkipBody =>
      'You can always take the product tour later using the banner on the Home page.';

  @override
  String get tourStep1Title => 'Get on Track!';

  @override
  String get tourStep1Body =>
      'Here you\'ll see jobs and courses selected for you, CV insights, and tools to help you start your job search.';

  @override
  String get tourStep2Title => 'Find a Job';

  @override
  String get tourStep2Body =>
      'Search for jobs by name or choose from categories below. You can find work near your city, or set other parameters to find the job you need.';

  @override
  String get tourStep3Title => 'Job Post';

  @override
  String get tourStep3Body =>
      'Each job card shows the main information - position, location, and salary. Tap the card to open full details and apply.';

  @override
  String get tourStep4Title => 'See how well this job fits for you';

  @override
  String get tourStep4Body =>
      'This part shows how well your experience and skills match the job. The higher the match, the better your chances.';

  @override
  String get tourStep5Title => 'Job Details';

  @override
  String get tourStep5Body =>
      'Read the full job description, requirements, and what the company offers before you apply.';

  @override
  String get tourStep6Title => 'Easy to Apply';

  @override
  String get tourStep6Body =>
      'Application is easy! Select your CV format and add a few words about yourself in the Cover Letter to increase your chances.';

  @override
  String get tourStep7Title => 'Track the Progress';

  @override
  String get tourStep7Body =>
      'Once you apply for a job, you can find your response in My Applications.';

  @override
  String get tourStep8Title => 'My Invitations';

  @override
  String get tourStep8Body =>
      'Companies can invite you directly. You can review relevant invitations from teams interested in your profile.';

  @override
  String get tourStep9Title => 'Get on Track!';

  @override
  String get tourStep9Body =>
      'You can open the invitation to read job details and accept the offer.';

  @override
  String get tourStep10Title => 'Build your Profile';

  @override
  String get tourStep10Body =>
      'Your profile shows your experience, skills, and contact info. A complete profile helps you get better job matches. You can edit or update it anytime.';

  @override
  String get tourStep11Title => 'Meet your Career Assistant';

  @override
  String get tourStep11Body =>
      'Pathfinder can help you improve your profile, find the right jobs, and answer your questions about work.';

  @override
  String get tourStep12Title => 'Learning Hub';

  @override
  String get tourStep12Body =>
      'Access courses and resources tailored to your career goals and the skills companies are looking for.';

  @override
  String get tourStep13Title => 'Get to know yourself better';

  @override
  String get tourStep13Body =>
      'Here you can take different assessments. Your results help highlight your strengths and working style.';

  @override
  String get changePasswordDescription =>
      'Change your password to keep your account secure';

  @override
  String get passwordUpdated => 'Your password has been updated.';

  @override
  String get currentPhoneNumberLabel => 'Current Phone Number';

  @override
  String get makeProfileInvisibleDescription =>
      'If you make your profile invisible, companies won\'t be able to find you in candidate searches. You\'ll still be able to apply for jobs you\'re interested in. You can change your profile visibility anytime in your account settings.';

  @override
  String get makeProfileInvisibleButton => 'Make Profile Invisible';

  @override
  String get switchLiteDescription =>
      'The interface will become simpler and easier to use. We\'ll show you only the jobs that best match your job interests.\nYou can switch back to the full interface at any time.';

  @override
  String get switchLiteButton => 'Switch to Ithaki Lite';

  @override
  String get switchedToLite => 'Switched to Ithaki Lite.';

  @override
  String get submit => 'Submit';

  @override
  String newValueLabel(String type) {
    return 'New $type';
  }

  @override
  String codeSentToContact(String contact) {
    return 'A 6-digit code was sent to your $contact.';
  }

  @override
  String get phoneViaSms => 'phone via SMS';

  @override
  String get changedEmail => 'Your email has been changed.';

  @override
  String get changedPhone => 'Your phone number has been changed.';

  @override
  String get jobReportedMessage => 'Job post has been reported';

  @override
  String get copyLink => 'Copy Link';

  @override
  String get shareWhatsappSms => 'Share WhatsApp/SMS';

  @override
  String get shareInEmail => 'Share in Email';

  @override
  String get shareOnLinkedIn => 'Share on LinkedIn';

  @override
  String get industryLabel => 'Industry';

  @override
  String get travelLabel => 'Travel';

  @override
  String get reportJobDescription =>
      'Reporting jobs helps us keep job postings at the highest quality levels.';

  @override
  String get tellUsMoreOptional => 'Tell us more (optional)';

  @override
  String get reportThisJobButton => 'Report this Job';

  @override
  String get setReminderButton => 'Set Reminder';

  @override
  String get reminderChoiceTitle => 'How would you like to be reminded?';

  @override
  String get reminderViaEmail => 'We\'ll send a reminder via email';

  @override
  String get reminderViaSmsWhatsappGeneric =>
      'We\'ll send a reminder via SMS/WhatsApp';

  @override
  String get jobClosedButton => 'Job Closed';

  @override
  String get removeFromSaved => 'Remove from Saved';

  @override
  String get newFeatureBanner =>
      'New on Ithaki! We just released a new feature that makes job search easier.';

  @override
  String get curiousWhyMatch => 'Curious why you match this job?';

  @override
  String get strongSkillsMatch => 'It\'s a Strong skills\nMatch!';

  @override
  String get goodSkillsMatch => 'It\'s a Good skills\nMatch!';

  @override
  String get partialSkillsMatch => 'It\'s a Partial skills\nMatch!';

  @override
  String get starterSkillsMatch => 'It\'s a Starter skills\nMatch!';

  @override
  String get deadlineBannerText =>
      'This job has a deadline! Application\nopen till:';

  @override
  String get skillsRequired => 'Skills required';

  @override
  String get aboutRoleTitle => 'About the role';

  @override
  String get requirementsTitle => 'Requirements';

  @override
  String get niceToHaveTitle => 'Nice to have';

  @override
  String get weOfferTitle => 'We offer';

  @override
  String get shareJob => 'Share Job';

  @override
  String get notInterested => 'Not Interested';

  @override
  String get deleteReminder => 'Delete Reminder';

  @override
  String get salaryRangeLabel => 'Salary Range';

  @override
  String get responsibilitiesTitle => 'Responsibilities';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get assessmentNotFound => 'Assessment not found';

  @override
  String get testDetails => 'Test Details';

  @override
  String get startTest => 'Start Test';

  @override
  String get viewDetails => 'View Details';

  @override
  String get inCv => 'In CV';

  @override
  String get showInCv => 'Show in CV';

  @override
  String questionsCount(int count) {
    return '$count questions';
  }

  @override
  String durationMinutes(int count) {
    return '$count min';
  }

  @override
  String rangeNumberSubtitle(
      int min, int max, String minLabel, String maxLabel) {
    return 'Select a number from $min to $max, where $min means \"$minLabel\" and $max means \"$maxLabel\".';
  }

  @override
  String get addJobInterestTitle => 'Add Job Interest';

  @override
  String get searchCityTitle => 'Search City';

  @override
  String get typeCityHint => 'Type a city name...';

  @override
  String get citySearchTypeMore => 'Type at least 2 characters';

  @override
  String get citySearchNoResults => 'No cities found';

  @override
  String get photoFileLimit => '5 MB max · PNG or JPG';

  @override
  String get photoRecommendation =>
      'We recommend a professional photo that clearly shows your face.';

  @override
  String get uploadPhoto => 'Upload Photo';

  @override
  String get replacePhoto => 'Replace Photo';

  @override
  String get screeningQuestionsSubtitle =>
      'Here are your answers to a few questions from the employer';

  @override
  String get toJobDetails => 'To Job Details';

  @override
  String get whatWeOfferTitle => 'What we offer';

  @override
  String get employeeReviewsTitle => 'Employee Reviews';

  @override
  String get applyButton => 'Apply';

  @override
  String get shareLabel => 'Share:';

  @override
  String get readArticle => 'Read Article';

  @override
  String get chatGetStartedHint => 'You can get started with an example below';

  @override
  String get chatWithCareerAssistant => 'Chat with your\nCareer Assistant';

  @override
  String get chatHistorySubtitle =>
      'You can search across all your previous chats by keywords or phrases.';

  @override
  String get chatHistorySearchHint =>
      'Type a word or phrase to find messages...';

  @override
  String get chatHistoryToday => 'Today';

  @override
  String get chatHistoryLast7Days => 'Last 7 days';

  @override
  String get chatThinking => 'Thinking...';

  @override
  String get chatSearchMessagesHint => 'Search messages...';

  @override
  String get culturalFitLabel => 'Cultural Fit';

  @override
  String savedJobsCountLabel(String count) {
    return '$count saved jobs';
  }

  @override
  String jobsFoundLabel(String count) {
    return '$count jobs found';
  }

  @override
  String get noSavedJobsYet => 'No saved jobs yet.';

  @override
  String get notificationsLabel => 'Notifications';

  @override
  String get notificationsScreenSubtitle =>
      'Here you can see all your news. Stay up to date with important updates.';

  @override
  String notificationsUnreadCount(int count) {
    return 'You have $count new notifications';
  }

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get accountInformationTitle => 'Account Information';

  @override
  String get accountInformationSubtitle =>
      'Manage your account details to keep your account secure and up to date.';

  @override
  String get profileVisibilityTitle => 'Profile Visibility';

  @override
  String get profileVisibleForEmployers => 'Profile Visible for Employers';

  @override
  String get profileHiddenFromEmployers => 'Profile Hidden from Employers';

  @override
  String get profileVisibilityDescription =>
      'Right now, employers can view your profile and send you invitations. If you prefer more privacy, you can hide your profile — it will only be visible when you apply to a job.';

  @override
  String get hideProfileFromEmployers => 'Hide Profile from Employers';

  @override
  String get showProfileToEmployers => 'Show Profile to Employers';

  @override
  String get digitalComfortTitle => 'Digital Comfort';

  @override
  String get digitalComfortExperienced => 'You are experienced tech user';

  @override
  String get digitalComfortDescription =>
      'You\'re using our full experience right now — perfect for confident tech users. If you ever want a simpler, easier interface, you can switch to the light version whenever you like.';

  @override
  String get tryIthakiLite => 'Try Ithaki Lite';

  @override
  String get deleteAnAccount => 'Delete an Account';

  @override
  String get deleteAccountTabDescription =>
      'Permanently remove your account and all related data from the system. This action cannot be undone.';

  @override
  String get jobInterestsStillLoading =>
      'Job interests are still loading. Try again in a moment.';

  @override
  String get failedToLoadJobInterests => 'Failed to load job interests.';

  @override
  String get relocationNegative => 'Not willing to relocate';

  @override
  String get relocationLocally => 'Willing to relocate locally';

  @override
  String get relocationNationally => 'Willing to relocate nationally';

  @override
  String get relocationInternationally => 'Willing to relocate internationally';
}
