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
  bool _isDiyanetMode = false;

  PrayerTimesModel? get prayerTimes => _prayerTimes;
  bool get isLoading => _isLoading;
  String get error => _error;
  City get selectedCity => _selectedCity;
  bool get isDiyanetMode => _isDiyanetMode;

  PrayerTimesProvider() {
    _loadSavedCity();
    _loadDiyanetMode();
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

  Future<void> _loadDiyanetMode() async {
    final prefs = await SharedPreferences.getInstance();
    _isDiyanetMode = prefs.getBool('isDiyanetMode') ?? false;
    notifyListeners();
  }

  Future<void> toggleDiyanetMode() async {
    _isDiyanetMode = !_isDiyanetMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDiyanetMode', _isDiyanetMode);
    notifyListeners();
    await fetchPrayerTimes();
  }

  DateTime _adjustToIstanbulTime(DateTime time) {
    // Convert UTC to Istanbul time (UTC+3)
    return time.add(const Duration(hours: 3));
  }

  DateTime _adjustTimeForDiyanet(DateTime time, Prayer prayer) {
    if (!_isDiyanetMode) return time;

    switch (prayer) {
      case Prayer.fajr:
        return time.add(const Duration(minutes: 6));
      case Prayer.sunrise:
        return time.add(const Duration(minutes: 3));
      case Prayer.dhuhr:
        return time.add(const Duration(minutes: 4));
      case Prayer.maghrib:
        return time.add(const Duration(minutes: 6));
      default:
        return time;
    }
  }

  Future<void> fetchPrayerTimes() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final coordinates = Coordinates(_selectedCity.latitude, _selectedCity.longitude);
      final params = _isDiyanetMode 
          ? CalculationMethod.turkey.getParameters()
          : CalculationMethod.muslim_world_league.getParameters();
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

  String getNextPrayerTime() {
    if (_prayerTimes == null) return '--:--';
    
    final nextPrayer = _prayerTimes!.nextPrayer();
    if (nextPrayer == null) return '--:--';
    
    final time = _prayerTimes!.timeForPrayer(nextPrayer);
    if (time == null) return '--:--';
    
    final adjustedTime = _adjustTimeForDiyanet(time, nextPrayer);
    return '${adjustedTime.hour.toString().padLeft(2, '0')}:${adjustedTime.minute.toString().padLeft(2, '0')}';
  }

  String getPrayerTime(Prayer prayer) {
    if (_prayerTimes == null) return '--:--';
    final time = _prayerTimes!.timeForPrayer(prayer);
    if (time == null) return '--:--';
    
    final adjustedTime = _adjustTimeForDiyanet(time, prayer);
    return '${adjustedTime.hour.toString().padLeft(2, '0')}:${adjustedTime.minute.toString().padLeft(2, '0')}';
  }

  Duration getTimeUntilNextPrayer() {
    if (_prayerTimes == null) return Duration.zero;
    
    final nextPrayer = _prayerTimes!.nextPrayer();
    if (nextPrayer == null) return Duration.zero;
    
    final nextPrayerTime = _prayerTimes!.timeForPrayer(nextPrayer);
    if (nextPrayerTime == null) return Duration.zero;
    
    final adjustedTime = _adjustTimeForDiyanet(nextPrayerTime, nextPrayer);
    return adjustedTime.difference(DateTime.now());
  }
} 