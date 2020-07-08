import 'package:flutter/material.dart';
import 'package:gghack/ProviderServiceListPage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:progress_dialog/progress_dialog.dart';
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

  bool _sortByStatus = true;
  Icon _sortIcon = new Icon(MdiIcons.history, color: Colors.white);

  ReservationList _reservations = new ReservationList(reservations: new List());
  Widget _appBarTitle =
      new Text(pappTitle, style: TextStyle(color: Colors.white));

  @override
  void initState() {
    super.initState();

    _getReservations();
  }

  void _getReservations() async {
    ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    await pr.show();
    ReservationList reservations =
        await Requester().providerRenderReservationList(User.token);

    reservations.sortReservationsByStatus();

    setState(() {
      for (Reservation reservation in reservations.reservations) {
        this._reservations.reservations.add(reservation);
      }
    });
    await pr.hide();
  }

  @override
  Widget build(BuildContext context) {
    Widget listitem;

    if (false) {
      // service exists
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateServicePage()));
        },
      );
    }

    return Scaffold(
      appBar: _buildBar(context),
      backgroundColor: Colors.white,
      body: _buildList(context),
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          DrawerHeader(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: "Menu\n",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
                  TextSpan(text: " \n", style: TextStyle(fontSize: 4.0)),
                  TextSpan(
                      text: "Hi, " + User.name,
                      style: TextStyle(fontSize: 14.0)),
                ],
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[colorGrad1, colorGrad2],
              ),
            ),
          ),
          listitem,
          ListTile(
            title: Text("My services"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new PServiceListPage()));
            },
          ),
          ListTile(
            title: Text("Log out"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ]),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      elevation: 0.2,
      centerTitle: true,
      title: _appBarTitle,
      iconTheme: IconThemeData(color: Colors.white),
      actions: <Widget>[
        IconButton(
          padding: const EdgeInsets.only(right: 10.0),
          icon: const Icon(MdiIcons.qrcodeScan),
          onPressed: () async {
            var result = await BarcodeScanner.scan();
            if (result.type == ResultType.Barcode) {
              ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
              await pr.show();
              int reservationId = int.parse(result.rawContent);
              await Requester()
                  .checkInReservation(User.token, reservationId)
                  .catchError((error) async {
                await pr.hide();
                Dialogue.showConfirmNoContent(context,
                    "Failed to scan QR code: ${error.toString()}", "Got it");
              }).then((_) async {
                await pr.hide();
                Dialogue.showBarrierDismissibleNoContent(
                    context, "Reservation checked in.");
                setState(() {
                  this._reservations.changeStatus(reservationId, "CP");
                  this._reservations.sortReservationsByStatus();
                });
              });
            } else if (result.type == ResultType.Error) {
              Dialogue.showConfirmNoContent(context,
                  "Failed to scan QR code: ${result.toString()}", "Got it");
            }
          },
        ),
        IconButton(
          icon: this._sortIcon,
          onPressed: _sortPressed,
        )
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[colorGrad1, colorGrad2],
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 16.0),
      children: _reservations.reservations.length == 0
          ? [
        Text("Please wait while we are loading reservations for you...",
            style: TextStyle(color: colorText))
      ]
          : this
          ._reservations
          .reservations
          .map((data) => _buildListItem(context, data))
          .toList(),
    );
  }

  Widget _buildListItem(BuildContext context, Reservation reservation) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      controller: slidableController,
      actionExtentRatio: (reservation.status == "PD" ? 0.25 : 0.0),
      child: Card(
        elevation: 0.2,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          height: 100,
          decoration: BoxDecoration(color: colorBase),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    (reservation.status == "CP"
                        ? completedIcon
                        : (reservation.status == "PD"
                            ? pendingIcon
                            : noShowIcon))
                  ]),
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
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      RichText(
                        text: TextSpan(
                          text: sprintf('2020-07-%02d %02d:00', [
                            reservation.bookDate + 6,
                            reservation.bookTime,
                          ]),
                          style: TextStyle(color: colorText),
                        ),
                        maxLines: 1,
                        softWrap: true,
                      )
                    ]))
              ],
            ),
            trailing: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onPressed: (reservation.status != "PD"
                  ? null
                  : () {
                      // confirm confirm
                      _showAlertDialog(context, reservation);
                    }),
              padding: EdgeInsets.all(8),
              disabledColor: Colors.grey,
              color: colorDark,
              child: Text(checkinButtonText,
                  style: TextStyle(color: Colors.white, fontSize: 14)),
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
                      sprintf("%s on Jul %02d at %02d:00",
                          [reservation.customer, reservation.bookDate + 6, reservation.bookTime]),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Not now"),
                      ),
                      FlatButton(
                          onPressed: () async {
                            ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
                            await pr.show();
                            await Requester()
                                .noShowReservation(User.token, reservation.id)
                                .then((value) {
                              if (value == 0) {
                                Navigator.of(context).pop(true);
                              }
                              setState(() {
                                this._reservations.changeStatus(reservation.id, "MS");
                                this._reservations.sortReservationsByStatus();
                              });
                            }).catchError((onError) async {
                              await pr.hide();
                              Navigator.of(context).pop(false);
                              Dialogue.showConfirmNoContent(
                                  context,
                                  "Mark no-show failed: ${onError.toString()}",
                                  "Got it.");
                            });
                            await pr.hide();
                          },
                          child: const Text("Confirm")),
                    ],
                  );
                },
              );
              if (response) {
                Dialogue.showBarrierDismissibleNoContent(
                    context, "Reservation marked as no-show.");
                setState(() {
                  this._reservations.changeStatus(reservation.id, "MS");
                  this._reservations.sortReservationsByStatus();
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
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Confirm"),
      onPressed: () async {
        Navigator.pop(context);
        ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
        await pr.show();
        await Requester()
            .checkInReservation(User.token, reservation.id)
            .then((_) async {
          await pr.hide();
          Dialogue.showBarrierDismissibleNoContent(
              context, "Checked in ${reservation.customer}.");
          setState(() {
            this._reservations.changeStatus(reservation.id, "CP");
            this._reservations.sortReservationsByStatus();
          });
        }).catchError((error) async {
          await pr.hide();
          Dialogue.showConfirmNoContent(
              context, "Failed to check in: ${error.toString()}", "Got it.");
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

  void _sortPressed() {
    setState(() {
      if (this._sortByStatus == true) {
        this._sortIcon = Icon(MdiIcons.sortBoolAscending, color: Colors.white);
        this._sortByStatus = false;
        this._reservations.sortReservationsChronologically();
      } else {
        this._sortIcon = Icon(MdiIcons.history, color: Colors.white);
        this._sortByStatus = true;
        this._reservations.sortReservationsByStatus();
      }
    });
  }
}
