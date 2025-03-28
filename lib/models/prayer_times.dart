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
    
    if (now.isBefore(maghrib)) {
      final difference = maghrib.difference(now);
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      return '$hours saat ${minutes.toString().padLeft(2, '0')} dakika';
    } else {
      // If iftar has passed, calculate time until next day's iftar
      final tomorrowMaghrib = maghrib.add(const Duration(days: 1));
      final difference = tomorrowMaghrib.difference(now);
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      return '$hours saat ${minutes.toString().padLeft(2, '0')} dakika';
    }
  }

  String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }
} 