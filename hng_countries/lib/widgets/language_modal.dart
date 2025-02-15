import 'package:flutter/material.dart';
import 'package:hng_countries/generated/l10n.dart';
import 'package:provider/provider.dart';

import '../theme/theme_provider.dart';

class LanguageModal extends StatelessWidget {
  final Function(Locale) onLocaleChange;

  const LanguageModal({super.key, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor = themeProvider.isDarkMode ? Colors.black : Colors.white;
    final List<Map<String, dynamic>> languages = [
      {'locale': const Locale('id'), 'name': 'Bahasa'},       // Indonesian
      {'locale': const Locale('de'), 'name': 'Deutsch'},      // German
      {'locale': const Locale('en'), 'name': 'English'},      // English
      {'locale': const Locale('es'), 'name': 'Español'},      // Spanish
      {'locale': const Locale('fr'), 'name': 'Française'},    // French
      {'locale': const Locale('it'), 'name': 'Italiano'},     // Italian
      {'locale': const Locale('pt'), 'name': 'Português'},    // Portuguese
      {'locale': const Locale('ru'), 'name': 'Русский'},      // Russian
      {'locale': const Locale('sv'), 'name': 'Svenska'},      // Swedish
      {'locale': const Locale('tr'), 'name': 'Türkçe'},       // Turkish
      {'locale': const Locale('zh'), 'name': '普通话'},       // Chinese (Mandarin)
      {'locale': const Locale('ar'), 'name': 'بالعربية'},    // Arabic
      {'locale': const Locale('bn'), 'name': 'বাংলা'},       // Bengali
    ];


    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).select_language, // Localized title
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),

            // Language Options (Dynamically Generated)
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final language = languages[index];
                  return ListTile(
                    title: Text(language['name']),
                    trailing: Radio<Locale>(
                      value: language['locale'],
                      groupValue: Localizations.localeOf(context),
                      onChanged: (Locale? value) {
                        if (value != null) {
                          onLocaleChange(value);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
