import 'package:country_explorer/screens/country_details.dart';
import 'package:flutter/material.dart';

class CountryTile extends StatelessWidget {
  final Map<String, dynamic> country;

  const CountryTile({Key? key, required this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // Navigate to country details screen when tile is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CountryDetailScreen(country: country),
          ),
        );
      },
      leading: Image.network(
        country['flags']['png'], // Display country flag
        width: 50,
        height: 30,
        fit: BoxFit.cover,
      ),
      title: Text(country['name']['common']),
      subtitle: Text(
          'Capital: ${country['capital']}, Population: ${country['population']}'), // Display country capital and population as subtitle
    );
  }
}
