import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme_provider.dart';

class CountryInfo extends StatelessWidget {
  const CountryInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final country = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text(country['name']['common'], style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flag with navigation arrows
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {}, // Placeholder for navigation
                      ),
                      Expanded( // Ensures the image takes only available space
                        child: Image.network(
                          country["flags"]["png"],
                          height: 200,
                          fit: BoxFit.contain, // Ensures the image scales properly
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () {}, // Placeholder for navigation
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),

            const SizedBox(height: 16.0),

            // Country details from API
            _buildDetailItem("Population", country['population'].toString(), context),
            _buildDetailItem("Region", country['region'], context),
            _buildDetailItem("Capital", country['capital']?[0] ?? 'N/A', context),
            _buildDetailItem("Official Name", country['name']['official'], context),
            SizedBox(height: 16.0,),
            _buildDetailItem("Official Language(s)", _getOfficialLanguages(country), context),
            _buildDetailItem("Subregion", country['subregion'] ?? 'N/A', context),
            _buildDetailItem("Borders", _getBorders(country), context),
            _buildDetailItem("UN Member", country['unMember'] == true ? "Yes" : "No", context),
            SizedBox(height: 16.0,),
            _buildDetailItem("Independent", country['independent'] == true ? "Yes" : "No", context),
            _buildDetailItem("Area", "${country['area']} km²", context),
            _buildDetailItem("Currency", _getCurrency(country), context),
            _buildDetailItem("Country Code", country['cca2'] ?? 'N/A', context),
            SizedBox(height: 16.0,),
            _buildDetailItem("Time Zone", (country['timezones'] as List).join(", "), context),
            _buildDetailItem("Start of Week", country['startOfWeek'] ?? 'N/A', context),
            _buildDetailItem("Dialing Code", "${country['idd']?['root'] ?? ''}${(country['idd']?['suffixes'] != null) ? country['idd']!['suffixes'][0] : ''}", context),
            _buildDetailItem("Driving Side", country['car']?['side'] ?? 'N/A', context),
          ],
        ),
      ),
    );
  }

  // Extracts official languages
  String _getOfficialLanguages(Map country) {
    if (country['languages'] != null) {
      return (country['languages'] as Map).values.join(", ");
    }
    return "N/A";
  }

  // Extracts currency
  String _getCurrency(Map country) {
    if (country['currencies'] != null) {
      var currency = country['currencies'] as Map;
      var currencyKey = currency.keys.first;
      return "${currency[currencyKey]['name']} ($currencyKey)";
    }
    return "N/A";
  }

  // Extracts border countries
  String _getBorders(Map country) {
    if (country['borders'] != null) {
      return (country['borders'] as List).join(", ");
    }
    return "None";
  }

  // Styled detail row
  Widget _buildDetailItem(String title, String value, BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Determine the text color based on the current theme mode
    Color textColor = themeProvider.isDarkMode ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: textColor),
          children: [
            TextSpan(text: "$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
