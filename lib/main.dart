import 'package:flutter/material.dart';

import 'features/number_trivia/presentation/routes/number_trivia_route.dart';
import 'injection_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initializeServiceLocator().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final _theme = ThemeData(
      primaryColor: Colors.green.shade800,
      primarySwatch: Colors.green,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _theme.copyWith(
        colorScheme: _theme.colorScheme.copyWith(
          secondary: Colors.green.shade600,
        ),
      ),
      home: const NumberTriviaRoute(),
    );
  }
}
