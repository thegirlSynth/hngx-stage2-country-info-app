import 'package:flutter/material.dart';
import 'package:hng_countries/screens/country_info.dart';
import 'package:hng_countries/screens/homescreen.dart';
import 'package:hng_countries/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/country_info': (context) => CountryInfo()
      },
    );
  }
}

