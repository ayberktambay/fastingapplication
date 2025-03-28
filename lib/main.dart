import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/prayer_times_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrayerTimesProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'İftar Vakti',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
