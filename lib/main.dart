import 'package:flutter/material.dart';
import 'package:project3/page/SplashPage.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project3/page/User/LoginUser.dart';
import 'package:project3/page/Admin/LoginAdmin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Tambahkan ini
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOKERAMQ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'MyCustomFont',
        primarySwatch: Colors.blue,
      ),
      home: const SplashPage(),
      initialRoute: '/',
      routes: {
        // Rute untuk halaman login

        '/LoginUser': (context) => LoginUser(),
        '/LoginAdmin': (context) => LoginAdmin(),
      },
    );
  }
}
