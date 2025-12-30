// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Sport Flutter';

  @override
  String get upNext => 'Далее';

  @override
  String videoViews(num count, Object date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count просмотров',
      many: '$count просмотров',
      few: '$count просмотра',
      one: '$count просмотр',
      zero: 'Нет просмотров',
    );
    return '$_temp0 • $date';
  }

  @override
  String daysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дней назад',
      many: '$count дней назад',
      few: '$count дня назад',
      one: '$count день назад',
      zero: 'Сегодня',
    );
    return '$_temp0';
  }

  @override
  String weeksAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count недель назад',
      many: '$count недель назад',
      few: '$count недели назад',
      one: '$count неделю назад',
      zero: 'На этой неделе',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count часов назад',
      many: '$count часов назад',
      few: '$count часа назад',
      one: '$count час назад',
      zero: 'только что',
    );
    return '$_temp0';
  }

  @override
  String minutesAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count минут назад',
      many: '$count минут назад',
      few: '$count минуты назад',
      one: '$count минуту назад',
      zero: 'только что',
    );
    return '$_temp0';
  }

  @override
  String get justNow => 'только что';

  @override
  String get showMore => 'Показать больше';

  @override
  String get showLess => 'Показать меньше';

  @override
  String get dislike => 'Не нравится';

  @override
  String get favorite => 'Избранное';

  @override
  String get tenThousand => ' тыс.';

  @override
  String get home => 'Главная';

  @override
  String get community => 'Сообщество';

  @override
  String get profile => 'Профиль';

  @override
  String get login => 'Войти';

  @override
  String get invalidUsernameOrPassword =>
      'Неверное имя пользователя или пароль';

  @override
  String get username => 'Имя пользователя';

  @override
  String get enterUsername => 'Пожалуйста, введите имя пользователя';

  @override
  String get password => 'Пароль';

  @override
  String get enterPassword => 'Пожалуйста, введите пароль';

  @override
  String get dontHaveAnAccount => 'Нет аккаунта? Зарегистрироваться';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get myProfile => 'Мой профиль';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get myPosts => 'Мои посты';

  @override
  String get myFavorites => 'Мое избранное';

  @override
  String get language => 'Язык';

  @override
  String get editProfile => 'Редактировать профиль';

  @override
  String get selectLanguage => 'Выберите язык';

  @override
  String get logout => 'Выйти';

  @override
  String get logoutConfirmation => 'Вы уверены, что хотите выйти?';

  @override
  String get cancel => 'Отмена';

  @override
  String get confirmLogout => 'Выйти';

  @override
  String get easy => 'Легко';

  @override
  String get medium => 'Средне';

  @override
  String get hard => 'Сложно';

  @override
  String get ultimate => 'Ультра';

  @override
  String get invalidEmail => 'Неверный адрес электронной почты';

  @override
  String get register => 'Зарегистрироваться';

  @override
  String get registrationSuccessful => 'Регистрация успешна';

  @override
  String get codeSent => 'Код подтверждения отправлен';

  @override
  String get email => 'Эл. почта';

  @override
  String get enterValidEmail =>
      'Пожалуйста, введите действительный адрес электронной почты';

  @override
  String get passwordTooShort => 'Пароль должен содержать не менее 6 символов';

  @override
  String get verificationCode => 'Код подтверждения';

  @override
  String get enterVerificationCode => 'Пожалуйста, введите код подтверждения';

  @override
  String get sendVerificationCode => 'Отправить код';

  @override
  String get agreement => 'Регистрируясь, вы соглашаетесь с нашей ';

  @override
  String get createPost => 'Создать пост';

  @override
  String get publish => 'Опубликовать';

  @override
  String get title => 'Заголовок';

  @override
  String get content => 'Содержание';

  @override
  String get deletePost => 'Удалить пост';

  @override
  String get deletePostConfirmation =>
      'Вы уверены, что хотите удалить этот пост?';

  @override
  String get delete => 'Удалить';

  @override
  String get comments => 'Комментарии';

  @override
  String get privacyPolicyContent =>
      'Настоящая Политика конфиденциальности описывает наши правила и процедуры сбора, использования и раскрытия вашей информации при использовании Вами Сервиса, а также информирует Вас о ваших правах на конфиденциальность и о том, как закон защищает Вас. Мы используем ваши персональные данные для предоставления и улучшения Сервиса. Используя Сервис, вы соглашаетесь на сбор и использование информации в соответствии с настоящей Политикой конфиденциальности.\n\n**Сбор и использование информации**\n\n**Типы собираемых данных**\n*   **Персональные данные:** При использовании Вами Сервиса мы можем попросить Вас предоставить нам определенную персональную информацию, которая может быть использована для связи с Вами или идентификации Вас. Персональная информация может включать, но не ограничиваться: адрес электронной почты, имя пользователя и аватар профиля.\n*   **Данные об использовании:** Данные об использовании автоматически собираются при использовании Сервиса. Это может включать информацию such as IP-адрес вашего устройства, тип браузера, версия браузера, страницы Сервиса, которые вы посещаете, дата и время посещения, время, проведенное на этих страницах, уникальные идентификаторы устройств и другие диагностические данные.\n*   **Контент, созданный пользователем:** Мы собираем контент, который вы создаете на нашем Сервисе, включая видео и изображения, которые вы загружаете, комментарии, лайки и избранные записи.\n\n**Использование ваших персональных данных**\nКомпания может использовать персональные данные в следующих целях:\n*   Для предоставления и поддержки нашего Сервиса, включая мониторинг использования Сервиса.\n*   Для управления вашим Аккаунтом: для управления вашей регистрацией как пользователя Сервиса.\n*   Для связи с Вами: Для связи с Вами по электронной почте в отношении обновлений или информативных сообщений, связанных с функциями, продуктами или заказанными услугами.\n*   Для предоставления вам новостей, специальных предложений и общих сведений о других товарах, услугах и мероприятиях, которые мы предлагаем.\n*   Для обработки ваших запросов: Для рассмотрения и обработки ваших запросов к нам.\n\n**Раскрытие вашей информации**\nМы не продаем вашу персональную информацию. Мы можем раскрывать вашу информацию третьим лицам, предоставляющим услуги от нашего имени, такие как хостинговые сервисы и аналитика.';

  @override
  String get introduction => 'Представление';

  @override
  String replyingTo(String username) {
    return 'Ответ на $username';
  }

  @override
  String get postYourComment => 'Опубликовать комментарий';

  @override
  String get beTheFirstToComment => 'Будьте первым, кто прокомментирует';

  @override
  String viewAllReplies(int count) {
    return 'Показать все $count ответов';
  }

  @override
  String commentDetails(int count) {
    return '$count ответов';
  }

  @override
  String get addAComment => 'Добавить комментарий';

  @override
  String get replies => 'Ответы';

  @override
  String fileLimitExceeded(int count) {
    return 'Вы можете выбрать не более $count файлов.';
  }

  @override
  String get selectPicturesFromAlbum => 'Выбрать фотографии из альбома';

  @override
  String get selectVideoFromAlbum => 'Выбрать видео из альбома';

  @override
  String get sportVideos => 'Спортные видео';

  @override
  String get resetPassword => 'Сбросить пароль';

  @override
  String get resetYourPassword => 'Сбросить пароль';

  @override
  String get resetPasswordInstruction =>
      'Пожалуйста, введите ваш адрес электронной почты. Мы отправим вам код подтверждения для сброса пароля.';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get confirmNewPassword => 'Подтвердить новый пароль';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get confirmReset => 'Подтвердить сброс';

  @override
  String get passwordResetSuccessLogin =>
      'Пароль успешно сброшен. Пожалуйста, войдите в систему.';

  @override
  String get usernameAndEmailMismatch =>
      'Имя пользователя и электронная почта не совпадают';

  @override
  String get noRepliesYet => 'Ответов еще нет.';

  @override
  String get invitationCode => 'Пригласительный код';

  @override
  String get incorrectInvitationCode => 'Неверный пригласительный код';

  @override
  String get pleaseRequestVerificationCodeFirst =>
      'Сначала запросите код подтверждения';

  @override
  String get invalidVerificationCode => 'Неверный код подтверждения.';

  @override
  String get videoLoadError => 'Не удалось загрузить видео';

  @override
  String get noPostsYet => 'No posts yet. Be the first to post!';
}
