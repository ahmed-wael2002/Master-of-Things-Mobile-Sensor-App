import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mot_app/view/home/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Add error handler for Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensors Demo',
      theme: ThemeData(
        useMaterial3: true,
        // TODO: Abstract theme file in separate file
        colorSchemeSeed: Colors.blue,
      ),
      home: const MyHomePage(title: 'Sensors Dashboard'),
      debugShowCheckedModeBanner: false,
    );
  }
}
