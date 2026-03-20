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
}
