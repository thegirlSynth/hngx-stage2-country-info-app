import 'package:flutter/material.dart';

class CountryInfo extends StatelessWidget{
  const CountryInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final country = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(title: Text(country['name']['common']),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(country["flags"]["png"], height: 100),
            SizedBox(height: 10.0,),
            Text('Capital: ${country['capital']?[0] ?? 'N/A'}'),
            Text('Population: ${country['population']}'),
            Text('Continent: ${country['region']}'),
            Text('Country Code: ${country['cca2']}'),
            Text('States/Provinces: ${country['subdivisions'] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }

}