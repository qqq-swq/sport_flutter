// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Sport Flutter';

  @override
  String get upNext => 'Suivant';

  @override
  String videoViews(num count, Object date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vues',
      one: '1 vue',
      zero: 'Aucune vue',
    );
    return '$_temp0 • $date';
  }

  @override
  String daysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count jours',
      one: 'Il y a 1 jour',
      zero: 'Aujourd\'hui',
    );
    return '$_temp0';
  }

  @override
  String weeksAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count semaines',
      one: 'Il y a 1 semaine',
      zero: 'Cette semaine',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count heures',
      one: 'Il y a 1 heure',
      zero: 'À l\'instant',
    );
    return '$_temp0';
  }

  @override
  String minutesAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count minutes',
      one: 'Il y a 1 minute',
      zero: 'À l\'instant',
    );
    return '$_temp0';
  }

  @override
  String get justNow => 'À l\'instant';

  @override
  String get showMore => 'Voir plus';

  @override
  String get showLess => 'Voir moins';

  @override
  String get dislike => 'Ne pas aimer';

  @override
  String get favorite => 'Favori';

  @override
  String get tenThousand => 'k';

  @override
  String get home => 'Accueil';

  @override
  String get community => 'Communauté';

  @override
  String get profile => 'Profil';

  @override
  String get login => 'Se connecter';

  @override
  String get invalidUsernameOrPassword =>
      'Nom d\'utilisateur ou mot de passe invalide';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get enterUsername => 'Veuillez entrer votre nom d\'utilisateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get enterPassword => 'Veuillez entrer votre mot de passe';

  @override
  String get dontHaveAnAccount => 'Pas de compte ? S\'inscrire';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get myProfile => 'Mon profil';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get myPosts => 'Mes publications';

  @override
  String get myFavorites => 'Mes favoris';

  @override
  String get language => 'Langue';

  @override
  String get editProfile => 'Éditer le profil';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get logoutConfirmation =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirmLogout => 'Se déconnecter';

  @override
  String get easy => 'Facile';

  @override
  String get medium => 'Moyen';

  @override
  String get hard => 'Difficile';

  @override
  String get ultimate => 'Ultime';

  @override
  String get invalidEmail => 'Adresse e-mail invalide';

  @override
  String get register => 'S\'inscrire';

  @override
  String get registrationSuccessful => 'Inscription réussie';

  @override
  String get codeSent => 'Code de vérification envoyé';

  @override
  String get email => 'E-mail';

  @override
  String get enterValidEmail => 'Veuillez entrer une adresse e-mail valide';

  @override
  String get passwordTooShort =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get verificationCode => 'Code de vérification';

  @override
  String get enterVerificationCode => 'Veuillez entrer le code de vérification';

  @override
  String get sendVerificationCode => 'Envoyer le code';

  @override
  String get agreement => 'En vous inscrivant, vous acceptez notre ';

  @override
  String get createPost => 'Créer une publication';

  @override
  String get publish => 'Publier';

  @override
  String get title => 'Titre';

  @override
  String get content => 'Contenu';

  @override
  String get deletePost => 'Supprimer la publication';

  @override
  String get deletePostConfirmation =>
      'Êtes-vous sûr de vouloir supprimer cette publication ?';

  @override
  String get delete => 'Supprimer';

  @override
  String get comments => 'Commentaires';

  @override
  String get privacyPolicyContent =>
      'La présente Politique de confidentialité décrit nos politiques et procédures relatives à la collecte, l\'utilisation et la divulgation de vos informations lorsque vous utilisez le Service et vous informe de vos droits en matière de confidentialité et de la manière dont la loi vous protège. Nous utilisons vos données personnelles pour fournir et améliorer le Service. En utilisant le Service, vous acceptez la collecte et l\'utilisation des informations conformément à la présente Politique de confidentialité.\n\n**Collecte et utilisation des informations**\n\n**Types de données collectées**\n*   **Données personnelles :** Lors de l\'utilisation de notre Service, nous pouvons vous demander de nous fournir certaines informations personnellement identifiables qui peuvent être utilisées pour vous contacter ou vous identifier. Les informations personnellement identifiables peuvent inclure, mais ne sont pas limitées à : adresse e-mail, nom d\'utilisateur et photo de profil.\n*   **Données d\'utilisation :** Les données d\'utilisation sont collectées automatiquement lors de l\'utilisation du Service. Cela peut inclure des informations telles que l\'adresse IP de votre appareil, le type de navigateur, la version du navigateur, les pages de notre Service que vous visitez, la date et l\'heure de votre visite, le temps passé sur ces pages, les identifiants d\'appareil uniques et autres données de diagnostic.\n*   **Contenu généré par l\'utilisateur :** Nous collectons le contenu que vous créez sur notre Service, y compris les vidéos et images que vous téléchargez, les commentaires que vous publiez, les likes et les favoris.\n\n**Utilisation de vos données personnelles**\nLa Société peut utiliser les données personnelles à以下es fins :\n*   Pour fournir et maintenir notre Service, y compris pour surveiller l\'utilisation de notre Service.\n*   Pour gérer votre Compte : pour gérer votre inscription en tant qu\'utilisateur du Service.\n*   Pour vous contacter : Pour vous contacter par e-mail concernant des mises à jour ou des communications informatives relatives aux fonctionnalités, produits ou services contractés.\n*   Pour vous fournir des nouvelles, des offres spéciales et des informations générales sur autres biens, services et événements que nous proposons.\n*   Pour gérer vos demandes : Pour traiter et gérer vos demandes auprès de nous.\n\n**Divulgation de vos informations**\nNous ne vendons pas vos informations personnelles. Nous pouvons partager vos informations avec des prestataires de services tiers qui effectuent des services en notre nom, tels que les services d\'hébergement et l\'analyse.';

  @override
  String get introduction => 'Introduction';

  @override
  String replyingTo(String username) {
    return 'Répondre à $username';
  }

  @override
  String get postYourComment => 'Publier votre commentaire';

  @override
  String get beTheFirstToComment => 'Soyez le premier à commenter';

  @override
  String viewAllReplies(int count) {
    return 'Voir toutes les $count réponses';
  }

  @override
  String commentDetails(int count) {
    return '$count réponses';
  }

  @override
  String get addAComment => 'Ajouter un commentaire';

  @override
  String get replies => 'Réponses';

  @override
  String fileLimitExceeded(int count) {
    return 'Vous ne pouvez sélectionner que jusqu\'à $count fichiers.';
  }

  @override
  String get selectPicturesFromAlbum =>
      'Sélectionner des photos depuis l\'album';

  @override
  String get selectVideoFromAlbum => 'Sélectionner une vidéo depuis l\'album';

  @override
  String get sportVideos => 'Vidéos sportives';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get resetYourPassword => 'Réinitialiser votre mot de passe';

  @override
  String get resetPasswordInstruction =>
      'Veuillez entrer votre adresse e-mail. Nous vous enverrons un code de vérification pour réinitialiser votre mot de passe.';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get confirmNewPassword => 'Confirmer le nouveau mot de passe';

  @override
  String get passwordsDoNotMatch =>
      'Les deux mots de passe ne correspondent pas';

  @override
  String get confirmReset => 'Confirmer la réinitialisation';

  @override
  String get passwordResetSuccessLogin =>
      'Le mot de passe a été réinitialisé. Veuillez vous connecter.';

  @override
  String get usernameAndEmailMismatch =>
      'Le nom d\'utilisateur et l\'e-mail ne correspondent pas';

  @override
  String get noRepliesYet => 'Aucune réponse pour l\'instant.';

  @override
  String get invitationCode => 'Code d\'invitation';

  @override
  String get incorrectInvitationCode => 'Code d\'invitation incorrect';

  @override
  String get pleaseRequestVerificationCodeFirst =>
      'Veuillez d\'abord demander le code de vérification';

  @override
  String get invalidVerificationCode => 'Code de vérification invalide.';

  @override
  String get videoLoadError => 'Impossible de charger la vidéo';

  @override
  String get noPostsYet => 'No posts yet. Be the first to post!';
}
