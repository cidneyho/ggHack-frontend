import 'package:flutter/material.dart';
import 'package:gghack/helpers/Constants.dart';
import 'package:gghack/helpers/Style.dart';
import 'package:gghack/helpers/Requester.dart';
import 'package:gghack/helpers/Dialogue.dart';
import 'package:gghack/models/User.dart';
import 'models/Service.dart';
import 'package:flutter_picker/flutter_picker.dart';

class DetailsPage extends StatelessWidget {
  final Service service;
  DetailsPage({this.service});

  @override
  Widget build(BuildContext context) {

    var startTime = service.startTime;
    var closeTime = service.closeTime;
    var data = service.freeSlots;

    // image
    final coverPhoto = Hero(
      tag: "avatar_" + service.name,
      child: new Image.network(service.image),
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
                  new Container(
                    width: max_width,
                    child: Text(
                      service.address,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: new TextStyle(color: colorText,),)
                  ),
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
                  new Container(
                    width: max_width,
                    child: Text(
                      service.introduction,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: new TextStyle(color: colorText,),)
                  ),
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
                for (int t = startTime; t < closeTime; t++)
                  TableRow(children: [
                    TableCell(child: Container(
                        padding: const EdgeInsets.all(3.0),
                        child: Center(child: Text(t.toString())))),
                    for (int d = 0; d < 7; d++) TableCell(child: Container(
                        color: getGradient(data[d][t-startTime]),
                        padding: const EdgeInsets.all(3.0),
                        child: Center(child: Text(data[d][t-startTime].toString()))))
                  ])
              ]))
    );

    // "reserve" button
    final reserveButton = Padding(
      padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 24.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
          _reservePressed(context);
        },
        padding: EdgeInsets.all(12),
        color: colorDark,
        child: Text(reserveButtonText, style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.2,
        title: new Text(service.name, style: TextStyle(color: Colors.white, fontSize: 18)),
        leading: BackButton(
            color: Colors.white
        ),
        flexibleSpace: Container(
          decoration: getGradientBox(),
        ),
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

  List<Map<String, List<int>>> _fillPickerData() {
    var pickerData = new List<Map<String, List<int>>>();
    for(var d = 0; d < service.freeSlots.length; ++d) {
      var dayList = new List<int>();
      for(var t = service.startTime; t < service.closeTime; ++t) {
        if(service.freeSlots[d][t - service.startTime] > 0) {
          dayList.add(t);
        }
      }
      pickerData.add({days[d+1] : dayList});
    }
    return pickerData;
  }

  void _reservePressed(BuildContext context) {
    new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: _fillPickerData()), // new JsonDecoder().convert(pickerData)),
        hideHeader: true,
        title: new Text(reservePopupText),
        onConfirm: (Picker picker, List value) async {
          int bookDate = value[0];
          int bookTime = int.parse(picker.getSelectedValues()[1]);
          await Requester().makeReservation(
            User.token, service.name, bookDate, bookTime).then((_) {
            Dialogue.showBarrierDismissible(
              context,
              'Successful Reservation',
              'You may find it in "Reservations".',
            );
          }
          ).catchError((error) {
            Dialogue.showConfirm(
              context,
              'Reservation failed.',
              'Error message ${error.toString()}',
              'Got it',
            );
          });
        }
    ).showDialog(context);
  }
}
