import 'package:flutter/material.dart';
import 'helpers/Constants.dart';
import 'helpers/Style.dart';
import 'helpers/Requester.dart';
import 'models/Service.dart';
import 'models/User.dart';

class CreateServicePage extends StatefulWidget {
  @override
  _CreateServiceState createState() {
    return _CreateServiceState();
  }

}

class _CreateServiceState extends State<CreateServicePage> {

  Widget _appBarTitle = new Text(createServiceTitle, style: TextStyle(color: Colors.white));

  final _nameController = TextEditingController();
  final _addrController = TextEditingController();
  final _introController = TextEditingController();
  final _imageController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _closeTimeController = TextEditingController();
  final _maxCapController = TextEditingController();
  final _placeIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final nameTitle = getFormTitle("Name");
    final nameField = Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: _nameController,
        keyboardType: TextInputType.text,
        maxLines: 1,
        decoration: getBlankDecoration(),
        style: TextStyle(color: colorText),
      )
    );

    final addrTitle = getFormTitle("Address");
    final addrField = Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: _addrController,
        keyboardType: TextInputType.text,
        maxLines: 1,
        decoration: getBlankDecoration(),
        style: TextStyle(color: colorText),
      )
    );
    
    final introTitle = getFormTitle("Introduction");
    final introField = Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: _introController,
        keyboardType: TextInputType.text,
        maxLines: 1,
        decoration: getBlankDecoration(),
        style: TextStyle(color: colorText),
      )
    );

    final imageTitle = getFormTitle("Image URL");
    final imageField = Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: _imageController,
        keyboardType: TextInputType.url,
        maxLines: 1,
        decoration: getBlankDecoration(),
        style: TextStyle(color: colorText),
      )
    );

    final startTimeTitle = getFormTitle("Start Time");
    final startTimeField = Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: _startTimeController,
        keyboardType: TextInputType.phone,
        maxLines: 1,
        decoration: getBlankDecoration(),
        style: TextStyle(color: colorText),
      )
    );

    final closeTimeTitle = getFormTitle("Close Time");
    final closeTimeField = Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: _closeTimeController,
        keyboardType: TextInputType.phone,
        maxLines: 1,
        decoration: getBlankDecoration(),
        style: TextStyle(color: colorText),
      )
    );

    final maxCapTitle = getFormTitle("Maximum Capacity");
    final maxCapField = Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: _maxCapController,
        keyboardType: TextInputType.phone,
        maxLines: 1,
        decoration: getBlankDecoration(),
        style: TextStyle(color: colorText),
      )
    );

    final placeIdTitle = getFormTitle("Place ID");
    final placeIdField = Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: _placeIdController,
        keyboardType: TextInputType.text,
        maxLines: 1,
        decoration: getBlankDecoration(),
        style: TextStyle(color: colorText),
      )
    );

    final createButton = Padding(
      padding: EdgeInsets.fromLTRB(64, 12, 64, 32),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () async {
          Service toCreate = new Service (
            name: _nameController.text,
            address: _addrController.text,
            introduction: _introController.text,
            image: _imageController.text,
            startTime: int.parse(_startTimeController.text),
            closeTime: int.parse(_closeTimeController.text),
            maxCapacity: int.parse(_maxCapController.text),
            placeId: _placeIdController.text,
          );

          Service returned = await Requester().createService(User.token, toCreate)
            .catchError((exp) => print("Error occurred in createService: $exp"));
          
          if (returned != null) {
              Navigator.of(context).pushNamed(phomePageTag);
          }
        },
        padding: EdgeInsets.all(12),
        color: colorDark,
        child: Text(createServiceButtonText,
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );

    return Scaffold (
      appBar: _buildBar(context),
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(28.0),
        children: <Widget>[
          nameTitle,
          nameField,
          addrTitle,
          addrField,
          introTitle,
          introField,
          imageTitle,
          imageField,
          startTimeTitle,
          startTimeField,
          closeTimeTitle,
          closeTimeField,
          maxCapTitle,
          maxCapField,
          placeIdTitle,
          placeIdField,
          createButton,
        ],
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar (
        elevation: 0.2,
        centerTitle: true,
        title: _appBarTitle,
        flexibleSpace: Container(
          decoration: getGradientBox(),
        ),
        iconTheme: IconThemeData(color: Colors.white),
    );
  }
}