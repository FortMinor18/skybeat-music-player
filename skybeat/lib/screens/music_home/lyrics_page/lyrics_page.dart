import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';

Future<Album> fetchAlbum() async {
  final response =
  await http.get('https://mourits-lyrics.p.rapidapi.com');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album{
  final String artist;
  final String song;
  Album({this.artist, this.song});
  factory Album.fromJson(Map<String, dynamic> json){
    return Album(
    song: json['song'],
    artist: json['artist']
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _myAppState createState() => _myAppState();
}

// ignore: camel_case_types
class _myAppState extends State<MyApp>{
  Future<Album> futureAlbum;

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    futureAlbum = fetchAlbum();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Fetch Data Unit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar( title: Text('Fetch data Sample'),),
      body: Center(
        child: FutureBuilder<Album>(
          future: futureAlbum,
          builder: (context, snapshot){
            if (snapshot.hasData){
              return Text(snapshot.data.song);
            }else if(snapshot.hasError){
              return Text("${snapshot.hasError}");
            }
            return CircularProgressIndicator();
          },
        )
      ),),
    );
  }
}