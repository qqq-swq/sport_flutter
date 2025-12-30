// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Deporte Flutter';

  @override
  String get upNext => 'Siguiente';

  @override
  String videoViews(num count, Object date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vistas',
      one: '1 vista',
      zero: 'Sin vistas',
    );
    return '$_temp0 • $date';
  }

  @override
  String daysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count días',
      one: 'Hace 1 día',
      zero: 'Hoy',
    );
    return '$_temp0';
  }

  @override
  String weeksAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count semanas',
      one: 'Hace 1 semana',
      zero: 'Esta semana',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count horas',
      one: 'Hace 1 hora',
      zero: 'Justo ahora',
    );
    return '$_temp0';
  }

  @override
  String minutesAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count minutos',
      one: 'Hace 1 minuto',
      zero: 'Justo ahora',
    );
    return '$_temp0';
  }

  @override
  String get justNow => 'Justo ahora';

  @override
  String get showMore => 'Mostrar más';

  @override
  String get showLess => 'Mostrar menos';

  @override
  String get dislike => 'No me gusta';

  @override
  String get favorite => 'Favorito';

  @override
  String get tenThousand => 'mil';

  @override
  String get home => 'Inicio';

  @override
  String get community => 'Comunidad';

  @override
  String get profile => 'Perfil';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get invalidUsernameOrPassword =>
      'Nombre de usuario o contraseña inválidos';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get enterUsername => 'Por favor, ingresa tu nombre de usuario';

  @override
  String get password => 'Contraseña';

  @override
  String get enterPassword => 'Por favor, ingresa tu contraseña';

  @override
  String get dontHaveAnAccount => '¿No tienes una cuenta? Regístrate';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get myProfile => 'Mi perfil';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get myPosts => 'Mis publicaciones';

  @override
  String get myFavorites => 'Mis favoritos';

  @override
  String get language => 'Idioma';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get logoutConfirmation =>
      '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirmLogout => 'Cerrar sesión';

  @override
  String get easy => 'Fácil';

  @override
  String get medium => 'Medio';

  @override
  String get hard => 'Difícil';

  @override
  String get ultimate => 'Definitivo';

  @override
  String get invalidEmail => 'Dirección de correo electrónico inválida';

  @override
  String get register => 'Registrarse';

  @override
  String get registrationSuccessful => 'Registro exitoso';

  @override
  String get codeSent => 'Código de verificación enviado';

  @override
  String get email => 'Correo electrónico';

  @override
  String get enterValidEmail =>
      'Por favor, ingresa una dirección de correo electrónico válida';

  @override
  String get passwordTooShort =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get verificationCode => 'Código de verificación';

  @override
  String get enterVerificationCode =>
      'Por favor, ingresa el código de verificación';

  @override
  String get sendVerificationCode => 'Enviar código';

  @override
  String get agreement => 'Al registrarte, aceptas nuestra ';

  @override
  String get createPost => 'Crear publicación';

  @override
  String get publish => 'Publicar';

  @override
  String get title => 'Título';

  @override
  String get content => 'Contenido';

  @override
  String get deletePost => 'Eliminar publicación';

  @override
  String get deletePostConfirmation =>
      '¿Estás seguro de que quieres eliminar esta publicación?';

  @override
  String get delete => 'Eliminar';

  @override
  String get comments => 'Comentarios';

  @override
  String get privacyPolicyContent =>
      'Esta Política de Privacidad describe nuestras políticas y procedimientos sobre la recolección, uso y divulgación de tu información cuando usas el Servicio y te informa sobre tus derechos de privacidad y cómo la ley te protege. Usamos tus datos personales para proporcionar y mejorar el Servicio. Al usar el Servicio, aceptas la recolección y uso de información de acuerdo con esta Política de Privacidad.\n\n**Recolección y uso de información**\n\n**Tipos de datos recolectados**\n*   **Datos personales:** Al usar nuestro Servicio, podemos pedirte que nos proporciones cierta información personal identificable que pueda usarse para contactarte o identificarte. La información personal identificable puede incluir, pero no se limita a: dirección de correo electrónico, nombre de usuario y foto de perfil.\n*   **Datos de uso:** Los datos de uso se recolectan automáticamente al usar el Servicio. Esto puede incluir información como la dirección IP de tu dispositivo, tipo de navegador, versión del navegador, las páginas de nuestro Servicio que visitas, la fecha y hora de tu visita, el tiempo que pasas en esas páginas, identificadores únicos de dispositivo y otros datos de diagnóstico.\n*   **Contenido generado por el usuario:** Recolectamos el contenido que creas en nuestro Servicio, que incluye videos e imágenes que subes, comentarios que publicas, me gustas y favoritos.\n\n**Uso de tus datos personales**\nLa Compañía puede usar datos personales para los siguientes fines:\n*   Proporcionar y mantener nuestro Servicio, incluyendo monitorear el uso de nuestro Servicio.\n*   Gestionar tu Cuenta: gestionar tu registro como usuario del Servicio.\n*   Contactarte: Para contactarte por correo electrónico con respecto a actualizaciones o comunicaciones informativas relacionadas con las funcionalidades, productos o servicios contratados.\n*   Proporcionarte noticias, ofertas especiales e información general sobre otros bienes, servicios y eventos que ofrecemos.\n*   Gestionar tus solicitudes: Atender y gestionar tus solicitudes a nosotros.\n\n**Divulgación de tu información**\nNo vendemos tu información personal. Podemos compartir tu información con proveedores de servicios de terceros que prestan servicios en nuestro nombre, como servicios de alojamiento y análisis.';

  @override
  String get introduction => 'Introducción';

  @override
  String replyingTo(String username) {
    return 'Respondiendo a $username';
  }

  @override
  String get postYourComment => 'Publica tu comentario';

  @override
  String get beTheFirstToComment => 'Se el primero en comentar';

  @override
  String viewAllReplies(int count) {
    return 'Ver todas las $count respuestas';
  }

  @override
  String commentDetails(int count) {
    return '$count respuestas';
  }

  @override
  String get addAComment => 'Agregar un comentario';

  @override
  String get replies => 'Respuestas';

  @override
  String fileLimitExceeded(int count) {
    return 'Solo puedes seleccionar hasta $count archivos.';
  }

  @override
  String get selectPicturesFromAlbum => 'Selecciona imágenes del álbum';

  @override
  String get selectVideoFromAlbum => 'Selecciona video del álbum';

  @override
  String get sportVideos => 'Videos deportivos';

  @override
  String get resetPassword => 'Restablecer contraseña';

  @override
  String get resetYourPassword => 'Restablece tu contraseña';

  @override
  String get resetPasswordInstruction =>
      'Por favor, ingresa tu dirección de correo electrónico. Te enviaremos un código de verificación para restablecer tu contraseña.';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get confirmNewPassword => 'Confirmar nueva contraseña';

  @override
  String get passwordsDoNotMatch => 'Las dos contraseñas no coinciden';

  @override
  String get confirmReset => 'Confirmar restablecimiento';

  @override
  String get passwordResetSuccessLogin =>
      'La contraseña se ha restablecido. Por favor, inicia sesión.';

  @override
  String get usernameAndEmailMismatch =>
      'El nombre de usuario y el correo electrónico no coinciden';

  @override
  String get noRepliesYet => 'Aún no hay respuestas.';

  @override
  String get invitationCode => 'Código de invitación';

  @override
  String get incorrectInvitationCode => 'Código de invitación incorrecto';

  @override
  String get pleaseRequestVerificationCodeFirst =>
      'Por favor, solicita el código de verificación primero';

  @override
  String get invalidVerificationCode => 'Código de verificación inválido.';

  @override
  String get videoLoadError => 'No se pudo cargar el video';

  @override
  String get noPostsYet => 'No posts yet. Be the first to post!';
}
