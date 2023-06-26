import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:qtivate/contants.dart';
import 'package:qtivate/pages/qrcode_scanner.dart';

class MongoDatabase {
  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
  }

  static checkLogin(String ra, String password) async {
    bool loginValid;
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection(COLLECTION_NAME);
    var login = await collection
        .find(where.eq('ra', ra).and(where.eq('password', password)))
        .toList();
    if (login.isEmpty) {
      loginValid = false;
    } else {
      loginValid = true;
    }
    return loginValid;
  }
}
