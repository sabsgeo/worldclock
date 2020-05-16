import 'package:flutter/material.dart';
import 'package:worldtime/services/world_time.dart';
import 'package:worldtime/singletons/app_data.dart';

class ChooseLocation extends StatefulWidget {
  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {

  @override
  void initState() {
    super.initState();
  }

  Future<bool> updateTime(int index, BuildContext appContext) async {
    WorldTime instance = appData.allWTLocations[index];
    await instance.timeDiffFromLocal();
    Map dayTime = await WorldTime.runRiseAndSet(
        instance.location.split('/')[instance.location.split('/').length - 1]);
    if(appContext.toString().length > 14) {
      Navigator.pop(appContext, {
        'location': instance.location,
        'flag': instance.flag,
        'timeDiff': instance.timeDiff,
        'dayTime': dayTime
      });
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Choose a location'),
          centerTitle: true,
          elevation: 0,
        ),
        body: ListView.builder(
          itemExtent: 70,
          itemCount: appData.allWTLocations .length,
          itemBuilder: (listContext, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
              child: Card(
                child: ListTile(
                  onTap: () async {
                    await updateTime(index, context);
                  },
                  title: Text(appData.allWTLocations[index].location),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://www.countryflags.io/${appData.allWTLocations[index].flag}/shiny/32.png'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            );
          },
        ));
  }
}
