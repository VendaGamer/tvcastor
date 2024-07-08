import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'home_page.dart';

void main() {
  runApp(const Base());
}

class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: FlexThemeData.light(scheme: FlexScheme.espresso),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.espresso),
      themeMode: ThemeMode.light,
    );
  }
}
