import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bg.dart';
import 'app_localizations_en.dart';
import 'app_localizations_sv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bg'),
    Locale('en'),
    Locale('sv'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'FlashLearn'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Flash Learn'**
  String get homeTitle;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @bulgarian.
  ///
  /// In en, this message translates to:
  /// **'Bulgarian'**
  String get bulgarian;

  /// No description provided for @swedish.
  ///
  /// In en, this message translates to:
  /// **'Swedish'**
  String get swedish;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as'**
  String get settingsSignedInAs;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsAboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Learn Linux basics, terminal commands, and practical workflows in one place.'**
  String get settingsAboutDescription;

  /// No description provided for @settingsHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personalize your learning environment with clean controls and focused account options.'**
  String get settingsHeroSubtitle;

  /// No description provided for @settingsMadeBy.
  ///
  /// In en, this message translates to:
  /// **'Made by'**
  String get settingsMadeBy;

  /// No description provided for @settingsGithub.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get settingsGithub;

  /// No description provided for @settingsFooterCredit.
  ///
  /// In en, this message translates to:
  /// **'Built with care by nikichashadow · github.com/nikichashadow-code'**
  String get settingsFooterCredit;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSsh.
  ///
  /// In en, this message translates to:
  /// **'SSH'**
  String get navSsh;

  /// No description provided for @navTerminal.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get navTerminal;

  /// No description provided for @exploreTopics.
  ///
  /// In en, this message translates to:
  /// **'Explore Topics'**
  String get exploreTopics;

  /// No description provided for @topicHistoryOfLinux.
  ///
  /// In en, this message translates to:
  /// **'History of Linux'**
  String get topicHistoryOfLinux;

  /// No description provided for @topicLinuxOsBasics.
  ///
  /// In en, this message translates to:
  /// **'Linux OS Basics'**
  String get topicLinuxOsBasics;

  /// No description provided for @topicTerminalCommands.
  ///
  /// In en, this message translates to:
  /// **'Terminal Commands'**
  String get topicTerminalCommands;

  /// No description provided for @topicDistrosEcosystem.
  ///
  /// In en, this message translates to:
  /// **'Distributions & Ecosystem'**
  String get topicDistrosEcosystem;

  /// No description provided for @searchCommandsHint.
  ///
  /// In en, this message translates to:
  /// **'Search commands...'**
  String get searchCommandsHint;

  /// No description provided for @noCommandsFound.
  ///
  /// In en, this message translates to:
  /// **'No commands found'**
  String get noCommandsFound;

  /// No description provided for @errorWithDetails.
  ///
  /// In en, this message translates to:
  /// **'Error: {details}'**
  String errorWithDetails(Object details);

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Linux Learn!'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover the world of Linux: its history, commands, and more. Start your journey to mastering the terminal!'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeWhatYouWillLearn.
  ///
  /// In en, this message translates to:
  /// **'What you will learn:'**
  String get welcomeWhatYouWillLearn;

  /// No description provided for @welcomeTopicHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get welcomeTopicHistory;

  /// No description provided for @welcomeTopicBasics.
  ///
  /// In en, this message translates to:
  /// **'Basics'**
  String get welcomeTopicBasics;

  /// No description provided for @welcomeTopicTerminal.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get welcomeTopicTerminal;

  /// No description provided for @welcomeTopicDistros.
  ///
  /// In en, this message translates to:
  /// **'Distros'**
  String get welcomeTopicDistros;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @authBrand.
  ///
  /// In en, this message translates to:
  /// **'Flash'**
  String get authBrand;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @loginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Login to continue'**
  String get loginToContinue;

  /// No description provided for @createAccountToContinue.
  ///
  /// In en, this message translates to:
  /// **'Create your account to continue'**
  String get createAccountToContinue;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @signUpLink.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUpLink;

  /// No description provided for @logInLink.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logInLink;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed.'**
  String get loginFailed;

  /// No description provided for @signupFailed.
  ///
  /// In en, this message translates to:
  /// **'Signup failed.'**
  String get signupFailed;

  /// No description provided for @signUpSuccessCheckEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign up successful! Check your email to confirm.'**
  String get signUpSuccessCheckEmail;

  /// No description provided for @enterEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get enterEmailAddress;

  /// No description provided for @passwordResetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to your email'**
  String get passwordResetLinkSent;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorPrefix(Object error);

  /// No description provided for @linuxHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'History of Linux'**
  String get linuxHistoryTitle;

  /// No description provided for @linuxBasicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Linux OS Basics'**
  String get linuxBasicsTitle;

  /// No description provided for @distrosEcosystemTitle.
  ///
  /// In en, this message translates to:
  /// **'Distributions & Ecosystem'**
  String get distrosEcosystemTitle;

  /// No description provided for @couldNotLaunchUrl.
  ///
  /// In en, this message translates to:
  /// **'Could not launch {url}'**
  String couldNotLaunchUrl(Object url);

  /// No description provided for @noCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No categories found.'**
  String get noCategoriesFound;

  /// No description provided for @noTopicsFound.
  ///
  /// In en, this message translates to:
  /// **'No topics found.'**
  String get noTopicsFound;

  /// No description provided for @noExamplesFound.
  ///
  /// In en, this message translates to:
  /// **'No examples found.'**
  String get noExamplesFound;

  /// No description provided for @terminalSimulatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Terminal Simulator'**
  String get terminalSimulatorTitle;

  /// No description provided for @typeCommandHint.
  ///
  /// In en, this message translates to:
  /// **'type command'**
  String get typeCommandHint;

  /// No description provided for @createNewSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Set'**
  String get createNewSetTitle;

  /// No description provided for @frontQuestion.
  ///
  /// In en, this message translates to:
  /// **'Front (Question)'**
  String get frontQuestion;

  /// No description provided for @backAnswer.
  ///
  /// In en, this message translates to:
  /// **'Back (Answer)'**
  String get backAnswer;

  /// No description provided for @saveSet.
  ///
  /// In en, this message translates to:
  /// **'Save Set'**
  String get saveSet;

  /// No description provided for @flashcardProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String flashcardProgress(Object current, Object total);

  /// No description provided for @know.
  ///
  /// In en, this message translates to:
  /// **'Know'**
  String get know;

  /// No description provided for @dontKnow.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Know'**
  String get dontKnow;

  /// No description provided for @sshClientTitle.
  ///
  /// In en, this message translates to:
  /// **'SSH Client'**
  String get sshClientTitle;

  /// No description provided for @connectionSaved.
  ///
  /// In en, this message translates to:
  /// **'Connection saved'**
  String get connectionSaved;

  /// No description provided for @connectedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Connected successfully'**
  String get connectedSuccessfully;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPassword;

  /// No description provided for @passwordForUserAtHost.
  ///
  /// In en, this message translates to:
  /// **'Password for {user}@{host}:'**
  String passwordForUserAtHost(Object user, Object host);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @passwordCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get passwordCannotBeEmpty;

  /// No description provided for @notConnectedToAnyServer.
  ///
  /// In en, this message translates to:
  /// **'Not connected to any server'**
  String get notConnectedToAnyServer;

  /// No description provided for @noOutput.
  ///
  /// In en, this message translates to:
  /// **'(no output)'**
  String get noOutput;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @connectedStatus.
  ///
  /// In en, this message translates to:
  /// **'● Connected'**
  String get connectedStatus;

  /// No description provided for @noSavedConnections.
  ///
  /// In en, this message translates to:
  /// **'No saved connections\nCreate a new one to get started'**
  String get noSavedConnections;

  /// No description provided for @connectAction.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connectAction;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @deleteConnectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Connection'**
  String get deleteConnectionTitle;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @newConnection.
  ///
  /// In en, this message translates to:
  /// **'New Connection'**
  String get newConnection;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @newSshConnection.
  ///
  /// In en, this message translates to:
  /// **'New SSH Connection'**
  String get newSshConnection;

  /// No description provided for @connectionName.
  ///
  /// In en, this message translates to:
  /// **'Connection Name'**
  String get connectionName;

  /// No description provided for @connectionNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., My Server'**
  String get connectionNameHint;

  /// No description provided for @hostIpAddress.
  ///
  /// In en, this message translates to:
  /// **'Host/IP Address'**
  String get hostIpAddress;

  /// No description provided for @hostIpHint.
  ///
  /// In en, this message translates to:
  /// **'example.com or 1.2.3.4'**
  String get hostIpHint;

  /// No description provided for @port.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., root or ubuntu'**
  String get usernameHint;

  /// No description provided for @sshPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your SSH password'**
  String get sshPasswordHint;

  /// No description provided for @savePassword.
  ///
  /// In en, this message translates to:
  /// **'Save Password'**
  String get savePassword;

  /// No description provided for @savePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Insecure - only on trusted devices'**
  String get savePasswordSubtitle;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get fillAllFields;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bg', 'en', 'sv'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bg':
      return AppLocalizationsBg();
    case 'en':
      return AppLocalizationsEn();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
