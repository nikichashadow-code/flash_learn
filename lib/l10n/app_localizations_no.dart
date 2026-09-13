// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian (`no`).
class AppLocalizationsNo extends AppLocalizations {
  AppLocalizationsNo([String locale = 'no']) : super(locale);

  @override
  String get appTitle => 'FlashLearn';

  @override
  String get homeTitle => 'Flash Learn';

  @override
  String get signOut => 'Logg ut';

  @override
  String get language => 'Sprak';

  @override
  String get english => 'Engelsk';

  @override
  String get bulgarian => 'Bulgarsk';

  @override
  String get swedish => 'Svensk';

  @override
  String get norwegian => 'Norsk';

  @override
  String get settingsTitle => 'Innstillinger';

  @override
  String get settingsAppearance => 'Utseende';

  @override
  String get settingsLanguage => 'Sprak';

  @override
  String get settingsAccount => 'Konto';

  @override
  String get settingsSignedInAs => 'Innlogget som';

  @override
  String get settingsAbout => 'Om';

  @override
  String get settingsAboutDescription =>
      'Laer deg grunnleggende Linux, terminalkommandoer og praktiske arbeidsflyter pa ett sted.';

  @override
  String get settingsHeroSubtitle =>
      'Tilpass laeringsmiljoet ditt med enkle kontroller og fokuserte kontoalternativer.';

  @override
  String get settingsMadeBy => 'Laget av';

  @override
  String get settingsGithub => 'GitHub';

  @override
  String get settingsFooterCredit =>
      'Bygget med omtanke av nikichashadow · github.com/nikichashadow-code';

  @override
  String get navHome => 'Hjem';

  @override
  String get navSsh => 'SSH';

  @override
  String get navTerminal => 'Terminal';

  @override
  String get exploreTopics => 'Utforsk emner';

  @override
  String get topicHistoryOfLinux => 'Linux-historie';

  @override
  String get topicLinuxOsBasics => 'Grunnleggende Linux';

  @override
  String get topicTerminalCommands => 'Terminalkommandoer';

  @override
  String get topicDistrosEcosystem => 'Distribusjoner og okosystem';

  @override
  String get searchCommandsHint => 'Sok etter kommandoer...';

  @override
  String get noCommandsFound => 'Ingen kommandoer funnet';

  @override
  String errorWithDetails(Object details) {
    return 'Feil: $details';
  }

  @override
  String get welcomeTitle => 'Velkommen til Linux Learn!';

  @override
  String get welcomeSubtitle =>
      'Oppdag Linux-verdenen: historien, kommandoene og mer. Start reisen din mot a mestre terminalen!';

  @override
  String get welcomeWhatYouWillLearn => 'Dette vil du laere:';

  @override
  String get welcomeTopicHistory => 'Historie';

  @override
  String get welcomeTopicBasics => 'Grunnleggende';

  @override
  String get welcomeTopicTerminal => 'Terminal';

  @override
  String get welcomeTopicDistros => 'Distribusjoner';

  @override
  String get getStarted => 'Kom i gang';

  @override
  String get authBrand => 'Flash';

  @override
  String get welcomeBack => 'Velkommen tilbake';

  @override
  String get signUp => 'Registrer deg';

  @override
  String get loginToContinue => 'Logg inn for a fortsette';

  @override
  String get createAccountToContinue => 'Opprett en konto for a fortsette';

  @override
  String get email => 'E-post';

  @override
  String get password => 'Passord';

  @override
  String get rememberMe => 'Husk meg';

  @override
  String get forgotPassword => 'Glemt passord?';

  @override
  String get login => 'Logg inn';

  @override
  String get dontHaveAccount => 'Har du ikke en konto? ';

  @override
  String get alreadyHaveAccount => 'Har du allerede en konto? ';

  @override
  String get signUpLink => 'Registrer deg';

  @override
  String get logInLink => 'Logg inn';

  @override
  String get loginFailed => 'Innlogging mislyktes.';

  @override
  String get signupFailed => 'Registrering mislyktes.';

  @override
  String get signUpSuccessCheckEmail =>
      'Registreringen var vellykket! Sjekk e-posten din for a bekrefte.';

  @override
  String get enterEmailAddress => 'Skriv inn e-postadressen din';

  @override
  String get passwordResetLinkSent =>
      'Lenke for tilbakestilling av passord er sendt til e-posten din';

  @override
  String errorPrefix(Object error) {
    return 'Feil: $error';
  }

  @override
  String get linuxHistoryTitle => 'Linux-historie';

  @override
  String get historyGnuProjectTitle => 'GNU-prosjektet kunngjores';

  @override
  String get historyGnuProjectDetails =>
      'Richard Stallman starter GNU-prosjektet med mal om a lage et fritt Unix-lignende operativsystem. GNU-prosjektet leverte mange viktige verktoy og funksjoner, men kjernen GNU Hurd var ikke klar for utbredt bruk.';

  @override
  String get historyLinuxKernelTitle => 'Linux-kjernen opprettes';

  @override
  String get historyLinuxKernelDetails =>
      'Den finske studenten Linus Torvalds kunngjor Linux-kjernen i nyhetsgruppen comp.os.minix. Han inviterer til samarbeid og tiltrekker raskt et globalt utviklerfellesskap. Den forste versjonen (0.01) utgis i september 1991.';

