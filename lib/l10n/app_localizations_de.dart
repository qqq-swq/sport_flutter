// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Sport Flutter';

  @override
  String get upNext => 'Nächste';

  @override
  String videoViews(num count, Object date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Aufrufe',
      one: '1 Aufruf',
      zero: 'Keine Aufrufe',
    );
    return '$_temp0 • $date';
  }

  @override
  String daysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vor $count Tagen',
      one: 'Vor 1 Tag',
      zero: 'Heute',
    );
    return '$_temp0';
  }

  @override
  String weeksAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vor $count Wochen',
      one: 'Vor 1 Woche',
      zero: 'Diese Woche',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vor $count Stunden',
      one: 'Vor 1 Stunde',
      zero: 'Gerade eben',
    );
    return '$_temp0';
  }

  @override
  String minutesAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vor $count Minuten',
      one: 'Vor 1 Minute',
      zero: 'Gerade eben',
    );
    return '$_temp0';
  }

  @override
  String get justNow => 'Gerade eben';

  @override
  String get showMore => 'Mehr anzeigen';

  @override
  String get showLess => 'Weniger anzeigen';

  @override
  String get dislike => 'Nicht mögen';

  @override
  String get favorite => 'Favorit';

  @override
  String get tenThousand => 'Tsd.';

  @override
  String get home => 'Startseite';

  @override
  String get community => 'Community';

  @override
  String get profile => 'Profil';

  @override
  String get login => 'Anmelden';

  @override
  String get invalidUsernameOrPassword =>
      'Ungültiger Benutzername oder Passwort';

  @override
  String get username => 'Benutzername';

  @override
  String get enterUsername => 'Bitte geben Sie Ihren Benutzernamen ein';

  @override
  String get password => 'Passwort';

  @override
  String get enterPassword => 'Bitte geben Sie Ihr Passwort ein';

  @override
  String get dontHaveAnAccount => 'Kein Konto? Registrieren';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get myProfile => 'Mein Profil';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get myPosts => 'Meine Beiträge';

  @override
  String get myFavorites => 'Meine Favoriten';

  @override
  String get language => 'Sprache';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get logout => 'Abmelden';

  @override
  String get logoutConfirmation => 'Möchten Sie sich wirklich abmelden?';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirmLogout => 'Abmelden';

  @override
  String get easy => 'Einfach';

  @override
  String get medium => 'Mittel';

  @override
  String get hard => 'Schwer';

  @override
  String get ultimate => 'Ultimativ';

  @override
  String get invalidEmail => 'Ungültige E-Mail-Adresse';

  @override
  String get register => 'Registrieren';

  @override
  String get registrationSuccessful => 'Registrierung erfolgreich';

  @override
  String get codeSent => 'Verifizierungscode gesendet';

  @override
  String get email => 'E-Mail';

  @override
  String get enterValidEmail =>
      'Bitte geben Sie eine gültige E-Mail-Adresse ein';

  @override
  String get passwordTooShort =>
      'Das Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get verificationCode => 'Verifizierungscode';

  @override
  String get enterVerificationCode =>
      'Bitte geben Sie den Verifizierungscode ein';

  @override
  String get sendVerificationCode => 'Code senden';

  @override
  String get agreement => 'Mit der Registrierung stimmen Sie unserer ';

  @override
  String get createPost => 'Beitrag erstellen';

  @override
  String get publish => 'Veröffentlichen';

  @override
  String get title => 'Titel';

  @override
  String get content => 'Inhalt';

  @override
  String get deletePost => 'Beitrag löschen';

  @override
  String get deletePostConfirmation =>
      'Möchten Sie diesen Beitrag wirklich löschen?';

  @override
  String get delete => 'Löschen';

  @override
  String get comments => 'Kommentare';

  @override
  String get privacyPolicyContent =>
      'Diese Datenschutzrichtlinie beschreibt unsere Richtlinien und Verfahren zum Sammeln, Verwenden und Weitergeben Ihrer Informationen, wenn Sie den Dienst nutzen, und informiert Sie über Ihre Privatsphäre Rechte und wie das Gesetz Sie schützt. Wir verwenden Ihre personenbezogenen Daten, um den Dienst bereitzustellen und zu verbessern. Durch die Nutzung des Dienstes stimmen Sie der Sammlung und Verwendung von Informationen entsprechend dieser Datenschutzrichtlinie zu.\n\n**Sammlung und Verwendung von Informationen**\n\n**Arten der erfassten Daten**\n*   **Personenbezogene Daten:** Bei der Nutzung unseres Dienstes können wir Sie bitten, uns bestimmte personenbezogene Informationen zur Verfügung zu stellen, mit denen Sie kontaktiert oder identifiziert werden können. Personenbezogene Informationen können unter anderem Folgendes umfassen: E-Mail-Adresse, Benutzername und Profilbild.\n*   **Nutzungsdaten:** Nutzungsdaten werden automatisch bei der Nutzung des Dienstes erfasst. Dies kann Informationen wie die Internetprotokolladresse (z. B. IP-Adresse) Ihres Geräts, den Browsertyp, die Browserversion, die Seiten unseres Dienstes, die Sie besuchen, das Datum und die Uhrzeit Ihres Besuchs, die auf diesen Seiten verbrachte Zeit, eindeutige Geräteidentifikatoren und andere Diagnosedaten umfassen.\n*   **Von Benutzern erzeugte Inhalte:** Wir erfassen die Inhalte, die Sie auf unserem Dienst erstellen, einschließlich Videos und Bildern, die Sie hochladen, Kommentaren, die Sie posten, Likes und Favoriten.\n\n**Verwendung Ihrer personenbezogenen Daten**\nDas Unternehmen kann personenbezogene Daten für folgende Zwecke verwenden:\n*   Um unseren Dienst bereitzustellen und zu warten, einschließlich der Überwachung der Nutzung unseres Dienstes.\n*   Um Ihr Konto zu verwalten: Um Ihre Registrierung als Benutzer des Dienstes zu verwalten.\n*   Um Sie zu kontaktieren: Um Sie per E-Mail über Updates oder informative Mitteilungen im Zusammenhang mit den Funktionen, Produkten oder abgeschlossenen Dienstleistungen zu informieren.\n*   Um Ihnen Nachrichten, Sonderangebote und allgemeine Informationen zu anderen Waren, Dienstleistungen und Veranstaltungen zukommen zu lassen, die wir anbieten.\n*   Um Ihre Anfragen zu bearbeiten: Um Ihre Anfragen an uns entgegenzunehmen und zu bearbeiten.\n\n**Weitergabe Ihrer Informationen**\nWir verkaufen Ihre personenbezogenen Informationen nicht. Wir können Ihre Informationen an Drittanbieter weitergeben, die im Namen unserer Firma Dienstleistungen erbringen, wie z. B. Hosting-Dienstleistungen und Analysen.';

  @override
  String get introduction => 'Einführung';

  @override
  String replyingTo(String username) {
    return 'Antwort an $username';
  }

  @override
  String get postYourComment => 'Kommentar posten';

  @override
  String get beTheFirstToComment => 'Sei der Erste, der kommentiert';

  @override
  String viewAllReplies(int count) {
    return 'Alle $count Antworten anzeigen';
  }

  @override
  String commentDetails(int count) {
    return '$count Antworten';
  }

  @override
  String get addAComment => 'Kommentar hinzufügen';

  @override
  String get replies => 'Antworten';

  @override
  String fileLimitExceeded(int count) {
    return 'Sie können maximal $count Dateien auswählen.';
  }

  @override
  String get selectPicturesFromAlbum => 'Bilder aus Album auswählen';

  @override
  String get selectVideoFromAlbum => 'Video aus Album auswählen';

  @override
  String get sportVideos => 'Sportvideos';

  @override
  String get resetPassword => 'Passwort zurücksetzen';

  @override
  String get resetYourPassword => 'Passwort zurücksetzen';

  @override
  String get resetPasswordInstruction =>
      'Bitte geben Sie Ihre E-Mail-Adresse ein. Wir senden Ihnen einen Verifizierungscode, um Ihr Passwort zurückzusetzen.';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get confirmNewPassword => 'Neues Passwort bestätigen';

  @override
  String get passwordsDoNotMatch =>
      'Die beiden Passwörter stimmen nicht überein';

  @override
  String get confirmReset => 'Zurücksetzung bestätigen';

  @override
  String get passwordResetSuccessLogin =>
      'Passwort wurde zurückgesetzt. Bitte melden Sie sich an.';

  @override
  String get usernameAndEmailMismatch =>
      'Benutzername und E-Mail stimmen nicht überein';

  @override
  String get noRepliesYet => 'Noch keine Antworten.';

  @override
  String get invitationCode => 'Einladungscode';

  @override
  String get incorrectInvitationCode => 'Falscher Einladungscode';

  @override
  String get pleaseRequestVerificationCodeFirst =>
      'Bitte fordern Sie zuerst den Verifizierungscode an';

  @override
  String get invalidVerificationCode => 'Ungültiger Verifizierungscode.';

  @override
  String get videoLoadError => 'Video konnte nicht geladen werden';

  @override
  String get noPostsYet => 'No posts yet. Be the first to post!';
}
