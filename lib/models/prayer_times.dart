import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

class PrayerTimesModel {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;

  PrayerTimesModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  Prayer? nextPrayer() {
    final now = DateTime.now();
    final prayers = [
      (Prayer.fajr, fajr),
      (Prayer.sunrise, sunrise),
      (Prayer.dhuhr, dhuhr),
      (Prayer.asr, asr),
      (Prayer.maghrib, maghrib),
      (Prayer.isha, isha),
    ];

    for (var prayer in prayers) {
      if (prayer.$2.isAfter(now)) {
        return prayer.$1;
      }
    }
    return Prayer.fajr;
  }

  DateTime? timeForPrayer(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return fajr;
      case Prayer.sunrise:
        return sunrise;
      case Prayer.dhuhr:
        return dhuhr;
      case Prayer.asr:
        return asr;
      case Prayer.maghrib:
        return maghrib;
      case Prayer.isha:
        return isha;
      default:
        return null;
    }
  }

  String getTimeUntilNextPrayer() {
    final now = DateTime.now();
    final prayers = [fajr, sunrise, dhuhr, asr, maghrib, isha];
    
    for (var prayer in prayers) {
      if (prayer.isAfter(now)) {
        final difference = prayer.difference(now);
        final hours = difference.inHours;
        final minutes = difference.inMinutes % 60;
        return '$hours:${minutes.toString().padLeft(2, '0')}';
      }
    }
    
    // If no next prayer found, return time until next day's fajr
    final tomorrowFajr = fajr.add(const Duration(days: 1));
    final difference = tomorrowFajr.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}';
  }

  String getTimeUntilIftar() {
    final now = DateTime.now();
    
    // Check if sahur (fajr) has passed
    if (now.isBefore(fajr)) {
      // Show time until sahur
      final difference = fajr.difference(now);
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      return 'Sahura kalan süre: $hours saat ${minutes.toString().padLeft(2, '0')} dakika';
    } else if (now.isBefore(maghrib)) {
      // Show time until iftar
      final difference = maghrib.difference(now);
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      return 'İftara kalan süre: $hours saat ${minutes.toString().padLeft(2, '0')} dakika';
    } else {
      // If iftar has passed, calculate time until next day's sahur
      final tomorrowFajr = fajr.add(const Duration(days: 1));
      final difference = tomorrowFajr.difference(now);
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      return 'Sahura kalan süre: $hours saat ${minutes.toString().padLeft(2, '0')} dakika';
    }
  }

  String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }
} 