import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:worldtime/services/world_time.dart';
import 'dart:async';
import 'package:worldtime/singletons/app_data.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map timeData = {};
  Map requestTimeInfo = {
    'requestTimeDay': '',
    'requestTime': '',
    'requestTimeSec': ''
  };
  bool isDayTime = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _requestLocationTime();
      Timer.periodic(Duration(seconds: 1), (Timer t) => _requestLocationTime());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    timeData = timeData != null && timeData.isNotEmpty
        ? timeData
        : ModalRoute.of(context).settings.arguments;
    String bgImage = isDayTime ? 'day.png' : 'night.png';
    Color bgColor = isDayTime ?  Color.fromRGBO(210, 241, 255, 1): Color.fromRGBO(6, 60, 102, 1);
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/$bgImage'), fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              onPressed: () async {
                dynamic result = await Navigator.pushNamed(context, '/location');
                setState(() {
                  timeData = result;
                });
              },
              icon: Icon(
                Icons.edit_location,
                color: Colors.black,
              ),
              label: Text(
                'Choose location',
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://www.countryflags.io/${timeData['flag']}/shiny/64.png'),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(width: 10.0),
                Text(
                  timeData['location'],
                  style: TextStyle(
                      fontSize: 28.0, letterSpacing: 2.0, color: Colors.black),
                )
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  requestTimeInfo['requestTime'],
                  style: TextStyle(fontSize: 45.0, color: Colors.black),
                ),
                Text(
                  requestTimeInfo['requestTimeSec'],
                  style: TextStyle(fontSize: 25.0, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                Text(
                  requestTimeInfo['requestTimeDay'],
                  style: TextStyle(fontSize: 45.0, color: Colors.black),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }

  void _requestLocationTime() {
    setState(() {
      isDayTime =
          WorldTime.isDayTime(timeData['timeDiff'], timeData['dayTime']);
      requestTimeInfo = WorldTime.getTime(timeData['timeDiff']);
    });
  }
}
