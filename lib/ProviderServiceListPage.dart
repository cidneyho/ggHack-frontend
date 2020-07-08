import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sprintf/sprintf.dart';
import 'helpers/Constants.dart';
import 'helpers/Dialogue.dart';
import 'helpers/Style.dart';
import 'helpers/Requester.dart';
import 'models/Service.dart';
import 'models/ServiceList.dart';
import 'ServiceDetailsPage.dart';
import 'models/User.dart';

class PServiceListPage extends StatefulWidget {
  @override
  _PServiceListPageState createState() {
    return _PServiceListPageState();
  }
}

class _PServiceListPageState extends State<PServiceListPage> {
  final TextEditingController _filter = new TextEditingController();

  ServiceList _services = new ServiceList();
  ServiceList _filteredServices = new ServiceList();

  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search, color: Colors.white);
  Widget _appBarTitle =
  new Text(appTitle, style: TextStyle(color: Colors.white));

  Position _currentPosition;

  @override
  void initState() {
    super.initState();

    _services.services = new List();
    _filteredServices.services = new List();

    _getServices();
  }

  void _getServices() async {
    if(_currentPosition == null) {
      await _getCurrentLocation();
    }

    ServiceList services =
    await Requester().providerRenderServiceList(User.token).catchError((error) async {
      Dialogue.showConfirmNoContent(
          context, "Failed to get services: ${error.toString()}", "Got it.");
    });
    if (_currentPosition != null) {
      await services.sortByDistance(_currentPosition);
    }
    setState(() {
      for (Service service in services.services) {
        this._services.services.add(service);
        this._filteredServices.services.add(service);
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

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      elevation: 0.2,
      centerTitle: true,
      title: _appBarTitle,
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
      _filteredServices.services = new List();
      for (int i = 0; i < _services.services.length; i++) {
        if (_services.services[i].name
            .toLowerCase()
            .contains(_searchText.toLowerCase()) ||
            _services.services[i].address
                .toLowerCase()
                .contains(_searchText.toLowerCase())) {
          _filteredServices.services.add(_services.services[i]);
        }
      }
    }

    return ListView(
      padding: const EdgeInsets.only(top: 16.0),
      children: _filteredServices.services.length == 0
          ? [
        Text("Please wait while we are loading services for you...",
            style: TextStyle(color: colorText))
      ]
          : this
          ._filteredServices
          .services
          .map((data) => _buildListItem(context, data))
          .toList(),
    );
  }

  Widget _buildListItem(BuildContext context, Service service) {
    return Card(
      key: ValueKey(service.id),
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
                      right:
                      new BorderSide(width: 1.0, color: Colors.white24))),
              child: Hero(
                tag: "avatar_" + service.id.toString(),
                child: new Image.network(
                  service.image,
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
                            child: Text(service.name,
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        RichText(
                          text: TextSpan(
                            text: service.address,
                            style: TextStyle(color: colorText),
                          ),
                          maxLines: 1,
                          softWrap: true,
                        ),
                        if (service.distance != null)
                          RichText(
                            text: TextSpan(
                              text: sprintf("%.1f km", [service.distance / 1000.0]),
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
              children: <Widget>[Icon(Icons.keyboard_arrow_right, size: 30.0)]),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new ServiceDetailsPage(service: service)));
          },
        ),
      ),
    );
  }

  _CustomerHomePageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _resetServices();
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  void _resetServices() {
    this._filteredServices.services = new List();
    for (Service service in _services.services) {
      this._filteredServices.services.add(service);
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

  Future<Position> _getCurrentLocation() async {
    final Geolocator geolocator = Geolocator();

    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });

    print(
        "LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}");
    return _currentPosition;
  }
}