import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/env/config_options.dart';
import 'package:flutter/material.dart';

void mainCommon(String env) {
  WidgetsFlutterBinding.ensureInitialized();
  initConfig(env: env);
  configureDependencies(env);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) =>
      const MaterialApp(title: 'Flutter Demo', home: HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Home Page')));
}
