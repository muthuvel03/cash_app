import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fresh_apk/login_page.dart';

import 'google_signin_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (GoogleSignInApi.isSignedIn == true) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackroundHandler);
  }
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
    theme: ThemeData(
      fontFamily: 'Poppins',
      primaryColor: Colors.white, // Set the primary color to white
    ),
  ));
}

Future<void> _firebaseMessagingBackroundHandler(RemoteMessage message) async {
  if (GoogleSignInApi.isSignedIn == true) {
    print(message.notification!.title.toString());
  }
}
