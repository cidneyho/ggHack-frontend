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
          // time table's title
          GestureDetector(
              onTap: () {},
              child: new Container(
                padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 14.0),
                child: new Row(
                  children: [
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Container(
                            child: new Text(
                                "Available slots",
                                style: new TextStyle(fontWeight: FontWeight.bold,))
                        ),
                      ],
                    ),
                  ],
                ),
              )
          ),
          // time table
          _renderTable(_freeSlots),
        ]
      )
    );
  }

  var _freeSlots = [
    [0,0,0,0,0,0,0,0,1,1,2,2,3,3,4,4,2,2,1,1,0,0,0,0], // Mon
    [0,0,0,0,0,0,0,0,1,1,3,3,2,2,1,1,1,1,1,1,0,0,0,0], // Tue
    [0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,2,2,1,1,0,0],
    [0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,1,1,1,1,0,0,0,0],
    [0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,1,1,1,1,1,1,0,0],
    [0,0,0,0,0,0,0,0,1,1,2,2,3,3,3,2,1,1,1,1,1,1,0,0],
    [0,0,0,0,0,0,0,0,1,1,2,2,3,3,2,2,1,1,1,1,1,1,0,0],
  ];

  Widget _renderTable(List<List<int>> data) {
    var days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Table(
          border: TableBorder.all(color: Colors.black26, width: 1, style: BorderStyle.solid),
          children: [
            TableRow(children: [
              for (var day in days) TableCell(child: Container(
                padding: const EdgeInsets.all(2.0),
                child: Center(child: Text(day))))
            ]),
            for (int t=0; t<24; t++)
              TableRow(children: [
                for (int d=0; d<7; d++) TableCell(child: Container(
                  color: _gradient(data[d][t]),
                  padding: const EdgeInsets.all(3.0),
                  child: Center(child: Text(data[d][t].toString()))))
              ])
          ]
        ));
  }

  Color _gradient(int data) {
    Color color;
    switch(data) {
      case 0:
        color = Colors.transparent;
        break;
      case 1:
        color = colorTone1;
        break;
      case 2:
        color = colorTone2;
        break;
      case 3:
        color = colorTone3;
        break;
      default:
        color = colorTone4;
        break;
    }
    return color;
  }
}
