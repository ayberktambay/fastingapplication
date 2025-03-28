import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prayer_times.dart';
import '../models/city.dart';

class PrayerTimesProvider with ChangeNotifier {
  static const String _cityKey = 'selected_city';
  PrayerTimesModel? _prayerTimes;
  bool _isLoading = false;
  String _error = '';
  City _selectedCity = City.cities.first;

  PrayerTimesModel? get prayerTimes => _prayerTimes;
  bool get isLoading => _isLoading;
  String get error => _error;
  City get selectedCity => _selectedCity;

  PrayerTimesProvider() {
    _loadSavedCity();
  }

  Future<void> _loadSavedCity() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCityName = prefs.getString(_cityKey) ?? City.cities.first.name;
    _selectedCity = City.cities.firstWhere(
      (city) => city.name == savedCityName,
      orElse: () => City.cities.first,
    );
    notifyListeners();
    fetchPrayerTimes();
  }

  Future<void> setSelectedCity(City city) async {
    if (_selectedCity.name == city.name) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cityKey, city.name);
    _selectedCity = city;
    notifyListeners();
    fetchPrayerTimes();
  }

  DateTime _adjustToIstanbulTime(DateTime time) {
    // Convert UTC to Istanbul time (UTC+3)
    return time.add(const Duration(hours: 3));
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