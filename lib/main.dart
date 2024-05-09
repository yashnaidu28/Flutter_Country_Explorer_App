
import 'package:country_explorer/screens/country_screen.dart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:country_explorer/provider/country_provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CountriesProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Country Explorer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const CountriesScreen(),
      ),
    );
  }
}

