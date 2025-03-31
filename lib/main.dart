import 'package:flutter/foundation.dart';
import 'package:namaz_vakti/localizations/app_localizations.dart';
import 'package:namaz_vakti/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'providers/prayer_times_provider.dart';
import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';
import 'theme/app_theme.dart';

void main() {
 WidgetsFlutterBinding.ensureInitialized();
  //Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  runApp(const MaterialApp(home: PrayerApp()));
  // Set the directory for localization files
  LocalJsonLocalization.delegate.directories = ['lib/languages'];
  runApp(const PrayerApp());
}

class PrayerApp extends StatelessWidget {
  const PrayerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PrayerTimesProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer2<LanguageProvider, ThemeProvider>(
        builder: (context, languageProvider, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'İftar Vakti',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            locale: languageProvider.currentLocale,
            supportedLocales: const [
              Locale('tr', 'TR'),
              Locale('en', 'US'),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              LocalJsonLocalization.delegate,
            ],
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
