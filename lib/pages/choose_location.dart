import 'package:flutter/material.dart';
import 'package:worldtime/services/world_time.dart';

class ChooseLocation extends StatefulWidget {
  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  List<WorldTime> locations = [];

  @override
  void initState() {
    super.initState();
  }

  void updateTime(index) async {
    WorldTime instance = locations[index];
    await instance.timeDiffFromLocal();
    Map dayTime = await WorldTime.runRiseAndSet(
        instance.location.split('/')[instance.location.split('/').length - 1]);
    Map timeInfo = WorldTime.getTime(instance.timeDiff);
    Navigator.pop(context, {
      'location': instance.location,
      'flag': instance.flag,
      'timeDiff': instance.timeDiff,
      'dayTime': dayTime
    });
  }

  @override
  Widget build(BuildContext context) {
    Map allLocations = ModalRoute.of(context).settings.arguments;
    allLocations['allTimeZone'].forEach((echItm) {
      String countryCode = allLocations['allTimeZoneMap'][echItm];
      locations.add(WorldTime(
          url: echItm,
          location: echItm
              .toString()
              .split('/')[echItm.toString().split('/').length - 1]
              .replaceAll('_', ' '),
          flag: countryCode));
    });
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Choose a location'),
          centerTitle: true,
          elevation: 0,
        ),
        body: ListView.builder(
          itemCount: locations.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
              child: Card(
                child: ListTile(
                  onTap: () {
                    updateTime(index);
                  },
                  title: Text(locations[index].location),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://www.countryflags.io/${locations[index].flag}/shiny/64.png'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            );
          },
        ));
  }
}
