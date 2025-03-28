import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_times_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/language_selector.dart';
import '../widgets/prayer_time_card.dart';
import '../models/city.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Ekran yüklendiğinde namaz vakitlerini getir
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PrayerTimesProvider>(context, listen: false).fetchPrayerTimes();
    });
  }

  List<City> _getFilteredCities() {
    if (_searchQuery.isEmpty) {
      return City.cities;
    }
    return City.cities
        .where((city) =>
            city.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _showCitySelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'select_city'.i18n(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'search'.i18n(),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _getFilteredCities().length,
                      itemBuilder: (context, index) {
                        final city = _getFilteredCities()[index];
                        final isSelected = city.name ==
                            Provider.of<PrayerTimesProvider>(context, listen: false)
                                .selectedCity
                                .name;
                        return ListTile(
                          title: Text(
                            city.name,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.green : Colors.black87,
                            ),
                          ),
                          onTap: () {
                            Provider.of<PrayerTimesProvider>(context, listen: false)
                                .setSelectedCity(city);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İftar Vakti'.i18n()),
        actions: [
            Container(
              height: 50,
              width: 50,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(360),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade300,Colors.blue.shade700])
          ),
          child: IconButton(onPressed: () => _showCitySelector(context),icon: Icon(Icons.location_on,color: Colors.white)))
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Consumer<PrayerTimesProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (provider.error.isNotEmpty) {
              return Center(
                child: Text(
                  provider.error,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            }

            final prayerTimes = provider.prayerTimes;
            if (prayerTimes == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.refresh,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load prayer times'.i18n(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => provider.fetchPrayerTimes(),
                      icon: const Icon(Icons.refresh),
                      label: Text('Try Again'.i18n()),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => provider.fetchPrayerTimes(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:  BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => _showCitySelector(context),
                            child: Text(
                              provider.selectedCity.name,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Remaining Time'.i18n(),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            prayerTimes.getTimeUntilIftar(),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Prayer Times'.i18n(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      childAspectRatio: 0.85,
                      children: [
                        _buildPrayerCard(
                          context,
                          prayerName: 'Fajr'.i18n(),
                          time: prayerTimes.formatTime(prayerTimes.fajr),
                          isNext: DateTime.now().isBefore(prayerTimes.fajr),
                          color: Colors.blue,
                        ),
                        _buildPrayerCard(
                          context,
                          prayerName: 'Sunrise'.i18n(),
                          time: prayerTimes.formatTime(prayerTimes.sunrise),
                          isNext: DateTime.now().isBefore(prayerTimes.sunrise) &&
                              DateTime.now().isAfter(prayerTimes.fajr),
                          color: Colors.orange,
                        ),
                        _buildPrayerCard(
                          context,
                          prayerName: 'Dhuhr'.i18n(),
                          time: prayerTimes.formatTime(prayerTimes.dhuhr),
                          isNext: DateTime.now().isBefore(prayerTimes.dhuhr) &&
                              DateTime.now().isAfter(prayerTimes.sunrise),
                          color: Colors.green,
                        ),
                        _buildPrayerCard(
                          context,
                          prayerName: 'Asr'.i18n(),
                          time: prayerTimes.formatTime(prayerTimes.asr),
                          isNext: DateTime.now().isBefore(prayerTimes.asr) &&
                              DateTime.now().isAfter(prayerTimes.dhuhr),
                          color: Colors.purple,
                        ),
                        _buildPrayerCard(
                          context,
                          prayerName: 'Maghrib'.i18n(),
                          time: prayerTimes.formatTime(prayerTimes.maghrib),
                          isNext: DateTime.now().isBefore(prayerTimes.maghrib) &&
                              DateTime.now().isAfter(prayerTimes.asr),
                          color: Colors.red,
                        ),
                        _buildPrayerCard(
                          context,
                          prayerName: 'Isha'.i18n(),
                          time: prayerTimes.formatTime(prayerTimes.isha),
                          isNext: DateTime.now().isBefore(prayerTimes.isha) &&
                              DateTime.now().isAfter(prayerTimes.maghrib),
                          color: Colors.indigo,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPrayerCard(
    BuildContext context, {
    required String prayerName,
    required String time,
    required bool isNext,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getPrayerIcon(prayerName),
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  prayerName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (isNext) ...[
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Next'.i18n(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getPrayerIcon(String prayerName) {
    switch (prayerName) {
      case 'Fajr':
        return Icons.nightlight_round;
      case 'Sunrise':
        return Icons.wb_sunny_rounded;
      case 'Dhuhr':
        return Icons.wb_sunny_outlined;
      case 'Asr':
        return Icons.wb_sunny;
      case 'Maghrib':
        return Icons.nights_stay_rounded;
      case 'Isha':
        return Icons.nightlight_round;
      default:
        return Icons.access_time;
    }
  }
} 