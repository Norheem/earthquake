// ignore_for_file: unnecessary_new, prefer_const_constructors, unused_import, avoid_print, avoid_web_libraries_in_flutter, curly_braces_in_flow_control_structures, unused_local_variable, no_leading_underscores_for_local_identifiers, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() async {
  /*
  Another method
  Map _quakes = (await getQuakes());
  _feature = _quakes['features'];
  time = _quakes['features']['time'];
  place = _quakes['features']['place'];
  mag = _quakes['features']['mag']'


  */

  runApp(
    new MaterialApp(
      home: Quakes(),
    ),
  );
}

class Quakes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: new Text("Quakes"),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
        ),
        body: new Center(
            child: FutureBuilder<Map>(
                future: getQuakes(),
                builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data!;
                    var features = data['features'];
                    if (features is List) {
                      return ListView.builder(
                        itemCount: features.length,
                        padding: EdgeInsets.all(20.0),
                        itemBuilder: (BuildContext context, int position) {
                          if (position.isOdd) return new Divider();
                          final index = position ~/
                              2; //We are dividing index by 2 and returning an integer result
                          var feature = features[index];
                          var properties = feature['properties'];
                          var mag = properties['mag'];
                          var place = properties['place'];
                          var title = properties['title'];
                          /*
                          Another method for time is;
                          */
                          var timeInMillis = properties['time'];
                          var time = DateTime.fromMillisecondsSinceEpoch(
                              timeInMillis,
                              isUtc: true);
                          String formattedTime =
                              DateFormat.yMMMMd().add_jms().format(time);

                          return ListTile(
                            title: Text(
                              formattedTime,
                              style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 20.0,
                              ),
                            ),
                            subtitle: Text(
                              place,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 30.0,
                              child: Text(
                                "$mag",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onTap: () {
                              _showOnTapMessage(context, title);
                            },
                          );
                        },
                      );
                    }
                  }
                  return CircularProgressIndicator();
                })));
  }
}

void _showOnTapMessage(BuildContext context, String message) {
  var alert = new AlertDialog(
    title: new Text("Quakes"),
    content: new Text(message),
    actions: <Widget>[
      new TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text('OK'))
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<Map> getQuakes() async {
  String apiUrl =
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';
  http.Response response = await http.get(Uri.parse(apiUrl));

  return jsonDecode(response.body);
}
