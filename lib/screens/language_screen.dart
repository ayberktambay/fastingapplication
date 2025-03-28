import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'language'.i18n(),
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      body: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildLanguageOption(
                context,
                title: 'Türkçe',
                subtitle: 'Turkish',
                isSelected: languageProvider.currentLocale.languageCode == 'tr',
                onTap: () => languageProvider.setLanguage('tr'),
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 12),
              _buildLanguageOption(
                context,
                title: 'English',
                subtitle: 'İngilizce',
                isSelected: languageProvider.currentLocale.languageCode == 'en',
                onTap: () => languageProvider.setLanguage('en'),
                isDarkMode: isDarkMode,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      elevation: isDarkMode ? 2 : 1,
      shadowColor: isDarkMode ? Colors.black : Colors.grey[300],
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Colors.green
                    : (isDarkMode ? Colors.white : Colors.black87),
              ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
        ),
        trailing: isSelected
            ? const Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}