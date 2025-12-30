// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'スポーツフラッター';

  @override
  String get upNext => '次へ';

  @override
  String videoViews(num count, Object date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '閲覧数$count件',
      one: '閲覧数1件',
      zero: '閲覧数なし',
    );
    return '$_temp0 • $date';
  }

  @override
  String daysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count日前',
      one: '1日前',
      zero: '今日',
    );
    return '$_temp0';
  }

  @override
  String weeksAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count週間前',
      one: '1週間前',
      zero: '今週',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count時間前',
      one: '1時間前',
      zero: 'たった今',
    );
    return '$_temp0';
  }

  @override
  String minutesAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count分前',
      one: '1分前',
      zero: 'たった今',
    );
    return '$_temp0';
  }

  @override
  String get justNow => 'たった今';

  @override
  String get showMore => 'もっと表示';

  @override
  String get showLess => '少なく表示';

  @override
  String get dislike => '嫌い';

  @override
  String get favorite => 'お気に入り';

  @override
  String get tenThousand => '万';

  @override
  String get home => 'ホーム';

  @override
  String get community => 'コミュニティ';

  @override
  String get profile => 'プロフィール';

  @override
  String get login => 'ログイン';

  @override
  String get invalidUsernameOrPassword => 'ユーザー名またはパスワードが不正です';

  @override
  String get username => 'ユーザー名';

  @override
  String get enterUsername => 'ユーザー名を入力してください';

  @override
  String get password => 'パスワード';

  @override
  String get enterPassword => 'パスワードを入力してください';

  @override
  String get dontHaveAnAccount => 'アカウントがないですか？新規登録';

  @override
  String get forgotPassword => 'パスワードを忘れましたか？';

  @override
  String get myProfile => 'マイプロフィール';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get myPosts => 'マイ投稿';

  @override
  String get myFavorites => 'マイお気に入り';

  @override
  String get language => '言語';

  @override
  String get editProfile => 'プロフィール編集';

  @override
  String get selectLanguage => '言語選択';

  @override
  String get logout => 'ログアウト';

  @override
  String get logoutConfirmation => '本当にログアウトしますか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirmLogout => 'ログアウト';

  @override
  String get easy => 'イージー';

  @override
  String get medium => 'ミディアム';

  @override
  String get hard => 'ハード';

  @override
  String get ultimate => 'アルティメット';

  @override
  String get invalidEmail => '無効なメールアドレスです';

  @override
  String get register => '新規登録';

  @override
  String get registrationSuccessful => '登録が完了しました';

  @override
  String get codeSent => '確認コードを送信しました';

  @override
  String get email => 'メールアドレス';

  @override
  String get enterValidEmail => '有効なメールアドレスを入力してください';

  @override
  String get passwordTooShort => 'パスワードは最低6文字以上です';

  @override
  String get verificationCode => '確認コード';

  @override
  String get enterVerificationCode => '確認コードを入力してください';

  @override
  String get sendVerificationCode => 'コード送信';

  @override
  String get agreement => '新規登録することで、本サービスの ';

  @override
  String get createPost => '投稿作成';

  @override
  String get publish => '公開';

  @override
  String get title => 'タイトル';

  @override
  String get content => 'コンテンツ';

  @override
  String get deletePost => '投稿削除';

  @override
  String get deletePostConfirmation => 'この投稿を本当に削除しますか？';

  @override
  String get delete => '削除';

  @override
  String get comments => 'コメント';

  @override
  String get privacyPolicyContent =>
      '本プライバシーポリシーは、本サービスをご利用になる際のお客様の情報の収集、使用、開示に関する当社の方針と手順を説明し、お客様のプライバシーに関する権利と法律による保護方法をお知らせします。当社は、本サービスの提供と改善のためにお客様の個人情報を使用します。本サービスをご利用になることで、お客様は本プライバシーポリシーに従った情報の収集と使用に同意したものとみなされます。\n\n**情報の収集と使用**\n\n**収集するデータの種類**\n*   **個人情報:** 本サービスの利用中、当社はお客様に連絡したり特定したりするために、特定の個人識別情報の提供をお願いする場合があります。個人識別情報には、以下のものが含まれますが、これらに限られません：メールアドレス、ユーザー名、プロフィール写真。\n*   **利用データ:** 利用データは、本サービスの利用時に自動的に収集されます。これには、お客様のデバイスのIPアドレス、ブラウザの種類、ブラウザのバージョン、アクセスした本サービスのページ、アクセス日時、各ページでの滞在時間、固有のデバイス識別子、その他の診断データなどの情報が含まれます。\n*   **ユーザー生成コンテンツ:** 当社は、お客様が本サービス上で作成したコンテンツを収集します。これには、お客様がアップロードした動画や画像、投稿したコメント、いいね、お気に入りが含まれます。\n\n**お客様の個人情報の使用**\n当社は、以下の目的で個人情報を使用する場合があります：\n*   本サービスの提供と維持、含む本サービスの利用状況の監視。\n*   お客様のアカウント管理：本サービスのユーザーとしてのお客様の登録管理。\n*   お客様への連絡：機能、製品、または契約したサービスに関する更新情報や案内通知をメールでお客様に連絡。\n*   当社が提供する他の商品、サービス、イベントに関するニュース、特別オファー、一般的な情報をお客様に提供。\n*   お客様のリクエスト管理：当社へのお客様のリクエストの受付と管理。\n\n**お客様の情報の開示**\n当社は、お客様の個人情報を販売しません。当社は、ホスティングサービスや分析など、当社の代わりにサービスを提供する第三者サービスプロバイダーとお客様の情報を共有する場合があります。';

  @override
  String get introduction => '紹介';

  @override
  String replyingTo(String username) {
    return '$usernameさんへの返信';
  }

  @override
  String get postYourComment => 'コメントを投稿';

  @override
  String get beTheFirstToComment => '最初のコメント投稿者になろう';

  @override
  String viewAllReplies(int count) {
    return 'すべて$count件の返信を表示';
  }

  @override
  String commentDetails(int count) {
    return '$count件の返信';
  }

  @override
  String get addAComment => 'コメントを追加';

  @override
  String get replies => '返信';

  @override
  String fileLimitExceeded(int count) {
    return '最大$count件のファイルまで選択できます。';
  }

  @override
  String get selectPicturesFromAlbum => 'アルバムから写真を選択';

  @override
  String get selectVideoFromAlbum => 'アルバムから動画を選択';

  @override
  String get sportVideos => 'スポーツ動画';

  @override
  String get resetPassword => 'パスワードリセット';

  @override
  String get resetYourPassword => 'パスワードリセット';

  @override
  String get resetPasswordInstruction =>
      'メールアドレスを入力してください。パスワードリセットのための確認コードを送信します。';

  @override
  String get newPassword => '新しいパスワード';

  @override
  String get confirmNewPassword => '新しいパスワード確認';

  @override
  String get passwordsDoNotMatch => '二つのパスワードが一致しません';

  @override
  String get confirmReset => 'リセット確認';

  @override
  String get passwordResetSuccessLogin => 'パスワードをリセットしました。ログインしてください。';

  @override
  String get usernameAndEmailMismatch => 'ユーザー名とメールアドレスが一致しません';

  @override
  String get noRepliesYet => 'まだ返信がありません。';

  @override
  String get invitationCode => '招待コード';

  @override
  String get incorrectInvitationCode => '不正な招待コードです';

  @override
  String get pleaseRequestVerificationCodeFirst => 'まず確認コードを要求してください';

  @override
  String get invalidVerificationCode => '無効な確認コードです。';

  @override
  String get videoLoadError => '動画を読み込めません';

  @override
  String get noPostsYet => 'まだ投稿がありません。一番乗りになろう！';
}
