import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sprintf/sprintf.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'helpers/Constants.dart';
import 'helpers/Dialogue.dart';
import 'helpers/Style.dart';
import 'helpers/Requester.dart';
import 'models/Reservation.dart';
import 'models/ReservationList.dart';
import 'models/User.dart';

class CustomerRListPage extends StatefulWidget {
  @override
  _CustomerRListPageState createState() {
    return _CustomerRListPageState();
  }
}

class _CustomerRListPageState extends State<CustomerRListPage> {
  final TextEditingController _filter = new TextEditingController();

  // To keep only one slider open
  final SlidableController slidableController = SlidableController();

  ReservationList _reservations = new ReservationList();
  ReservationList _filteredReservations = new ReservationList();

  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search, color: Colors.white);
  Widget _appBarTitle =
      new Text(rlistTitle, style: TextStyle(color: Colors.white));

  Icon _sortIcon = new Icon(MdiIcons.history, color: Colors.white);
  bool _sortByStatus = true; // false: sorted chronologically

  @override
  void initState() {
    super.initState();

    _getReservations();
  }

  void _getReservations() async {
    ReservationList reservations = await Requester(context)
        .customerRenderReservationList(User.token)
        .catchError((error) async {
      Dialogue.showConfirmNoContent(context,
          "Failed to get reservations: ${error.toString()}", "Got it.");
    });
    reservations.sortReservationsByStatus();
    setState(() {
      _reservations.reservations = new List();
      _filteredReservations.reservations = new List();
      for (Reservation reservation in reservations.reservations) {
        this._reservations.reservations.add(reservation);
        this._filteredReservations.reservations.add(reservation);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            decoration: getGradientBox(),
          ),
          ListTile(
            title: Text("Home"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Log out"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ]),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  List<Widget> _buildAppBarIcons() {
    var iconList = [
      IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    ];
    if (_searchIcon.icon == Icons.search) {
      iconList.add(IconButton(
        icon: _sortIcon,
        onPressed: _sortPressed,
      ));
    }
    return iconList;
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      elevation: 0.2,
      centerTitle: true,
      title: _appBarTitle,
      flexibleSpace: Container(
        decoration: getGradientBox(),
      ),
      actions: _buildAppBarIcons(),
      iconTheme: IconThemeData(color: Colors.white),
    );
  }

  Widget _buildList(BuildContext context) {
    if (_searchText.isNotEmpty) {
      _filteredReservations.reservations = new List();
      for (int i = 0; i < _reservations.reservations.length; i++) {
        if (_reservations.reservations[i].service.name
                .toLowerCase()
                .contains(_searchText.toLowerCase()) ||
            _reservations.reservations[i].service.address
                .toLowerCase()
                .contains(_searchText.toLowerCase())) {
          _filteredReservations.reservations.add(_reservations.reservations[i]);
        }
      }
    }

    return ListView(
      padding: const EdgeInsets.only(top: 16.0),
      children: _filteredReservations.reservations == null
          ? [waitText("reservations")]
          : _filteredReservations.reservations.length == 0
              ? [emptyText("reservations")]
              : this
                  ._filteredReservations
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
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(
                              width: 1.0, color: Colors.white24))),
                  child: Hero(
                    tag: "avatar_" + reservation.id.toString(),
                    child: new Image.network(
                      reservation.service.image,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  )),
              title: Row(
                children: <Widget>[
                  new Flexible(
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        Container(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Text(reservation.service.name,
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        RichText(
                          text: TextSpan(
                            text: sprintf('07-%02d %02d:00 @ %s', [
                              reservation.bookDate + 6,
                              reservation.bookTime,
                              reservation.service.address,
                            ]),
                            style: TextStyle(color: colorText),
                          ),
                          maxLines: 1,
                          softWrap: true,
                        )
                      ]))
                ],
              ),
              trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    (reservation.status == "PD"
                        ? Icon(Icons.receipt,
                            size:
                                24.0) // Icons.local_activity // MdiIcons.qrcode
                        : (reservation.status == "MS"
                            ? noShowIcon
                            : completedIcon))
                  ]),
              onTap: reservation.status != "PD"
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (_) => QrCodeDialog(reservation: reservation),
                      );
                    },
            ),
          ),
        ),
        secondaryActions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.4),
            child: IconSlideAction(
                caption: 'Cancel',
                color: Colors.red[400],
                icon: Icons.close,
                onTap: () async {
                  bool response = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Cancel reservation?"),
                          content: Text(sprintf('%s on Jul %d at %02d:00', [
                            reservation.service.name,
                            reservation.bookDate + 6,
                            reservation.bookTime,
                          ])),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Not now"),
                            ),
                            FlatButton(
                                onPressed: () async {
                                  await Requester(context)
                                      .cancelReservation(
                                          User.token, reservation.id)
                                      .then((value) async {
                                    if (value == 0) {
                                      Navigator.of(context).pop(true);
                                      setState(() {
                                        this
                                            ._filteredReservations
                                            .reservations
                                            .removeWhere((element) =>
                                                element.id == reservation.id);
                                      });
                                      Dialogue.showBarrierDismissibleNoContent(
                                          context, "Reservation canceled.");
                                    }
                                  }).catchError((onError) async {
                                    Navigator.of(context).pop(false);
                                    Dialogue.showConfirmNoContent(
                                        context,
                                        "Cancellation failed: ${onError.toString()}",
                                        "Got it.");
                                  });
                                },
                                child: const Text("Confirm")),
                          ],
                        );
                      });
                }),
          ),
        ]);
  }

  _CustomerRListPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _resetReservations();
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  void _resetReservations() {
    this._filteredReservations.reservations = new List();
    for (Reservation reservation in _reservations.reservations) {
      this._filteredReservations.reservations.add(reservation);
    }
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close, color: Colors.white);
        this._appBarTitle = new TextField(
          controller: _filter,
          style: new TextStyle(color: Colors.white, fontSize: 18),
          autofocus: true,
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search, color: Colors.white),
            border: InputBorder.none,
            hintText: searchBarHintText,
            hintStyle: TextStyle(color: Colors.white, fontSize: 18),
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search, color: Colors.white);
        this._sortIcon = new Icon(
            (_sortByStatus ? MdiIcons.history : MdiIcons.sortBoolAscending),
            color: Colors.white);
        this._appBarTitle = new Text(rlistTitle,
            style: TextStyle(color: Colors.white, fontSize: 18));
        _filter.clear();
      }
    });
  }

  void _sortPressed() {
    setState(() {
      if (this._sortByStatus == true) {
        this._sortIcon = Icon(MdiIcons.sortBoolAscending, color: Colors.white);
        this._sortByStatus = false;
        this._reservations.sortReservationsChronologically();
        this._filteredReservations.sortReservationsChronologically();
      } else {
        this._sortIcon = Icon(MdiIcons.history, color: Colors.white);
        this._sortByStatus = true;
        this._reservations.sortReservationsByStatus();
        this._filteredReservations.sortReservationsByStatus();
      }
    });
  }
}

class QrCodeDialogState extends State<QrCodeDialog>
    with SingleTickerProviderStateMixin {
  Widget _buildQrCodeBox(BuildContext context, Reservation reservation) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: getGradientBox(),
        width: 280,
        child: Wrap(children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(reservation.service.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white)),
              ),
              SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  sprintf("07-%02d %02d:00",
                      [reservation.bookDate + 6, reservation.bookTime]),
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  reservation.service.address,
                  maxLines: 3,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              SizedBox(height: 20),
              Container(
                color: Colors.white,
                child: QrImage(
                  data: reservation.id.toString(),
                  version: QrVersions.auto,
                  size: 200,
                ),
              ),
              SizedBox(height: 10),
            ],
          )
        ]));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0))),
          child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: _buildQrCodeBox(context, widget.reservation)),
        ),
      ),
    );
  }
}

class QrCodeDialog extends StatefulWidget {
  final Reservation reservation;

  QrCodeDialog({Key key, @required this.reservation}) : super(key: key);

  @override
  State<StatefulWidget> createState() => QrCodeDialogState();
}
