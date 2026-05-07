// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'Ithaki';

  @override
  String get loginAction => 'Σύνδεση';

  @override
  String get signUpAction => 'Εγγραφή';

  @override
  String get continueButton => 'Συνέχεια';

  @override
  String get skipButton => 'Παράλειψη';

  @override
  String get backButton => 'Πίσω';

  @override
  String get goBack => 'Επιστροφή';

  @override
  String get welcomeHeading =>
      'Καλώς ήρθατε στο Ithaki!\nΑς δημιουργήσουμε έναν Λογαριασμό!';

  @override
  String get selectLanguageTitle => 'Επιλέξτε τη Γλώσσα σας';

  @override
  String get selectLanguageDescription =>
      'Μπορείτε να αλλάξετε τη γλώσσα διεπαφής ανά πάσα στιγμή. Όλο το περιεχόμενο, συμπεριλαμβανομένης της περιγραφής εργασίας, του βιογραφικού σας και της επικοινωνίας με συμβούλους και το chatbot, θα είναι στα Αγγλικά.';

  @override
  String get languageLabel => 'Γλώσσα';

  @override
  String get selectLanguagePlaceholder => 'Επιλέξτε τη γλώσσα σας';

  @override
  String get techComfortTitle => 'Πόσο άνετα νιώθετε με την τεχνολογία;';

  @override
  String get techComfortDescription =>
      'Θα χρησιμοποιήσουμε την απάντησή σας για να κάνουμε την πλατφόρμα πιο άνετη για εσάς.';

  @override
  String get techExperiencedLabel => 'Είμαι Έμπειρος/η';

  @override
  String get techExperiencedSubtitle =>
      'Νιώθω άνετα χρησιμοποιώντας ψηφιακά εργαλεία και μου αρέσει να εξερευνώ νέες τεχνολογίες';

  @override
  String get techNewLabel => 'Είμαι ακόμα νέος/α σε αυτό';

  @override
  String get techNewSubtitle =>
      'Δεν μου αρέσουν τα πολύπλοκα εργαλεία - προτιμώ όταν η τεχνολογία απλά λειτουργεί ομαλά';

  @override
  String get signInWithGoogle => 'Σύνδεση με Google';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'Εισάγετε το email σας';

  @override
  String get passwordLabel => 'Κωδικός';

  @override
  String get passwordHint => 'Εισάγετε τον κωδικό σας';

  @override
  String get confirmPasswordLabel => 'Επιβεβαίωση Κωδικού';

  @override
  String get confirmPasswordHint => 'Επαναλάβετε τον κωδικό σας';

  @override
  String get passwordUpperLower =>
      'Περιλαμβάνει ένα κεφαλαίο και ένα πεζό γράμμα';

  @override
  String get passwordMinLength => 'Τουλάχιστον 8 χαρακτήρες';

  @override
  String get passwordNumber => 'Περιλαμβάνει τουλάχιστον έναν αριθμό';

  @override
  String get passwordSpecial =>
      'Περιλαμβάνει έναν ειδικό χαρακτήρα (όπως !@#\$%^&)';

  @override
  String get passwordsDoNotMatch => 'Οι κωδικοί δεν ταιριάζουν';

  @override
  String get termsText =>
      'Συνεχίζοντας, αναγνωρίζετε ότι έχετε διαβάσει και αποδεχτεί την ';

  @override
  String get privacyPolicy => 'Πολιτική Απορρήτου';

  @override
  String get andText => ' και τους ';

  @override
  String get termsOfUse => 'Όρους Χρήσης';

  @override
  String get personalDetailsHeading => 'Σχεδόν έτοιμο!\nΠείτε μας για εσάς';

  @override
  String get personalDetailsDescription =>
      'Το όνομά σας και ο αριθμός τηλεφώνου βοηθούν τους εργοδότες να επικοινωνήσουν μαζί σας απευθείας.';

  @override
  String get nameLabel => 'Όνομα';

  @override
  String get nameHint => 'Εισάγετε το Όνομά σας';

  @override
  String get lastNameLabel => 'Επώνυμο';

  @override
  String get lastNameHint => 'Εισάγετε το Επώνυμό σας';

  @override
  String get verifyEmailHeading => 'Επαληθεύστε τη διεύθυνση email σας';

  @override
  String get verifyEmailDescription =>
      'Στείλαμε έναν σύνδεσμο επαλήθευσης στη διεύθυνση email σας.\nΕλέγξτε τα εισερχόμενά σας και ακολουθήστε τον σύνδεσμο για να ολοκληρώσετε τη ρύθμιση του λογαριασμού σας.';

  @override
  String get verifyEmailSpamHint =>
      'Δεν λάβατε το email; Ελέγξτε τον φάκελο ανεπιθύμητης αλληλογραφίας ή στείλτε το ξανά.';

  @override
  String get verifiedEmailButton => 'Έχω επαληθεύσει το email μου';

  @override
  String get resendEmailLabel => 'Αποστολή συνδέσμου ξανά μέσω email';

  @override
  String get verifyPhoneHeading => 'Επαληθεύστε τον αριθμό τηλεφώνου σας';

  @override
  String get verifyPhoneDescription =>
      'Θα στείλουμε έναν κωδικό επαλήθευσης στο τηλέφωνό σας. Επιλέξτε πώς θέλετε να τον λάβετε.';

  @override
  String get selectMethodTitle => 'Επιλέξτε μέθοδο λήψης του κωδικού';

  @override
  String get sendViaSms => 'Αποστολή ασφαλούς κωδικού μέσω SMS';

  @override
  String get sendViaWhatsapp => 'Αποστολή ασφαλούς κωδικού μέσω WhatsApp';

  @override
  String get rememberChoice => 'Απομνημόνευση της επιλογής μου';

  @override
  String get verifyAccountTitle => 'Ας επαληθεύσουμε τον Λογαριασμό σας';

  @override
  String get verifyAccountSubtitle =>
      'Στείλαμε έναν κωδικό επαλήθευσης στον αριθμό τηλεφώνου σας.';

  @override
  String get notYourPhone => 'Δεν είναι το τηλέφωνό σας;';

  @override
  String get resendCode => 'Αποστολή κωδικού ξανά';

  @override
  String get loginHeading => 'Σύνδεση στο Ithaki Talent';

  @override
  String get loginSubtitle =>
      'Εισάγετε τον αριθμό τηλεφώνου σας. Θα σας στείλουμε κωδικό μέσω SMS.';

  @override
  String loginVerifySubtitle(String phone) {
    return 'Στείλαμε έναν κωδικό επαλήθευσης στο $phone.';
  }

  @override
  String get rememberMe => 'Να με θυμάσαι';

  @override
  String get sendCodeButton => 'Αποστολή Κωδικού';

  @override
  String get signInWithEmail => 'Σύνδεση με Email';

  @override
  String get preferEmail => 'Προτιμάτε email; Μπορείτε να συνδεθείτε με email.';

  @override
  String get signInWithPhone => 'Σύνδεση με Τηλέφωνο';

  @override
  String get preferPhone =>
      'Προτιμάτε τηλέφωνο; Μπορείτε να συνδεθείτε με τηλέφωνο.';

  @override
  String get signInButton => 'Σύνδεση';

  @override
  String get forgotPassword => 'Ξεχάσατε τον κωδικό σας;';

  @override
  String get forgotPasswordHeading => 'Ξεχάσατε τον κωδικό σας';

  @override
  String get forgotPasswordDescription =>
      'Μην ανησυχείτε. Εισάγετε τη διεύθυνση email του λογαριασμού σας και θα σας στείλουμε έναν σύνδεσμο για να επαναφέρετε τον κωδικό σας.';

  @override
  String get backToLogin => 'Επιστροφή στη Σύνδεση';

  @override
  String get sendResetLink => 'Αποστολή συνδέσμου';

  @override
  String get resetLinkSentHeading => 'Ο σύνδεσμος επαναφοράς στάλθηκε!';

  @override
  String get resetLinkSentDescription =>
      'Ελέγξτε τα εισερχόμενά σας. Το email περιλαμβάνει έναν ασφαλή σύνδεσμο για τη δημιουργία νέου κωδικού. Δεν λάβατε το email;';

  @override
  String get resendResetLinkEmail => 'Αποστολή συνδέσμου ξανά μέσω email';

  @override
  String get sendResetViaWhatsapp => 'Αποστολή ασφαλούς κωδικού μέσω WhatsApp';

  @override
  String get resetPasswordHeading => 'Επαναφορά κωδικού';

  @override
  String get resetPasswordDescription =>
      'Τελευταίο βήμα. Δημιουργήστε έναν νέο κωδικό για να ασφαλίσετε τον λογαριασμό σας.';

  @override
  String get newPasswordLabel => 'Νέος Κωδικός';

  @override
  String get newPasswordHint => 'Εισάγετε τον νέο κωδικό σας';

  @override
  String get confirmNewPasswordLabel => 'Επιβεβαίωση νέου Κωδικού';

  @override
  String get confirmNewPasswordHint => 'Εισάγετε τον νέο κωδικό σας';

  @override
  String get resetPasswordButton => 'Επαναφορά Κωδικού';

  @override
  String get welcomeModalHeading =>
      'Καλώς ήρθατε!\nΟ λογαριασμός σας δημιουργήθηκε και επαληθεύτηκε!';

  @override
  String get welcomeModalDescription =>
      'Ας κάνουμε μια σύντομη ρύθμιση για να σας ταιριάξουμε με τις καλύτερες επιλογές εργασίας.';

  @override
  String get skipForNow => 'Παράλειψη Προς Τώρα';

  @override
  String get startSetup => 'Έναρξη Ρύθμισης';

  @override
  String get ithakiLogo => 'Ithaki-logo';

  @override
  String get stepLocation => 'Τοποθεσία';

  @override
  String get stepJobInterests => 'Ενδιαφέροντα';

  @override
  String get stepPreferences => 'Προτιμήσεις';

  @override
  String get stepValues => 'Αξίες';

  @override
  String get stepCommunication => 'Επικοινωνία';

  @override
  String get locationHeading => 'Τοποθεσία';

  @override
  String get locationDescription =>
      'Επιλέξτε τοποθεσία για να περιορίσετε τις σχετικές ευκαιρίες εργασίας.';

  @override
  String get citizenshipLabel => 'Υπηκοότητα';

  @override
  String get citizenshipHint => 'Επιλέξτε χώρα ή πληκτρολογήστε για αναζήτηση';

  @override
  String get residenceLabel => 'Κατοικία';

  @override
  String get residenceHint => 'Επιλέξτε χώρα ή πληκτρολογήστε για αναζήτηση';

  @override
  String get workAuthorizationLabel => 'Άδεια Εργασίας';

  @override
  String get workAuthorizationHint => 'Επιλέξτε την κατάστασή σας';

  @override
  String get relocationLabel => 'Ετοιμότητα Μετεγκατάστασης';

  @override
  String get relocationHint => 'Επιλέξτε την προτίμησή σας για μετεγκατάσταση';

  @override
  String get roleCitizen => 'Πολίτης';

  @override
  String get roleResident => 'Κάτοικος';

  @override
  String get roleWorkPermit => 'Άδεια Εργασίας';

  @override
  String get roleStudent => 'Φοιτητής';

  @override
  String get roleFreelancer => 'Ελεύθερος Επαγγελματίας';

  @override
  String get roleJobSeeker => 'Αναζητών Εργασία';

  @override
  String get roleExpat => 'Εκπατρισμένος';

  @override
  String get relocationYes => 'Ναι, έτοιμος/η για μετεγκατάσταση';

  @override
  String get relocationNo => 'Όχι, δεν ψάχνω μετεγκατάσταση';

  @override
  String get relocationOpen => 'Ανοιχτός/ή σε αυτό';

  @override
  String get relocationRemote => 'Μόνο εξ αποστάσεως';

  @override
  String get relocationWithinCountry => 'Μόνο εντός της χώρας μου';

  @override
  String get jobInterestsHeading => 'Ενδιαφέροντα Εργασίας';

  @override
  String get jobInterestsDescription =>
      'Επιλέξτε τύπους εργασίας ή τομείς που ταιριάζουν με τα επαγγελματικά σας ενδιαφέροντα. Μπορείτε να προσθέσετε έως 5 διαφορετικούς τομείς.';

  @override
  String get searchJobInterest => 'Αναζήτηση και προσθήκη ενδιαφέροντος';

  @override
  String get addAnotherJobInterest => 'Προσθήκη Άλλου Ενδιαφέροντος';

  @override
  String get selectJobInterest => 'Επιλογή Ενδιαφέροντος Εργασίας';

  @override
  String get preferencesHeading => 'Προτιμήσεις Εργασίας';

  @override
  String get preferencesDescription =>
      'Ορίστε τον επιθυμητό μισθό, το επίπεδο θέσης, τον τύπο σύμβασης και τη μορφή εργασίας (εξ αποστάσεως, επιτόπια ή υβριδική) για να σας ταιριάξουμε με τις πιο σχετικές ευκαιρίες.';

  @override
  String get positionLevelLabel => 'Επίπεδο Θέσης';

  @override
  String get positionLevelHint => 'Επιλέξτε το επίπεδο θέσης σας';

  @override
  String get jobTypeTitle => 'Τύπος Εργασίας';

  @override
  String get jobTypeDescription =>
      'Επιλέξτε τους τύπους απασχόλησης που σας ενδιαφέρουν. Μπορείτε να επιλέξετε περισσότερες από μία επιλογές.';

  @override
  String get workplaceFormatTitle => 'Μορφή Εργασίας';

  @override
  String get workplaceFormatDescription =>
      'Επιλέξτε τις προτιμώμενες μορφές εργασίας σας. Μπορείτε να επιλέξετε περισσότερες από μία επιλογές.';

  @override
  String get positionIntern => 'Ασκούμενος';

  @override
  String get positionJunior => 'Junior';

  @override
  String get positionMid => 'Μεσαίο Επίπεδο';

  @override
  String get positionSenior => 'Senior';

  @override
  String get positionLead => 'Lead';

  @override
  String get positionManager => 'Διευθυντής';

  @override
  String get positionDirector => 'Διευθύνων';

  @override
  String get jobFullTime => 'Πλήρης Απασχόληση';

  @override
  String get jobPartTime => 'Μερική Απασχόληση';

  @override
  String get jobContract => 'Σύμβαση';

  @override
  String get jobFreelance => 'Ελεύθερος Επαγγελματίας';

  @override
  String get jobInternship => 'Πρακτική Άσκηση';

  @override
  String get workOnSite => 'Επιτόπια';

  @override
  String get workRemote => 'Εξ αποστάσεως';

  @override
  String get workHybrid => 'Υβριδική';

  @override
  String get payMonthly => 'Μηνιαία';

  @override
  String get payWeekly => 'Εβδομαδιαία';

  @override
  String get payYearly => 'Ετήσια';

  @override
  String get payHourly => 'Ωριαία';

  @override
  String get payDaily => 'Ημερήσια';

  @override
  String get valuesHeading => 'Αξίες';

  @override
  String valuesDescription(int max) {
    return 'Επιλέξτε τις αξίες που σας αντιπροσωπεύουν περισσότερο. Μπορείτε να επιλέξετε έως $max.';
  }

  @override
  String get valueIntegrity => 'Ακεραιότητα';

  @override
  String get valueResponsibility => 'Υπευθυνότητα';

  @override
  String get valueTeamwork => 'Ομαδική Εργασία';

  @override
  String get valueRespect => 'Σεβασμός';

  @override
  String get valueGrowth => 'Ανάπτυξη & Μάθηση';

  @override
  String get valueInnovation => 'Καινοτομία';

  @override
  String get valueCreativity => 'Δημιουργικότητα';

  @override
  String get valueTransparency => 'Διαφάνεια';

  @override
  String get valueEmpathy => 'Ενσυναίσθηση';

  @override
  String get valueAccountability => 'Λογοδοσία';

  @override
  String get valueWorkLifeBalance => 'Ισορροπία Εργασίας-Ζωής';

  @override
  String get valueOpenCommunication => 'Ανοιχτή Επικοινωνία';

  @override
  String get valueReliability => 'Αξιοπιστία';

  @override
  String get valueAdaptability => 'Προσαρμοστικότητα';

  @override
  String get valueProblemSolving => 'Επίλυση Προβλημάτων';

  @override
  String get valueOwnership => 'Ιδιοκτησία';

  @override
  String get valueCustomerFocus => 'Εστίαση στον Πελάτη';

  @override
  String get valueAmbition => 'Φιλοδοξία';

  @override
  String get valueInitiative => 'Πρωτοβουλία';

  @override
  String get valueCollaboration => 'Συνεργασία';

  @override
  String get communicationHeading => 'Επικοινωνία';

  @override
  String get communicationDescription =>
      'Επιλέξτε κανάλι για να λαμβάνετε ειδοποιήσεις σχετικά με νέες σχετικές θέσεις εργασίας και απαντήσεις σε υποβληθείσες αιτήσεις. Μπορείτε να επιλέξετε πολλαπλές επιλογές και να τις αλλάξετε ανά πάσα στιγμή.';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get sms => 'SMS';

  @override
  String get email => 'Email';

  @override
  String get receiveTips =>
      'Λήψη συμβουλών για ευκαιρίες εργασίας, πληροφορίες για μαθήματα και επερχόμενες εκδηλώσεις.';

  @override
  String get finishSetup => 'Ολοκλήρωση Ρύθμισης';

  @override
  String get searchHint => 'Αναζήτηση...';

  @override
  String get selectAction => 'Επιλογή';

  @override
  String get expectedPaymentLabel => 'Αναμενόμενη Αμοιβή';

  @override
  String get fromLabel => 'Από';

  @override
  String get paymentTermTitle => 'Περίοδος Πληρωμής';

  @override
  String get paymentTermPlaceholder => 'Μηνιαία';

  @override
  String get currencySymbol => '€';

  @override
  String get preferNotToSpecify => 'Προτιμώ να μην προσδιορίσω';

  @override
  String get selectCountryTitle => 'Επιλογή Χώρας';

  @override
  String get phoneValidationError => 'Παρακαλώ εισάγετε σωστό αριθμό τηλεφώνου';

  @override
  String get phoneNumberLabel => 'Αριθμός Τηλεφώνου';

  @override
  String get myApplicationsTabLabel => 'Οι Αιτήσεις μου';

  @override
  String get myApplicationsTabDescription =>
      'Παρακολούθησε όλες τις θέσεις για τις οποίες έχεις κάνει αίτηση και δες την τρέχουσα κατάστασή τους. Μπορείς επίσης να βρεις παλιές αιτήσεις στο αρχείο σου.';

  @override
  String get myApplicationsLoadError => 'Αποτυχία φόρτωσης αιτήσεων.';

  @override
  String get myApplicationsEmptyTitle => 'Δεν υπάρχουν αιτήσεις ακόμη';

  @override
  String get myApplicationsEmptySubtitle =>
      'Θέσεις που κάνεις αίτηση θα εμφανιστούν εδώ\nώστε να παρακολουθείς την πορεία τους.';

  @override
  String myInvitationsTabLabel(int count) {
    return 'Οι Προσκλήσεις μου ($count)';
  }

  @override
  String get draftsTabLabel => 'Πρόχειρα';

  @override
  String get archiveTabLabel => 'Αρχείο';

  @override
  String get invitationsTabDescription =>
      'Εδώ θα βρεις ευκαιρίες εργασίας στις οποίες έχεις προσκληθεί. Εξέτασε προσκλήσεις από εργοδότες που βρήκαν το προφίλ σου ενδιαφέρον.';

  @override
  String get invitationsLoadError => 'Αποτυχία φόρτωσης προσκλήσεων.';

  @override
  String get invitationsEmptyTitle => 'Δεν υπάρχουν ακόμη προσκλήσεις';

  @override
  String get invitationsEmptySubtitle =>
      'Όταν εργοδότες βρουν το προφίλ σου ενδιαφέρον\nθα σε προσκαλέσουν εδώ.';

  @override
  String get draftsTabDescription =>
      'Εδώ θα βρεις αιτήσεις που ξεκίνησες αλλά δεν υπέβαλες. Συνέχισε από εκεί που σταμάτησες ή διέγραψέ τις.';

  @override
  String get draftsLoadError => 'Αποτυχία φόρτωσης πρόχειρων.';

  @override
  String get draftsEmptyTitle => 'Δεν υπάρχουν πρόχειρα';

  @override
  String get draftsEmptySubtitle =>
      'Αιτήσεις που ξεκινάς αλλά δεν υποβάλλεις\nθα εμφανιστούν εδώ.';

  @override
  String get archiveTabDescription =>
      'Εδώ θα βρεις όλες τις απορριφθείσες προσκλήσεις και τις κλειστές αιτήσεις. Αποθηκεύονται για αναφορά.';

  @override
  String get archiveEmptyTitle => 'Το αρχείο σου είναι άδειο';

  @override
  String get archiveEmptySubtitle =>
      'Απορριφθείσες προσκλήσεις και κλειστές αιτήσεις\nθα αποθηκευτούν εδώ.';

  @override
  String get invitationDeclinedLabel => 'Η πρόσκληση απορρίφθηκε';

  @override
  String get viewJobDetails => 'View Job Details';

  @override
  String get dismissInvite => 'Απόρριψη Πρόσκλησης';

  @override
  String get declinedConfirmed => 'Απορρίφθηκε';

  @override
  String get viewJob => 'Δες Θέση';

  @override
  String get dismissBannerTitle => 'Η πρόσκληση θα μεταφερθεί στο Αρχείο';

  @override
  String get dismissBannerCountdown => 'Επιβεβαιώνεται σε 5 δευτερόλεπτα';

  @override
  String get undo => 'Αναίρεση';

  @override
  String get invitationDismissedToast =>
      'Η πρόσκληση απορρίφθηκε και μεταφέρθηκε στο Αρχείο';

  @override
  String get invitationDeclinedToast =>
      'Η πρόσκληση απορρίφθηκε και μεταφέρθηκε στο Αρχείο';

  @override
  String get careerAssistantBannerTitle =>
      'Δεν ξέρεις τι να κάνεις στη συνέχεια;';

  @override
  String get careerAssistantBannerSubtitle =>
      'Κατά μέσο όρο, οι εργοδότες εξετάζουν αιτήσεις μέσα στην πρώτη εβδομάδα. Μπορείς πάντα να με ρωτήσεις για βοήθεια.';

  @override
  String get askCareerAssistant => 'Ρώτα τον Career Assistant';

  @override
  String get blogNewsTitle => 'Blog & Νέα';

  @override
  String get blogNewsSubtitle =>
      'Ανακαλύψτε συμβουλές καριέρας, οδηγούς συνεντεύξεων και νέα της πλατφόρμας.';

  @override
  String get blogSearchHint => 'Αναζήτηση άρθρων και θεμάτων';

  @override
  String get blogAllCategories => 'Όλα';

  @override
  String get blogRelatedArticles => 'Σχετικά Άρθρα';

  @override
  String get blogDiscoverAll => 'Ανακαλύψτε Όλα τα Νέα';

  @override
  String get blogArticleNotFound => 'Το άρθρο δεν βρέθηκε.';

  @override
  String blogArticleBy(String author) {
    return 'Από $author';
  }

  @override
  String get cardAppliedWithCv => 'Υπέβαλες αίτηση με το Ithaki CV σου';

  @override
  String get cardJobClosed => 'Η θέση έχει κλείσει.';

  @override
  String get continueApplication => 'Συνέχεια';

  @override
  String get viewApplication => 'Δες Αίτηση';

  @override
  String get applySheetTitle => 'Έτοιμος/η να κάνεις αίτηση για αυτή τη θέση;';

  @override
  String get applySheetSubtitle =>
      'Βεβαιώσου ότι τα στοιχεία του προφίλ σου είναι ενημερωμένα πριν υποβάλεις την αίτησή σου. Μπορείς επίσης να ανεβάσεις το βιογραφικό σου.';

  @override
  String get applyOptionIthakiCvTitle => 'Χρήση Ithaki CV';

  @override
  String get applyOptionIthakiCvSubtitle =>
      'Χρησιμοποίησε το αποθηκευμένο CV και τα στοιχεία προφίλ σου για να υποβάλεις αίτηση.';

  @override
  String get applyOptionUploadTitle => 'Ανέβασε το CV σου';

  @override
  String get applyOptionUploadSubtitle =>
      'Ανέβασε νέο αρχείο (PDF ή DOC) για να υποβάλεις αίτηση.';

  @override
  String get applyNow => 'Υποβολή Αίτησης';

  @override
  String get declineSheetTitle => 'Απόρριψη Πρόσκλησης';

  @override
  String get declineSheetSubtitle =>
      'Είσαι σίγουρος/η ότι θέλεις να απορρίψεις αυτή την πρόσκληση;';

  @override
  String get declineReasonLabel => 'Παρακαλώ επίλεξε έναν λόγο';

  @override
  String get declineReasonHint => 'Επίλεξε λόγο';

  @override
  String get declineReasonNotInterested => 'Δεν ενδιαφέρομαι για αυτή τη θέση';

  @override
  String get declineReasonFoundJob => 'Βρήκα ήδη δουλειά';

  @override
  String get declineReasonSalary =>
      'Ο μισθός δεν αντιστοιχεί στις προσδοκίες μου';

  @override
  String get declineReasonLocation => 'Η τοποθεσία δεν με εξυπηρετεί';

  @override
  String get declineReasonOther => 'Άλλο';

  @override
  String get declineButton => 'Απόρριψη Πρόσκλησης';

  @override
  String get declinedButton => '✓  Απορρίφθηκε';

  @override
  String get jobDetailNotFoundMessage =>
      'Δεν βρέθηκαν λεπτομέρειες για αυτή την αίτηση ακόμα.';

  @override
  String get backToApplications => 'Επιστροφή στις Αιτήσεις';

  @override
  String get acceptInviteAndApply => 'Αποδοχή Πρόσκλησης & Υποβολή';

  @override
  String get jobDetailsTitle => 'Λεπτομέρειες Θέσης';

  @override
  String get save => 'Αποθήκευση';

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get open => 'Άνοιγμα';

  @override
  String get delete => 'Διαγραφή';

  @override
  String get appBarTitleIthaki => 'Ithaki';

  @override
  String get profileAboutMeTitle => 'Σχετικά με μένα';

  @override
  String get profileSkillsTitle => 'Δεξιότητες';

  @override
  String get hardSkillsTitle => 'Τεχνικές Δεξιότητες';

  @override
  String get softSkillsTitle => 'Ήπιες Δεξιότητες';

  @override
  String get competenciesTitle => 'Ικανότητες';

  @override
  String get computerSkillsTitle => 'Γνώσεις Η/Υ';

  @override
  String get drivingLicenseTitle => 'Άδεια Οδήγησης';

  @override
  String get licenseCategoryTitle => 'Κατηγορία Άδειας';

  @override
  String get editCompetenciesTitle => 'Επεξεργασία Ικανοτήτων';

  @override
  String get editSkillsTitle => 'Επεξεργασία Δεξιοτήτων';

  @override
  String get editLanguagesTitle => 'Επεξεργασία Γλωσσών';

  @override
  String get editValuesTitle => 'Αξίες';

  @override
  String get editAboutMeTitle => 'Σχετικά με μένα';

  @override
  String get addBioOptional => 'Προσθήκη Βιογραφικού (προαιρετικό)';

  @override
  String get addVideoPresentationOptional =>
      'Προσθήκη Παρουσίασης Βίντεο (προαιρετικό)';

  @override
  String get uploadFile => 'Μεταφόρτωση Αρχείου';

  @override
  String get pasteVideoUrlHere => 'Επικολλήστε εδώ το URL του βίντεο';

  @override
  String get noValuesAddedYet => 'Δεν έχουν προστεθεί αξίες ακόμα.';

  @override
  String get profileMyFilesTitle => 'Τα Αρχεία μου';

  @override
  String get couldNotOpenVideoIntroduction =>
      'Δεν ήταν δυνατό το άνοιγμα της εισαγωγής βίντεο.';

  @override
  String openFileNoSource(String fileName) {
    return 'Το $fileName δεν έχει πηγή αρχείου για άνοιγμα.';
  }

  @override
  String couldNotOpenFile(String fileName) {
    return 'Δεν ήταν δυνατό το άνοιγμα του $fileName.';
  }

  @override
  String openingFile(String fileName) {
    return 'Άνοιγμα $fileName';
  }

  @override
  String get openCv => 'Άνοιγμα CV';

  @override
  String get accountSettings => 'Ρυθμίσεις Λογαριασμού';

  @override
  String get editJobPreferencesTitle => 'Προτιμήσεις Εργασίας';

  @override
  String get positionLevelOptionalLabel => 'Επίπεδο Θέσης (προαιρετικό)';

  @override
  String get selectLevel => 'Επιλέξτε επίπεδο';

  @override
  String get profileEducationTitle => 'Εκπαίδευση';

  @override
  String get profileEducationSubtitle =>
      'Προσθέστε πληροφορίες για το εκπαιδευτικό σας υπόβαθρο, τον τίτλο και τον τομέα σπουδών.';

  @override
  String get addEducation => 'Προσθήκη Εκπαίδευσης';

  @override
  String get editEducation => 'Επεξεργασία Εκπαίδευσης';

  @override
  String get institutionNameLabel => 'Όνομα Ιδρύματος';

  @override
  String get institutionNameHint => 'π.χ. Πανεπιστήμιο Αθηνών';

  @override
  String get fieldOfStudyLabel => 'Τομέας Σπουδών';

  @override
  String get fieldOfStudyHint => 'π.χ. Πληροφορική';

  @override
  String get degreeTypeLabel => 'Τύπος Πτυχίου';

  @override
  String get selectDegree => 'Επιλέξτε πτυχίο';

  @override
  String get startDateLabel => 'Ημερομηνία Έναρξης';

  @override
  String get endDateLabel => 'Ημερομηνία Λήξης';

  @override
  String get mmYyyyHint => 'ΜΜ-ΕΕΕΕ';

  @override
  String get currentlyStudyHere => 'Σπουδάζω εδώ αυτήν την περίοδο';

  @override
  String get profileWorkExperienceTitle => 'Εργασιακή Εμπειρία';

  @override
  String get profileWorkExperienceSubtitle =>
      'Προσθέστε λεπτομέρειες για τους προηγούμενους ρόλους και εταιρείες σας';

  @override
  String get addWorkExperience => 'Προσθήκη Εργασιακής Εμπειρίας';

  @override
  String get editWorkExperience => 'Επεξεργασία Εργασιακής Εμπειρίας';

  @override
  String get jobTitleLabel => 'Τίτλος Θέσης';

  @override
  String get jobTitleHint => 'π.χ. Μηχανικός Λογισμικού';

  @override
  String get companyNameLabel => 'Όνομα Εταιρείας';

  @override
  String get companyNameHint => 'π.χ. Acme Corp';

  @override
  String get experienceSummaryOptional => 'Περίληψη Εμπειρίας (προαιρετικό)';

  @override
  String get experienceSummaryHint =>
      'Περιγράψτε τον ρόλο και τα επιτεύγματά σας...';

  @override
  String get currentlyWorkHere => 'Εργάζομαι εδώ αυτήν την περίοδο';

  @override
  String charactersCounter(int current, int max) {
    return '$current / $max χαρακτήρες';
  }

  @override
  String get dateOfBirthLabel => 'Ημερομηνία Γέννησης';

  @override
  String get yourFirstNameHint => 'Το όνομά σας';

  @override
  String get yourLastNameHint => 'Το επώνυμό σας';

  @override
  String get genderLabel => 'Φύλο';

  @override
  String get selectGender => 'Επιλέξτε φύλο';

  @override
  String get selectCountry => 'Επιλέξτε χώρα';

  @override
  String get statusLabel => 'Κατάσταση';

  @override
  String get selectStatus => 'Επιλέξτε κατάσταση';

  @override
  String get relocationReadinessLabel => 'Ετοιμότητα Μετεγκατάστασης';

  @override
  String get selectOption => 'Επιλέξτε επιλογή';

  @override
  String get fileExceedsLimit => 'Το αρχείο υπερβαίνει το όριο των 5 MB';

  @override
  String get leaveEditingTitle => 'Έξοδος από Επεξεργασία;';

  @override
  String get leaveEditingMessage =>
      'Όλες οι πληροφορίες που εισαγάγατε θα χαθούν αν εγκαταλείψετε αυτή την οθόνη.';

  @override
  String get leaveWithoutSaving => 'Έξοδος χωρίς αποθήκευση';

  @override
  String get saveAndLeave => 'Αποθήκευση και Έξοδος';

  @override
  String get highLabel => 'Υψηλό';

  @override
  String get genderInfoLabel => 'Φύλο';

  @override
  String get ageInfoLabel => 'Ηλικία';

  @override
  String get locationInfoLabel => 'Τοποθεσία';

  @override
  String get showFullCv => 'Εμφάνιση πλήρους CV';

  @override
  String get coverLetterTitle => 'Συνοδευτική Επιστολή';

  @override
  String get screeningQuestionsTitle => 'Ερωτήσεις Αξιολόγησης';

  @override
  String get aboutCompanyTitle => 'Σχετικά με την Εταιρεία';

  @override
  String get teamTitle => 'Ομάδα';

  @override
  String get companyProfile => 'Προφίλ Εταιρείας';

  @override
  String get typeCityToSearch => 'Πληκτρολογήστε πόλη για αναζήτηση';

  @override
  String get experienceLevelLabel => 'Επίπεδο Εμπειρίας';

  @override
  String get workplaceLabel => 'Workplace';

  @override
  String get selectWorkplace => 'Επιλέξτε χώρο εργασίας';

  @override
  String get selectJobType => 'Επιλέξτε τύπο εργασίας';

  @override
  String get skillsDescription =>
      'Επιλέξτε τις δεξιότητες που αντιπροσωπεύουν καλύτερα τα προσόντα και την επαγγελματική σας εμπειρογνωμοσύνη.';

  @override
  String get addSkillHint =>
      'Αρχίστε να πληκτρολογείτε για να προσθέσετε μια δεξιότητα';

  @override
  String errorLoadingSkills(String error) {
    return 'Σφάλμα φόρτωσης δεξιοτήτων: $error';
  }

  @override
  String chooseValuesDescription(int max) {
    return 'Επιλέξτε έως $max αξίες που αντιπροσωπεύουν καλύτερα αυτό που έχει μεγαλύτερη σημασία για εσάς επαγγελματικά.';
  }

  @override
  String get videoIntroductionTitle => 'Εισαγωγή Βίντεο';

  @override
  String get editAboutMeVideo =>
      'Επεξεργασία Σχετικά με μένα & Εισαγωγή Βίντεο';

  @override
  String get addAboutMeInformation => 'Προσθήκη Πληροφοριών Σχετικά με μένα';

  @override
  String get aboutMeEmptyDescription =>
      'Προσθέστε μερικές λέξεις για τον εαυτό σας για να βοηθήσετε τις ομάδες να καταλάβουν ποιοι είστε και τι κάνετε.';

  @override
  String get addSkills => 'Προσθήκη Δεξιοτήτων';

  @override
  String get addCompetencies => 'Προσθήκη Ικανοτήτων';

  @override
  String get addLanguages => 'Προσθήκη Γλωσσών';

  @override
  String get editLanguages => 'Επεξεργασία Γλωσσών';

  @override
  String get languagesTitle => 'Γλώσσες';

  @override
  String get aboutMeEditDescription =>
      'Παρακαλώ παρέχετε μερικές βασικές πληροφορίες για τον εαυτό σας. Αυτό μας βοηθά να ρυθμίσουμε το προφίλ σας και να εξατομικεύσουμε την εμπειρία σας. Μπορείτε να προσθέσετε πληροφορίες αργότερα ή να τις ενημερώσετε οποτεδήποτε στο Προφίλ.';

  @override
  String get addBioDescription =>
      'Προσθέστε μερικές λέξεις για τον εαυτό σας για να βοηθήσετε τις ομάδες να καταλάβουν ποιοι είστε και τι κάνετε. Συνιστούμε να παραμείνετε συνοπτικοί, αποφεύγοντας περιττό περιεχόμενο και αναδεικνύοντας βασικές δεξιότητες και εμπειρία.';

  @override
  String get addVideoDescription =>
      'Προσθέστε ένα σύντομο βίντεο για να συστηθείτε στις ομάδες, να αναδείξετε την εμπειρία σας και να προβάλλετε τις δεξιότητές σας. Ένα βίντεο σας βοηθά να ξεχωρίσετε ανάμεσα στους άλλους υποψηφίους.';

  @override
  String get uploadViaUrl => 'Μεταφόρτωση μέσω URL';

  @override
  String get uploadInstructions =>
      'πατήστε για αναζήτηση (μέγ. 10 αρχεία, έως 5 MB\nέκαστο· υποστηριζόμενες μορφές: .pdf, .doc, .png, .jpg)';

  @override
  String get selectCategory => 'Επιλέξτε κατηγορία';

  @override
  String categoryLabel(String category) {
    return 'Κατηγορία $category';
  }

  @override
  String get iHaveGreekLicense => 'Έχω Ελληνική Άδεια';

  @override
  String get yes => 'Ναι';

  @override
  String get no => 'Όχι';

  @override
  String get selectLanguage => 'Επιλέξτε Γλώσσα';

  @override
  String get languageFieldLabel => 'Γλώσσα';

  @override
  String get selectLanguageHint => 'Επιλέξτε γλώσσα';

  @override
  String get searchLanguage => 'Αναζήτηση γλώσσας';

  @override
  String get loadingLanguages => 'Φόρτωση γλωσσών...';

  @override
  String get noLanguagesAvailable =>
      'Δεν υπάρχουν διαθέσιμες γλώσσες αυτήν τη στιγμή.';

  @override
  String get proficiencyLevel => 'Επίπεδο Γνώσης';

  @override
  String get addAnotherLanguage => 'Προσθήκη Ακόμα μιας Γλώσσας';

  @override
  String get editJobsPreferences => 'Επεξεργασία Προτιμήσεων Εργασίας';

  @override
  String get assessmentsResultsTitle => 'Αποτελέσματα Αξιολογήσεων';

  @override
  String get companyTabVacancies => 'Κενές Θέσεις';

  @override
  String get companyTabAboutCompany => 'Σχετικά με την Εταιρεία';

  @override
  String get companyTabEvents => 'Εκδηλώσεις';

  @override
  String get companyTabPosts => 'Αναρτήσεις';

  @override
  String companyJobsFound(int count) {
    return '$count θέσεις εργασίας';
  }

  @override
  String get companyNoVacancies =>
      'Δεν υπάρχουν ανοιχτές θέσεις αυτή τη στιγμή.';

  @override
  String get saveJob => 'Αποθήκευση Θέσης';

  @override
  String get entryLevel => 'Αρχάριος';

  @override
  String get companyPerksTitle => 'Παροχές & Οφέλη';

  @override
  String get companyGalleryTitle => 'Φωτογραφίες Εταιρείας';

  @override
  String get companyNoEvents => 'Δεν υπάρχουν επερχόμενες εκδηλώσεις.';

  @override
  String get companyEventsTitle => 'Εκδηλώσεις Εταιρείας';

  @override
  String get companyPostsTitle => 'Αναρτήσεις Εταιρείας';

  @override
  String companyPostsFound(int count) {
    return '$count αναρτήσεις';
  }

  @override
  String get companyNoPostsYet => 'Δεν υπάρχουν ακόμα αναρτήσεις εταιρείας.';

  @override
  String get shareButton => 'Κοινοποίηση';

  @override
  String get culturalMatchScore => 'Βαθμός Πολιτισμικής Συμβατότητας';

  @override
  String get culturalMatchDescription =>
      'Εσείς και αυτή η εταιρεία επιλέξατε τις κορυφαίες 5 αξίες και προτιμήσεις σας. Αυτή η βαθμολογία δείχνει πόσο στενά ευθυγραμμίζονται.';

  @override
  String get culturalMatchYouBothCareAbout => 'Ενδιαφέρεστε και οι δύο για:';

  @override
  String companyTeamEmployees(String teamSize) {
    return '$teamSize υπάλληλοι';
  }

  @override
  String get companyLabelMainOffice => 'Κύρια Τοποθεσία Γραφείου';

  @override
  String get companyLabelOtherLocations => 'Άλλες Τοποθεσίες';

  @override
  String get companyLabelContactPhone => 'Τηλέφωνο Επικοινωνίας';

  @override
  String get companyLabelWebsite => 'Ιστοσελίδα';

  @override
  String get notAvailable => 'Δ/Υ';

  @override
  String get eventDetailsTitle => 'Λεπτομέρειες Εκδήλωσης';

  @override
  String get eventAddressLabel => 'Διεύθυνση';

  @override
  String get eventRegistrationLink => 'Σύνδεσμος Εγγραφής';

  @override
  String get companyLoadError => 'Δεν ήταν δυνατή η φόρτωση της εταιρείας.';

  @override
  String get tryAgain => 'Δοκιμάστε Ξανά';

  @override
  String get assessmentsRecommendedForYou =>
      'Αξιολογήσεις που προτείνονται για εσάς';

  @override
  String get assessmentYourScore => 'Η Βαθμολογία Σας';

  @override
  String get assessmentLevel => 'Επίπεδο';

  @override
  String get assessmentSkillBreakdown => 'Ανάλυση Δεξιοτήτων';

  @override
  String get assessmentKeyInsights => 'Βασικά Ευρήματα';

  @override
  String get assessmentPreviousResults => 'Προηγούμενα Αποτελέσματα';

  @override
  String get assessmentYouImproving => 'Βελτιώνεστε!';

  @override
  String get assessmentMeansForProfile => 'Τι σημαίνει αυτό για το προφίλ σας';

  @override
  String get assessmentAboutThis => 'Σχετικά με αυτή την αξιολόγηση';

  @override
  String get assessmentUsedFor => 'Σε τι χρησιμοποιείται αυτή η αξιολόγηση';

  @override
  String get assessmentBeforeStart => 'Πριν ξεκινήσετε';

  @override
  String get assessmentApproxDuration => 'Κατά Προσέγγιση Διάρκεια';

  @override
  String get assessmentQuestionsLabel => 'Ερωτήσεις';

  @override
  String get bannerNotSureJob =>
      'Δεν είστε σίγουροι πώς να βρείτε τη σωστή δουλειά;';

  @override
  String get chatNewChat => 'Νέα Συνομιλία';

  @override
  String get chatSearchInChats => 'Αναζήτηση σε Συνομιλίες';

  @override
  String get chatHistory => 'Ιστορικό Συνομιλιών';

  @override
  String get homeNeedRefresher => 'Χρειάζεστε μια γρήγορη επανάληψη;';

  @override
  String get homeCvSuccess => 'Επιτυχία CV';

  @override
  String get homeStatViews => 'Προβολές';

  @override
  String get homeStatInvitations => 'Προσκλήσεις';

  @override
  String get homeStatApplicationsSent => 'Αιτήσεις που Στάλθηκαν';

  @override
  String get homeStatInterviews => 'Συνεντεύξεις';

  @override
  String get homeRecommendedCourses => 'Προτεινόμενα Μαθήματα';

  @override
  String get homeLatestNews => 'Τελευταία Νέα';

  @override
  String get homeSmartJobRecommendations => 'Έξυπνες Προτάσεις Εργασίας';

  @override
  String get viewAll => 'Προβολή Όλων';

  @override
  String get searchByJobTitle => 'Αναζήτηση κατά τίτλο εργασίας';

  @override
  String get jobLoadError => 'Δεν ήταν δυνατή η φόρτωση της θέσης εργασίας.';

  @override
  String get jobRemovedFromSaved => 'Αφαιρέθηκε από τις αποθηκευμένες θέσεις.';

  @override
  String get jobSavedMessage =>
      'Η θέση αποθηκεύτηκε! Ελέγξτε τις αποθηκευμένες θέσεις σας.';

  @override
  String get jobPostRemoved => 'Η αγγελία εργασίας αφαιρέθηκε';

  @override
  String get deadlineReminderSet =>
      'Η υπενθύμιση προθεσμίας ορίστηκε. Θα σας ειδοποιήσουμε μια εβδομάδα πριν την προθεσμία.';

  @override
  String get readMore => 'Διαβάστε περισσότερα';

  @override
  String jobPostedDate(String date) {
    return 'Δημοσιεύτηκε $date';
  }

  @override
  String get jobClosedLabel => 'Κλειστή';

  @override
  String get deadlineReminderLabel => 'Υπενθύμιση Προθεσμίας';

  @override
  String get reportLabel => 'Αναφορά';

  @override
  String get reminderSetNotification =>
      'Έχετε ορίσει υπενθύμιση για αυτή την αγγελία εργασίας';

  @override
  String get odysseaReviewLabel => 'Αξιολόγηση Odyssea: ';

  @override
  String get recommendedForYouLabel => 'Προτείνεται για εσάς';

  @override
  String get tabAllJobs => 'Όλες οι Θέσεις';

  @override
  String tabSavedJobs(int count) {
    return 'Αποθηκευμένες ($count)';
  }

  @override
  String get sortingTitle => 'Ταξινόμηση';

  @override
  String get filtersTitle => 'Φίλτρα';

  @override
  String get resetFilters => 'Επαναφορά Φίλτρων';

  @override
  String get applyFilters => 'Εφαρμογή Φίλτρων';

  @override
  String get filterAllLabel => 'Όλα';

  @override
  String get filterClear => 'Εκκαθάριση';

  @override
  String get applyFilter => 'Εφαρμογή Φίλτρου';

  @override
  String get salaryTitle => 'Μισθός';

  @override
  String get tillLabel => 'Έως';

  @override
  String get reportJobTitle => 'Αναφορά αυτής της θέσης;';

  @override
  String get selectReasonHint => 'Επιλογή αιτίας';

  @override
  String get setReminderTitle => 'Ορισμός υπενθύμισης';

  @override
  String get applicationOpenTill => 'Η αίτηση είναι ανοιχτή έως:';

  @override
  String get whenShouldRemind => 'Πότε να σας υπενθυμίσουμε;';

  @override
  String get reminderTomorrow => 'Αύριο';

  @override
  String get reminderTomorrowSub => 'Η υπενθύμιση θα σταλεί αύριο αυτή την ώρα';

  @override
  String get reminderOneWeek => 'Σε μια εβδομάδα';

  @override
  String get reminderOneWeekSub =>
      'Η υπενθύμιση θα σταλεί σε μια εβδομάδα αυτή την ώρα';

  @override
  String get reminderOneDayBefore => 'Μια μέρα πριν την προθεσμία';

  @override
  String get reminderOneDayBeforeSub =>
      'Η υπενθύμιση θα σταλεί μια μέρα πριν την προθεσμία';

  @override
  String get reminderCustomDate => 'Επιλογή προσαρμοσμένης ημερομηνίας';

  @override
  String get reminderCustomDateSub =>
      'Επιλέξτε προσαρμοσμένη ημερομηνία για την υπενθύμισή σας';

  @override
  String get selectDateLabel => 'Επιλέξτε ημερομηνία';

  @override
  String get selectTimeLabel => 'Επιλέξτε ώρα';

  @override
  String get ddMmYyyyHint => 'ΗΗ-ΜΜ-ΕΕΕΕ';

  @override
  String reminderViaContactSub(String contact) {
    return 'Θα στείλουμε υπενθύμιση στο:\n$contact';
  }

  @override
  String get reminderViaSmsWhatsapp => 'SMS / WhatsApp';

  @override
  String get changeEmailTitle => 'Αλλαγή Email';

  @override
  String get newEmailLabel => 'Νέο Email';

  @override
  String get newEmailHint => 'Εισάγετε νέο email';

  @override
  String get changePasswordTitle => 'Αλλαγή Κωδικού';

  @override
  String get repeatNewPasswordLabel => 'Επανάληψη Νέου Κωδικού';

  @override
  String get repeatNewPasswordHint => 'Επαναλάβετε τον νέο κωδικό σας';

  @override
  String get changePhoneTitle => 'Αλλαγή Αριθμού Τηλεφώνου';

  @override
  String get newPhoneNumberLabel => 'Νέος Αριθμός Τηλεφώνου';

  @override
  String get confirmAccountDeletion => 'Επιβεβαίωση Διαγραφής Λογαριασμού';

  @override
  String get typeDeleteToConfirm => 'Πληκτρολογήστε \'delete\' για επιβεβαίωση';

  @override
  String get enterDeleteHint => 'Εισάγετε \"delete\"';

  @override
  String get deleteAccountButton => 'Διαγραφή Λογαριασμού';

  @override
  String get makeProfileInvisible => 'Να γίνει αόρατο το προφίλ σας;';

  @override
  String get switchToLite => 'Μετάβαση στο Ithaki Lite;';

  @override
  String get verificationTitle => 'Επαλήθευση';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get unsubscribe => 'Κατάργηση εγγραφής';

  @override
  String get noMoreJobInterests =>
      'Δεν υπάρχουν άλλα επαγγελματικά ενδιαφέροντα για προσθήκη.';

  @override
  String get roleMigrant => 'Μετανάστης';

  @override
  String get roleRefugee => 'Πρόσφυγας';

  @override
  String get roleAsylumSeeker => 'Αιτών Άσυλο';

  @override
  String homeGreetingName(String name) {
    return 'Γεια σου, $name!';
  }

  @override
  String get homeGreetingNoName => 'Γεια σου!';

  @override
  String get homeGreetingSubtitle =>
      'Ακολουθεί μια γρήγορη επισκόπηση των τελευταίων αντιστοιχίσεων εργασίας, ενημερώσεων και χρήσιμων συμβουλών για την πρόοδο της καριέρας σας.';

  @override
  String get homeRestartProductTourSubtitle =>
      'Ξεκινήστε ξανά την περιήγηση στο προϊόν όποτε θέλετε από την Αρχική.';

  @override
  String get homeRestartProductTour => 'Επανεκκίνηση Περιήγησης';

  @override
  String get homeCareerAssistantBannerSubtitle =>
      'Ο Career Assistant μπορεί να βοηθήσει αν δεν είστε σίγουροι από πού να ξεκινήσετε!';

  @override
  String get homeCoursesSubtitle =>
      'Αναβαθμίστε τις δεξιότητές σας με μαθήματα που σας βοηθούν να εξελιχθείτε γρηγορότερα. Μάθετε με τον δικό σας ρυθμό.';

  @override
  String get homeProfileCompleteYourProfile => 'Συμπληρώστε το προφίλ σας';

  @override
  String get homeProfileWelcomeTitle => 'Καλώς ήρθατε στο Ithaki!';

  @override
  String get homeProfileFillMissing =>
      'Συμπληρώστε τα στοιχεία που λείπουν για να ξεκλειδώσετε την πλήρη εμπειρία. Ένα πλήρες προφίλ σας βοηθά να έχετε καλύτερες αντιστοιχίσεις και περισσότερες προσκλήσεις.';

  @override
  String get homeProfileBenefitsTitle => 'Πλεονεκτήματα ενός πλήρους προφίλ';

  @override
  String get homeProfileFillButton => 'Συμπλήρωση Προφίλ';

  @override
  String get homeQuestionsTitle => 'Έχετε ερωτήσεις;';

  @override
  String get homeQuestionsSubtitle => 'Αφήστε μας να σας βοηθήσουμε!';

  @override
  String get homeQuestionsButton => 'Κλείστε Ραντεβού με Σύμβουλο';

  @override
  String get assessmentStartNew => 'Νέα Αξιολόγηση';

  @override
  String assessmentsInProgressTitle(int count) {
    return 'Αξιολογήσεις σε Εξέλιξη ($count)';
  }

  @override
  String get assessmentsInProgressSubtitle =>
      'Έχετε αξιολογήσεις σε εξέλιξη. Ολοκληρώστε τις για να δείτε τα αποτελέσματά σας.';

  @override
  String get assessmentsRecommendedSubtitle =>
      'Σας προτείνουμε αυτές τις αξιολογήσεις για να επικυρώσετε τις δεξιότητές σας.';

  @override
  String get assessmentsCompletedTitle => 'Ολοκληρωμένες Αξιολογήσεις σας';

  @override
  String get assessmentsCompletedSubtitle =>
      'Δείτε τις ολοκληρωμένες αξιολογήσεις και τα αποτελέσματά σας.';

  @override
  String get assessmentStartTitle => 'Έναρξη Αξιολόγησης';

  @override
  String get assessmentStartSubtitle =>
      'Πρόκειται να ξεκινήσετε την παρακάτω αξιολόγηση';

  @override
  String get assessmentStartNow => 'Ξεκινήστε τώρα';

  @override
  String get assessmentContinueTitle => 'Να συνεχίσετε την αξιολόγηση;';

  @override
  String get assessmentContinueSubtitle =>
      'Έχετε ήδη ξεκινήσει αυτή την αξιολόγηση. Θέλετε να συνεχίσετε από εκεί που σταματήσατε ή να ξεκινήσετε από την αρχή;';

  @override
  String get assessmentStartOver => 'Ξεκίνημα από την αρχή';

  @override
  String get assessmentSkillBreakdownSubtitle =>
      'Αυτή η ανάλυση δείχνει πώς κατανέμονται τα αποτελέσματά σας στους βασικούς τομείς δεξιοτήτων.';

  @override
  String get assessmentResultsConfirmSkills =>
      'Αυτό το αποτέλεσμα επιβεβαιώνει τις δεξιότητές σας, οι οποίες αντικατοπτρίζονται στις αιτήσεις εργασίας σας στην πλατφόρμα.';

  @override
  String get assessmentShowInCV => 'Εμφάνιση αποτελέσματος στο CV μου';

  @override
  String get assessmentHideFromCV => 'Απόκρυψη από το CV';

  @override
  String assessmentTakenLabel(String date) {
    return 'Έγινε: $date';
  }

  @override
  String get assessmentImprovingSubtitle =>
      'Τα αποτελέσματά σας δείχνουν σταθερή βελτίωση στον τρόπο που αντιμετωπίζετε προβλήματα εργασίας.';

  @override
  String get assessmentProcessingTitle => 'Επεξεργασία αποτελεσμάτων!';

  @override
  String get assessmentProcessingSubtitle =>
      'Έχετε ολοκληρώσει επιτυχώς την αξιολόγηση. Δημιουργούμε τα αποτελέσματά σας — αυτό θα πάρει μόνο μια στιγμή.';

  @override
  String get assessmentLeaveTitle => 'Αποχώρηση από τη σελίδα;';

  @override
  String get assessmentLeaveSubtitle =>
      'Πρόκειται να φύγετε από αυτή την αξιολόγηση. Η πρόοδός σας θα αποθηκευτεί αυτόματα και μπορείτε να συνεχίσετε αργότερα.';

  @override
  String get assessmentLeaveButton => 'Αποχώρηση';

  @override
  String get quizSelectOneAnswer => 'Επιλέξτε μόνο μία απάντηση';

  @override
  String quizSelectUpToAnswers(int max) {
    return 'Επιλέξτε έως $max απαντήσεις';
  }

  @override
  String get quizSelectBestReflects =>
      'Επιλέξτε την επιλογή που αντικατοπτρίζει καλύτερα το πώς αισθάνεστε συνήθως.';

  @override
  String get quizNoResults => 'Δεν βρέθηκαν αποτελέσματα';

  @override
  String get edit => '???????????';

  @override
  String get present => '??????';

  @override
  String get cvCouldNotLoadTitle => '??? ???? ?????? ? ??????? ??? CV ???.';

  @override
  String get cvCouldNotLoadMessage =>
      '???????? ?? ?????????? ?? ???????? ??? ?????? ??? ??? ?????? ?? ????.';

  @override
  String get goToProfile => '???????? ??? ??????';

  @override
  String get publishCv => '?????????? CV';

  @override
  String get downloadCv => '???? CV';

  @override
  String get cvDownloadSoon => '? ???? ??? CV ?? ????? ????????? ???????.';

  @override
  String get returnToProfileSetup => '????????? ??? ??????? ??????';

  @override
  String get publishedBadge => '????????????';

  @override
  String get draftModeBadge => '????????';

  @override
  String get cvDraftReviewTitle =>
      '???? ????? ?? CV ??? - ???? ?? ??????? ?? ?????????.';

  @override
  String get cvDraftReviewBody =>
      '?????? ?????????? ???? ??? ??????????? ??? ???? ??? ??????????? ??????? ???? ???????????? ?? CV ???.\n?? ?? CV ??? ??? ???????????, ?? ????????? ??? ?? ??????? ?? ?? ????.\n??????? ?? ??????????? ??? ??????????? ??? ??????????? ?????? ??? ?? ??????. ?? CV ??? ?? ???????????? ????????.';

  @override
  String get contactVisibilityNote =>
      '?? ???????? ???????????? ??? ?????????? ????? ????? ?? ?????? ?????? ?? ??? ???? ? ?? ?????????? ?????????.';

  @override
  String get youBothShareSameValues => '?????????? ??? ????? ?????';

  @override
  String get learnMore => '???? ???????????';

  @override
  String get greatJob => '???? ????!';

  @override
  String get cvLevelLabel => '??????? CV:';

  @override
  String get strongLevel => '??????';

  @override
  String get cvAssistantImprovementSummary =>
      '? ?????? ????? 4 ?????? ??? ??????? ?? ?????????? ??? ?? ???????? ??? ??????????? ??? ??? ??????? ??????? ???? 15%.';

  @override
  String get careerAssistantTitle => '? ?????? ???????? ???';

  @override
  String get pathfinderName => 'Pathfinder';

  @override
  String get pathfinderAdviceText =>
      '????! ????? ? Pathfinder, ? ?????? ???????? ???.\n?????? ?? ?????? ??? ??? ????? ??????? ???????? ??????????:\n\n- ???????: ? ?????????? ?????? ??? ???????? ????. ??????? ??? ??????, ????????????? ?????????? ??? ???????? ????? ????????.\n- ????????????: ???????? ???????????? ???????????? ???? ????????? ??? ???????? - ??????? ?? ???????????? ??? ?? ????? ? ?????????? ???.\n- ?????: ????????? ??? ??????? ?????????? ??????. ????? ??? ?????? ?? ????????? ???? ??? ??? ????? ?? ?????? ??? ?? ?????????.\n????? ?? ?????? ??????? ?? ?????????? ??????? ??? ?????????? ??? ??? ??????? ???.';

  @override
  String get askCareerPathHint =>
      '?????? ?? ??? ??? ?????? ??? ???????? ???...';

  @override
  String get leaveWithoutPublishingTitle => '?????? ????? ??????????;';

  @override
  String get leaveWithoutPublishingMessage =>
      '?? ?????? ??? ???? ?? ??????, ?? CV ??? ??? ?? ??????????? ??? ?? ????????? ??? ?? ??????? ?? ?? ????. ??????? ????? ?? ?? ???????????? ???????? ??? ?? ?????? ???, ???? ??????????? ?? ?? ???????????? ???? ??? ?? ???????? ??? ??????????? ??? ??? ???????.';

  @override
  String get notSpecified => '??? ???? ???????';

  @override
  String get workspaceLabel => '????? ????????';

  @override
  String get levelLabel => '???????';

  @override
  String get desiredSalaryLabel => '?????????? ??????';

  @override
  String get jobPreferencesTabDescription =>
      '??? ??????????? ? ??????? ??? ???????? ???? ?? ??????. ??????? ?? ?? ???????? ??????????? ??????.';

  @override
  String get preferencesSectionTitle => '???????????';

  @override
  String experienceAtCompany(String role, String company) {
    return '$role  ????  $company';
  }

  @override
  String educationAtInstitution(String field, String institution) {
    return '$field  ???\n$institution';
  }

  @override
  String periodWithDuration(String start, String end, String duration) {
    return '$start - $end  ($duration)';
  }

  @override
  String assessmentCategoryLabel(String category) {
    return '?????????? $category';
  }

  @override
  String get jobPreferencesUpdated =>
      '?? ??????????? ???????? ??? ????????????.';

  @override
  String get updateButton => '?????????';

  @override
  String get currentEmailLabel => '?????? email';

  @override
  String get updateEmailDescription => '????????? ?? ????????? email ???';

  @override
  String get deleteAccountDescription =>
      '??? ?? ?????????? ???????? ??? ?????????? ???, ????????????? delete ??? ????? ????????.\n???? ? ???????? ??? ?????? ?? ????????? - ??? ?? ???????? ??? ?? ?????????? ??? ?????.';

  @override
  String get communicationChannelTitle => '?????? ????????????';

  @override
  String get emailNewsletterTitle => '??????????? email';

  @override
  String get emailNewsletterDescription =>
      '????? ???????????? ??? ?????????? ??? ???????? ???! ??????? ?? ??????????? ??? ????????? ?????? ?? ????????? ??? inbox ???.';

  @override
  String get newsletterActive => '(??????)';

  @override
  String get newsletterInactive => '(????????)';

  @override
  String get subscribe => '???????';

  @override
  String get settingsUpdatedSuccessfully =>
      '?? ????????? ???????????? ????????.';

  @override
  String get newsletterJobsTitle => '????????? ????????';

  @override
  String get newsletterJobsSubtitle =>
      '???????????????? ????????? ?? ???? ??? ?????????? ??? ??? ??????????? ???';

  @override
  String get newsletterCareerTipsTitle => '????????? ????????';

  @override
  String get newsletterCareerTipsSubtitle =>
      '????????? ??? ????? ??? ??? ????????????? ??? ????????';

  @override
  String get newsletterEventsTitle => '?????????? & Webinars';

  @override
  String get newsletterEventsSubtitle =>
      '??????????? ??????????, ?????????? ??? ????????? ?????????';

  @override
  String get newsletterPlatformTitle => '??????????? ??????????';

  @override
  String get newsletterPlatformSubtitle =>
      '???? ???????????, ???????? ??? ?????????? ?????????';

  @override
  String get newsletterLearningTitle => '????????? ???????';

  @override
  String get newsletterLearningSubtitle =>
      'Online ???????? ??? ????????????? ??? ?? ?????????? ??? ?????????? ???';

  @override
  String get uploadFilesTitle => '???????? ???????';

  @override
  String get uploadMore => '??????? ???????????';

  @override
  String get uploadFileInstructions =>
      '?????? ?? ?????? ??? ?????????\n(???. 10 ??????, ??? 5 MB ?? ??????;\n??????????????: .pdf, .doc, .png, .jpg)';

  @override
  String get documentUrlDescription =>
      '???? ???? ???????? ???????? ??? ???????? ??? ???????.';

  @override
  String get documentUrlMustBeActive =>
      '? ????????? ?????? ?? ????? ??????? ??? ??????????? ????? ???????.';

  @override
  String get documentUrlSupportedFormats =>
      '?? ??????? ?????? ?? ????? ?? ?????????????? ????? (PDF, DOC, DOCX).';

  @override
  String get documentUrlCommonServices =>
      '???????????? ?????????: Google Drive, Dropbox, iCloud.';

  @override
  String get documentLinkHint => '???????? ???????? ????????';

  @override
  String get fileComplete => '????????????';

  @override
  String get fileUploading => '?????????...';

  @override
  String get fileFallbackLabel => '??????';

  @override
  String get profileMenuMyProfile => '?? ?????? ???';

  @override
  String get profileMenuMyCv => '?? CV ???';

  @override
  String get logOut => '??????????';

  @override
  String get goToJobSearch => '???????? ???? ????????? ????????';

  @override
  String get startProductTour => '?????? ??????????';

  @override
  String get continueProductTour => '???????? ??????????';

  @override
  String get skipAndClose => '????????? ??? ????????';

  @override
  String get finish => '?????';

  @override
  String get nextButton => '???????';

  @override
  String tourStepIndicator(int current, int total) {
    return '???? $current / $total';
  }

  @override
  String get tourReadyTitle => '????? ???????!';

  @override
  String get tourReadyBody =>
      '???? ????????? ??? ??????? ??????????? ??? ??????????. ?????????? ?? ?????? ???, ???? ???????????? ??? ???? ???????? ?? ???????? ??? ??? ??????????.';

  @override
  String get tourWelcomeTitle => '?? ???????????!';

  @override
  String get tourWelcomeBody =>
      '??? ??????? ?? ????? ??????? ??? ????????? ???? ?????????? ??? ??? ???????? ???. ???? ???? ????.';

  @override
  String get tourSkipTitle => '????????? ??? ????;';

  @override
  String get tourSkipBody =>
      '??????? ????? ?? ?????? ??? ????????? ???????? ??? ?? banner ???? ?????? ??????.';

  @override
  String get tourStep1Title => '???? ?? ??????!';

  @override
  String get tourStep1Body =>
      '??? ?? ???? ???????? ??? ???????? ?????????? ??? ?????, ???????? ??? ?? CV ??? ??? ???????? ??? ?? ?????????? ??? ????????? ????????.';

  @override
  String get tourStep2Title => '???? ???????';

  @override
  String get tourStep2Body =>
      '????????? ???????? ?? ????? ? ??????? ??????????. ??????? ?? ????? ??????? ????? ???? ???? ??? ? ?? ??????? ???? ????????.';

  @override
  String get tourStep3Title => '??????? ????????';

  @override
  String get tourStep3Body =>
      '???? ????? ??????? ??? ??????? ??????????? - ????, ????????? ??? ?????. ?????? ??? ??? ??????? ???????????? ??? ??????.';

  @override
  String get tourStep4Title => '??? ???? ??? ????????? ? ???????';

  @override
  String get tourStep4Body =>
      '???? ??????? ???? ?????????? ? ???????? ??? ?? ?????????? ??? ?? ?? ???????. ??? ?????????? ?? match, ???? ????????? ?? ???????????.';

  @override
  String get tourStep5Title => '???????????? ????????';

  @override
  String get tourStep5Body =>
      '??????? ??? ????? ?????????, ??? ?????????? ??? ?? ????????? ? ???????? ???? ?????? ??????.';

  @override
  String get tourStep6Title => '?????? ??????';

  @override
  String get tourStep6Body =>
      '? ?????? ????? ??????! ??????? ????? CV ??? ???????? ???? ????? ??? Cover Letter ??? ?? ???????? ??? ??????????? ???.';

  @override
  String get tourStep7Title => '????????????? ??? ??????';

  @override
  String get tourStep7Body =>
      '????? ?????? ??????, ?? ????? ??? ???????? ???? ???????? ???.';

  @override
  String get tourStep8Title => '?? ??????????? ???';

  @override
  String get tourStep8Body =>
      '?? ????????? ??????? ?? ?? ???????????? ?????????. ??????? ?? ???? ???????? ??????????? ??? ?????? ??? ????????????? ??? ?? ?????? ???.';

  @override
  String get tourStep9Title => '???? ?? ??????!';

  @override
  String get tourStep9Body =>
      '??????? ?? ???????? ??? ????????? ??? ?? ????????? ???????????? ??? ?? ?????????? ??? ????????.';

  @override
  String get tourStep10Title => '????? ?? ?????? ???';

  @override
  String get tourStep10Body =>
      '?? ?????? ??? ??????? ????????, ?????????? ??? ???????? ????????????. ??? ?????? ?????? ????? ?? ???????? job matches.';

  @override
  String get tourStep11Title => '??????? ??? ????? ????????';

  @override
  String get tourStep11Body =>
      '? Pathfinder ?????? ?? ?? ???????? ?? ?????????? ?? ?????? ???, ?? ????? ?????????? ???????? ??? ?? ????????? ?? ?????????.';

  @override
  String get tourStep12Title => 'Learning Hub';

  @override
  String get tourStep12Body =>
      '???????? ?? ???????? ??? ?????? ??? ???? ??????? ???????? ??? ??? ??? ?????????? ??? ????????? ?? ?????????.';

  @override
  String get tourStep13Title => '??????? ???????? ??? ????? ???';

  @override
  String get tourStep13Body =>
      '??? ??????? ?? ?????? ????????????. ?? ???????????? ??????? ?? ??????????? ?? ?????? ??? ?????? ??? ? ?????? ???????? ???.';

  @override
  String get changePasswordDescription =>
      '?????? ??? ?????? ??? ??? ?? ????????? ??? ?????????? ??? ??????';

  @override
  String get passwordUpdated => '? ??????? ??? ???????????.';

  @override
  String get currentPhoneNumberLabel => '?????? ??????? ?????????';

  @override
  String get makeProfileInvisibleDescription =>
      '?? ?????? ?? ?????? ??? ??????, ?? ????????? ??? ?? ??????? ?? ?? ???????? ???? ??????????? ?????????. ?? ??????? ????? ?? ?????? ???????? ?? ?????? ??? ?? ???????????. ??????? ?? ???????? ??? ????????? ??????????? ?????? ???? ????????? ???????????.';

  @override
  String get makeProfileInvisibleButton => '???? ?? ?????? ??????';

  @override
  String get switchLiteDescription =>
      '? ??????? ?? ????? ??? ???? ??? ?????? ??? ?????. ?? ??? ????????? ???? ??? ???????? ??? ?????????? ???????? ??? ???????????? ???.\n??????? ?? ??????????? ???? ????? ??????? ??????????? ??????.';

  @override
  String get switchLiteButton => '???????? ?? Ithaki Lite';

  @override
  String get switchedToLite => '????? ???????? ?? Ithaki Lite.';

  @override
  String get submit => '???????';

  @override
  String newValueLabel(String type) {
    return '??? $type';
  }

  @override
  String codeSentToContact(String contact) {
    return '???? 6?????? ??????? ???????? ??? $contact.';
  }

  @override
  String get phoneViaSms => '???????? ??? ???? SMS';

  @override
  String get changedEmail => '?? email ??? ??????.';

  @override
  String get changedPhone => '? ??????? ????????? ??? ??????.';

  @override
  String get jobReportedMessage => '? ??????? ??????????';

  @override
  String get copyLink => '????????? ?????????';

  @override
  String get shareWhatsappSms => '??????????? ?? WhatsApp/SMS';

  @override
  String get shareInEmail => '??????????? ?? email';

  @override
  String get shareOnLinkedIn => '??????????? ??? LinkedIn';

  @override
  String get industryLabel => '??????';

  @override
  String get travelLabel => '???????';

  @override
  String get reportJobDescription =>
      '?? ???????? ??????? ?? ?????????? ??? ???????? ?? ????? ????????.';

  @override
  String get tellUsMoreOptional => '??? ??? ??????????? (???????????)';

  @override
  String get reportThisJobButton => '??????? ????????';

  @override
  String get setReminderButton => '??????? ???????????';

  @override
  String get reminderChoiceTitle => '??? ?????? ?? ??? ????????? ??????????;';

  @override
  String get reminderViaEmail => '?? ??? ????????? ?????????? ???? email';

  @override
  String get reminderViaSmsWhatsappGeneric =>
      '?? ??? ????????? ?????????? ???? SMS/WhatsApp';

  @override
  String get jobClosedButton => '? ???? ???????';

  @override
  String get removeFromSaved => '???????? ??? ????????????';

  @override
  String get newFeatureBanner =>
      '??? ??? Ithaki! ????????????? ??? ??? ?????????? ??? ????? ??? ????????? ???????? ??? ??????.';

  @override
  String get curiousWhyMatch =>
      '?????? ?? ?????? ????? ?????????? ?? ???? ?? ???????;';

  @override
  String get strongSkillsMatch => '??????\n????????? ??????????!';

  @override
  String get goodSkillsMatch => '????\n????????? ??????????!';

  @override
  String get partialSkillsMatch => '??????\n????????? ??????????!';

  @override
  String get starterSkillsMatch => '??????\n????????? ??????????!';

  @override
  String get deadlineBannerText =>
      '???? ? ??????? ???? ?????????! ?? ????????\n????? ???????? ???:';

  @override
  String get skillsRequired => '???????????? ??????????';

  @override
  String get aboutRoleTitle => '??????? ?? ??? ????';

  @override
  String get requirementsTitle => '??????????';

  @override
  String get niceToHaveTitle => '????????? ????????';

  @override
  String get weOfferTitle => '???????????';

  @override
  String get shareJob => '??????????? ?????';

  @override
  String get notInterested => '??? ?? ??????????';

  @override
  String get deleteReminder => '???????? ???????????';

  @override
  String get salaryRangeLabel => '????? ??????';

  @override
  String get responsibilitiesTitle => '????????????';

  @override
  String errorMessage(String error) {
    return '??????: $error';
  }

  @override
  String get assessmentNotFound => '? ?????????? ??? ???????';

  @override
  String get testDetails => '???????????? ????';

  @override
  String get startTest => '?????? ????';

  @override
  String get viewDetails => '??????? ????????????';

  @override
  String get inCv => '??? CV';

  @override
  String get showInCv => '???????? ??? CV';

  @override
  String questionsCount(int count) {
    return '$count ?????????';
  }

  @override
  String durationMinutes(int count) {
    return '$count ?????';
  }

  @override
  String rangeNumberSubtitle(
      int min, int max, String minLabel, String maxLabel) {
    return '??????? ???? ?????? ??? $min ??? $max, ???? $min ???????? \"$minLabel\" ??? $max ???????? \"$maxLabel\".';
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
      'Τα επαγγελματικά ενδιαφέροντα φορτώνονται ακόμα. Δοκιμάστε ξανά σε λίγο.';

  @override
  String get failedToLoadJobInterests =>
      'Αποτυχία φόρτωσης επαγγελματικών ενδιαφερόντων.';

  @override
  String get relocationNegative => 'Δεν είμαι διατεθειμένος να μετακομίσω';

  @override
  String get relocationLocally => 'Διατεθειμένος να μετακομίσω τοπικά';

  @override
  String get relocationNationally => 'Διατεθειμένος να μετακομίσω εθνικά';

  @override
  String get relocationInternationally => 'Διατεθειμένος να μετακομίσω διεθνώς';
}
