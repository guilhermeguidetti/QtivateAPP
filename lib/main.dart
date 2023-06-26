// @dart=2.9
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:qtivate/pages/login_page.dart';
import 'package:qtivate/pages/qrcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mongodb.dart';

// RODA NESSE COMANDO AQUI
// flutter run --no-sound-null-safety

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLoggedIn = (prefs.getBool('isLoggedIn') == null)
      ? false
      : prefs.getBool('isLoggedIn');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: isLoggedIn ? const QrScanner() : LoginScreen(),
  ));
}
