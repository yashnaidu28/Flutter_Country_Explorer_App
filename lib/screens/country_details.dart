import 'package:flutter/material.dart';

class CountryDetailScreen extends StatelessWidget {
  final dynamic country;

  const CountryDetailScreen({Key? key, required this.country})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country['name']['common']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              country['flags']['png'],
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text('Capital: ${country['capital']}'),
            const SizedBox(height: 10),
            Text('Population: ${country['population']}'),
            const SizedBox(height: 10),
            Text('Region: ${country['region']}'),
            const SizedBox(height: 10),
            Text('Subregion: ${country['subregion']}'),
          ],
        ),
      ),
    );
  }
}
