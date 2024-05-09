import 'package:country_explorer/widgets/county_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:country_explorer/provider/country_provider.dart';

class CountryList extends StatelessWidget {
  final String searchQuery;
  final String? selectedSortOption;
  final String? selectedContinent;
  final String? selectedSubregion;
  final Function(String, String) onExpansionChanged;
  const CountryList({
    Key? key,
    required this.searchQuery,
    required this.selectedSortOption,
    required this.selectedContinent,
    required this.selectedSubregion,
    required this.onExpansionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final countriesProvider = Provider.of<CountriesProvider>(context);

    // Build a ListView of expansion tiles for continents and subregions
    return ListView.builder(
      itemCount: countriesProvider.continents.length,
      itemBuilder: (BuildContext context, int index) {
        String continent = countriesProvider.continents.keys.elementAt(index);
        Map<String, List<dynamic>> subregions =
            countriesProvider.continents[continent]!;
        return ExpansionTile(
          initiallyExpanded: continent == selectedContinent,
          onExpansionChanged: (expanded) {
            onExpansionChanged(continent, '');
          },
          title: Text(continent),
          children: subregions.entries.map<Widget>((entry) {
            String subregion = entry.key;
            List<dynamic> countries = entry.value;
            List<dynamic> sortedCountries = _sortCountries(countries);
            List<dynamic> filteredCountries = _filterCountries(sortedCountries);
            return ExpansionTile(
              initiallyExpanded: subregion == selectedSubregion,
              onExpansionChanged: (expanded) {
                onExpansionChanged(continent, subregion);
              },
              title: Text(subregion),
              children: filteredCountries
                  .map<Widget>((country) => CountryTile(country: country))
                  .toList(),
            );
          }).toList(),
        );
      },
    );
  }

  // Function to sort countries based on the selected sorting option
  List<dynamic> _sortCountries(List<dynamic> countries) {
    if (selectedSortOption == 'name') {
      countries
          .sort((a, b) => a['name']['common'].compareTo(b['name']['common']));
    } else if (selectedSortOption == 'population') {
      countries.sort((a, b) => a['population'].compareTo(b['population']));
    }
    return countries;
  }

  // Function to filter countries based on the search query
  List<dynamic> _filterCountries(List<dynamic> countries) {
    String query = searchQuery.toLowerCase();
    if (query.isNotEmpty) {
      return countries
          .where((country) =>
              country['name']['common'].toLowerCase().contains(query))
          .toList();
    }
    return countries;
  }
}
