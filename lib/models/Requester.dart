/// This file is for networking demo from the tutorial
/// Fetch data: https://flutter.dev/docs/cookbook/networking/fetch-data
/// Send data: https://flutter.dev/docs/cookbook/networking/send-data
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:gghack/helpers/Constants.dart';
import 'ServiceList.dart';

// Suppose that we have a class called album
class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

// Get the json and fill in an object
// Note that I replaced ServiceService.dart with the following already
// https://flutter.dev/docs/cookbook/networking/send-data#2-sending-data-to-server
Future<Album> fetchAlbum() async {
  // Fetch data like the following
  final response =
  // The url should be replaced
  await http.get('https://jsonplaceholder.typicode.com/albums/1');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

// Send data to cloud to create albums
// https://flutter.dev/docs/cookbook/networking/send-data#2-sending-data-to-server
Future<http.Response> createAlbum(String title) {
  return http.post(
    // The url should be replaced according to the API
    'https://jsonplaceholder.typicode.com/albums',
    headers: <String, String>{
      // the header should be something Ting mentioned too
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );
}


/// The following is for demo display.
/// We won't use it, neither is it main.dart
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.title);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
