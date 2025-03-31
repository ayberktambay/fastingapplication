
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:namaz_vakti/models/prayer_times.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_times_provider.dart';
import '../providers/theme_provider.dart';
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
                              color: isSelected ? Colors.green : Theme.of(context).textTheme.bodyLarge?.color,
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
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Namaz Vakti'.i18n()),
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
              child: IconButton(
                onPressed: () => _showCitySelector(context),
                icon: const Icon(Icons.location_on,color: Colors.white)
              )
            )
        ],
      ),
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
                  style: const TextStyle(color: Colors.red),
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
                    Icon(
                      Icons.refresh,
                      size: 48,
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load prayer times'.i18n(),
                      style: Theme.of(context).textTheme.titleMedium,
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
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode 
                              ? Colors.black26
                              : Colors.black.withOpacity(0.1),
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
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: theme.textTheme.titleLarge?.color,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                       
                          PrayerCountdown(prayerTimes: prayerTimes),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Prayer Times'.i18n(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      childAspectRatio: 0.75,
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
        color: Theme.of(context).cardColor,
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
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getPrayerIcon(prayerName),
                    color: color,
                    size: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    prayerName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: Text(
                    time,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isNext) ...[
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Next'.i18n(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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