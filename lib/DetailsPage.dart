import 'package:flutter/material.dart';
import 'package:gghack/helpers/Constants.dart';
import 'package:gghack/helpers/GradientColors.dart';
import 'models/Service.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'dart:convert';

class DetailsPage extends StatelessWidget {
  final Service service;
  DetailsPage({this.service});

  @override
  Widget build(BuildContext context) {

    var time = service.time;
    var data = service.slots;

    // image
    final coverPhoto = Hero(
      tag: "avatar_" + service.name,
      child: new Image.network(service.photo),
    );

    // service name & address
    final basicInfo = GestureDetector(
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
                          style: new TextStyle(fontWeight: FontWeight.bold,))),
                  new Text(
                    service.address,
                    style: new TextStyle(color: colorBase,),),
                ]),
            ]),)
    );

    // service intro
    final introText = GestureDetector(
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
                          introductionText,
                          style: new TextStyle(fontWeight: FontWeight.bold,))),
                  new Text(
                    service.introduction,
                    style: new TextStyle(color: colorBase,),),
                ]),
            ]),)
    );

    // time table's title
    final timeTableTitle = GestureDetector(
        child: new Container(
          padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 14.0),
          child: new Row(
              children: [
                new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Container(
                          child: new Text(
                              timeTableTitleText,
                              style: new TextStyle(fontWeight: FontWeight.bold,))),
                    ]),
              ]),)
    );

    // time table
    final timeTable = GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Table(
              border: TableBorder.all(color: Colors.black12, width: 1, style: BorderStyle.solid),
              children: [
                TableRow(children: [
                  for (var day in days) TableCell(child: Container(
                      padding: const EdgeInsets.all(3.0),
                      child: Center(child: Text(day))))
                ]),
                for (int t = time[0]; t < time[1]; t++)
                  TableRow(children: [
                    TableCell(child: Container(
                        padding: const EdgeInsets.all(3.0),
                        child: Center(child: Text(t.toString())))),
                    for (int d = 0; d < 7; d++) TableCell(child: Container(
                        color: getGradient(data[d][t-time[0]]),
                        padding: const EdgeInsets.all(3.0),
                        child: Center(child: Text(data[d][t-time[0]].toString()))))
                  ])
              ]))
    );

    // "reserve" button
    final reserveButton = Padding(
      padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 40.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
          _reservePressed(context);
        },
        padding: EdgeInsets.all(12),
        color: colorLight,
        child: Text(reserveButtonText, style: TextStyle(color: Colors.white)),
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(service.name),
      ),
      body: new ListView(
        children: <Widget>[
          coverPhoto,
          basicInfo,
          introText,
          timeTableTitle,
          timeTable,
          reserveButton,
        ]
      )
    );
  }

  void _reservePressed(BuildContext context) {
    new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: new JsonDecoder().convert(pickerData)),
        hideHeader: true,
        title: new Text(reservePopupText),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
        }
    ).showDialog(context);
  }
}
