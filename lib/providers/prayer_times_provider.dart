import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import '../models/prayer_times.dart';
import '../models/city.dart';

class PrayerTimesProvider extends ChangeNotifier {
  PrayerTimesModel? _prayerTimes;
  bool _isLoading = false;
  String _error = '';
  City _selectedCity = City.cities[0]; // Default to Istanbul

  PrayerTimesModel? get prayerTimes => _prayerTimes;
  bool get isLoading => _isLoading;
  String get error => _error;
  City get selectedCity => _selectedCity;

  DateTime _adjustToIstanbulTime(DateTime time) {
    // Convert UTC to Istanbul time (UTC+3)
    return time.add(const Duration(hours: 3));
  }

  void setSelectedCity(City city) {
    _selectedCity = city;
    notifyListeners();
    fetchPrayerTimes();
  }

  Future<void> fetchPrayerTimes() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final coordinates = Coordinates(_selectedCity.latitude, _selectedCity.longitude);
      final params = CalculationMethod.muslim_world_league.getParameters();
      final date = DateComponents.from(DateTime.now());
      
      final prayerTimes = PrayerTimes(coordinates, date, params);
      
      _prayerTimes = PrayerTimesModel(
        fajr: _adjustToIstanbulTime(prayerTimes.fajr!),
        sunrise: _adjustToIstanbulTime(prayerTimes.sunrise!),
        dhuhr: _adjustToIstanbulTime(prayerTimes.dhuhr!),
        asr: _adjustToIstanbulTime(prayerTimes.asr!),
        maghrib: _adjustToIstanbulTime(prayerTimes.maghrib!),
        isha: _adjustToIstanbulTime(prayerTimes.isha!),
      );
    } catch (e) {
      _error = 'Namaz vakitleri alınamadı: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 