import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:worldtime/services/world_time.dart';

class AppData {
  static final AppData _appData = new AppData._internal();

  String text;
  Map timeZoneInfo = {};
  List allTimeZones = [];
  Map localTimeInfo = {};
  List<WorldTime> allWTLocations = [];

  factory AppData() {
    return _appData;
  }
  AppData._internal();
}
final appData = AppData();