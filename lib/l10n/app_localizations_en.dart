// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FlashLearn';

  @override
  String get homeTitle => 'Flash Learn';

  @override
  String get signOut => 'Sign Out';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get bulgarian => 'Bulgarian';

  @override
  String get swedish => 'Swedish';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsSignedInAs => 'Signed in as';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsAboutDescription =>
      'Learn Linux basics, terminal commands, and practical workflows in one place.';

  @override
  String get settingsHeroSubtitle =>
      'Personalize your learning environment with clean controls and focused account options.';

  @override
  String get settingsMadeBy => 'Made by';

  @override
  String get settingsGithub => 'GitHub';

  @override
  String get settingsFooterCredit =>
      'Built with care by nikichashadow · github.com/nikichashadow-code';

  @override
  String get navHome => 'Home';

  @override
  String get navSsh => 'SSH';

  @override
  String get navTerminal => 'Terminal';

  @override
  String get exploreTopics => 'Explore Topics';

  @override
  String get topicHistoryOfLinux => 'History of Linux';

  @override
  String get topicLinuxOsBasics => 'Linux OS Basics';

  @override
  String get topicTerminalCommands => 'Terminal Commands';

  @override
  String get topicDistrosEcosystem => 'Distributions & Ecosystem';

  @override
  String get searchCommandsHint => 'Search commands...';

  @override
  String get noCommandsFound => 'No commands found';

  @override
  String errorWithDetails(Object details) {
    return 'Error: $details';
  }

  @override
  String get welcomeTitle => 'Welcome to Linux Learn!';

  @override
  String get welcomeSubtitle =>
      'Discover the world of Linux: its history, commands, and more. Start your journey to mastering the terminal!';

  @override
  String get welcomeWhatYouWillLearn => 'What you will learn:';

  @override
  String get welcomeTopicHistory => 'History';

  @override
  String get welcomeTopicBasics => 'Basics';

  @override
  String get welcomeTopicTerminal => 'Terminal';

  @override
  String get welcomeTopicDistros => 'Distros';

  @override
  String get getStarted => 'Get Started';

  @override
  String get authBrand => 'Flash';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signUp => 'Sign Up';

  @override
  String get loginToContinue => 'Login to continue';

  @override
  String get createAccountToContinue => 'Create your account to continue';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get rememberMe => 'Remember Me';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get login => 'Login';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get signUpLink => 'Sign up';

  @override
  String get logInLink => 'Log in';

  @override
  String get loginFailed => 'Login failed.';

  @override
  String get signupFailed => 'Signup failed.';

  @override
  String get signUpSuccessCheckEmail =>
      'Sign up successful! Check your email to confirm.';

  @override
  String get enterEmailAddress => 'Please enter your email address';

  @override
  String get passwordResetLinkSent => 'Password reset link sent to your email';

  @override
  String errorPrefix(Object error) {
    return 'Error: $error';
  }

  @override
  String get linuxHistoryTitle => 'History of Linux';

  @override
  String get linuxBasicsTitle => 'Linux OS Basics';

  @override
  String get distrosEcosystemTitle => 'Distributions & Ecosystem';

  @override
  String couldNotLaunchUrl(Object url) {
    return 'Could not launch $url';
  }

  @override
  String get noCategoriesFound => 'No categories found.';

  @override
  String get noTopicsFound => 'No topics found.';

  @override
  String get noExamplesFound => 'No examples found.';

  @override
  String get terminalSimulatorTitle => 'Terminal Simulator';

  @override
  String get typeCommandHint => 'type command';

  @override
  String get createNewSetTitle => 'Create New Set';

  @override
  String get frontQuestion => 'Front (Question)';

  @override
  String get backAnswer => 'Back (Answer)';

  @override
  String get saveSet => 'Save Set';

  @override
  String flashcardProgress(Object current, Object total) {
    return '$current of $total';
  }

  @override
  String get know => 'Know';

  @override
  String get dontKnow => 'Don\'t Know';

  @override
  String get sshClientTitle => 'SSH Client';

  @override
  String get connectionSaved => 'Connection saved';

  @override
  String get connectedSuccessfully => 'Connected successfully';

  @override
  String get enterPassword => 'Enter Password';

  @override
  String passwordForUserAtHost(Object user, Object host) {
    return 'Password for $user@$host:';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get connect => 'Connect';

  @override
  String get passwordCannotBeEmpty => 'Password cannot be empty';

  @override
  String get notConnectedToAnyServer => 'Not connected to any server';

  @override
  String get noOutput => '(no output)';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get connectedStatus => '● Connected';

  @override
  String get noSavedConnections =>
      'No saved connections\nCreate a new one to get started';

  @override
  String get connectAction => 'Connect';

  @override
  String get deleteAction => 'Delete';

  @override
  String get deleteConnectionTitle => 'Delete Connection';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get newConnection => 'New Connection';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get unknown => 'Unknown';

  @override
  String get newSshConnection => 'New SSH Connection';

  @override
  String get connectionName => 'Connection Name';

  @override
  String get connectionNameHint => 'e.g., My Server';

  @override
  String get hostIpAddress => 'Host/IP Address';

  @override
  String get hostIpHint => 'example.com or 1.2.3.4';

  @override
  String get port => 'Port';

  @override
  String get username => 'Username';

  @override
  String get usernameHint => 'e.g., root or ubuntu';

  @override
  String get sshPasswordHint => 'Enter your SSH password';

  @override
  String get savePassword => 'Save Password';

  @override
  String get savePasswordSubtitle => 'Insecure - only on trusted devices';

  @override
  String get fillAllFields => 'Please fill in all fields';
}
