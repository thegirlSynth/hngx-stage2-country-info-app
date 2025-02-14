import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height * 0.7;
    double modalHeight = isExpanded ? maxHeight : MediaQuery.of(context).size.height * 0.5;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                          title: Text(continent),
                          value: selectedContinents.contains(continent),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedContinents.add(continent);
                              } else {
                                selectedContinents.remove(continent);
                              }
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
              children: [
                // Reset Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        selectedContinents.clear();
                        selectedTimeZones.clear();
                      });
                    },
                    child: Text("Reset"),
                  ),
                ),
                SizedBox(width: 10),
                // Show Results Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onFilterApplied(selectedContinents, selectedTimeZones);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: Text("Show results"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
