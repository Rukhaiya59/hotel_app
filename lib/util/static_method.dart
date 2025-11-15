import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/entity_user.dart';
import '../objectbox.g.dart';

class StaticMethod {
  // StaticMethod.loadUsersFromJson(boxUser);
  static Future<void> loadUsersFromJson(Box<EntityUser> boxUser) async {
    final String jsonString = await rootBundle.loadString(
      'assets/json/users.json',
    );
    final List<dynamic> jsonList = jsonDecode(jsonString);
    List<EntityUser> listUser = jsonList
        .map((e) => EntityUser.fromJson(e))
        .toList();
    debugPrint("loadUsersFromJson: listUser.length: ${listUser.length}");
    boxUser.removeAll();
    boxUser.putMany(listUser);
  }

  // StaticMethod.getCurrentDateTimeToString()
  static String getCurrentDateTimeToString() {
    return DateTime.now().toUtc().toString();
    }
}