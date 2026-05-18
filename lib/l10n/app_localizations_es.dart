// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Ithaki';

  @override
  String get loginAction => 'Iniciar sesión';

  @override
  String get signUpAction => 'Registrarse';

  @override
  String get continueButton => 'Continuar';

  @override
  String get skipButton => 'Omitir';

  @override
  String get backButton => 'Atrás';

  @override
  String get goBack => 'Regresar';

  @override
  String get welcomeHeading =>
      '¡Te damos la bienvenida a Ithaki!\n¡Vamos a crear una cuenta!';

  @override
  String get selectLanguageTitle => 'Selecciona tu idioma';

  @override
  String get selectLanguageDescription =>
      'Puedes cambiar el idioma de la interfaz en cualquier momento. Todo el contenido, incluida la descripción del empleo, tu currículum y la comunicación con los consultores y el chatbot, estará en inglés.';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get selectLanguagePlaceholder => 'Selecciona tu idioma';

  @override
  String get techComfortTitle =>
      '¿Qué tan cómodo te sientes con la tecnología?';

  @override
  String get techComfortDescription =>
      'Usaremos tu respuesta para que la plataforma te resulte más cómoda.';

  @override
  String get techExperiencedLabel => 'Tengo experiencia';

  @override
  String get techExperiencedSubtitle =>
      'Me siento cómodo usando herramientas digitales y disfruto explorando nuevas tecnologías';

  @override
  String get techNewLabel => 'Aún soy nuevo en esto';

  @override
  String get techNewSubtitle =>
      'No me gustan las herramientas complejas; prefiero cuando la tecnología simplemente funciona sin problemas';

  @override
  String get signInWithGoogle => 'Iniciar sesión con Google';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get emailHint => 'Ingresa tu correo electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get passwordHint => 'Ingresa tu contraseña';

  @override
  String get confirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get confirmPasswordHint => 'Repite tu contraseña';

  @override
  String get passwordUpperLower =>
      'Incluye una letra mayúscula y una minúscula';

  @override
  String get passwordMinLength => 'Al menos 8 caracteres';

  @override
  String get passwordNumber => 'Incluye al menos un número';

  @override
  String get passwordSpecial => 'Incluye un carácter especial (como !@#\$%^&)';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get termsText =>
      'Al continuar, reconoces que has leído y aceptado nuestra ';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get andText => ' y los ';

  @override
  String get termsOfUse => 'Términos de uso';

  @override
  String get personalDetailsHeading =>
      '¡Ya casi terminamos!\nCuéntanos sobre ti';

  @override
  String get personalDetailsDescription =>
      'Tu nombre y número de teléfono ayudan a los equipos a contactarte directamente.';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get nameHint => 'Ingresa tu nombre';

  @override
  String get lastNameLabel => 'Apellido';

  @override
  String get lastNameHint => 'Ingresa tu apellido';

  @override
  String get verifyEmailHeading =>
      'Verifica tu dirección de correo electrónico';

  @override
  String get verifyEmailDescription =>
      'Hemos enviado un enlace de verificación a tu dirección de correo electrónico.\nRevisa tu bandeja de entrada y sigue el enlace para completar la configuración de tu cuenta.';

  @override
  String get verifyEmailSpamHint =>
      '¿No recibiste el correo? Revisa tu carpeta de spam o reenvíalo.';

  @override
  String get verifiedEmailButton => 'He verificado mi correo electrónico';

  @override
  String get resendEmailLabel => 'Reenviar enlace por correo electrónico';

  @override
  String get verifyPhoneHeading => 'Verifica tu número de teléfono';

  @override
  String get verifyPhoneDescription =>
      'Enviaremos un código de verificación a tu número de teléfono. Elige cómo te gustaría recibirlo.';

  @override
  String get selectMethodTitle => 'Selecciona un método para recibir el código';

  @override
  String get sendViaSms => 'Enviar código seguro por SMS';

  @override
  String get sendViaWhatsapp => 'Enviar código seguro por WhatsApp';

  @override
  String get rememberChoice => 'Recordar mi elección';

  @override
  String get verifyAccountTitle => 'Vamos a verificar tu cuenta';

  @override
  String get verifyAccountSubtitle =>
      'Hemos enviado un código de verificación a tu número de teléfono.';

  @override
  String get notYourPhone => '¿Este no es tu teléfono?';

  @override
  String get resendCode => 'Reenviar código';

  @override
  String get loginHeading => 'Iniciar sesión en Ithaki Talent';

  @override
  String get loginSubtitle =>
      'Ingresa tu número de teléfono. Te enviaremos un código por SMS.';

  @override
  String loginVerifySubtitle(String phone) {
    return 'Hemos enviado un código de verificación al $phone.';
  }

  @override
  String get rememberMe => 'Recordarme';

  @override
  String get sendCodeButton => 'Enviar código';

  @override
  String get signInWithEmail => 'Iniciar sesión con correo electrónico';

  @override
  String get preferEmail =>
      '¿Prefieres el correo electrónico? Puedes iniciar sesión con tu correo en su lugar.';

  @override
  String get signInWithPhone => 'Iniciar sesión con teléfono';

  @override
  String get preferPhone =>
      '¿Prefieres el teléfono? Puedes iniciar sesión con tu teléfono en su lugar.';

  @override
  String get signInButton => 'Iniciar sesión';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get forgotPasswordHeading => 'Olvidaste tu contraseña';

  @override
  String get forgotPasswordDescription =>
      'No te preocupes. Ingresa el correo electrónico de tu cuenta y te enviaremos un enlace para restablecer tu contraseña.';

  @override
  String get backToLogin => 'Volver al inicio de sesión';

  @override
  String get sendResetLink => 'Enviar enlace de restablecimiento';

  @override
  String get resetLinkSentHeading =>
      '¡Enlace de restablecimiento de contraseña enviado!';

  @override
  String get resetLinkSentDescription =>
      'Revisa tu bandeja de entrada. El correo incluye un enlace seguro para crear una nueva contraseña. ¿No recibiste el correo?';

  @override
  String get resendResetLinkEmail => 'Reenviar enlace por correo';

  @override
  String get sendResetViaWhatsapp => 'Enviar código seguro por WhatsApp';

  @override
  String get resetPasswordHeading => 'Restablece tu contraseña';

  @override
  String get resetPasswordDescription =>
      'Último paso. Crea una nueva contraseña para proteger tu cuenta.';

  @override
  String get newPasswordLabel => 'Nueva contraseña';

  @override
  String get newPasswordHint => 'Ingresa tu nueva contraseña';

  @override
  String get confirmNewPasswordLabel => 'Confirmar nueva contraseña';

  @override
  String get confirmNewPasswordHint => 'Ingresa tu nueva contraseña';

  @override
  String get resetPasswordButton => 'Restablecer contraseña';

  @override
  String get welcomeModalHeading =>
      '¡Te damos la bienvenida a bordo!\n¡Tu cuenta ha sido creada y verificada!';

  @override
  String get welcomeModalDescription =>
      'Hagamos una breve configuración para poder conectarte con las mejores opciones de empleo.';

  @override
  String get skipForNow => 'Omitir por ahora';

  @override
  String get startSetup => 'Iniciar configuración';

  @override
  String get ithakiLogo => 'Logo-Ithaki';

  @override
  String get stepLocation => 'Ubicación';

  @override
  String get stepJobInterests => 'Intereses laborales';

  @override
  String get stepPreferences => 'Preferencias';

  @override
  String get stepValues => 'Valores';

  @override
  String get stepCommunication => 'Comunicación';

  @override
  String get locationHeading => 'Ubicación';

  @override
  String get locationDescription =>
      'Selecciona una ubicación para filtrar oportunidades de empleo relevantes.';

  @override
  String get citizenshipLabel => 'Ciudadanía';

  @override
  String get citizenshipHint => 'Selecciona un país o escribe para buscar';

  @override
  String get residenceLabel => 'Residencia';

  @override
  String get residenceHint => 'Selecciona un país o escribe para buscar';

  @override
  String get workAuthorizationLabel => 'Autorización de trabajo';

  @override
  String get workAuthorizationHint => 'Selecciona tu estado';

  @override
  String get relocationLabel => 'Disposición para reubicarse';

  @override
  String get relocationHint => 'Selecciona tu preferencia de reubicación';

  @override
  String get roleCitizen => 'Ciudadano';

  @override
  String get roleResident => 'Residente';

  @override
  String get roleWorkPermit => 'Permiso de trabajo';

  @override
  String get roleStudent => 'Estudiante';

  @override
  String get roleFreelancer => 'Autónomo/Freelance';

  @override
  String get roleJobSeeker => 'Buscador de empleo';

  @override
  String get roleExpat => 'Expatriado';

  @override
  String get relocationYes => 'Sí, dispuesto a reubicarme';

  @override
  String get relocationNo => 'No, no busco reubicarme';

  @override
  String get relocationOpen => 'Abierto a considerarlo';

  @override
  String get relocationRemote => 'Solo trabajo remoto';

  @override
  String get relocationWithinCountry => 'Solo dentro de mi país';

  @override
  String get jobInterestsHeading => 'Intereses laborales';

  @override
  String get jobInterestsDescription =>
      'Selecciona los tipos de empleo o campos que coincidan con tus intereses profesionales. Puedes agregar hasta 5 campos diferentes.';

  @override
  String get searchJobInterest => 'Buscar y agregar interés laboral';

  @override
  String get addAnotherJobInterest => 'Agregar otro interés laboral';

  @override
  String get selectJobInterest => 'Seleccionar interés laboral';

  @override
  String get preferencesHeading => 'Preferencias laborales';

  @override
  String get preferencesDescription =>
      'Establece tu salario deseado, nivel del puesto, tipo de contrato y formato de trabajo (remoto, presencial o híbrido) para ayudarnos a conectarte con las oportunidades más relevantes.';

  @override
  String get positionLevelLabel => 'Nivel del puesto';

  @override
  String get positionLevelHint => 'Selecciona tu nivel';

  @override
  String get jobTypeTitle => 'Tipo de empleo';

  @override
  String get jobTypeDescription =>
      'Elige los tipos de empleo en los que estás interesado. Puedes seleccionar más de una opción.';

  @override
  String get workplaceFormatTitle => 'Formato de trabajo';

  @override
  String get workplaceFormatDescription =>
      'Selecciona tus formatos de trabajo preferidos. Puedes seleccionar más de una opción.';

  @override
  String get positionIntern => 'Pasante';

  @override
  String get positionJunior => 'Junior';

  @override
  String get positionMid => 'Semi-Senior';

  @override
  String get positionSenior => 'Senior';

  @override
  String get positionLead => 'Líder';

  @override
  String get positionManager => 'Gerente';

  @override
  String get positionDirector => 'Director';

  @override
  String get jobFullTime => 'Tiempo completo';

  @override
  String get jobPartTime => 'Medio tiempo';

  @override
  String get jobContract => 'Por contrato';

  @override
  String get jobFreelance => 'Freelance';

  @override
  String get jobInternship => 'Pasantía';

  @override
  String get workOnSite => 'Presencial';

  @override
  String get workRemote => 'Remoto';

  @override
  String get workHybrid => 'Híbrido';

  @override
  String get payMonthly => 'Mensual';

  @override
  String get payWeekly => 'Semanal';

  @override
  String get payYearly => 'Anual';

  @override
  String get payHourly => 'Por hora';

  @override
  String get payDaily => 'Diario';

  @override
  String get valuesHeading => 'Valores';

  @override
  String valuesDescription(int max) {
    return 'Elige los valores que más te representen. Puedes elegir hasta $max.';
  }

  @override
  String get valueIntegrity => 'Integridad';

  @override
  String get valueResponsibility => 'Responsabilidad';

  @override
  String get valueTeamwork => 'Trabajo en equipo';

  @override
  String get valueRespect => 'Respeto';

  @override
  String get valueGrowth => 'Crecimiento y aprendizaje';

  @override
  String get valueInnovation => 'Innovación';

  @override
  String get valueCreativity => 'Creatividad';

  @override
  String get valueTransparency => 'Transparencia';

  @override
  String get valueEmpathy => 'Empatía';

  @override
  String get valueAccountability => 'Rendición de cuentas';

  @override
  String get valueWorkLifeBalance => 'Equilibrio trabajo-vida';

  @override
  String get valueOpenCommunication => 'Comunicación abierta';

  @override
  String get valueReliability => 'Confiabilidad';

  @override
  String get valueAdaptability => 'Adaptabilidad';

  @override
  String get valueProblemSolving => 'Resolución de problemas';

  @override
  String get valueOwnership => 'Sentido de pertenencia';

  @override
  String get valueCustomerFocus => 'Enfoque en el cliente';

  @override
  String get valueAmbition => 'Ambición';

  @override
  String get valueInitiative => 'Iniciativa';

  @override
  String get valueCollaboration => 'Colaboración';

  @override
  String get communicationHeading => 'Comunicación';

  @override
  String get communicationDescription =>
      'Elige un canal para recibir notificaciones sobre nuevas ofertas de empleo relevantes y respuestas a las solicitudes enviadas. Puedes seleccionar múltiples opciones y cambiarlas en cualquier momento.';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get sms => 'SMS';

  @override
  String get email => 'Correo electrónico';

  @override
  String get receiveTips =>
      'Recibir consejos sobre oportunidades de empleo, información sobre cursos y próximos eventos.';

  @override
  String get finishSetup => 'Finalizar configuración';

  @override
  String get searchHint => 'Buscar...';

  @override
  String get selectAction => 'Seleccionar';

  @override
  String get expectedPaymentLabel => 'Pago esperado';

  @override
  String get fromLabel => 'Desde';

  @override
  String get paymentTermTitle => 'Plazo de pago';

  @override
  String get paymentTermPlaceholder => 'Mensual';

  @override
  String get currencySymbol => '€';

  @override
  String get preferNotToSpecify => 'Prefiero no especificar';

  @override
  String get selectCountryTitle => 'Seleccionar país';

  @override
  String get phoneValidationError =>
      'Por favor, ingresa un número de teléfono válido';

  @override
  String get phoneNumberLabel => 'Número de teléfono';

  @override
  String get myApplicationsTabLabel => 'Mis solicitudes';

  @override
  String get myApplicationsTabDescription =>
      'Haz un seguimiento de todos los empleos a los que te has postulado y consulta su estado actual. También puedes revisar las invitaciones que has aceptado o buscar solicitudes pasadas en tu archivo.';

  @override
  String get myApplicationsLoadError => 'Error al cargar las solicitudes.';

  @override
  String get myApplicationsEmptyTitle => 'Aún no hay solicitudes';

  @override
  String get myApplicationsEmptySubtitle =>
      'Los empleos a los que te postules aparecerán aquí\npara que puedas seguir su estado.';

  @override
  String myInvitationsTabLabel(int count) {
    return 'Mis invitaciones ($count)';
  }

  @override
  String get draftsTabLabel => 'Borradores';

  @override
  String get archiveTabLabel => 'Archivo';

  @override
  String get invitationsTabDescription =>
      'Aquí puedes encontrar oportunidades de empleo a las que te han invitado. Revisa invitaciones de empresas u organizaciones a las que les interesó tu perfil.';

  @override
  String get invitationsLoadError => 'Error al cargar las invitaciones.';

  @override
  String get invitationsEmptyTitle => 'Aún no hay invitaciones';

  @override
  String get invitationsEmptySubtitle =>
      'Cuando a las empresas les interese tu perfil,\nte invitarán aquí.';

  @override
  String get draftsTabDescription =>
      'Aquí puedes encontrar solicitudes que empezaste pero que aún no has enviado. Continúa donde lo dejaste o descártalas.';

  @override
  String get draftsLoadError => 'Error al cargar los borradores.';

  @override
  String get draftsEmptyTitle => 'Aún no hay borradores';

  @override
  String get draftsEmptySubtitle =>
      'Las solicitudes que inicies pero no envíes\naparecerán aquí.';

  @override
  String get archiveTabDescription =>
      'Aquí puedes encontrar todas las invitaciones rechazadas y las solicitudes cerradas. Se guardan para tu referencia y pueden verse en cualquier momento.';

  @override
  String get archiveEmptyTitle => 'No hay nada en tu archivo';

  @override
  String get archiveEmptySubtitle =>
      'Las invitaciones rechazadas y solicitudes cerradas\nse guardarán aquí.';

  @override
  String get invitationDeclinedLabel => 'Invitación rechazada';

  @override
  String get viewJobDetails => 'Ver detalles del empleo';

  @override
  String get dismissInvite => 'Descartar invitación';

  @override
  String get declinedConfirmed => 'Rechazada';

  @override
  String get viewJob => 'Ver empleo';

  @override
  String get dismissBannerTitle => 'Esta invitación se moverá al Archivo';

  @override
  String get dismissBannerCountdown => 'Se auto-confirma en 5 segundos';

  @override
  String get undo => 'Deshacer';

  @override
  String get invitationDismissedToast =>
      'Invitación descartada y movida al Archivo';

  @override
  String get invitationDeclinedToast =>
      'Invitación rechazada y movida al Archivo';

  @override
  String get careerAssistantBannerTitle =>
      '¿No sabes qué hacer a continuación?';

  @override
  String get careerAssistantBannerSubtitle =>
      'En promedio, las solicitudes se revisan dentro de la primera semana. Siempre puedes pedirme ayuda con tus próximos pasos.';

  @override
  String get askCareerAssistant => 'Preguntar al Asistente de Carrera';

  @override
  String get blogNewsTitle => 'Blog y Noticias';

  @override
  String get blogNewsSubtitle =>
      'Descubre consejos de carrera, guías para entrevistas y actualizaciones de la plataforma.';

  @override
  String get blogSearchHint => 'Buscar artículos y temas';

  @override
  String get blogAllCategories => 'Todos';

  @override
  String get blogRelatedArticles => 'Artículos relacionados';

  @override
  String get blogDiscoverAll => 'Descubrir todas las noticias';

  @override
  String get blogArticleNotFound => 'Artículo no encontrado.';

  @override
  String blogArticleBy(String author) {
    return 'Por $author';
  }

  @override
  String get cardAppliedWithCv => 'Te postulaste con tu CV de Ithaki';

  @override
  String get cardJobClosed => 'El empleo está cerrado.';

  @override
  String get continueApplication => 'Continuar';

  @override
  String get viewApplication => 'Ver solicitud';

  @override
  String get applySheetTitle => '¿Listo para postularte a este puesto?';

  @override
  String get applySheetSubtitle =>
      'Asegúrate de que los detalles de tu perfil estén actualizados antes de enviar tu solicitud. También puedes subir tu CV.';

  @override
  String get applyOptionIthakiCvTitle => 'Usar CV de Ithaki';

  @override
  String get applyOptionIthakiCvSubtitle =>
      'Usa tu CV guardado y los detalles de tu perfil para postularte.';

  @override
  String get applyOptionUploadTitle => 'Sube tu CV';

  @override
  String get applyOptionUploadSubtitle =>
      'Sube un archivo nuevo (PDF o DOC) para postularte.';

  @override
  String get applyNow => 'Postularse ahora';

  @override
  String get declineSheetTitle => 'Rechazar invitación';

  @override
  String get declineSheetSubtitle =>
      '¿Estás seguro de que deseas rechazar esta invitación?';

  @override
  String get declineReasonLabel => 'Por favor, selecciona un motivo';

  @override
  String get declineReasonHint => 'Seleccionar motivo';

  @override
  String get declineReasonNotInterested => 'No me interesa este puesto';

  @override
  String get declineReasonFoundJob => 'Ya encontré un empleo';

  @override
  String get declineReasonSalary =>
      'El salario no coincide con mis expectativas';

  @override
  String get declineReasonLocation => 'La ubicación no me conviene';

  @override
  String get declineReasonOther => 'Otro';

  @override
  String get declineButton => 'Rechazar invitación';

  @override
  String get declinedButton => '✓ Rechazada';

  @override
  String get jobDetailNotFoundMessage =>
      'Aún no pudimos encontrar los detalles del empleo para esta solicitud.';

  @override
  String get backToApplications => 'Volver a Solicitudes';

  @override
  String get acceptInviteAndApply => 'Aceptar invitación y postularse';

  @override
  String get jobDetailsTitle => 'Detalles del empleo';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get open => 'Abrir';

  @override
  String get delete => 'Eliminar';

  @override
  String get appBarTitleIthaki => 'Ithaki';

  @override
  String get profileAboutMeTitle => 'Acerca de mí';

  @override
  String get profileSkillsTitle => 'Habilidades';

  @override
  String get hardSkillsTitle => 'Habilidades técnicas';

  @override
  String get softSkillsTitle => 'Habilidades blandas';

  @override
  String get competenciesTitle => 'Competencias';

  @override
  String get computerSkillsTitle => 'Conocimientos informáticos';

  @override
  String get drivingLicenseTitle => 'Licencia de conducir';

  @override
  String get licenseCategoryTitle => 'Categoría de licencia';

  @override
  String get editCompetenciesTitle => 'Editar competencias';

  @override
  String get editSkillsTitle => 'Editar habilidades';

  @override
  String get editLanguagesTitle => 'Editar idiomas';

  @override
  String get editValuesTitle => 'Valores';

  @override
  String get editAboutMeTitle => 'Acerca de mí';

  @override
  String get addBioOptional => 'Añadir biografía (opcional)';

  @override
  String get addVideoPresentationOptional =>
      'Añadir presentación en video (opcional)';

  @override
  String get uploadFile => 'Subir archivo';

  @override
  String get pasteVideoUrlHere => 'Pega la URL del video aquí';

  @override
  String get noValuesAddedYet => 'Aún no se han añadido valores.';

  @override
  String get profileMyFilesTitle => 'Mis archivos';

  @override
  String get couldNotOpenVideoIntroduction =>
      'No se pudo abrir el video de presentación.';

  @override
  String openFileNoSource(String fileName) {
    return '$fileName no tiene un origen de archivo para abrir.';
  }

  @override
  String couldNotOpenFile(String fileName) {
    return 'No se pudo abrir $fileName.';
  }

  @override
  String openingFile(String fileName) {
    return 'Abriendo $fileName';
  }

  @override
  String get openCv => 'Abrir CV';

  @override
  String get accountSettings => 'Configuración de la cuenta';

  @override
  String get editJobPreferencesTitle => 'Preferencias de empleo';

  @override
  String get positionLevelOptionalLabel => 'Nivel del puesto (opcional)';

  @override
  String get selectLevel => 'Seleccionar nivel';

  @override
  String get profileEducationTitle => 'Educación';

  @override
  String get profileEducationSubtitle =>
      'Añade información sobre tus antecedentes educativos, título y campo de estudio.';

  @override
  String get addEducation => 'Añadir educación';

  @override
  String get editEducation => 'Editar educación';

  @override
  String get institutionNameLabel => 'Nombre de la institución';

  @override
  String get institutionNameHint => 'Ej. Universidad de Atenas';

  @override
  String get fieldOfStudyLabel => 'Campo de estudio';

  @override
  String get fieldOfStudyHint => 'Ej. Ingeniería de Software';

  @override
  String get degreeTypeLabel => 'Tipo de título';

  @override
  String get selectDegree => 'Seleccionar título';

  @override
  String get startDateLabel => 'Fecha de inicio';

  @override
  String get endDateLabel => 'Fecha de finalización';

  @override
  String get mmYyyyHint => 'MM-AAAA';

  @override
  String get currentlyStudyHere => 'Actualmente estudio aquí';

  @override
  String get profileWorkExperienceTitle => 'Experiencia laboral';

  @override
  String get profileWorkExperienceSubtitle =>
      'Añade detalles sobre tus roles y empresas anteriores';

  @override
  String get addWorkExperience => 'Añadir experiencia laboral';

  @override
  String get editWorkExperience => 'Editar experiencia laboral';

  @override
  String get jobTitleLabel => 'Título del puesto';

  @override
  String get jobTitleHint => 'Ej. Desarrollador de Software';

  @override
  String get companyNameLabel => 'Nombre de la empresa';

  @override
  String get companyNameHint => 'Ej. Acme Corp';

  @override
  String get experienceSummaryOptional => 'Resumen de experiencia (opcional)';

  @override
  String get experienceSummaryHint => 'Describe tu rol y logros...';

  @override
  String get currentlyWorkHere => 'Actualmente trabajo aquí';

  @override
  String charactersCounter(int current, int max) {
    return '$current / $max caracteres';
  }

  @override
  String get dateOfBirthLabel => 'Fecha de nacimiento';

  @override
  String get yourFirstNameHint => 'Tu nombre';

  @override
  String get yourLastNameHint => 'Tu apellido';

  @override
  String get genderLabel => 'Género';

  @override
  String get selectGender => 'Seleccionar género';

  @override
  String get selectCountry => 'Seleccionar país';

  @override
  String get statusLabel => 'Estado';

  @override
  String get selectStatus => 'Seleccionar estado';

  @override
  String get relocationReadinessLabel => 'Disposición para reubicarse';

  @override
  String get selectOption => 'Seleccionar opción';

  @override
  String get fileExceedsLimit => 'El archivo supera el límite de 5 MB';

  @override
  String get leaveEditingTitle => '¿Abandonar la edición?';

  @override
  String get leaveEditingMessage =>
      'Toda la información ingresada se perderá si sales de esta pantalla.';

  @override
  String get leaveWithoutSaving => 'Salir sin guardar';

  @override
  String get saveAndLeave => 'Guardar y salir';

  @override
  String get highLabel => 'Alto';

  @override
  String get genderInfoLabel => 'Género';

  @override
  String get ageInfoLabel => 'Edad';

  @override
  String get locationInfoLabel => 'Ubicación';

  @override
  String get showFullCv => 'Mostrar CV completo';

  @override
  String get coverLetterTitle => 'Carta de presentación';

  @override
  String get screeningQuestionsTitle => 'Preguntas de preselección';

  @override
  String get aboutCompanyTitle => 'Acerca de la empresa';

  @override
  String get teamTitle => 'Equipo';

  @override
  String get companyProfile => 'Perfil de la empresa';

  @override
  String get typeCityToSearch => 'Escribe la ciudad para buscar';

  @override
  String get experienceLevelLabel => 'Nivel de experiencia';

  @override
  String get workplaceLabel => 'Lugar de trabajo';

  @override
  String get selectWorkplace => 'Seleccionar lugar de trabajo';

  @override
  String get selectJobType => 'Seleccionar tipo de empleo';

  @override
  String get skillsDescription =>
      'Selecciona las habilidades que mejor representen tus calificaciones y experiencia profesional.';

  @override
  String get addSkillHint => 'Empieza a escribir para añadir una habilidad';

  @override
  String errorLoadingSkills(String error) {
    return 'Error al cargar habilidades: $error';
  }

  @override
  String chooseValuesDescription(int max) {
    return 'Elige hasta $max valores que representen mejor lo que más te importa profesionalmente.';
  }

  @override
  String get videoIntroductionTitle => 'Video de presentación';

  @override
  String get editAboutMeVideo => 'Editar Acerca de mí y Video de presentación';

  @override
  String get addAboutMeInformation => 'Añadir información de Acerca de mí';

  @override
  String get aboutMeEmptyDescription =>
      'Añade unas palabras sobre ti para ayudar a los equipos a entender quién eres y qué haces.';

  @override
  String get addSkills => 'Añadir habilidades';

  @override
  String get addCompetencies => 'Añadir competencias';

  @override
  String get addLanguages => 'Añadir idiomas';

  @override
  String get editLanguages => 'Editar idiomas';

  @override
  String get languagesTitle => 'Idiomas';

  @override
  String get aboutMeEditDescription =>
      'Proporciona información básica sobre ti. Esto nos ayuda a configurar tu perfil y personalizar tu experiencia. Puedes añadir información más tarde o actualizarla en cualquier momento en tu Perfil.';

  @override
  String get addBioDescription =>
      'Añade unas palabras sobre ti para ayudar a los equipos a entender quién eres y qué haces. Recomendamos que sea conciso, evitando el relleno innecesario y destacando habilidades y experiencia clave.';

  @override
  String get addVideoDescription =>
      'Añade un video corto para presentarte a los equipos, destacar tu experiencia y mostrar tus habilidades. Un video te ayuda a sobresalir entre otros candidatos.';

  @override
  String get uploadViaUrl => 'Subir a través de URL';

  @override
  String get uploadInstructions =>
      'toca el botón para explorar (máximo 10 archivos, hasta 5 MB\ncada uno; formatos admitidos: .pdf, .doc, .png, .jpg)';

  @override
  String get uploadVideoInstructions =>
      'toca el botón para subir un video (formatos admitidos: .mp4, .mov, .avi, .mkv, .webm)';

  @override
  String get playVideo => 'Reproducir video';

  @override
  String get pauseVideo => 'Pausar video';

  @override
  String get selectCategory => 'Seleccionar categoría';

  @override
  String categoryLabel(String category) {
    return 'Categoría $category';
  }

  @override
  String get iHaveGreekLicense => 'Tengo licencia griega';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get languageFieldLabel => 'Idioma';

  @override
  String get selectLanguageHint => 'Seleccionar idioma';

  @override
  String get searchLanguage => 'Buscar idioma';

  @override
  String get loadingLanguages => 'Cargando idiomas...';

  @override
  String get noLanguagesAvailable =>
      'No hay idiomas disponibles en este momento.';

  @override
  String get proficiencyLevel => 'Nivel de dominio';

  @override
  String get addAnotherLanguage => 'Añadir otro idioma';

  @override
  String get editJobsPreferences => 'Editar preferencias de empleo';

  @override
  String get assessmentsResultsTitle => 'Resultados de las evaluaciones';

  @override
  String get companyTabVacancies => 'Vacantes';

  @override
  String get companyTabAboutCompany => 'Acerca de la empresa';

  @override
  String get companyTabEvents => 'Eventos';

  @override
  String get companyTabPosts => 'Publicaciones';

  @override
  String companyJobsFound(int count) {
    return '$count empleos encontrados';
  }

  @override
  String get companyNoVacancies => 'No hay vacantes abiertas en este momento.';

  @override
  String get saveJob => 'Guardar empleo';

  @override
  String get entryLevel => 'Inicial';

  @override
  String get companyPerksTitle => 'Beneficios y ventajas';

  @override
  String get companyGalleryTitle => 'Galería de la empresa';

  @override
  String get companyNoEvents => 'No hay próximos eventos.';

  @override
  String get companyEventsTitle => 'Eventos de la empresa';

  @override
  String get companyPostsTitle => 'Publicaciones de la empresa';

  @override
  String companyPostsFound(int count) {
    return '$count publicaciones encontradas';
  }

  @override
  String get companyNoPostsYet => 'Aún no hay publicaciones de la empresa.';

  @override
  String get shareButton => 'Compartir';

  @override
  String get culturalMatchScore => 'Puntuación de afinidad cultural';

  @override
  String get culturalMatchDescription =>
      'Tú y esta empresa eligieron sus 5 valores y preferencias principales. Esta puntuación muestra qué tan bien se alinean.';

  @override
  String get culturalMatchYouBothCareAbout => 'A ambos les importa:';

  @override
  String companyTeamEmployees(String teamSize) {
    return '$teamSize empleados';
  }

  @override
  String get companyLabelMainOffice => 'Ubicación de la oficina principal';

  @override
  String get companyLabelOtherLocations => 'Otras ubicaciones';

  @override
  String get companyLabelContactPhone => 'Teléfono de contacto';

  @override
  String get companyLabelWebsite => 'Sitio web';

  @override
  String get notAvailable => 'N/D';

  @override
  String get eventDetailsTitle => 'Detalles del evento';

  @override
  String get eventAddressLabel => 'Dirección';

  @override
  String get eventRegistrationLink => 'Enlace de registro';

  @override
  String get companyLoadError => 'No se pudo cargar la empresa.';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get assessmentsRecommendedForYou =>
      'Evaluaciones recomendadas para ti';

  @override
  String get assessmentYourScore => 'Tu puntuación';

  @override
  String get assessmentLevel => 'Nivel';

  @override
  String get assessmentSkillBreakdown => 'Desglose de habilidades';

  @override
  String get assessmentKeyInsights => 'Conocimientos clave';

  @override
  String get assessmentPreviousResults => 'Resultados anteriores';

  @override
  String get assessmentYouImproving => '¡Estás mejorando!';

  @override
  String get assessmentMeansForProfile => 'Qué significa esto para tu perfil';

  @override
  String get assessmentAboutThis => 'Acerca de esta evaluación';

  @override
  String get assessmentUsedFor => 'Para qué se utiliza esta evaluación';

  @override
  String get assessmentBeforeStart => 'Antes de empezar';

  @override
  String get assessmentApproxDuration => 'Duración aproximada';

  @override
  String get assessmentQuestionsLabel => 'Preguntas';

  @override
  String get bannerNotSureJob =>
      '¿No estás seguro de cómo encontrar el empleo adecuado?';

  @override
  String get chatNewChat => 'Nuevo chat';

  @override
  String get chatSearchInChats => 'Buscar en los chats';

  @override
  String get chatHistory => 'Historial de chat';

  @override
  String get homeNeedRefresher => '¿Necesitas un repaso rápido?';

  @override
  String get homeCvSuccess => 'Éxito de tu CV';

  @override
  String get homeStatViews => 'Vistas';

  @override
  String get homeStatInvitations => 'Invitaciones';

  @override
  String get homeStatApplicationsSent => 'Solicitudes enviadas';

  @override
  String get homeStatInterviews => 'Entrevistas';

  @override
  String get homeRecommendedCourses => 'Cursos recomendados';

  @override
  String get homeLatestNews => 'Últimas noticias';

  @override
  String get homeSmartJobRecommendations =>
      'Recomendaciones inteligentes de empleo';

  @override
  String get viewAll => 'Ver todo';

  @override
  String get searchByJobTitle => 'Buscar por título de empleo';

  @override
  String get jobLoadError => 'No se pudo cargar el empleo.';

  @override
  String get jobRemovedFromSaved => 'Eliminado de empleos guardados.';

  @override
  String get jobSavedMessage =>
      '¡El empleo ha sido guardado! Revisa tus empleos guardados.';

  @override
  String get jobPostRemoved => 'La publicación del empleo ha sido eliminada';

  @override
  String get deadlineReminderSet =>
      'Se ha configurado el recordatorio de fecha límite. Te notificaremos una semana antes de que finalice.';

  @override
  String get readMore => 'Leer más';

  @override
  String jobPostedDate(String date) {
    return 'Publicado $date';
  }

  @override
  String get postedToday => 'Publicado hoy';

  @override
  String get postedOneDayAgo => 'Publicado hace 1 día';

  @override
  String postedDaysAgo(int count) {
    return 'Publicado hace $count días';
  }

  @override
  String postedWeeksAgo(int count) {
    return 'Publicado hace $count semanas';
  }

  @override
  String postedMonthsAgo(int count) {
    return 'Publicado hace $count meses';
  }

  @override
  String appliedToday(String time) {
    return 'Solicitud enviada hoy $time';
  }

  @override
  String appliedYesterday(String time) {
    return 'Solicitud enviada ayer $time';
  }

  @override
  String appliedOnDate(String date, String time) {
    return 'Solicitud enviada el $date, $time';
  }

  @override
  String get jobClosedLabel => 'Cerrado';

  @override
  String get deadlineReminderLabel => 'Recordatorio de fecha límite';

  @override
  String get reportLabel => 'Denunciar';

  @override
  String get reminderSetNotification =>
      'Has configurado un recordatorio para este empleo';

  @override
  String get odysseaReviewLabel => 'Revisión de Odyssea: ';

  @override
  String get recommendedForYouLabel => 'Recomendado para ti';

  @override
  String get tabAllJobs => 'Todos los empleos';

  @override
  String tabSavedJobs(int count) {
    return 'Guardados ($count)';
  }

  @override
  String get sortingTitle => 'Ordenar por';

  @override
  String get sortMostRelevant => 'Más relevantes';

  @override
  String get sortSalaryHighToLow => 'Salario: de mayor a menor';

  @override
  String get sortSalaryLowToHigh => 'Salario: de menor a mayor';

  @override
  String get sortDateRecent => 'Fecha: reciente';

  @override
  String get sortDateLatest => 'Fecha: última';

  @override
  String get filtersTitle => 'Filtros';

  @override
  String get resetFilters => 'Restablecer filtros';

  @override
  String get applyFilters => 'Aplicar filtros';

  @override
  String get filterAllLabel => 'Todos';

  @override
  String get filterClear => 'Borrar';

  @override
  String get applyFilter => 'Aplicar filtro';

  @override
  String get salaryTitle => 'Salario';

  @override
  String get tillLabel => 'Hasta';

  @override
  String get reportJobTitle => '¿Denunciar este empleo?';

  @override
  String get selectReasonHint => 'Seleccionar motivo';

  @override
  String get setReminderTitle => 'Configurar un recordatorio';

  @override
  String get applicationOpenTill => 'Solicitudes abiertas hasta:';

  @override
  String get whenShouldRemind => '¿Cuándo deberíamos recordarte?';

  @override
  String get reminderTomorrow => 'Mañana';

  @override
  String get reminderTomorrowSub =>
      'El recordatorio se enviará mañana a esta hora';

  @override
  String get reminderOneWeek => 'En una semana';

  @override
  String get reminderOneWeekSub =>
      'El recordatorio se enviará la próxima semana a esta hora';

  @override
  String get reminderOneDayBefore => 'Un día antes de la fecha límite';

  @override
  String get reminderOneDayBeforeSub =>
      'El recordatorio se enviará un día antes del cierre';

  @override
  String get reminderCustomDate => 'Elegir una fecha personalizada';

  @override
  String get reminderCustomDateSub =>
      'Elige una fecha personalizada para tu recordatorio';

  @override
  String get selectDateLabel => 'Seleccionar fecha';

  @override
  String get selectTimeLabel => 'Seleccionar hora';

  @override
  String get ddMmYyyyHint => 'DD-MM-AAAA';

  @override
  String reminderViaContactSub(String contact) {
    return 'Enviaremos un recordatorio a:\n$contact';
  }

  @override
  String get reminderViaSmsWhatsapp => 'SMS / WhatsApp';

  @override
  String get changeEmailTitle => 'Cambiar correo electrónico';

  @override
  String get newEmailLabel => 'Nuevo correo electrónico';

  @override
  String get newEmailHint => 'Ingresa un nuevo correo electrónico';

  @override
  String get changePasswordTitle => 'Cambiar contraseña';

  @override
  String get repeatNewPasswordLabel => 'Repetir nueva contraseña';

  @override
  String get repeatNewPasswordHint => 'Repite tu nueva contraseña';

  @override
  String get changePhoneTitle => 'Cambiar número de teléfono';

  @override
  String get newPhoneNumberLabel => 'Nuevo número de teléfono';

  @override
  String get confirmAccountDeletion => 'Confirmar eliminación de la cuenta';

  @override
  String get typeDeleteToConfirm => 'Escribe \'eliminar\' para confirmar';

  @override
  String get enterDeleteHint => 'Escribe \"eliminar\"';

  @override
  String get deleteAccountButton => 'Eliminar cuenta';

  @override
  String get makeProfileInvisible => '¿Hacer que tu perfil sea invisible?';

  @override
  String get switchToLite => '¿Cambiar a Ithaki Lite?';

  @override
  String get verificationTitle => 'Verificación';

  @override
  String get pushNotifications => 'Notificaciones Push';

  @override
  String get unsubscribe => 'Darse de baja';

  @override
  String get noMoreJobInterests =>
      'No hay más intereses laborales disponibles para agregar.';

  @override
  String get roleMigrant => 'Migrante';

  @override
  String get roleRefugee => 'Refugiado';

  @override
  String get roleAsylumSeeker => 'Solicitante de asilo';

  @override
  String homeGreetingName(String name) {
    return '¡Hola, $name!';
  }

  @override
  String get homeGreetingNoName => '¡Hola!';

  @override
  String get homeGreetingSubtitle =>
      'Aquí tienes un resumen rápido de tus últimas coincidencias de empleo, actualizaciones y consejos útiles para avanzar en tu carrera.';

  @override
  String get homeRestartProductTourSubtitle =>
      'Reinicia el recorrido del producto cuando quieras desde el Inicio.';

  @override
  String get homeRestartProductTour => 'Reiniciar recorrido del producto';

  @override
  String get homeCareerAssistantBannerSubtitle =>
      '¡El Asistente de Carrera puede ayudarte si no estás seguro por dónde empezar!';

  @override
  String get homeCoursesSubtitle =>
      'Mejora tus habilidades con cursos que te ayudan a crecer más rápido y a mantenerte alineado con los estándares actuales de la industria. Aprende a tu propio ritmo y refuerza la experiencia en tu perfil.';

  @override
  String get homeProfileCompleteYourProfile => 'Completa tu perfil';

  @override
  String get homeProfileWelcomeTitle => '¡Te damos la bienvenida a Ithaki!';

  @override
  String get homeProfileFillMissing =>
      'Completa la información faltante para desbloquear toda tu experiencia en la plataforma. Un perfil completo te ayuda a obtener mejores coincidencias de empleo y más invitaciones.';

  @override
  String get homeProfileBenefitsTitle => 'Beneficios de completar tu perfil';

  @override
  String get profileCompletionAboutMe => 'Acerca de mí';

  @override
  String get profileCompletionPhoto => 'Foto';

  @override
  String get profileCompletionExperience => 'Mi experiencia';

  @override
  String get profileCompletionEducation => 'Mi educación';

  @override
  String get profileCompletionSkills => 'Mis habilidades';

  @override
  String get profileCompletionDocuments => 'Documentos';

  @override
  String get homeProfileFillButton => 'Completar perfil';

  @override
  String get homeQuestionsTitle => '¿Tienes preguntas?';

  @override
  String get homeQuestionsSubtitle => '¡Déjanos ayudarte!';

  @override
  String get homeQuestionsButton => 'Programar llamada con un consejero';

  @override
  String get assessmentStartNew => 'Iniciar nueva evaluación';

  @override
  String assessmentsInProgressTitle(int count) {
    return 'Evaluaciones en progreso ($count)';
  }

  @override
  String get assessmentsInProgressSubtitle =>
      'Tienes evaluaciones en progreso. Complétalas para ver tus resultados.';

  @override
  String get assessmentsRecommendedSubtitle =>
      'Te recomendamos estas evaluaciones para ayudarte a validar tus habilidades.';

  @override
  String get assessmentsCompletedTitle => 'Tus evaluaciones completadas';

  @override
  String get assessmentsCompletedSubtitle =>
      'Aquí están tus evaluaciones completadas y los resultados.';

  @override
  String get assessmentStartTitle => 'Iniciar la evaluación';

  @override
  String get assessmentStartSubtitle =>
      'Estás a punto de comenzar la siguiente evaluación';

  @override
  String get assessmentStartNow => 'Empezar ahora';

  @override
  String get assessmentContinueTitle => '¿Continuar tu evaluación?';

  @override
  String get assessmentContinueSubtitle =>
      'Ya has iniciado esta evaluación y tienes el progreso guardado. ¿Te gustaría continuar donde lo dejaste o empezar de nuevo?';

  @override
  String get assessmentStartOver => 'Empezar de nuevo';

  @override
  String get assessmentSkillBreakdownSubtitle =>
      'Este desglose muestra cómo se distribuyen tus resultados en áreas de habilidades clave.';

  @override
  String get assessmentResultsConfirmSkills =>
      'Este resultado confirma tus habilidades, las cuales se reflejan en tus solicitudes de empleo en la plataforma.';

  @override
  String get assessmentShowInCV => 'Mostrar resultado en mi CV';

  @override
  String get assessmentHideFromCV => 'Ocultar en mi CV';

  @override
  String assessmentTakenLabel(String date) {
    return 'Tomado: $date';
  }

  @override
  String get assessmentImprovingSubtitle =>
      'Tus resultados muestran una mejora constante en cómo abordas y resuelves problemas relacionados con el trabajo.';

  @override
  String get assessmentProcessingTitle => '¡Procesando tus resultados!';

  @override
  String get assessmentProcessingSubtitle =>
      'Has completado la evaluación con éxito. Ahora estamos generando tus resultados, esto tomará solo un momento.';

  @override
  String get assessmentLeaveTitle => '¿Abandonar esta página?';

  @override
  String get assessmentLeaveSubtitle =>
      'Estás a punto de salir de esta evaluación. Tu progreso se guardará automáticamente y podrás continuar más tarde.';

  @override
  String get assessmentLeaveButton => 'Abandonar';

  @override
  String get quizSelectOneAnswer => 'Selecciona solo una respuesta';

  @override
  String quizSelectUpToAnswers(int max) {
    return 'Selecciona hasta $max respuestas';
  }

  @override
  String get quizSelectBestReflects =>
      'Selecciona la opción que mejor refleje cómo te sientes usualmente.';

  @override
  String get quizNoResults => 'No se encontraron resultados';

  @override
  String get edit => 'Editar';

  @override
  String get present => 'Presente';

  @override
  String get cvCouldNotLoadTitle => 'No pudimos cargar tu CV.';

  @override
  String get cvCouldNotLoadMessage =>
      'Intenta actualizar los datos de tu perfil y ábrelo nuevamente.';

  @override
  String get goToProfile => 'Ir al Perfil';

  @override
  String get publishCv => 'Publicar CV';

  @override
  String get downloadCv => 'Descargar CV';

  @override
  String get cvDownloadSoon => 'La descarga del CV estará disponible pronto.';

  @override
  String get returnToProfileSetup => 'Volver a la configuración del perfil';

  @override
  String get publishedBadge => 'Publicado';

  @override
  String get draftModeBadge => 'Modo borrador';

  @override
  String get cvDraftReviewTitle =>
      'Este es tu CV; así es como te ven las empresas.';

  @override
  String get cvDraftReviewBody =>
      'Por favor, revisa toda la información cuidadosamente y realiza los cambios necesarios antes de publicar tu CV.\nSi tu CV no está publicado, las empresas no podrán revisarlo.\nPuedes actualizar tu información en cualquier momento desde el Perfil. Tu CV se actualizará automáticamente.';

  @override
  String get contactVisibilityNote =>
      'Tus detalles de contacto permanecerán ocultos hasta que te postules a un empleo o aceptes una invitación.';

  @override
  String get youBothShareSameValues => 'Ambos comparten los mismos valores';

  @override
  String get learnMore => 'Más información';

  @override
  String get greatJob => '¡Buen trabajo!';

  @override
  String get cvLevelLabel => 'Tu nivel de CV:';

  @override
  String get strongLevel => 'SÓLIDO';

  @override
  String get cvAssistantImprovementSummary =>
      'El asistente encontró 4 áreas que puedes mejorar para aumentar tus posibilidades de conseguir un empleo en aproximadamente un 15%.';

  @override
  String get careerAssistantTitle => 'Tu Asistente de Carrera';

  @override
  String get pathfinderName => 'Pathfinder';

  @override
  String get pathfinderAdviceText =>
      '¡Hola! Soy Pathfinder, tu asistente de carrera.\nHe revisado tu perfil y he encontrado algunas mejoras rápidas:\n\n- Crítico: La foto de tu perfil se ve borrosa. Sube una clara y profesional para dar una mejor primera impresión.\n- Recomendado: Agrega más detalles a tu experiencia laboral: especifica qué lograste para mostrar tu impacto real.\n- Menor: Graba una breve introducción en video. Ayuda a los equipos a conectarse contigo y hace que tu perfil se destaque.\nEstas pequeñas actualizaciones aumentarán notablemente tu credibilidad y visibilidad.';

  @override
  String get askCareerPathHint =>
      'Pregúntame sobre tu trayectoria profesional...';

  @override
  String get leaveWithoutPublishingTitle => '¿Salir sin publicar?';

  @override
  String get leaveWithoutPublishingMessage =>
      'Si sales de esta página, tu CV no se publicará y las empresas no podrán revisarlo. Siempre puedes publicarlo más tarde desde tu perfil, pero te recomendamos publicarlo ahora para aumentar tus posibilidades de conseguir empleos.';

  @override
  String get notSpecified => 'No especificado';

  @override
  String get workspaceLabel => 'Lugar de trabajo';

  @override
  String get levelLabel => 'Nivel';

  @override
  String get desiredSalaryLabel => 'Salario deseado';

  @override
  String get jobPreferencesTabDescription =>
      'Esto muestra el empleo que buscas actualmente. Puedes cambiar esto en cualquier momento.';

  @override
  String get preferencesSectionTitle => 'Preferencias';

  @override
  String experienceAtCompany(String role, String company) {
    return '$role en $company';
  }

  @override
  String educationAtInstitution(String field, String institution) {
    return '$field en\n$institution';
  }

  @override
  String periodWithDuration(String start, String end, String duration) {
    return '$start - $end ($duration)';
  }

  @override
  String assessmentCategoryLabel(String category) {
    return 'Evaluación de $category';
  }

  @override
  String get jobPreferencesUpdated =>
      'Tus preferencias de empleo se han actualizado.';

  @override
  String get updateButton => 'Actualizar';

  @override
  String get currentEmailLabel => 'Correo electrónico actual';

  @override
  String get updateEmailDescription =>
      'Actualiza tu dirección de correo electrónico';

  @override
  String get deleteAccountDescription =>
      'Para eliminar tu cuenta permanentemente, escribe \'eliminar\' en el campo a continuación.\nEsta acción no se puede deshacer: todos tus datos se eliminarán para siempre.';

  @override
  String get communicationChannelTitle => 'Canal de comunicación';

  @override
  String get emailNewsletterTitle => 'Boletín por correo electrónico';

  @override
  String get emailNewsletterDescription =>
      '¡Mantente informado y aprovecha al máximo tu experiencia! Elige qué tipos de actualizaciones y perspectivas te gustaría recibir directamente en tu bandeja de entrada.';

  @override
  String get newsletterActive => '(activo)';

  @override
  String get newsletterInactive => '(inactivo)';

  @override
  String get subscribe => 'Suscribirse';

  @override
  String get settingsUpdatedSuccessfully =>
      'Configuración actualizada con éxito.';

  @override
  String get newsletterJobsTitle => 'Recomendaciones de empleo';

  @override
  String get newsletterJobsSubtitle =>
      'Ofertas de empleo personalizadas basadas en tus habilidades y preferencias';

  @override
  String get newsletterCareerTipsTitle => 'Consejos de carrera';

  @override
  String get newsletterCareerTipsSubtitle =>
      'Consejos de expertos y recursos para impulsar tu crecimiento profesional';

  @override
  String get newsletterEventsTitle => 'Eventos y Webinars';

  @override
  String get newsletterEventsSubtitle =>
      'Próximos eventos de carrera, talleres y sesiones de networking';

  @override
  String get newsletterPlatformTitle => 'Actualizaciones de la plataforma';

  @override
  String get newsletterPlatformSubtitle =>
      'Nuevas funciones, herramientas y mejoras de producto';

  @override
  String get newsletterLearningTitle => 'Oportunidades de aprendizaje';

  @override
  String get newsletterLearningSubtitle =>
      'Cursos en línea y certificaciones para mejorar tus habilidades';

  @override
  String get uploadFilesTitle => 'Subir archivos';

  @override
  String get uploadMore => 'Subir más';

  @override
  String get uploadFileInstructions =>
      'Toca el botón para explorar\n(máximo 10 archivos, hasta 5 MB cada uno;\nsoportados: .pdf, .doc, .png, .jpg)';

  @override
  String get documentUrlDescription =>
      'Proporciona un enlace a un documento para importarlo al sistema.';

  @override
  String get documentUrlMustBeActive =>
      'El enlace debe estar activo y accesible sin iniciar sesión.';

  @override
  String get documentUrlSupportedFormats =>
      'El documento debe estar en un formato admitido (PDF, DOC, DOCX).';

  @override
  String get documentUrlCommonServices =>
      'Servicios comunes: Google Drive, Dropbox, iCloud.';

  @override
  String get documentLinkHint => 'Añadir enlace del documento';

  @override
  String get fileComplete => 'Completado';

  @override
  String get fileUploading => 'Subiendo...';

  @override
  String get fileFallbackLabel => 'ARCHIVO';

  @override
  String get profileMenuMyProfile => 'Mi Perfil';

  @override
  String get profileMenuMyCv => 'Mi CV';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get goToJobSearch => 'Ir a Buscar empleo';

  @override
  String get startProductTour => 'Iniciar recorrido del producto';

  @override
  String get continueProductTour => 'Continuar recorrido del producto';

  @override
  String get skipAndClose => 'Omitir y cerrar';

  @override
  String get finish => 'Finalizar';

  @override
  String get nextButton => 'Siguiente';

  @override
  String tourStepIndicator(int current, int total) {
    return 'Paso $current / $total';
  }

  @override
  String get tourReadyTitle => '¡Estás listo!';

  @override
  String get tourReadyBody =>
      'Ahora conoces las características principales de la plataforma. Completa tu perfil, realiza evaluaciones y postúlate a empleos que coincidan contigo.';

  @override
  String get tourWelcomeTitle => '¡Comencemos!';

  @override
  String get tourWelcomeBody =>
      'Aquí puedes encontrar un empleo que se ajuste a tus habilidades y experiencia. Vamos paso a paso.';

  @override
  String get tourSkipTitle => '¿Omitir por ahora?';

  @override
  String get tourSkipBody =>
      'Siempre puedes tomar el recorrido del producto más tarde usando el banner en la página de Inicio.';

  @override
  String get tourStep1Title => '¡Ponte en marcha!';

  @override
  String get tourStep1Body =>
      'Aquí verás empleos y cursos seleccionados para ti, perspectivas sobre tu CV y herramientas que te ayudarán a comenzar a buscar empleo.';

  @override
  String get tourStep2Title => 'Encontrar un empleo';

  @override
  String get tourStep2Body =>
      'Busca empleos por nombre o elige de las categorías de abajo. Puedes encontrar trabajo cerca de tu ciudad o establecer otros parámetros para encontrar lo que necesitas.';

  @override
  String get tourStep3Title => 'Publicación de empleo';

  @override
  String get tourStep3Body =>
      'Cada tarjeta de empleo muestra la información principal: puesto, ubicación y salario. Toca la tarjeta para abrir los detalles completos y postularte.';

  @override
  String get tourStep4Title => 'Mira qué tan bien se adapta este empleo a ti';

  @override
  String get tourStep4Body =>
      'Esta parte muestra cómo tu experiencia y habilidades coinciden con el empleo. Cuanto mayor sea la coincidencia, mejores serán tus oportunidades.';

  @override
  String get tourStep5Title => 'Detalles del empleo';

  @override
  String get tourStep5Body =>
      'Lee la descripción completa del empleo, los requisitos y lo que ofrece la empresa antes de postularte.';

  @override
  String get tourStep6Title => 'Fácil de postularse';

  @override
  String get tourStep6Body =>
      '¡Postularse es fácil! Selecciona el formato de tu CV y añade unas palabras sobre ti en la Carta de presentación para aumentar tus posibilidades.';

  @override
  String get tourStep7Title => 'Sigue tu progreso';

  @override
  String get tourStep7Body =>
      'Una vez que te postules a un empleo, podrás encontrar la respuesta en Mis solicitudes.';

  @override
  String get tourStep8Title => 'Mis invitaciones';

  @override
  String get tourStep8Body =>
      'Las empresas pueden invitarte directamente. Puedes revisar invitaciones relevantes de equipos interesados en tu perfil.';

  @override
  String get tourStep9Title => '¡Ponte en marcha!';

  @override
  String get tourStep9Body =>
      'Puedes abrir la invitación para leer los detalles del empleo y aceptar la oferta.';

  @override
  String get tourStep10Title => 'Crea tu perfil';

  @override
  String get tourStep10Body =>
      'Tu perfil muestra tu experiencia, habilidades e información de contacto. Un perfil completo te ayuda a conseguir mejores empleos. Puedes editarlo o actualizarlo en cualquier momento.';

  @override
  String get tourStep11Title => 'Conoce a tu Asistente de Carrera';

  @override
  String get tourStep11Body =>
      'Pathfinder puede ayudarte a mejorar tu perfil, encontrar los empleos adecuados y responder a tus preguntas sobre el trabajo.';

  @override
  String get tourStep12Title => 'Centro de Aprendizaje';

  @override
  String get tourStep12Body =>
      'Accede a cursos y recursos adaptados a tus objetivos profesionales y a las habilidades que buscan las empresas.';

  @override
  String get tourStep13Title => 'Conócete mejor';

  @override
  String get tourStep13Body =>
      'Aquí puedes realizar diferentes evaluaciones. Tus resultados ayudan a resaltar tus puntos fuertes y tu estilo de trabajo.';

  @override
  String get changePasswordDescription =>
      'Cambia tu contraseña para mantener tu cuenta segura';

  @override
  String get passwordUpdated => 'Tu contraseña ha sido actualizada.';

  @override
  String get currentPhoneNumberLabel => 'Número de teléfono actual';

  @override
  String get makeProfileInvisibleDescription =>
      'Si haces que tu perfil sea invisible, las empresas no podrán encontrarte en las búsquedas de candidatos. Seguirás pudiendo postularte a los empleos que te interesen. Puedes cambiar la visibilidad de tu perfil en cualquier momento en la configuración de tu cuenta.';

  @override
  String get makeProfileInvisibleButton => 'Hacer perfil invisible';

  @override
  String get switchLiteDescription =>
      'La interfaz será más simple y fácil de usar. Te mostraremos solo los empleos que mejor coincidan con tus intereses laborales.\nPuedes volver a la interfaz completa en cualquier momento.';

  @override
  String get switchLiteButton => 'Cambiar a Ithaki Lite';

  @override
  String get switchedToLite => 'Se ha cambiado a Ithaki Lite.';

  @override
  String get submit => 'Enviar';

  @override
  String newValueLabel(String type) {
    return 'Nuevo $type';
  }

  @override
  String codeSentToContact(String contact) {
    return 'Se ha enviado un código de 6 dígitos a tu $contact.';
  }

  @override
  String get phoneViaSms => 'teléfono por SMS';

  @override
  String get changedEmail => 'Tu correo electrónico ha sido cambiado.';

  @override
  String get changedPhone => 'Tu número de teléfono ha sido cambiado.';

  @override
  String get jobReportedMessage =>
      'La publicación del empleo ha sido reportada';

  @override
  String get copyLink => 'Copiar enlace';

  @override
  String get shareWhatsappSms => 'Compartir por WhatsApp/SMS';

  @override
  String get shareInEmail => 'Compartir por correo electrónico';

  @override
  String get shareOnLinkedIn => 'Compartir en LinkedIn';

  @override
  String get industryLabel => 'Industria';

  @override
  String get travelLabel => 'Viajar';

  @override
  String get reportJobDescription =>
      'Denunciar empleos nos ayuda a mantener las publicaciones con los más altos niveles de calidad.';

  @override
  String get tellUsMoreOptional => 'Cuéntanos más (opcional)';

  @override
  String get reportThisJobButton => 'Denunciar este empleo';

  @override
  String get setReminderButton => 'Configurar recordatorio';

  @override
  String get reminderChoiceTitle =>
      '¿Cómo te gustaría recibir el recordatorio?';

  @override
  String get reminderViaEmail =>
      'Enviaremos un recordatorio por correo electrónico';

  @override
  String get reminderViaSmsWhatsappGeneric =>
      'Enviaremos un recordatorio por SMS/WhatsApp';

  @override
  String get jobClosedButton => 'Empleo cerrado';

  @override
  String get removeFromSaved => 'Eliminar de Guardados';

  @override
  String get newFeatureBanner =>
      '¡Nuevo en Ithaki! Acabamos de lanzar una nueva función que facilita la búsqueda de empleo.';

  @override
  String get curiousWhyMatch =>
      '¿Tienes curiosidad por saber por qué coincides con este empleo?';

  @override
  String get strongSkillsMatch =>
      '¡Es una coincidencia\nSólida de habilidades!';

  @override
  String get goodSkillsMatch => '¡Es una coincidencia\nBuena de habilidades!';

  @override
  String get partialSkillsMatch =>
      '¡Es una coincidencia\nParcial de habilidades!';

  @override
  String get starterSkillsMatch =>
      '¡Es una coincidencia\nBásica de habilidades!';

  @override
  String get deadlineBannerText =>
      '¡Este empleo tiene una fecha límite! Solicitudes\nabiertas hasta:';

  @override
  String get skillsRequired => 'Habilidades requeridas';

  @override
  String get aboutRoleTitle => 'Acerca del puesto';

  @override
  String get requirementsTitle => 'Requisitos';

  @override
  String get niceToHaveTitle => 'Deseable';

  @override
  String get weOfferTitle => 'Ofrecemos';

  @override
  String get shareJob => 'Compartir empleo';

  @override
  String get notInterested => 'No me interesa';

  @override
  String get deleteReminder => 'Eliminar recordatorio';

  @override
  String get salaryRangeLabel => 'Rango salarial';

  @override
  String get responsibilitiesTitle => 'Responsabilidades';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get assessmentNotFound => 'Evaluación no encontrada';

  @override
  String get testDetails => 'Detalles de la prueba';

  @override
  String get startTest => 'Iniciar prueba';

  @override
  String get viewDetails => 'Ver detalles';

  @override
  String get inCv => 'En CV';

  @override
  String get showInCv => 'Mostrar en CV';

  @override
  String questionsCount(int count) {
    return '$count preguntas';
  }

  @override
  String durationMinutes(int count) {
    return '$count min';
  }

  @override
  String rangeNumberSubtitle(
      int min, int max, String minLabel, String maxLabel) {
    return 'Selecciona un número del $min al $max, donde $min significa \"$minLabel\" y $max significa \"$maxLabel\".';
  }

  @override
  String get addJobInterestTitle => 'Añadir interés laboral';

  @override
  String get searchCityTitle => 'Buscar ciudad';

  @override
  String get typeCityHint => 'Escribe el nombre de una ciudad...';

  @override
  String get citySearchTypeMore => 'Escribe al menos 2 caracteres';

  @override
  String get citySearchNoResults => 'No se encontraron ciudades';

  @override
  String get photoFileLimit => '5 MB máx. · PNG o JPG';

  @override
  String get photoRecommendation =>
      'Te recomendamos una foto profesional que muestre tu rostro con claridad.';

  @override
  String get uploadPhoto => 'Subir foto';

  @override
  String get replacePhoto => 'Reemplazar foto';

  @override
  String get screeningQuestionsSubtitle =>
      'Aquí están tus respuestas a algunas preguntas del empleador';

  @override
  String get toJobDetails => 'A detalles del empleo';

  @override
  String get whatWeOfferTitle => 'Lo que ofrecemos';

  @override
  String get employeeReviewsTitle => 'Reseñas de empleados';

  @override
  String get applyButton => 'Postularse';

  @override
  String get shareLabel => 'Compartir:';

  @override
  String get readArticle => 'Leer artículo';

  @override
  String get chatGetStartedHint =>
      'Puedes empezar con un ejemplo a continuación';

  @override
  String get chatWithCareerAssistant => 'Chatea con tu\nAsistente de Carrera';

  @override
  String get chatHistorySubtitle =>
      'Puedes buscar en todos tus chats anteriores usando palabras clave o frases.';

  @override
  String get chatHistorySearchHint =>
      'Escribe una palabra o frase para buscar mensajes...';

  @override
  String get chatHistoryToday => 'Hoy';

  @override
  String get chatHistoryLast7Days => 'Últimos 7 días';

  @override
  String get chatThinking => 'Pensando...';

  @override
  String get chatSearchMessagesHint => 'Buscar mensajes...';

  @override
  String get culturalFitLabel => 'Afinidad cultural';

  @override
  String savedJobsCountLabel(String count) {
    return '$count empleos guardados';
  }

  @override
  String jobsFoundLabel(String count) {
    return '$count empleos encontrados';
  }

  @override
  String jobSearchPageStatus(int current, int total) {
    return 'Página $current de $total';
  }

  @override
  String get noSavedJobsYet => 'Aún no hay empleos guardados.';

  @override
  String get notificationsLabel => 'Notificaciones';

  @override
  String get notificationsScreenSubtitle =>
      'Aquí puedes ver todas tus novedades. Mantente al día con las actualizaciones importantes.';

  @override
  String notificationsUnreadCount(int count) {
    return 'Tienes $count notificaciones nuevas';
  }

  @override
  String get markAllAsRead => 'Marcar todo como leído';

  @override
  String get accountInformationTitle => 'Información de la cuenta';

  @override
  String get accountInformationSubtitle =>
      'Gestiona los detalles de tu cuenta para mantenerla segura y actualizada.';

  @override
  String get profileVisibilityTitle => 'Visibilidad del perfil';

  @override
  String get profileVisibleForEmployers => 'Perfil visible para empleadores';

  @override
  String get profileHiddenFromEmployers => 'Perfil oculto a empleadores';

  @override
  String get profileVisibilityDescription =>
      'En este momento, los empleadores pueden ver tu perfil y enviarte invitaciones. Si prefieres más privacidad, puedes ocultar tu perfil: solo será visible cuando te postules a un empleo.';

  @override
  String get hideProfileFromEmployers => 'Ocultar perfil a los empleadores';

  @override
  String get showProfileToEmployers => 'Mostrar perfil a los empleadores';

  @override
  String get digitalComfortTitle => 'Comodidad digital';

  @override
  String get digitalComfortExperienced =>
      'Eres un usuario con experiencia técnica';

  @override
  String get digitalComfortDescription =>
      'Estás utilizando nuestra experiencia completa ahora mismo, ideal para usuarios seguros con la tecnología. Si en algún momento quieres una interfaz más sencilla, puedes cambiar a la versión ligera cuando lo desees.';

  @override
  String get tryIthakiLite => 'Probar Ithaki Lite';

  @override
  String get deleteAnAccount => 'Eliminar una cuenta';

  @override
  String get deleteAccountTabDescription =>
      'Elimina de forma permanente tu cuenta y todos los datos relacionados del sistema. Esta acción no se puede deshacer.';

  @override
  String get jobInterestsStillLoading =>
      'Los intereses laborales aún se están cargando. Inténtalo de nuevo en un momento.';

  @override
  String get failedToLoadJobInterests =>
      'Error al cargar los intereses laborales.';

  @override
  String get relocationNegative => 'Sin disposición a reubicarse';

  @override
  String get relocationLocally => 'Dispuesto a reubicarse a nivel local';

  @override
  String get relocationNationally => 'Dispuesto a reubicarse a nivel nacional';

  @override
  String get relocationInternationally =>
      'Dispuesto a reubicarse a nivel internacional';

  @override
  String get positionInternYears => '0 años';

  @override
  String get positionJuniorYears => '0–2 años';

  @override
  String get positionMidYears => '2–5 años';

  @override
  String get positionSeniorYears => '5–8 años';

  @override
  String get positionLeadYears => '8–12 años';

  @override
  String get positionManagerYears => '10+ años';

  @override
  String get positionDirectorYears => '12+ años';

  @override
  String get jobCouldNotLoad =>
      'No pudimos cargar este empleo en este momento.';

  @override
  String get navHome => 'Inicio';

  @override
  String get navJobSearch => 'Buscar empleo';

  @override
  String get navMyApplications => 'Mis solicitudes';

  @override
  String get navCareerAssistant => 'Asistente de Carrera';

  @override
  String get navMyAssessments => 'Mis evaluaciones';

  @override
  String get navBlogNews => 'Blog y Noticias';

  @override
  String get profileTabJobPreferences => 'Preferencias de empleo';

  @override
  String get profileTabAboutMe => 'Acerca de mí';

  @override
  String get profileTabSkills => 'Habilidades';

  @override
  String get profileTabWorkExperience => 'Experiencia laboral';

  @override
  String get profileTabEducation => 'Educación';

  @override
  String get profileTabFiles => 'Archivos';

  @override
  String get profileTabValues => 'Valores';

  @override
  String get profileLoadError =>
      'No se pudo cargar tu perfil.\nComprueba tu conexión e inténtalo de nuevo.';

  @override
  String get retryButton => 'Reintentar';

  @override
  String get profilePartialLoadWarning =>
      'No se pudieron cargar algunos datos del perfil. Mostrando datos en caché.';

  @override
  String get editProfileBasicsButton => 'Editar información básica del perfil';

  @override
  String get ageLabel => 'Edad';

  @override
  String get locationLabel => 'Ubicación';

  @override
  String get profileFilesDescription =>
      'Sube certificados, CV, fotos o cualquier otro archivo que muestre tus calificaciones.';
}
