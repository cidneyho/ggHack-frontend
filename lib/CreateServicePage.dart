import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:imgur/imgur.dart' as imgur;
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:url_launcher/url_launcher.dart';
import 'ServiceDetailsPage.dart';
import 'helpers/Constants.dart';
import 'helpers/Dialogue.dart';
import 'helpers/Style.dart';
import 'helpers/Requester.dart';
import 'helpers/Tokens.dart';
import 'models/Service.dart';
import 'models/User.dart';

class CreateServicePage extends StatefulWidget {
  @override
  _CreateServiceState createState() {
    return _CreateServiceState();
  }
}

class _CreateServiceState extends State<CreateServicePage> {
  Widget _appBarTitle =
      new Text(createServiceTitle, style: TextStyle(color: Colors.white));

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
          decoration: getBlankDecoration(hintText: "What is your service's display name?"),
          style: TextStyle(color: colorText),
        ));

    final addrTitle = getFormTitle("Address");
    final addrField = Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: TextFormField(
          controller: _addrController,
          keyboardType: TextInputType.text,
          maxLines: 1,
          decoration: getBlankDecoration(hintText: "Where can people find your service?"),
          style: TextStyle(color: colorText),
        ));

    final introTitle = getFormTitle("Introduction");
    final introField = Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: TextFormField(
          controller: _introController,
          keyboardType: TextInputType.text,
          maxLines: 1,
          decoration: getBlankDecoration(hintText: "Briefly introduce your service."),
          style: TextStyle(color: colorText),
        ));

    PickedFile _image;
    final picker = ImagePicker();
    final imageTitle = getFormTitle("Photo");
    final imagePickerButton = IconButton(
      onPressed: () async {
        var _pickedImage = await picker.getImage(source: ImageSource.gallery);
        if (_pickedImage == null) {
          _pickedImage = (await picker.getLostData()).file;
        }
        setState(() {
          _image = _pickedImage;
          _imageController.text = _image.path;
        });
      },
      icon: Icon(
        Icons.photo_library,
        size: 24.0,
        semanticLabel: 'Open library to pick service image',
      ),
    );
    final imageTakerButton = IconButton(
      onPressed: () async {
        var _pickedImage = await picker.getImage(source: ImageSource.camera);
        if (_pickedImage == null) {
          _pickedImage = (await picker.getLostData()).file;
        }
        setState(() {
          _image = _pickedImage;
          _imageController.text = _image.path;
        });
      },
      icon: Icon(
        Icons.photo_camera,
        size: 24.0,
        semanticLabel: 'Open library to pick service image',
      ),
    );
    final imageIconButtons = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min, // added line
      children: <Widget>[
        imagePickerButton,
        imageTakerButton,
      ],
    );
    final imageField = Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: TextFormField(
          controller: _imageController,
          keyboardType: TextInputType.url,
          maxLines: 1,
          decoration: getBlankDecoration(suffixIcon: imageIconButtons, hintText: 'Take a photo or choose one from library'),
          style: TextStyle(color: colorText),
        ));

    final startTimeTitle = getFormTitle("Start Time");
    final startTimeField = Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: TextFormField(
          controller: _startTimeController,
          keyboardType: TextInputType.phone,
          maxLines: 1,
          decoration: getBlankDecoration(hintText: 'Enter 13 for 13:00'),
          style: TextStyle(color: colorText),
        ));

    final closeTimeTitle = getFormTitle("Close Time");
    final closeTimeField = Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: TextFormField(
          controller: _closeTimeController,
          keyboardType: TextInputType.phone,
          maxLines: 1,
          decoration: getBlankDecoration(hintText: 'Enter 20 for 20:00'),
          style: TextStyle(color: colorText),
        ));

    final maxCapTitle = getFormTitle("Maximum Capacity");
    final maxCapField = Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: TextFormField(
          controller: _maxCapController,
          keyboardType: TextInputType.phone,
          maxLines: 1,
          decoration: getBlankDecoration(hintText: 'Enter 3 if at most 3 people can visit concurrently'),
          style: TextStyle(color: colorText),
        ));

    final placeIdTitle = getFormTitle("Place ID");
    final placeIdFinderButton = IconButton(
      onPressed: () async {
        final url = placeIdFinderUrl;
        if (await canLaunch(url)) {
          await launch(
            url,
            forceSafariVC: false,
          );
        }
      },
      icon: Icon(
        Icons.map,
        size: 24.0,
        semanticLabel: 'Open Google map to get place ID',
      ),
    );
    final placeIdField = Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: TextFormField(
          controller: _placeIdController,
          keyboardType: TextInputType.text,
          maxLines: 1,
          decoration: getBlankDecoration(suffixIcon: placeIdFinderButton, hintText: 'Click to search; paste it here'),
          style: TextStyle(color: colorText),
        ));

    final createButton = Padding(
      padding: EdgeInsets.fromLTRB(64, 12, 64, 32),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () async {
          var pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
          await pr.show();

          // Host the image on imgur
          print("To upload");
          print("Path: " + _imageController.text);
          String accessToken = Token.imgur;
          final client =
              imgur.Imgur(imgur.Authentication.fromToken(accessToken));
          var image = await client.image
              .uploadImage(
                  imagePath: _imageController.text,
                  title: 'service ${_nameController.text}',
                  description: 'by ${User.name}')
              .catchError((error) async {
            pr.hide();
            Dialogue.showConfirmNoContent(context,
                "Failed to upload image. Please take a photo or choose one from your library.", "Got it.");
            return;
          });

          print("Image uploaded: ${image.link}");

          Service toCreate;
          try {
            toCreate = new Service(
              name: _nameController.text,
              address: _addrController.text,
              introduction: _introController.text,
              image: image.link,
              startTime: int.tryParse(_startTimeController.text),
              closeTime: int.tryParse(_closeTimeController.text),
              maxCapacity: int.tryParse(_maxCapController.text),
              placeId: _placeIdController.text,
            );
            if (toCreate.startTime < 0 || toCreate.closeTime > 24) {
              throw Exception("Start Time should be an integer from 0 to 24.");
            }
            if (toCreate.closeTime <= toCreate.startTime || toCreate.closeTime > 24) {
              throw Exception("Close Time should be an integer >= Start Time and <= 24.");
            }
            if (toCreate.maxCapacity <= 0) {
              throw Exception("Please enter a valid Maximum Capacity.");
            }
          } catch (exp) {
            pr.hide();
            Dialogue.showConfirmNoContent(context,
                "Service creation failed: ${exp.toString()}", "Got it.");
            return;
          }


          await Requester(context)
              .createService(User.token, toCreate)
              .then((returnedService) async {
            if (returnedService != null) {
              Navigator.of(context).pop();
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => new ServiceDetailsPage(service: returnedService)));
            }
            Dialogue.showBarrierDismissibleNoContent(
                context, "Service created: ${returnedService.name}");
          })
              .catchError((exp) async {
            print("Error occurred in createService: $exp");
            Dialogue.showConfirmNoContent(context,
                "Service creation failed: ${exp.toString()}", "Got it.");
          });
        },
        padding: EdgeInsets.all(12),
        color: colorDark,
        child: Text(createServiceButtonText,
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );

    return Scaffold(
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
    return new AppBar(
      elevation: 0.2,
      centerTitle: true,
      title: _appBarTitle,
      leading: BackButton(color: Colors.white),
      flexibleSpace: Container(
        decoration: getGradientBox(),
      ),
      iconTheme: IconThemeData(color: Colors.white),
    );
  }
}
