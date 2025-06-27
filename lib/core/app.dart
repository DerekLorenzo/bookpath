import 'package:book_path/core/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_path/core/landing_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'BookPath',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: LandingPage(),
      ),
    );
  }
}
