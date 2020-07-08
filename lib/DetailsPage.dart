import 'package:flutter/material.dart';

import 'package:flutter_picker/flutter_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'helpers/Constants.dart';
import 'helpers/Dialogue.dart';
import 'helpers/Requester.dart';
import 'helpers/Style.dart';
import 'models/Service.dart';
import 'models/User.dart';

class DetailsPage extends StatefulWidget {
  final Service service;

  DetailsPage({Key key, this.service}) : super(key: key);

  @override
  _DetailsPageState createState() {
    return _DetailsPageState();
  }
}

class _DetailsPageState extends State<DetailsPage> {
  int _showWhichTable = 0; // 0 for freeSlots; 1 for PopularTimes

  @override
  Widget build(BuildContext context) {
    var startTime = widget.service.startTime;
    var closeTime = widget.service.closeTime;
    var freeSlots = widget.service.freeSlots;
    var popularTimes = widget.service.popularTimes;

    // image
    final coverPhoto = Hero(
      tag: "avatar_" + widget.service.id.toString(),
      child: new Image.network(widget.service.image),
    );

    // service name & address
    final basicInfo = GestureDetector(
        child: new Container(
      padding: const EdgeInsets.all(20.0),
      child: new Row(children: [
        new Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          new Container(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: new Text(widget.service.name,
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                  ))),
          new Container(
              width: max_width,
              child: Text(
                widget.service.address,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: new TextStyle(
                  color: colorText,
                ),
              )),
        ]),
      ]),
    ));

    // service intro
    final introText = GestureDetector(
        child: new Container(
      padding: const EdgeInsets.all(20.0),
      child: new Row(children: [
        new Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          new Container(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: new Text(introductionText,
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                  ))),
          new Container(
              width: max_width,
              child: Text(
                widget.service.introduction,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: new TextStyle(
                  color: colorText,
                ),
              )),
        ]),
      ]),
    ));

    // freeSlots and popularTimes table's titles
    final timeTableTitles = Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ToggleButtons(
              color: Colors.black12,
              selectedColor: Colors.black,
              borderColor: Colors.transparent,
              selectedBorderColor: Colors.transparent,
              fillColor: Colors.transparent,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(timeTableTitleText,
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(popularTimesTitleText,
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                      )
                  ),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  _showWhichTable = index == 1? 1 : 0;
                });
              },
              isSelected: [_showWhichTable == 0, _showWhichTable == 1],
            )
          ],
        )
    );

    // freeSlots table's title
    final freeSlotsTableTitle = new Container(
      padding: const EdgeInsets.only(
          left: 20.0, top: 20.0, right: 20.0, bottom: 14.0),
      child: new Row(children: [
        new Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          new Container(
              child: new Text(timeTableTitleText,
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                  ))),
        ]),
      ]),
    );

    // freeSlots table
    List<List<Color>> freeSlotsColors =
        getGradientColors(freeSlots, colorFreeSlot, 4, true);

    final freeSlotsTable = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Table(
          border: TableBorder.all(
              color: Colors.black12, width: 1, style: BorderStyle.solid),
          children: [
            TableRow(children: [
              for (var day in days)
                TableCell(
                    child: Container(
                        padding: const EdgeInsets.all(3.0),
                        child: Center(child: Text(day))))
            ]),
            for (int t = startTime; t < closeTime; t++)
              TableRow(children: [
                TableCell(
                    child: Container(
                        padding: const EdgeInsets.all(3.0),
                        child: Center(child: Text(t.toString())))),
                for (int d = 0; d < 7; d++)
                  TableCell(
                      child: Container(
                          color: freeSlotsColors[d][t - startTime],
                          padding: const EdgeInsets.all(3.0),
                          child: Center(
                              child: Text(
                                  freeSlots[d][t - startTime].toString()))))
              ])
          ]),
    );

    // popularTimes table's title
    final popularTimesTableTitle = new Container(
      padding: const EdgeInsets.only(
          left: 20.0, top: 20.0, right: 20.0, bottom: 14.0),
      child: new Row(children: [
        new Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          new Container(
              child: new Text(popularTimesTitleText,
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                  ))),
        ]),
      ]),
    );

    List<List<Color>> popularTimeColors = popularTimes.length == 0
        ? List()
        : getGradientColors(popularTimes, colorPopTime, 4);
    // popularTimes table
    final popularTimesTable = popularTimes.length == 0
        ? null
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Table(
                border: TableBorder.all(
                    color: Colors.black12, width: 1, style: BorderStyle.solid),
                children: [
                  TableRow(children: [
                    for (var day in days)
                      TableCell(
                          child: Container(
                              padding: const EdgeInsets.all(3.0),
                              child: Center(child: Text(day))))
                  ]),
                  for (int t = startTime; t < closeTime; t++)
                    TableRow(children: [
                      TableCell(
                          child: Container(
                              padding: const EdgeInsets.all(3.0),
                              child: Center(child: Text(t.toString())))),
                      for (int d = 0; d < 7; d++)
                        TableCell(
                            child: Container(
                                color: popularTimeColors[d][t],
                                padding: const EdgeInsets.all(3.0),
                                child: Center(
                                    child:
                                        Text(popularTimes[d][t].toString()))))
                    ])
                ]),
          );

    var timeSlotsTables = popularTimes.length == 0
        ? Column(children: <Widget>[
            freeSlotsTableTitle,
            freeSlotsTable,
          ])
        : Column(
          children: <Widget>[
            timeTableTitles,
            GestureDetector(
                onTap: () {
                  setState(() {
                    _showWhichTable = _showWhichTable == 1? 0 : 1;
                  });
                },
                child: IndexedStack(
                  index: _showWhichTable,
                  children: <Widget>[
                    Column(children: <Widget>[
                      //freeSlotsTableTitle,
                      freeSlotsTable,
                    ]),
                    Column(children: <Widget>[
                      //popularTimesTableTitle,
                      popularTimesTable,
                    ]),
                  ],
                ),
              ),
          ],
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
        child: Text(reserveButtonText,
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );

    return new Scaffold(
        appBar: new AppBar(
          elevation: 0.2,
          title: new Text(widget.service.name,
              style: TextStyle(color: Colors.white, fontSize: 18)),
          leading: BackButton(color: Colors.white),
          flexibleSpace: Container(
            decoration: getGradientBox(),
          ),
        ),
        body: new ListView(children: <Widget>[
          coverPhoto,
          basicInfo,
          introText,
          timeSlotsTables,
          reserveButton,
        ]));
  }

  List<Map<String, List<String>>> _fillPickerData() {
    var pickerData = new List<Map<String, List<String>>>();
    for (var d = 0; d < widget.service.freeSlots.length; ++d) {
      var dayList = new List<String>();
      for (var t = widget.service.startTime;
          t < widget.service.closeTime;
          ++t) {
        if (widget.service.freeSlots[d][t - widget.service.startTime] > 0) {
          dayList.add("${t <= 12? t : t-12} " + (t < 12? "am" : "pm"));
        }
      }
      pickerData.add({days[d + 1]: dayList});
    }
    return pickerData;
  }

  void _reservePressed(BuildContext context) {
    new Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata:
                _fillPickerData()), // new JsonDecoder().convert(pickerData)),
        hideHeader: true,
        title: new Text(reservePopupText),
        onConfirm: (Picker picker, List value) async {
          ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
          await pr.show();
          int bookDate = value[0];
          int bookTime = int.parse(picker.getSelectedValues()[1]);
          await Requester()
              .makeReservation(
                  User.token, widget.service.name, bookDate, bookTime)
              .then((_) async {
            await pr.hide();
            Dialogue.showBarrierDismissibleNoContent(
              context,
              'Reservation succeeded.',
            );
            setState(() {
              widget.service.freeSlots[bookDate]
                  [bookTime - widget.service.startTime] -= 1;
            });
          }).catchError((error) async {
            await pr.hide();
            Dialogue.showConfirmNoContent(
              context,
              'Reservation failed:  ${error.toString()}',
              'Got it',
            );
          });
          await pr.hide();
        }).showDialog(context);
  }
}
