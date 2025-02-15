import 'package:flutter/material.dart';
import 'package:hng_countries/services/fetch_countries.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:hng_countries/theme/theme_provider.dart';
import 'package:hng_countries/widgets/filter_modal.dart';
import 'package:hng_countries/widgets/language_modal.dart';  // Import the new modal

class HomeScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const HomeScreen({super.key, required this.onLocaleChange});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FetchCountries _countryInfo = FetchCountries();
  List _countries = [];
  List _filteredCountries = [];
  Set<String> _selectedContinents = {};
  Set<String> _selectedTimeZones = {};
  final Map<String, List> _groupedCountries = {};

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    final countries = await _countryInfo.fetchCountries();
    countries.sort((a, b) => a['name']['common'].compareTo(b['name']['common']));
    setState(() {
      _countries = countries;
      _filteredCountries = List.from(countries);
      _groupCountries();
    });
  }

  void _filterCountries(String query) {
    setState(() {
      _filteredCountries = _countries
          .where((country) => country["name"]["common"]
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
      _groupCountries();
    });
  }

  void _filterCountriesByContinentAndTimeZone(Set<String> selectedContinents, Set<String> selectedTimeZones) {
    setState(() {
      _selectedContinents = selectedContinents;
      _selectedTimeZones = selectedTimeZones;

      // Show all countries if no filter is selected
      if (_selectedContinents.isEmpty && _selectedTimeZones.isEmpty) {
        _filteredCountries = List.from(_countries);
      } else {
        _filteredCountries = _countries.where((country) {
          List continents = country['continents'] ?? [];
          List timezones = country['timezones'] ?? [];

          bool continentMatch = _selectedContinents.isEmpty ||
              continents.any((c) => _selectedContinents.contains(c));

          bool timezoneMatch = _selectedTimeZones.isEmpty ||
              timezones.any((tz) => _selectedTimeZones.contains(tz));

          return continentMatch && timezoneMatch;
        }).toList();
      }

      _groupCountries(); // Ensure grouped countries update
    });
  }


  void _groupCountries() {
    _groupedCountries.clear();

    for (var country in _filteredCountries) {
      String firstLetter = country['name']['common'][0].toUpperCase();
      if (!_groupedCountries.containsKey(firstLetter)) {
        _groupedCountries[firstLetter] = [];
      }
      _groupedCountries[firstLetter]?.add(country);
    }
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FilterModal(
          selectedContinents: _selectedContinents,
          selectedTimeZones:  _selectedTimeZones,
          onFilterApplied: _filterCountriesByContinentAndTimeZone,
        );
      },
    );
  }

  void _showLanguageModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return LanguageModal(onLocaleChange: widget.onLocaleChange);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final textColor = themeProvider.isDarkMode ? Colors.white : Colors.black;
    final backgroundColor = themeProvider.isDarkMode ? Colors.black : Colors.white;
    final searchBarColor = themeProvider.isDarkMode ? Color(0x3398A2B3) : Color(0xFFF2F4F7);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            Image.asset(
              themeProvider.isDarkMode ? 'assets/img/explore_dark.png':'assets/img/explore_light.png',
              height: themeProvider.isDarkMode ? 26 : 35,
            ),
            Spacer(),
            IconButton(
              onPressed: () => themeProvider.toggleTheme(),
              icon: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 10),

            // Search Bar
            TextField(
              onChanged: _filterCountries,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Search Country',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: searchBarColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 10),

            // Language & Filter Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _showLanguageModal,
                  label: Text('EN', style: TextStyle(color: textColor)),
                  icon: Icon(Icons.language, color: textColor),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    shape: RoundedRectangleBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showFilterModal,
                  label: Text('Filter', style: TextStyle(color: textColor)),
                  icon: Icon(Icons.filter_alt_outlined, color: textColor),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    shape: RoundedRectangleBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            // Wrap content in Expanded + SingleChildScrollView
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _groupedCountries.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _groupedCountries.keys.length,
                      itemBuilder: (context, index) {
                        String letter = _groupedCountries.keys.elementAt(index);
                        List countries = _groupedCountries[letter] ?? [];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section Header
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                              child: Text(
                                letter,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                              ),
                            ),

                            // Country List
                            ...countries.map((country) {
                              return ListTile(
                                leading: CachedNetworkImage(
                                  imageUrl: country['flags']['png'],
                                  width: 40,
                                  height: 40,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error, color: textColor),
                                ),
                                title: Text(
                                  country['name']['common'],
                                  style: TextStyle(color: textColor, fontWeight: FontWeight.w400),
                                ),
                                subtitle: Text(
                                  country['capital']?.first ?? 'No Capital',
                                  style: TextStyle(color: textColor, fontWeight: FontWeight.w300),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    "/country_info",
                                    arguments: country,
                                  );
                                },
                              );
                            }),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
