import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:map_launcher/map_launcher.dart';

class MapUtils {
  Future openMaps(BuildContext context, String name, String vicinity,
      double lat, double lng) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;

      print(availableMaps);

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: Coords(lat, lng),
                          title: name,
                          description: vicinity,
                        ),
                        title: Text(map.mapName),
                        leading: Image(
                          image: map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
