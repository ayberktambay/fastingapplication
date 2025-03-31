import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/material.dart';

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

  List<dynamic> getTimeUntilNextPrayerWithSeconds() {
    final now = DateTime.now();
    final nextPrayer = this.nextPrayer();
    if (nextPrayer != null) {
      final nextPrayerTime = timeForPrayer(nextPrayer);
      if (nextPrayerTime != null) {
        final difference = nextPrayerTime.difference(now);
        final hours = difference.inHours;
        final minutes = difference.inMinutes % 60;
        final seconds = difference.inSeconds % 60;

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
        final time = '$hours saat ${minutes.toString().padLeft(2, '0')} dakika ${seconds.toString().padLeft(2, '0')} saniye sonra';
        List<dynamic> timeList = [
          prayerName,
          time
        ];
        return timeList;
      }
    }
    return [];
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

class PrayerCountdown extends StatefulWidget {
  final PrayerTimesModel prayerTimes;

  const PrayerCountdown({Key? key, required this.prayerTimes}) : super(key: key);

  @override
  _PrayerCountdownState createState() => _PrayerCountdownState();
}

class _PrayerCountdownState extends State<PrayerCountdown> {
  late String timeUntilNextPrayer;
  late List<dynamic> data =[];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    data = widget.prayerTimes.getTimeUntilNextPrayerWithSeconds();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        data = widget.prayerTimes.getTimeUntilNextPrayerWithSeconds();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(data.isEmpty)
          const Text(
            'Sıradaki ezan bilgisi bulunamadı',
            style: TextStyle(fontSize: 16),
          )
        else
        Column(
          children: [
            Text(
              data[0],
              style: Theme.of(context).textTheme.titleLarge,
            ),
             Text(
          data[1],
          style: Theme.of(context).textTheme.titleMedium,
        ),
          ],
        ),
       
      ],
    );
  }
}

