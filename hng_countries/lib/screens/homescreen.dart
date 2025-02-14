import 'package:flutter/material.dart';
import 'package:hng_countries/services/fetch_countries.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:hng_countries/theme/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FetchCountries _countryInfo = FetchCountries();
  List _countries = [];
  List _filteredCountries = [];
  Map<String, List> _groupedCountries = {};

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  void _fetchCountries() async {
    final countries = await _countryInfo.fetchCountries();
    countries.sort((a, b) => a['name']['common'].compareTo(b['name']['common']));

    setState(() {
      _countries = countries;
      _filteredCountries = countries;
      _groupCountries();
    });
  }

  void _filterCountries(String query) {
    setState(() {
      _filteredCountries = _countries
          .where((country) =>
          country["name"]["common"].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
      _groupCountries(); // Re-group after filtering
    });
  }

  void _groupCountries() {
    _groupedCountries = {}; // Reset before grouping

    for (var country in _filteredCountries) {
      String firstLetter = country['name']['common'][0].toUpperCase();
      if (!_groupedCountries.containsKey(firstLetter)) {
        _groupedCountries[firstLetter] = [];
      }
      _groupedCountries[firstLetter]?.add(country);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Text(
              "Explore.",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            IconButton(
              onPressed: () => themeProvider.toggleTheme(),
              icon: Icon(themeProvider.isDarkMode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: _filterCountries,
                    decoration: InputDecoration(
                      hintText: 'Search Country',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {},
                  label: Text('EN'),
                  icon: Icon(Icons.language),
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () {}, // Add filter function here
                  icon: Icon(Icons.filter_list),
                )
              ],
            ),
            Expanded(
              child: ListView(
                children: _groupedCountries.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...entry.value.map((country) => ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: country['flags']['png'],
                          width: 40,
                          height: 40,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        title: Text(country['name']['common']),
                        subtitle: Text(
                            country['capital']?.first ?? 'No Capital'),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/country_info",
                            arguments: country,
                          );
                        },
                      ))
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
