import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme_provider.dart';

class FilterModal extends StatefulWidget {
  final Set<String> selectedContinents;
  final Function(Set<String>, Set<String>) onFilterApplied;
  final Set<String> selectedTimeZones;

  const FilterModal({
    super.key,
    required this.selectedContinents,
    required this.selectedTimeZones,
    required this.onFilterApplied,
  });

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  final List<String> allTimeZones = [
    "GMT+12:00", "GMT+11:00", "GMT+10:00", "GMT+9:00", "GMT+8:00",
    "GMT+7:00", "GMT+6:00", "GMT+5:00", "GMT+4:00", "GMT+3:00",
    "GMT+2:00", "GMT+1:00", "GMT+0:00", "GMT-1:00", "GMT-2:00",
    "GMT-3:00", "GMT-4:00", "GMT-5:00", "GMT-6:00",
  ];
  final List<String> continents = [
    "Africa",
    "Antarctica",
    "Asia",
    "Australia",
    "Europe",
    "North America",
    "South America"
  ];
  late Set<String> selectedContinents;
  late Set<String> selectedTimeZones;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    selectedContinents = Set.from(widget.selectedContinents);
    selectedTimeZones = Set.from(widget.selectedTimeZones);
  }

  void toggleExpanded(bool value) {
    setState(() {
      isExpanded = value;
    });
  }

  void _onSelectionChanged() {
    widget.onFilterApplied(selectedContinents, selectedTimeZones);
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor = themeProvider.isDarkMode ? Colors.black : Colors.white;
    final textColor = themeProvider.isDarkMode ? Colors.white : Colors.black;
    double maxHeight = MediaQuery.of(context).size.height * 0.7;
    double modalHeight = isExpanded ? maxHeight : MediaQuery.of(context).size.height * 0.5;

    return Container(
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16.0, right: 16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: modalHeight,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Filter", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Continent Filters
                        ExpansionTile(
                          title: Text("Continent", style: TextStyle(fontWeight: FontWeight.bold)),
                          onExpansionChanged: toggleExpanded,
                          children: continents.map((continent) {
                            return CheckboxListTile(
                              activeColor: textColor,
                              checkColor: backgroundColor,
                              title: Text(continent),
                              value: selectedContinents.contains(continent),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedContinents.add(continent);
                                  } else {
                                    selectedContinents.remove(continent);
                                  }
                                  _onSelectionChanged();
                                });
                              },
                            );
                          }).toList(),
                        ),

                        // Time Zone Filters
                        ExpansionTile(
                          title: Text("TimeZone", style: TextStyle(fontWeight: FontWeight.bold)),
                          onExpansionChanged: toggleExpanded,
                          children: allTimeZones.map((timezone) {
                            return CheckboxListTile(
                              title: Text(timezone),
                              value: selectedTimeZones.contains(timezone),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedTimeZones.add(timezone);
                                  } else {
                                    selectedTimeZones.remove(timezone);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Reset Button
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            selectedContinents.clear();
                            selectedTimeZones.clear();
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: textColor),
                          foregroundColor: textColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Rounded corners
                          ),
                        ),
                        child: Text("Reset"),
                      ),
                    ),
                    SizedBox(width: 35),
                    // Show Results Button
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onFilterApplied(selectedContinents, selectedTimeZones);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF6C00),
                          foregroundColor: Colors.white, // White text
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Rounded corners
                          ),
                        ),
                        child: Text("Show results"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
