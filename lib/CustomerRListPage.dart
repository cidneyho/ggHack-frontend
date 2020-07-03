import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gghack/QrCode.dart';
import 'HomePage.dart';
import 'helpers/Constants.dart';
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

  ReservationList _reservations = new ReservationList();
  ReservationList _filteredReservations = new ReservationList();

  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search, color: Colors.white);
  Widget _appBarTitle = new Text(appTitle);

  @override
  void initState() {
    super.initState();

    _reservations.reservations = new List();
    _filteredReservations.reservations = new List();

    _getReservations();
  }

  void _getReservations() async {
    ReservationList reservations = await Requester().customerRenderReservationList(User.token);
    setState(() {
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
        child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text("Menu"),
                decoration: getGradientBox(),
              ),
              ListTile(
                title: Text("Services"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
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
      title: Text("Reservations"),//_appBarTitle,
      flexibleSpace: Container(
        decoration: getGradientBox(),
      ),
      actions: <Widget>[
        new IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
        ),
      ],
      iconTheme: IconThemeData(color: Colors.white),
    );
  }

  Widget _buildList(BuildContext context) {
    // TODO: search implementation
    if (_searchText.isNotEmpty) {
      _filteredReservations.reservations = new List();
      for (int i = 0; i < _reservations.reservations.length; i++) {
        if (_reservations.reservations[i].service.name.toLowerCase().contains(
            _searchText.toLowerCase())
            || _reservations.reservations[i].service.address.toLowerCase().contains(
                _searchText.toLowerCase())) {
          _filteredReservations.reservations.add(_reservations.reservations[i]);
        }
      }
    }

    return ListView(
      padding: const EdgeInsets.only(top: 16.0),
      children: this._filteredReservations.reservations.map((data) =>
          _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, Reservation reservation) {
    return Card(
      key: ValueKey(reservation.service.name),
      elevation: 0.2,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(color: colorBase),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
              horizontal: 20.0, vertical: 10.0),
          leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(
                          width: 1.0, color: Colors.white24))),
              child: Hero(
                tag: "avatar_" + reservation.service.name,
                child: new Image.network(
                  reservation.service.image,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              )
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
                            child: Text(reservation.service.name,
                                style: TextStyle(fontWeight: FontWeight.bold))
                        ),
                        RichText(
                          text: TextSpan(
                            text: '07-0${reservation.bookDate} ${reservation.bookTime}:00 @ ${reservation.service.address}',
                            style: TextStyle(color: colorText),
                          ),
                          maxLines: 1,
                          softWrap: true,
                        )
                      ]
                  ))
            ],),
          trailing:
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.confirmation_number, size: 30.0)]
                ),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => QrCodeDialog(reservation: reservation),
            );
          },
        ),
      ),
    );
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
        this._appBarTitle = new Text(appTitle);
        _filter.clear();
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
        height: 330,
        width: 280,
        child: Column (
          children: <Widget>[
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                reservation.service.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
              ),
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '07-0${reservation.bookDate} ${reservation.bookTime}:00',
                style: TextStyle(color: colorText, fontSize: 14),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                reservation.service.address,
                style: TextStyle(color: colorText, fontSize: 14),
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
          ],
        )
    );
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
            child: _buildQrCodeBox(context, widget.reservation)
          ),
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
