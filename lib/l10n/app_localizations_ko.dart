// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '스포츠 플러터';

  @override
  String get upNext => '다음';

  @override
  String videoViews(num count, Object date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '조회수 $count회',
      one: '조회수 1회',
      zero: '조회수 없음',
    );
    return '$_temp0 • $date';
  }

  @override
  String daysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count일 전',
      one: '1일 전',
      zero: '오늘',
    );
    return '$_temp0';
  }

  @override
  String weeksAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count주 전',
      one: '1주 전',
      zero: '이번 주',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count시간 전',
      one: '1시간 전',
      zero: '방금 전',
    );
    return '$_temp0';
  }

  @override
  String minutesAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count분 전',
      one: '1분 전',
      zero: '방금 전',
    );
    return '$_temp0';
  }

  @override
  String get justNow => '방금 전';

  @override
  String get showMore => '더 보기';

  @override
  String get showLess => '적게 보기';

  @override
  String get dislike => '싫어요';

  @override
  String get favorite => '즐겨찾기';

  @override
  String get tenThousand => '만';

  @override
  String get home => '홈';

  @override
  String get community => '커뮤니티';

  @override
  String get profile => '프로필';

  @override
  String get login => '로그인';

  @override
  String get invalidUsernameOrPassword => '아이디 또는 비밀번호가 올바르지 않습니다';

  @override
  String get username => '아이디';

  @override
  String get enterUsername => '아이디를 입력해주세요';

  @override
  String get password => '비밀번호';

  @override
  String get enterPassword => '비밀번호를 입력해주세요';

  @override
  String get dontHaveAnAccount => '계정이 없으신가요? 회원가입';

  @override
  String get forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get myProfile => '내 프로필';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get myPosts => '내 게시물';

  @override
  String get myFavorites => '내 즐겨찾기';

  @override
  String get language => '언어';

  @override
  String get editProfile => '프로필 편집';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get logout => '로그아웃';

  @override
  String get logoutConfirmation => '정말로 로그아웃하시겠어요?';

  @override
  String get cancel => '취소';

  @override
  String get confirmLogout => '로그아웃';

  @override
  String get easy => '쉬움';

  @override
  String get medium => '중간';

  @override
  String get hard => '어려움';

  @override
  String get ultimate => '극한';

  @override
  String get invalidEmail => '유효하지 않은 이메일 주소입니다';

  @override
  String get register => '회원가입';

  @override
  String get registrationSuccessful => '회원가입 성공';

  @override
  String get codeSent => '인증코드가 발송되었습니다';

  @override
  String get email => '이메일';

  @override
  String get enterValidEmail => '유효한 이메일 주소를 입력해주세요';

  @override
  String get passwordTooShort => '비밀번호는 최소 6자 이상이어야 합니다';

  @override
  String get verificationCode => '인증코드';

  @override
  String get enterVerificationCode => '인증코드를 입력해주세요';

  @override
  String get sendVerificationCode => '코드 발송';

  @override
  String get agreement => '회원가입을 함으로써 귀하는 본인의 ';

  @override
  String get createPost => '게시물 작성';

  @override
  String get publish => '게시';

  @override
  String get title => '제목';

  @override
  String get content => '내용';

  @override
  String get deletePost => '게시물 삭제';

  @override
  String get deletePostConfirmation => '정말로 이 게시물을 삭제하시겠어요?';

  @override
  String get delete => '삭제';

  @override
  String get comments => '댓글';

  @override
  String get privacyPolicyContent =>
      '본 개인정보 처리방침은 귀하가 서비스를 사용할 때 귀하의 정보 수집, 사용 및 공개에 관한 저희의 정책과 절차를 설명하며, 귀하의 개인정보 보호 권리 및 법률에 따른 보호 방식을 안내합니다. 저희는 서비스 제공 및 개선을 위해 귀하의 개인정보를 사용합니다. 서비스를 사용함으로써 귀하는 본 개인정보 처리방침에 따라 정보 수집 및 사용에 동의하는 것으로 간주됩니다.\n\n**정보 수집 및 사용**\n\n**수집되는 데이터 유형**\n*   **개인정보:** 저희 서비스 사용 중에 저희는 귀하에게 연락하거나 식별할 수 있는 특정 개인 식별 정보를 요청할 수 있습니다. 개인 식별 정보에는 다음이 포함될 수 있지만 이에 국한되지 않습니다: 이메일 주소, 아이디 및 프로필 사진.\n*   **사용 데이터:** 사용 데이터는 서비스 사용 시 자동으로 수집됩니다. 이에는 귀하의 장치 IP 주소, 브라우저 유형, 브라우저 버전, 방문한 저희 서비스 페이지, 방문 날짜 및 시간, 해당 페이지에서 소요된 시간, 고유 장치 식별자 및 기타 진단 데이터 등의 정보가 포함될 수 있습니다.\n*   **사용자 생성 콘텐츠:** 저희는 귀하가 저희 서비스에서 생성한 콘텐츠를 수집합니다. 이에는 귀하가 업로드한 비디오 및 이미지, 게시한 댓글, 좋아요 및 즐겨찾기가 포함됩니다.\n\n**귀하의 개인정보 사용**\n회사는 다음과 같은 목적으로 개인정보를 사용할 수 있습니다:\n*   저희 서비스 제공 및 유지 관리, 포함하여 저희 서비스 사용 모니터링.\n*   귀하의 계정 관리: 서비스 사용자로서의 귀하의 등록 관리.\n*   귀하에게 연락: 기능, 제품 또는 계약된 서비스와 관련된 업데이트 또는 정보 통신을 이메일로 귀하에게 연락.\n*   저희가 제공하는 기타 상품, 서비스 및 이벤트에 대한 뉴스, 특별 할인 및 일반 정보 제공.\n*   귀하의 요청 관리: 저희에 대한 귀하의 요청 접수 및 관리.\n\n**귀하의 정보 공유**\n저희는 귀하의 개인정보를 판매하지 않습니다. 저희는 호스팅 서비스 및 분석과 같이 저희 대신 서비스를 수행하는 제3자 서비스 제공업체와 귀하의 정보를 공유할 수 있습니다.';

  @override
  String get introduction => '소개';

  @override
  String replyingTo(String username) {
    return '$username님에게 답글';
  }

  @override
  String get postYourComment => '댓글 작성';

  @override
  String get beTheFirstToComment => '첫 댓글을 작성해보세요!';

  @override
  String viewAllReplies(int count) {
    return '모든 $count개의 답글 보기';
  }

  @override
  String commentDetails(int count) {
    return '$count개의 답글';
  }

  @override
  String get addAComment => '댓글 추가';

  @override
  String get replies => '답글';

  @override
  String fileLimitExceeded(int count) {
    return '최대 $count개의 파일만 선택할 수 있습니다.';
  }

  @override
  String get selectPicturesFromAlbum => '앨범에서 사진 선택';

  @override
  String get selectVideoFromAlbum => '앨범에서 비디오 선택';

  @override
  String get sportVideos => '스포츠 비디오';

  @override
  String get resetPassword => '비밀번호 재설정';

  @override
  String get resetYourPassword => '비밀번호 재설정';

  @override
  String get resetPasswordInstruction =>
      '이메일 주소를 입력해주세요. 비밀번호 재설정을 위한 인증코드를 보내드릴 것입니다.';

  @override
  String get newPassword => '새 비밀번호';

  @override
  String get confirmNewPassword => '새 비밀번호 확인';

  @override
  String get passwordsDoNotMatch => '두 비밀번호가 일치하지 않습니다';

  @override
  String get confirmReset => '재설정 확인';

  @override
  String get passwordResetSuccessLogin => '비밀번호가 재설정되었습니다. 로그인해주세요.';

  @override
  String get usernameAndEmailMismatch => '아이디와 이메일이 일치하지 않습니다';

  @override
  String get noRepliesYet => '아직 답글이 없습니다.';

  @override
  String get invitationCode => '초대 코드';

  @override
  String get incorrectInvitationCode => '잘못된 초대 코드입니다';

  @override
  String get pleaseRequestVerificationCodeFirst => '먼저 인증코드를 요청해주세요';

  @override
  String get invalidVerificationCode => '유효하지 않은 인증코드입니다.';

  @override
  String get videoLoadError => '비디오를 불러올 수 없습니다';

  @override
  String get noPostsYet => '아직 게시물이 없습니다. 첫 번째 게시물을 작성해보세요!';
}
