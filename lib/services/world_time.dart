import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;

class WorldTime {
  String location;
  String flag;
  String url;
  int timeDiff;
  String time;

  WorldTime({this.location, this.flag, this.url});

  Future<void> timeDiffFromLocal() async {
    Map localDataTemp = await getLocalTime();
    String localData = localDataTemp['utc_offset'].toString();
    Response requestTimeZoneInfo =
        await get('http://worldtimeapi.org/api/timezone/$url');
    String requestData =
        jsonDecode(requestTimeZoneInfo.body)['utc_offset'].toString();

    int localMulFactor = 1;
    int requestMulFactor = 1;

    if (localData.substring(0, 1) == '-') {
      localMulFactor = -1;
    }

    if (requestData.substring(0, 1) == '-') {
      requestMulFactor = -1;
    }

    int requestTimeInSec = DateFormat.Hm()
            .parse(requestData.substring(1, 6))
            .difference(DateFormat.Hm().parse("00:00"))
            .inSeconds *
        requestMulFactor;
    int localTimeInSec = DateFormat.Hm()
            .parse(localData.substring(1, 6))
            .difference(DateFormat.Hm().parse("00:00"))
            .inSeconds *
        localMulFactor;

    timeDiff = requestTimeInSec - localTimeInSec;
  }

  static Future<Map> getLocalTime() async {
    Response currentLocalTimeZoneInfo =
        await get('http://worldtimeapi.org/api/ip');
    return jsonDecode(currentLocalTimeZoneInfo.body);
  }

  static Map getTime(int timeDiffInSec) {
    DateTime requestNow = DateTime.now().add(Duration(seconds: timeDiffInSec));
    String requestTimeMin = DateFormat.jms().format(requestNow);
    return {
      'requestTime': requestTimeMin.substring(0, requestTimeMin.length - 6),
      'requestTimeSec': requestTimeMin.substring(
          requestTimeMin.length - 5, requestTimeMin.length - 2),
      'requestTimeDay': requestTimeMin.substring(requestTimeMin.length - 2)
    };
  }

  static Future<List> getAllTimeZone() async {
    Map allTimeZone = await getTimezoneToCountry();
    List data = allTimeZone.keys.toList();
    data.sort((a, b) => a.toString().compareTo(b.toString()));
    return data;
  }

  static Future<Map> getTimezoneToCountry() async {
    String jsonString =
        await rootBundle.loadString('assets/timezone_to_country.json');
    return json.decode(jsonString);
  }

  static Future<Map> runRiseAndSet(placeName) async {
    Response data = await get(
        'https://weather.ls.hereapi.com/weather/1.0/report.json?product=forecast_astronomy&name=$placeName&apiKey=Q5OwMtcBfPgz1UIHgtUelhvZ5RvDAieiyIHAmU8mUYM');
    Map decodeData = jsonDecode(data.body)['astronomy']['astronomy'][0];
    List sunrise = decodeData['sunrise'].toString().split('AM')[0].split(':');
    List sunset = decodeData['sunset'].toString().split('PM')[0].split(':');

    return {
      'sunrise': {
        'hours': int.parse(sunrise[0]),
        'minutes': int.parse(sunrise[1])
      },
      'sunset': {
        'hours': 12 + int.parse(sunset[0]),
        'minutes': int.parse(sunset[1])
      }
    };
  }

  static bool isDayTime(int timeDiffInSec, Map dayTime) {
    DateTime requestNow = DateTime.now().add(Duration(seconds: timeDiffInSec));
    String requestTimeMin = DateFormat.jms().format(requestNow);
    if (requestNow.hour >= dayTime['sunrise']['hours'] &&
            requestNow.hour <= dayTime['sunset']['hours']
        ? true
        : false) {
      if (requestNow.hour == dayTime['sunrise']['hours'] &&
          requestNow.hour < 12) {
        if (requestNow.minute >= dayTime['sunrise']['minutes']) {
          return true;
        } else {
          return false;
        }
      } else if (requestNow.hour == dayTime['sunrise']['hours'] &&
          requestNow.hour > 12) {
        if (requestNow.minute <= dayTime['sunset']['minutes']) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  }
}
