import 'package:flutter/material.dart';
import 'helpers/Constants.dart';
import 'models/Service.dart';
import 'models/ServiceList.dart';
import 'models/ServiceService.dart';
import 'DetailsPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return _HomePageState();
  }

}

class _HomePageState extends State<HomePage> {
  final TextEditingController _filter = new TextEditingController();

  ServiceList _services = new ServiceList();
  ServiceList _filteredServices = new ServiceList();

  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search, color: Colors.white);
  Icon _menuIcon = new Icon(Icons.menu, color: Colors.white);
  Widget _appBarTitle = new Text(appTitle);

  @override
  void initState() {
    super.initState();

    _services.services = new List();
    _filteredServices.services = new List();

    // TODO: get info from backend
    _getServices();
  }

  void _getServices() async {
    ServiceList services = await ServiceService().loadServices();
    setState(() {
      for (Service service in services.services) {
        this._services.services.add(service);
        this._filteredServices.services.add(service);
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
                title: Text("Reservations"),
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
        if (_services.services[i].name.toLowerCase().contains(_searchText.toLowerCase())
            || _services.services[i].address.toLowerCase().contains(_searchText.toLowerCase())) {
          _filteredServices.services.add(_services.services[i]);
        }
      }
    }

    return ListView (
      padding: const EdgeInsets.only(top: 16.0),
      children: this._filteredServices.services.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, Service service) {
    return Card(
      key: ValueKey(service.name),
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
                  tag: "avatar_" + service.name,
                  child: new Image.network(
                      service.photo,
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
                          child: Text(service.name,
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ),
                        RichText(
                          text: TextSpan(
                            text: service.address,
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
                Icon(Icons.keyboard_arrow_right, size: 30.0)]),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => new DetailsPage(service: service)));
          },
        ),
      ),
    );
  }

  _HomePageState() {
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
