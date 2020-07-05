import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:sprintf/sprintf.dart';
import 'helpers/Dialogue.dart';
import 'helpers/Constants.dart';
import 'helpers/Requester.dart';
import 'models/Reservation.dart';
import 'models/ReservationList.dart';
import 'models/User.dart';
import 'CreateServicePage.dart';

class ProviderHomePage extends StatefulWidget {

  @override
  _ProviderHomePageState createState() {
    return _ProviderHomePageState();
  }

}

class _ProviderHomePageState extends State<ProviderHomePage> {
  final TextEditingController _filter = new TextEditingController();

  // To keep only one slider open
  final SlidableController slidableController = SlidableController();

  ReservationList _reservations = new ReservationList(reservations: new List());
  Widget _appBarTitle = new Text(pappTitle, style: TextStyle(color: Colors.white));

  @override
  void initState() {
    super.initState();

    _getReservations();
  }

  void _getReservations() async {
    ReservationList reservations = await Requester().providerRenderReservationList(User.token);
    // Sort reservations chronologically
   reservations.reservations.sort((e1, e2) => (e1.bookDate > e2.bookDate || (e1.bookDate == e2.bookDate && e1.bookTime > e2.bookTime))? 1: 0);
    setState(() {
      for (Reservation reservation in reservations.reservations) {
        this._reservations.reservations.add(reservation);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget listitem;

    if (false) { // service exists
      listitem = ListTile(
        title: Text("Edit Service"),
        onTap: () {
          Navigator.pop(context);
        },
      );
    } else {
      listitem = ListTile(
        title: Text("Create Service"),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => CreateServicePage()));
        },
      );
    }

    return Scaffold (
      appBar: _buildBar(context),
      backgroundColor: Colors.white,
      body: _buildList(context),
      drawer: Drawer(
        child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: "Menu\n", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                      TextSpan(text: " \n", style: TextStyle(fontSize: 4.0)),
                      TextSpan(text: "Hi, " + User.name, style: TextStyle(fontSize: 14.0)),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      colorGrad1,
                      colorGrad2
                    ],),
                ),
              ),
              listitem,
            ]
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar (
        elevation: 0.2,
        centerTitle: true,
        title: _appBarTitle,
        iconTheme: IconThemeData(color: Colors.white),
      actions: <Widget>[
        IconButton(
          padding: const EdgeInsets.only(right: 10.0),
          icon: const Icon(MdiIcons.qrcodeScan),
          onPressed: () async {
            print("Scan QR code");
            var result = await BarcodeScanner.scan();
            print(result.type);
            print(result.rawContent);
            int reservationId = int.parse(result.rawContent);
            await Requester().checkInReservation(User.token, reservationId).catchError((error) {
              Dialogue.showConfirmNoContent(context, "Failed to scan QR code: ${error.toString()}", "Got it");
            }).then((_) {
              Dialogue.showBarrierDismissibleNoContent(context, "Reservation checked in.");
            });
          },
        ),
      ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                colorGrad1,
                colorGrad2
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView (
      padding: const EdgeInsets.only(top: 16.0),
      children: this._reservations.reservations.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, Reservation reservation) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      controller: slidableController,
      actionExtentRatio: (reservation.status == "PD"? 0.25 : 0.0),
      child: Card(
        elevation: 0.2,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          height: 100,
          decoration: BoxDecoration(color: colorBase),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(

              padding: EdgeInsets.only(right: 12.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[(
                      reservation.status == "CP"? completedIcon : (
                      reservation.status == "PD"? pendingIcon :
                      noShowIcon))]
              ),
            ),
            title: Row(
              children: <Widget>[
                new Flexible(
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Text(reservation.customer,
                                  style: TextStyle(fontWeight: FontWeight.bold))
                          ),
                          RichText(
                            text: TextSpan(
                              text: "2020-07-0${(reservation.bookDate+2)%7+4} ${reservation.bookTime}:00",
                              style: TextStyle(color: colorText),
                            ),
                            maxLines: 1,
                            softWrap: true,
                          )
                        ]
                    ))
              ],),
            trailing: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onPressed: (reservation.status != "PD"? null : () {
                // confirm confirm
                _showAlertDialog(context, reservation);
              }),
              padding: EdgeInsets.all(8),
              disabledColor: Colors.grey,
              color: colorDark,
              child: Text(checkinButtonText, style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ),
        ),
      ),
// We may slide to check-in, too
//      actions: <Widget>[
//        IconSlideAction(
//          caption: 'Check in',
//          color: Colors.lightGreen,
//          icon: Icons.check,
//          onTap: () {print("More");},
//        ),
//      ],
      secondaryActions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.4),
          child: IconSlideAction(
            caption: 'No show',
            color: Colors.red[400],
            icon: Icons.close,
            onTap: () async {
              bool response = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Mark no-show reservation?"),
                    content: Text(
                      sprintf("%s on 7/${(reservation.bookDate+2)%7+4} at ${reservation.bookTime}:00",[]),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Not now"),
                      ),
                      FlatButton(
                          onPressed: () async {
                            await Requester().noShowReservation(User.token, reservation.id)
                                .then((value) {
                              if(value == 0) {
                                Navigator.of(context).pop(true);
                              }
                            }).catchError((onError) {
                              Navigator.of(context).pop(false);
                              Dialogue.showConfirmNoContent(context, "Mark no-show failed: ${onError.toString()}", "Got it.");
                            });
                          },
                          child: const Text("Confirm")
                      ),
                    ],
                  );
                },
              );
              if(response) {
                Dialogue.showBarrierDismissibleNoContent(context, "Reservation marked as no-show.");
                setState(() {
                  this._reservations.changeStatus(reservation.id, "MS");
                });
              }
            },
          ),
        ),
      ],
    );
  }

  _showAlertDialog(BuildContext context, Reservation reservation) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () { Navigator.pop(context); },
    );
    Widget continueButton = FlatButton(
      child: Text("Confirm"),
      onPressed:  () async {
        Navigator.pop(context);
        await Requester().checkInReservation(User.token, reservation.id).then((_) {
          Dialogue.showBarrierDismissibleNoContent(context, "Checked in ${reservation.customer}.");
          setState(() {
            this._reservations.changeStatus(reservation.id, "CP");
          });
        }).catchError((error) {
          Dialogue.showConfirmNoContent(context, "Failed to check in: ${error.toString()}", "Got it.");
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm " + checkinButtonText),
      // content: Text(""),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
