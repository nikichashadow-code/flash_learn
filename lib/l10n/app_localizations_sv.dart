// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'FlashLearn';

  @override
  String get homeTitle => 'Flash Learn';

  @override
  String get signOut => 'Logga ut';

  @override
  String get language => 'Språk';

  @override
  String get english => 'Engelska';

  @override
  String get bulgarian => 'Bulgariska';

  @override
  String get swedish => 'Svenska';

  @override
  String get settingsTitle => 'Inställningar';

  @override
  String get settingsAppearance => 'Utseende';

  @override
  String get settingsLanguage => 'Språk';

  @override
  String get settingsAccount => 'Konto';

  @override
  String get settingsSignedInAs => 'Inloggad som';

  @override
  String get settingsAbout => 'Om appen';

  @override
  String get settingsAboutDescription =>
      'Lär dig Linux-grunder, terminalkommandon och praktiska arbetsflöden på ett ställe.';

  @override
  String get settingsHeroSubtitle =>
      'Anpassa din lärmiljö med rena kontroller och fokuserade kontoalternativ.';

  @override
  String get settingsMadeBy => 'Skapad av';

  @override
  String get settingsGithub => 'GitHub';

  @override
  String get settingsFooterCredit =>
      'Byggd med omsorg av nikichashadow · github.com/nikichashadow-code';

  @override
  String get navHome => 'Hem';

  @override
  String get navSsh => 'SSH';

  @override
  String get navTerminal => 'Terminal';

  @override
  String get exploreTopics => 'Utforska ämnen';

  @override
  String get topicHistoryOfLinux => 'Linux historia';

  @override
  String get topicLinuxOsBasics => 'Grunder i Linux OS';

  @override
  String get topicTerminalCommands => 'Terminalkommandon';

  @override
  String get topicDistrosEcosystem => 'Distributioner och ekosystem';

  @override
  String get searchCommandsHint => 'Sök kommandon...';

  @override
  String get noCommandsFound => 'Inga kommandon hittades';

  @override
  String errorWithDetails(Object details) {
    return 'Fel: $details';
  }

  @override
  String get welcomeTitle => 'Välkommen till Linux Learn!';

  @override
  String get welcomeSubtitle =>
      'Upptäck Linux värld: dess historia, kommandon och mer. Börja din resa mot att bemästra terminalen!';

  @override
  String get welcomeWhatYouWillLearn => 'Det här kommer du att lära dig:';

  @override
  String get welcomeTopicHistory => 'Historia';

  @override
  String get welcomeTopicBasics => 'Grunder';

  @override
  String get welcomeTopicTerminal => 'Terminal';

  @override
  String get welcomeTopicDistros => 'Distributioner';

  @override
  String get getStarted => 'Kom igång';

  @override
  String get authBrand => 'Flash';

  @override
  String get welcomeBack => 'Välkommen tillbaka';

  @override
  String get signUp => 'Registrera dig';

  @override
  String get loginToContinue => 'Logga in för att fortsätta';

  @override
  String get createAccountToContinue => 'Skapa ditt konto för att fortsätta';

  @override
  String get email => 'E-post';

  @override
  String get password => 'Lösenord';

  @override
  String get rememberMe => 'Kom ihåg mig';

  @override
  String get forgotPassword => 'Glömt lösenord?';

  @override
  String get login => 'Logga in';

  @override
  String get dontHaveAccount => 'Har du inget konto? ';

  @override
  String get alreadyHaveAccount => 'Har du redan ett konto? ';

  @override
  String get signUpLink => 'Registrera dig';

  @override
  String get logInLink => 'Logga in';

  @override
  String get loginFailed => 'Inloggningen misslyckades.';

  @override
  String get signupFailed => 'Registreringen misslyckades.';

  @override
  String get signUpSuccessCheckEmail =>
      'Registreringen lyckades! Kontrollera din e-post för att bekräfta.';

  @override
  String get enterEmailAddress => 'Ange din e-postadress';

  @override
  String get passwordResetLinkSent =>
      'Länk för lösenordsåterställning skickad till din e-post';

  @override
  String errorPrefix(Object error) {
    return 'Fel: $error';
  }

  @override
  String get linuxHistoryTitle => 'Linux historia';

  @override
  String get linuxBasicsTitle => 'Grunder i Linux OS';

  @override
  String get distrosEcosystemTitle => 'Distributioner och ekosystem';

  @override
  String couldNotLaunchUrl(Object url) {
    return 'Kunde inte öppna $url';
  }

  @override
  String get noCategoriesFound => 'Inga kategorier hittades.';

  @override
  String get noTopicsFound => 'Inga ämnen hittades.';

  @override
  String get noExamplesFound => 'Inga exempel hittades.';

  @override
  String get terminalSimulatorTitle => 'Terminalsimulator';

  @override
  String get typeCommandHint => 'skriv kommando';

  @override
  String get createNewSetTitle => 'Skapa nytt set';

  @override
  String get frontQuestion => 'Framsida (Fråga)';

  @override
  String get backAnswer => 'Baksida (Svar)';

  @override
  String get saveSet => 'Spara set';

  @override
  String flashcardProgress(Object current, Object total) {
    return '$current av $total';
  }

  @override
  String get know => 'Kan';

  @override
  String get dontKnow => 'Kan inte';

  @override
  String get sshClientTitle => 'SSH-klient';

  @override
  String get connectionSaved => 'Anslutningen sparades';

  @override
  String get connectedSuccessfully => 'Ansluten';

  @override
  String get enterPassword => 'Ange lösenord';

  @override
  String passwordForUserAtHost(Object user, Object host) {
    return 'Lösenord för $user@$host:';
  }

  @override
  String get cancel => 'Avbryt';

  @override
  String get connect => 'Anslut';

  @override
  String get passwordCannotBeEmpty => 'Lösenord får inte vara tomt';

  @override
  String get notConnectedToAnyServer => 'Inte ansluten till någon server';

  @override
  String get noOutput => '(ingen utdata)';

  @override
  String get disconnected => 'Frånkopplad';

  @override
  String get connectedStatus => '● Ansluten';

  @override
  String get noSavedConnections =>
      'Inga sparade anslutningar\nSkapa en ny för att komma igång';

  @override
  String get connectAction => 'Anslut';

  @override
  String get deleteAction => 'Ta bort';

  @override
  String get deleteConnectionTitle => 'Ta bort anslutning';

  @override
  String get areYouSure => 'Är du säker?';

  @override
  String get newConnection => 'Ny anslutning';

  @override
  String get disconnect => 'Koppla från';

  @override
  String get unknown => 'Okänd';

  @override
  String get newSshConnection => 'Ny SSH-anslutning';

  @override
  String get connectionName => 'Anslutningsnamn';

  @override
  String get connectionNameHint => 't.ex. Min server';

  @override
  String get hostIpAddress => 'Värd/IP-adress';

  @override
  String get hostIpHint => 'example.com eller 1.2.3.4';

  @override
  String get port => 'Port';

  @override
  String get username => 'Användarnamn';

  @override
  String get usernameHint => 't.ex. root eller ubuntu';

  @override
  String get sshPasswordHint => 'Ange ditt SSH-lösenord';

  @override
  String get savePassword => 'Spara lösenord';

  @override
  String get savePasswordSubtitle => 'Osäkert - endast på betrodda enheter';

  @override
  String get fillAllFields => 'Fyll i alla fält';
}
