import 'package:flutter/material.dart';
import 'package:gghack/helpers/Constants.dart';
import 'models/Service.dart';

class DetailsPage extends StatelessWidget {
  final Service service;
  DetailsPage({this.service});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(service.name),
      ),
      body: new ListView(
        children: <Widget>[
          // image
          Hero(
            tag: "avatar_" + service.name,
            child: new Image.network(service.photo),
          ),
          // service name and address
          GestureDetector(
            onTap: () {},
            child: new Container(
              padding: const EdgeInsets.all(20.0),
              child: new Row(
                children: [
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Container(
                        padding: const EdgeInsets.only(bottom: 8.0),
                          child: new Text(
                              service.name,
                              style: new TextStyle(fontWeight: FontWeight.bold,))
                      ),
                      new Text(
                        service.address,
                        style: new TextStyle(color: colorBase,),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ),
          // service introduction
          GestureDetector(
              onTap: () {},
              child: new Container(
                padding: const EdgeInsets.all(20.0),
                child: new Row(
                  children: [
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Container(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: new Text(
                            "Introduction",
                            style: new TextStyle(fontWeight: FontWeight.bold,))
                        ),
                        new Text(
                          "work to be done.",
                          style: new TextStyle(color: colorBase,),
                        ),
                      ],
                    ),
                  ],
                ),
              )
          ),
        ]
      )
    );
  }
}