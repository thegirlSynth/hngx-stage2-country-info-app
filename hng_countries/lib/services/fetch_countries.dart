import 'dart:convert';
import 'package:http/http.dart';

class FetchCountries {
  Future<List> fetchCountries () async {
    final url = Uri.parse("https://restcountries.com/v3.1/all");
    final response = await get(url);

    List data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      return ["Failed to load countries"];
    }
  }
}