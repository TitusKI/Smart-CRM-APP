import 'package:flutter/material.dart';
import 'package:smart_crm_app/injection_container.dart';

Future<void> main() async {
  await initializeInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
          body: Container(child: const Center(child: Text('Smart CRM APP')))),
    );
  }
}
