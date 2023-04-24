import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yatri/Authentication/authpage.dart';
import 'package:yatri/Authentication/utils.dart';
import 'package:yatri/Authentication/verify_amail_page.dart';

import 'homepage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Mainpage(),
      ),
    );
  }
}

class Mainpage extends StatelessWidget {
  const Mainpage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
          body: StreamBuilder<User?>(
        //here stream builder takes care of if the user is signed in  it will return homepage else it will return loginpagge
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const VerifyEmailPage();
          } else {
            return const AuthPage();
          }
        },
      ));
}
