import 'package:fe_cnpmn/dependency_injection.dart';
import 'package:fe_cnpmn/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  setupDependencies();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
      },
    );
}
