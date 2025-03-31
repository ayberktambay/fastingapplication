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
    final now = DateTime.now(); // Adjust current time to UTC+3
    final prayers = [
      (Prayer.fajr, (fajr)),
      (Prayer.sunrise, (sunrise)),
      (Prayer.dhuhr, (dhuhr)),
      (Prayer.asr, (asr)),
      (Prayer.maghrib, (maghrib)),
      (Prayer.isha, (isha)),
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
        return (fajr);
      case Prayer.sunrise:
        return (sunrise);
      case Prayer.dhuhr:
        return (dhuhr);
      case Prayer.asr:
        return (asr);
      case Prayer.maghrib:
        return (maghrib);
      case Prayer.isha:
        return (isha);
      default:
        return null;
    }
  }

  String getTimeUntilNextPrayer() {
    final now = DateTime.now(); 
    final nextPrayer = this.nextPrayer();
    if (nextPrayer != null) {
      final nextPrayerTime = timeForPrayer(nextPrayer);
      if (nextPrayerTime != null) {
        final difference = nextPrayerTime.difference(now);
        final hours = difference.inHours;
        final minutes = difference.inMinutes % 60;

        // Map prayer names to their Turkish equivalents
        final prayerNames = {
          Prayer.fajr: 'İmsak',
          Prayer.sunrise: 'Güneş',
          Prayer.dhuhr: 'Öğle',
          Prayer.asr: 'İkindi',
          Prayer.maghrib: 'Akşam',
          Prayer.isha: 'Yatsı',
        };

        final prayerName = prayerNames[nextPrayer] ?? 'Bilinmeyen';
        return '$prayerName: $hours saat ${minutes.toString().padLeft(2, '0')} dakika sonra';
      }
    }
    return 'Sıradaki ezan bilgisi bulunamadı';
  }

  String getTimeUntilIftar() {
    final now = DateTime.now(); // Adjust current time to UTC+3
    final fajrTime = (fajr);
    final maghribTime = (maghrib);
    
    // Check if sahur (fajr) has passed
    if (now.isBefore(fajrTime)) {
      // Show time until sahur
      final difference = fajrTime.difference(now);
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      return 'Sahura kalan süre: $hours saat ${minutes.toString().padLeft(2, '0')} dakika';
    } else if (now.isBefore(maghribTime)) {
      // Show time until iftar
      final difference = maghribTime.difference(now);
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      return 'İftara kalan süre: $hours saat ${minutes.toString().padLeft(2, '0')} dakika';
    } else {
      // If iftar has passed, calculate time until next day's sahur
      final tomorrowFajr = fajrTime.add(const Duration(days: 1));
      final difference = tomorrowFajr.difference(now);
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      return 'Sahura kalan süre: $hours saat ${minutes.toString().padLeft(2, '0')} dakika';
    }
  }

  String formatTime(DateTime time) {
    return DateFormat('HH:mm').format((time));
  }
}