import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:country_explorer/provider/country_provider.dart';
import 'package:country_explorer/screens/loading_screen.dart';
import 'package:country_explorer/widgets/content_list.dart';
import 'error_screen.dart';

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({Key? key}) : super(key: key);

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  String? _selectedContinent;
  String? _selectedSubregion;
  String? _selectedSortOption;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final countriesProvider = Provider.of<CountriesProvider>(context);

    // Fetch countries data if not already loading and continents data is empty
    if (!countriesProvider.isLoading &&
        countriesProvider.continents.isEmpty) {
      countriesProvider.fetchCountriesByContinent();
    }

    if (countriesProvider.isLoading) {
      return const LoadingScreen();
    }

    if (countriesProvider.errorMessage.isNotEmpty) {
      return ErrorScreen(errorMessage: countriesProvider.errorMessage);
    }

    return GestureDetector(
      onTap: () {
        // Unfocus the keyboard when tapping outside the search box
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(105, 61, 60, 56),
          title: const Text('Countries by Continent'),
          actions: [
            // Popup menu for sorting options
            PopupMenuButton<String>(
              onSelected: (option) {
                setState(() {
                  _selectedSortOption = option;
                });
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'name',
                  child: Text('Sort by Name'),
                ),
                const PopupMenuItem(
                  value: 'population',
                  child: Text('Sort by Population'),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Search ',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                // Listen for vertical drags to dismiss the keyboard
                onVerticalDragUpdate: (_) {
                  FocusScope.of(context).unfocus();
                },
                child: CountryList(
                  // Pass parameters to the country list widget
                  searchQuery: _searchController.text.toLowerCase(),
                  selectedSortOption: _selectedSortOption,
                  selectedContinent: _selectedContinent,
                  selectedSubregion: _selectedSubregion,
                  onExpansionChanged: (String continent, String subregion) {
                    setState(() {
                      _selectedContinent = continent;
                      _selectedSubregion = subregion;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