  @override
  String get historyOpenSourceTitle => 'Linux blir apen kildekode';

  @override
  String get historyOpenSourceDetails =>
      'Linux lisensieres pa nytt under GNU General Public License (GPL), noe som gjor systemet fritt og apent. Alle kan dermed bruke, endre og distribuere Linux, noe som akselererer utviklingen og utbredelsen.';

  @override
  String get historyFirstDistributionsTitle => 'De forste distribusjonene';

  @override
  String get historyFirstDistributionsDetails =>
      'Distribusjoner som Slackware og Debian utgis og gjor Linux enklere a installere og bruke. Distribusjonene kombinerer Linux-kjernen med GNU-verktoy og annen programvare for a tilby et komplett operativsystem.';

  @override
  String get historyTuxTitle => 'Pingvinen Tux';

  @override
  String get historyTuxDetails =>
      'Pingvinen Tux velges som Linux sin offisielle maskot. Tux, som er designet av Larry Ewing, blir et symbol pa Linux-fellesskapets morsomme og vennlige stil.';

  @override
  String get historyUbuntuTitle => 'Ubuntu lanseres';

  @override
  String get historyUbuntuDetails =>
      'Ubuntu utgis med fokus pa brukervennlighet og regelmessige utgivelser. Det blir raskt en av de mest populaere Linux-distribusjonene for datamaskiner og servere.';

  @override
  String get historyServersCloudTitle => 'Linux dominerer servere og skyen';

  @override
  String get historyServersCloudDetails =>
      'Linux blir det dominerende operativsystemet for servere, superdatamaskiner og skyinfrastruktur. Android, som er basert pa Linux-kjernen, blir verdens mest populaere mobile operativsystem.';

  @override
  String get historyEverywhereTitle => 'Linux overalt';

  @override
  String get historyEverywhereDetails =>
      'Linux driver smarttelefoner, smart-TV-er, biler, innebygde enheter og verdens raskeste superdatamaskiner. Fellesskapet for apen kildekode fortsetter a drive innovasjon og samarbeid.';

  @override
  String get linuxBasicsTitle => 'Grunnleggende Linux';

  @override
  String get distrosEcosystemTitle => 'Distribusjoner og okosystem';

  @override
  String couldNotLaunchUrl(Object url) {
    return 'Kunne ikke apne $url';
  }

  @override
  String get noCategoriesFound => 'Ingen kategorier funnet.';

  @override
  String get noTopicsFound => 'Ingen emner funnet.';

  @override
  String get noExamplesFound => 'Ingen eksempler funnet.';

  @override
  String get terminalSimulatorTitle => 'Terminalsimulator';

  @override
  String get typeCommandHint => 'skriv kommando';

  @override
  String get createNewSetTitle => 'Opprett nytt sett';

  @override
  String get frontQuestion => 'Forside (sporsmal)';

  @override
  String get backAnswer => 'Bakside (svar)';

  @override
  String get saveSet => 'Lagre sett';

  @override
  String flashcardProgress(Object current, Object total) {
    return '$current av $total';
  }

  @override
  String get know => 'Kan';

  @override
  String get dontKnow => 'Kan ikke';

  @override
  String get sshClientTitle => 'SSH-klient';

  @override
  String get connectionSaved => 'Tilkobling lagret';

  @override
  String get connectedSuccessfully => 'Tilkoblet';

  @override
  String get enterPassword => 'Skriv inn passord';

  @override
  String passwordForUserAtHost(Object user, Object host) {
    return 'Passord for $user@$host:';
  }

  @override
  String get cancel => 'Avbryt';

  @override
  String get connect => 'Koble til';

  @override
  String get passwordCannotBeEmpty => 'Passord kan ikke vaere tomt';

  @override
  String get notConnectedToAnyServer => 'Ikke koblet til noen server';

  @override
  String get noOutput => '(ingen utdata)';

  @override
  String get disconnected => 'Frakoblet';

  @override
  String get connectedStatus => '● Tilkoblet';

  @override
  String get noSavedConnections =>
      'Ingen lagrede tilkoblinger\nOpprett en ny for a komme i gang';

  @override
  String get connectAction => 'Koble til';

  @override
  String get deleteAction => 'Slett';

  @override
  String get deleteConnectionTitle => 'Slett tilkobling';

  @override
  String get areYouSure => 'Er du sikker?';

  @override
  String get newConnection => 'Ny tilkobling';

  @override
  String get disconnect => 'Koble fra';

  @override
  String get unknown => 'Ukjent';

  @override
  String get newSshConnection => 'Ny SSH-tilkobling';

  @override
  String get connectionName => 'Tilkoblingsnavn';

  @override
  String get connectionNameHint => 'f.eks. Min server';

  @override
  String get hostIpAddress => 'Vertsadresse/IP-adresse';

  @override
  String get hostIpHint => 'eksempel.no eller 1.2.3.4';

  @override
  String get port => 'Port';

  @override
  String get username => 'Brukernavn';

  @override
  String get usernameHint => 'f.eks. root eller ubuntu';

  @override
  String get sshPasswordHint => 'Skriv inn SSH-passordet ditt';

  @override
  String get savePassword => 'Lagre passord';

  @override
  String get savePasswordSubtitle => 'Usikkert - bare pa enheter du stoler pa';

  @override
  String get fillAllFields => 'Fyll ut alle feltene';
}
