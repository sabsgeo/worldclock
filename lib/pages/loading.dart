import 'package:flutter/material.dart';
import 'package:worldtime/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:worldtime/singletons/app_data.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Future<void> setupWorldTime() async {
    Map localInfo = await WorldTime.getLocalTime();
    Map allTimeZoneMap = await WorldTime.getTimezoneToCountry();
    List allTimeZone = await WorldTime.getAllTimeZone();
    if (appData.allWTLocations.isEmpty) {
      allTimeZone.forEach((echItm) {
        String countryCode = allTimeZoneMap[echItm]['country_code'];
        appData.allWTLocations.add(WorldTime(
            url: echItm,
            location: echItm
                .toString()
                .split('/')[echItm
                .toString()
                .split('/')
                .length - 1]
                .replaceAll('_', ' '),
            flag: countryCode));
      });
    }
    WorldTime instance = WorldTime(
        location: localInfo['timezone'].toString().split('/')[1],
        flag: 'IN',
        url: localInfo['timezone']);
    await instance.timeDiffFromLocal();
    Map dayTime = await WorldTime.runRiseAndSet(
        instance.location.split('/')[instance.location.split('/').length - 1]);
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'location': instance.location,
      'flag': instance.flag,
      'timeDiff': instance.timeDiff,
      'dayTime': dayTime
    });
  }

  @override
  void initState() {
    super.initState();
    setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [
                    0.5,
                    0.5
                  ],
                  colors: [Color.fromRGBO(210, 241, 255, 1), Color.fromRGBO(6, 60, 102, 1)]),
              image: DecorationImage(
                  image: AssetImage('assets/day_night.png'), fit: BoxFit.cover)),
          child: Center(
            child: SpinKitFoldingCube(
              color: Color.fromRGBO(0, 0, 0, .5),
              size: 80.0,
            ),
          ),
        ));
  }
}
