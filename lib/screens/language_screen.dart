import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';
import '../providers/language_provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('language'.i18n()),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
              ),
              const SizedBox(height: 12),
              _buildLanguageOption(
                context,
                title: 'English',
                subtitle: 'İngilizce',
                isSelected: languageProvider.currentLocale.languageCode == 'en',
                onTap: () => languageProvider.setLanguage('en'),
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
  }) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.green : Colors.black87,
              ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
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