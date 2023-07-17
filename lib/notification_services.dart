import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fresh_apk/home_page.dart';

import 'google_signin_api.dart';

class NotificationServices {
  final username = GoogleSignInApi.currentUser?.displayName;
  final user = GoogleSignInApi.currentUser!;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
  );

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User denied permission");
    }
  }

  Future<void> initLocalNotification(
      BuildContext context, RemoteMessage message, user) async {
    if (GoogleSignInApi.isSignedIn == true) {
      var androidInitializationSettings =
          const AndroidInitializationSettings("@mipmap/ic_launcher");

      var initializationSetting =
          InitializationSettings(android: androidInitializationSettings);
      await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
          onDidReceiveNotificationResponse: (payload) async {
        handleMessage(context, message, user);
      });
    }
  }

  void firebaseInit(BuildContext context) {
    print("user name :$username");
    if (username != null) {
      print("user name 1:$username");
      if (GoogleSignInApi.isSignedIn == true && username == username) {
        print("user name 2:$username");
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          print("user name 3:$username");
          RemoteNotification? notification = message.notification;
          AndroidNotification? android = message.notification?.android;
          if (notification != null &&
              android != null &&
              GoogleSignInApi.isSignedIn == true &&
              username != null) {
            print("user name 4:$username");
            _flutterLocalNotificationsPlugin.show(
              message.notification!.hashCode,
              message.notification!.title.toString(),
              message.notification!.body.toString(),
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                ),
              ),
            );
          }
          print(message.notification!.body.toString());
          print(message.notification!.title.toString());
          print(message.data.toString());
          print(GoogleSignInApi.isSignedIn);
          initLocalNotification(context, message, user);
        });
      } else {
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
      }
    } else {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
    }
  }

  Future<void> showNotification() async {
    if (GoogleSignInApi.isSignedIn == true) {
      print(GoogleSignInApi.isSignedIn);
      await _flutterLocalNotificationsPlugin.show(
        0,
        "Testing",
        "How you doin ?",
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.high,
            color: Colors.blue,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  }

  void getDeviceToken() async {
    String? token = await messaging.getToken();
    print("Device Token:");
    print(token);
    saveToken(token!);
  }

  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((event) {
      print("Token refreshed");
      print(event);
      deleteToken();
      getDeviceToken();
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection("userTokens")
        .doc(GoogleSignInApi.currentUser?.id)
        .set({'token': token});
  }

  void deleteToken() async {
    await FirebaseFirestore.instance
        .collection("userTokens")
        .doc(GoogleSignInApi.currentUser?.id)
        .delete();
  }

  void handleMessage(BuildContext context, RemoteMessage message, user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Homepage(
          user: user,
        ),
      ),
    );
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    if (GoogleSignInApi.isSignedIn == true) {
      // When app is terminated
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();

      if (initialMessage != null) {
        handleMessage(context, initialMessage, user);
      }

      // When app is running in the background
      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        handleMessage(context, event, user);
      });
    }
  }
}
