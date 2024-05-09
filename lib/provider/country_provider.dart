import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CountriesProvider extends ChangeNotifier {
  Map<String, Map<String, List<dynamic>>> continents = {};
  bool isLoading = false;
  String errorMessage = '';
  Future<void> fetchCountriesByContinent() async {
    isLoading = true;
    try {
      final response =
          await http.get(Uri.parse('https://restcountries.com/v3.1/all'));
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data != null && data is List<dynamic>) {
          continents.clear();
          for (var country in data) {
            final String? continent = country['region'];
            final String? subregion = country['subregion'];
            // Check if both continent and subregion exist
            if (continent != null && subregion != null) {
              if (!continents.containsKey(continent)) {
                continents[continent] = {};
              }
              if (!continents[continent]!.containsKey(subregion)) {
                continents[continent]![subregion] = [];
              }
              continents[continent]![subregion]!.add(country);
            }
          }
          errorMessage = ''; // Clear error message if data fetch is successful
        } else {
          throw 'Invalid data format';
        }
      } else {
        throw 'Failed to load data: ${response.statusCode}';
      }
    } catch (error) {
      errorMessage = _handleError(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Method to handle and format error messages
  String _handleError(dynamic error) {
    if (error is http.ClientException) {
      return 'Error: No internet connection';
    } else {
      return 'Error: $error';
    }
  }
}
