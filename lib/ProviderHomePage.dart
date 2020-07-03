import 'package:flutter/material.dart';
import 'helpers/Constants.dart';
import 'helpers/Requester.dart';
import 'models/Reservation.dart';
import 'models/ReservationList.dart';
import 'models/User.dart';


class ProviderHomePage extends StatefulWidget {
  @override
  _ProviderHomePageState createState() {
    return _ProviderHomePageState();
  }

}

class _ProviderHomePageState extends State<ProviderHomePage> {
  final TextEditingController _filter = new TextEditingController();

  ReservationList _reservations = new ReservationList();

  Widget _appBarTitle = new Text(appTitle);

  @override
  void initState() {
    super.initState();

    _reservations.reservations = new List();

    _getReservations();
  }

  void _getReservations() async {
    ReservationList reservations = await Requester().providerRenderReservationList(User.token);
    setState(() {
      for (Reservation reservation in reservations.reservations) {
        this._reservations.reservations.add(reservation);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: _buildBar(context),
      backgroundColor: Colors.white,
      body: _buildList(context),
      drawer: Drawer(
        child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text("Menu"),
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
              ListTile(
                title: Text("Edit Business"),
                onTap: () {
                  Navigator.pop(context);
                },
              ), ]
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
    return Card(
      key: ValueKey(reservation.customer),
      elevation: 0.2,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(color: colorBase),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0, color: Colors.white24))),
              child: Hero(
                  tag: "avatar_" + reservation.customer,
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
                          child: Text(reservation.customer,
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ),
                        RichText(
                          text: TextSpan(
                            text: "What is this TextSpan for?",  // TODO What is it? Do we need it?
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
            onPressed: () {
              // confirm confirm
              _showAlertDialog(context);
            },
            padding: EdgeInsets.all(8),
            color: colorDark,
            child: Text(checkinButtonText, style: TextStyle(color: Colors.white, fontSize: 14)),
          ),
        ),
      ),
    );
  }

  _showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () { Navigator.pop(context); },
    );
    Widget continueButton = FlatButton(
      child: Text("Confirm"),
      onPressed:  () {},
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
