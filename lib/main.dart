
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practica/config/router/app_router.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importa SharedPreferences

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Inicializa SharedPreferences
  await SharedPreferences.getInstance();
  
  runApp(const ProviderScope(child:  MyApp()));
}

class MyApp extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const MyApp({Key? key});

  @override 
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Clima",
      theme: ThemeData.light(),
      routerConfig: appRouter,
    );
  }
}
