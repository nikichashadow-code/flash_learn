// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get appTitle => 'FlashLearn';

  @override
  String get homeTitle => 'Flash Learn';

  @override
  String get signOut => 'Изход';

  @override
  String get language => 'Език';

  @override
  String get english => 'Английски';

  @override
  String get bulgarian => 'Български';

  @override
  String get swedish => 'Шведски';

  @override
  String get norwegian => 'Норвежки';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsAppearance => 'Външен вид';

  @override
  String get settingsLanguage => 'Език';

  @override
  String get settingsAccount => 'Акаунт';

  @override
  String get settingsSignedInAs => 'Влязъл като';

  @override
  String get settingsAbout => 'За приложението';

  @override
  String get settingsAboutDescription =>
      'Учи основи на Linux, терминални команди и практически умения на едно място.';

  @override
  String get settingsHeroSubtitle =>
      'Персонализирай учебната среда с изчистени контроли и фокусирани опции за акаунт.';

  @override
  String get settingsMadeBy => 'Създадено от';

  @override
  String get settingsGithub => 'GitHub';

  @override
  String get settingsFooterCredit =>
      'Създадено с внимание от nikichashadow · github.com/nikichashadow-code';

  @override
  String get navHome => 'Начало';

  @override
  String get navSsh => 'SSH';

  @override
  String get navTerminal => 'Терминал';

  @override
  String get flashcardsTitle => 'Флашкарти';

  @override
  String get requiredField => 'Това поле е задължително';

  @override
  String get createSetSubtitle =>
      'Напиши въпрос и отговор, за да добавиш карта към учебната си библиотека.';

  @override
  String get frontQuestionHint => 'Какво искаш да запомниш?';

  @override
  String get backAnswerHint => 'Напиши обяснението или отговора';

  @override
  String get noFlashcards => 'Все още няма флашкарти';

  @override
  String get createFirstFlashcard =>
      'Създай първата си флашкарта, за да започнеш да учиш.';

  @override
  String get studyFlashcards => 'Учи с флашкарти';

  @override
  String get exploreTopics => 'Разгледай теми';

  @override
  String get topicHistoryOfLinux => 'История на Linux';

  @override
  String get topicLinuxOsBasics => 'Основи на Linux';

  @override
  String get topicTerminalCommands => 'Команди в терминала';

  @override
  String get topicDistrosEcosystem => 'Дистрибуции и екосистема';

  @override
  String get searchCommandsHint => 'Търси команди...';

  @override
  String get noCommandsFound => 'Няма намерени команди';

  @override
  String errorWithDetails(Object details) {
    return 'Грешка: $details';
  }

  @override
  String get welcomeTitle => 'Добре дошли в Linux Learn!';

  @override
  String get welcomeSubtitle =>
      'Открий света на Linux: история, команди и още. Започни пътя си към овладяване на терминала!';

  @override
  String get welcomeWhatYouWillLearn => 'Какво ще научиш:';

  @override
  String get welcomeTopicHistory => 'История';

  @override
  String get welcomeTopicBasics => 'Основи';

  @override
  String get welcomeTopicTerminal => 'Терминал';

  @override
  String get welcomeTopicDistros => 'Дистрибуции';

  @override
  String get getStarted => 'Започни';

  @override
  String get authBrand => 'Flash';

  @override
  String get welcomeBack => 'Добре дошъл отново';

  @override
  String get signUp => 'Регистрация';

  @override
  String get loginToContinue => 'Влез, за да продължиш';

  @override
  String get createAccountToContinue => 'Създай акаунт, за да продължиш';

  @override
  String get email => 'Имейл';

  @override
  String get password => 'Парола';

  @override
  String get rememberMe => 'Запомни ме';

  @override
  String get forgotPassword => 'Забравена парола?';

  @override
  String get login => 'Вход';

  @override
  String get dontHaveAccount => 'Нямаш акаунт? ';

  @override
  String get alreadyHaveAccount => 'Имаш акаунт? ';

  @override
  String get signUpLink => 'Регистрация';

  @override
  String get logInLink => 'Вход';

  @override
  String get loginFailed => 'Неуспешен вход.';

  @override
  String get signupFailed => 'Неуспешна регистрация.';

  @override
  String get signUpSuccessCheckEmail =>
      'Успешна регистрация! Провери имейла си за потвърждение.';

  @override
  String get enterEmailAddress => 'Моля, въведи имейл адрес';

  @override
  String get passwordResetLinkSent =>
      'Линк за смяна на парола е изпратен на имейла ти';

  @override
  String errorPrefix(Object error) {
    return 'Грешка: $error';
  }

  @override
  String get linuxHistoryTitle => 'История на Linux';

  @override
  String get historyGnuProjectTitle => 'Обявен е проектът GNU';

  @override
  String get historyGnuProjectDetails =>
      'Ричард Столман стартира проекта GNU с цел създаване на свободна Unix-подобна операционна система. Проектът GNU предоставя много основни инструменти и помощни програми, но ядрото GNU Hurd не е готово за широко използване.';

  @override
  String get historyLinuxKernelTitle => 'Създадено е ядрото Linux';

  @override
  String get historyLinuxKernelDetails =>
      'Финландският студент Линус Торвалдс обявява ядрото Linux в новинарската група comp.os.minix. Той кани други разработчици да се присъединят и бързо привлича глобална общност. Първата версия (0.01) е публикувана през септември 1991 г.';

  @override
  String get historyOpenSourceTitle => 'Linux става с отворен код';

  @override
  String get historyOpenSourceDetails =>
      'Linux е лицензирана отново под GNU General Public License (GPL), което я прави свободна система с отворен код. Това позволява на всеки да използва, променя и разпространява Linux, ускорявайки развитието и приемането му.';

  @override
  String get historyFirstDistributionsTitle => 'Първи дистрибуции';

  @override
  String get historyFirstDistributionsDetails =>
      'Дистрибуции като Slackware и Debian са публикувани, което улеснява инсталирането и използването на Linux. Те обединяват ядрото Linux с GNU инструменти и друг софтуер, за да предоставят цялостна операционна система.';

  @override
  String get historyTuxTitle => 'Пингвинът Tux';

  @override
  String get historyTuxDetails =>
      'Пингвинът Tux е избран за официален талисман на Linux. Създаден от Лари Юинг, Tux се превръща в символ на забавния и приятелски дух на общността Linux.';

  @override
  String get historyUbuntuTitle => 'Стартира Ubuntu';

  @override
  String get historyUbuntuDetails =>
      'Ubuntu е публикувана с фокус върху лесната употреба и редовните издания. Бързо се превръща в една от най-популярните Linux дистрибуции за настолни компютри и сървъри.';

  @override
  String get historyServersCloudTitle =>
      'Linux доминира при сървърите и облака';

  @override
  String get historyServersCloudDetails =>
      'Linux се превръща във водещата операционна система за сървъри, суперкомпютри и облачна инфраструктура. Android, базирана на ядрото Linux, става най-популярната мобилна операционна система в света.';

  @override
  String get historyEverywhereTitle => 'Linux навсякъде';

  @override
  String get historyEverywhereDetails =>
      'Linux работи на смартфони, смарт телевизори, автомобили, вградени устройства и най-бързите суперкомпютри в света. Общността с отворен код продължава да насърчава иновациите и сътрудничеството.';

  @override
  String get linuxBasicsTitle => 'Основи на Linux';

  @override
  String get distrosEcosystemTitle => 'Дистрибуции и екосистема';

  @override
  String couldNotLaunchUrl(Object url) {
    return 'Не може да се отвори $url';
  }

  @override
  String get noCategoriesFound => 'Няма намерени категории.';

  @override
  String get noTopicsFound => 'Няма намерени теми.';

  @override
  String get noExamplesFound => 'Няма намерени примери.';

  @override
  String get terminalSimulatorTitle => 'Симулатор на терминал';

  @override
  String get typeCommandHint => 'въведи команда';

  @override
  String get createNewSetTitle => 'Създай нов комплект';

  @override
  String get frontQuestion => 'Лице (Въпрос)';

  @override
  String get backAnswer => 'Гръб (Отговор)';

  @override
  String get saveSet => 'Запази комплекта';

  @override
  String flashcardProgress(Object current, Object total) {
    return '$current от $total';
  }

  @override
  String get know => 'Знам';

  @override
  String get dontKnow => 'Не знам';

  @override
  String get flashcardComplete => 'Сесията за учене завърши';

  @override
  String flashcardScore(Object known, Object total) {
    return 'Знаеше $known от $total флашкарти.';
  }

  @override
  String get restartStudy => 'Учи отново';

  @override
  String get sshClientTitle => 'SSH клиент';

  @override
  String get connectionSaved => 'Връзката е запазена';

  @override
  String get connectedSuccessfully => 'Успешно свързване';

  @override
  String get enterPassword => 'Въведи парола';

  @override
  String passwordForUserAtHost(Object user, Object host) {
    return 'Парола за $user@$host:';
  }

  @override
  String get cancel => 'Отказ';

  @override
  String get connect => 'Свържи';

  @override
  String get passwordCannotBeEmpty => 'Паролата не може да е празна';

  @override
  String get notConnectedToAnyServer => 'Няма активна връзка със сървър';

  @override
  String get noOutput => '(няма изход)';

  @override
  String get disconnected => 'Прекъснато';

  @override
  String get connectedStatus => '● Свързан';

  @override
  String get noSavedConnections =>
      'Няма запазени връзки\nСъздай нова, за да започнеш';

  @override
  String get connectAction => 'Свържи';

  @override
  String get deleteAction => 'Изтрий';

  @override
  String get deleteConnectionTitle => 'Изтриване на връзка';

  @override
  String get areYouSure => 'Сигурен ли си?';

  @override
  String get newConnection => 'Нова връзка';

  @override
  String get disconnect => 'Прекъсни';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get newSshConnection => 'Нова SSH връзка';

  @override
  String get connectionName => 'Име на връзката';

  @override
  String get connectionNameHint => 'напр. Моят сървър';

  @override
  String get hostIpAddress => 'Хост/IP адрес';

  @override
  String get hostIpHint => 'example.com или 1.2.3.4';

  @override
  String get port => 'Порт';

  @override
  String get username => 'Потребител';

  @override
  String get usernameHint => 'напр. root или ubuntu';

  @override
  String get sshPasswordHint => 'Въведи SSH паролата си';

  @override
  String get savePassword => 'Запази паролата';

  @override
  String get savePasswordSubtitle => 'Несигурно — само на доверени устройства';

  @override
  String get fillAllFields => 'Моля, попълни всички полета';
}
