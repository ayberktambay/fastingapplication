import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return PopupMenuButton<String>(
          icon: const Icon(Icons.language),
          onSelected: (String value) {
            languageProvider.setLanguage(value);
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'tr',
              child: Text('Türkçe'.i18n()),
            ),
            PopupMenuItem<String>(
              value: 'en',
              child: Text('English'.i18n()),
            ),
          ],
        );
      },
    );
  }
} 