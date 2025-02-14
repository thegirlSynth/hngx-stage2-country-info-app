import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hng_countries/services/fetch_countries.dart';
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
  String _searchQuery = '';

  @override
  void initState () {
    super.initState();
    _fetchCountries();
  }

  void _fetchCountries() async {
    final countries = await _countryInfo.fetchCountries();
    countries.sort((a, b) => a['name']['common'].compareTo(b['name']['common']));
    setState((){
      _countries = countries;
      _filteredCountries = countries;
    });
  }

  void _filterCountries(String query) {
    setState((){
      _searchQuery = query;
      _filteredCountries = _countries
          .where((country) => country["name"]["common"]
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.white,
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
              icon: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Colors.black87,
              ),
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
                SizedBox(width: 10,),
                ElevatedButton.icon(
                  onPressed: (){},
                  label: Text('EN'),
                  icon: Icon(Icons.language),
                ),
                SizedBox(width: 10,),
                IconButton(
                  onPressed: (){}, 
                  icon: Icon(Icons.filter_list),
                )
              ],
            ),
        
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCountries.length,
                itemBuilder: (context, index){
        
                  final country = _filteredCountries[index];
        
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: country['flags']['png'],
                      width: 40,
                      height: 40,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    title: Text(country['name']['common']),
                    subtitle: Text(country['capital']?.first ?? 'No Capital'),
                    onTap: (){
                      Navigator.pushNamed(
                        context,
                        "/country_info",
                        arguments: country,
                      );
                    },
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
