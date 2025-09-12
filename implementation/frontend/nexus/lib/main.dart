import 'package:flutter/material.dart';
//import 'package:calendar/synccalendar.dart';
//import 'package:calendar/kcalendar.dart';
import 'package:flutter/rendering.dart';
import 'package:performance_playground/performance_playground.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Center(
        child: Text(
          'Error: ${details.exception}',
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ),
    );
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugRepaintRainbowEnabled = true;
    debugProfileLayoutsEnabled = true;
    debugProfileBuildsEnabled = true;
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SafeArea(child: PerformancePlayground()),
    );
  }
}
