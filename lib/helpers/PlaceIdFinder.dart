import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Constants.dart';

class PlaceIdFinder {
  Widget getPlaceIdFinderButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: RaisedButton (
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onPressed: () async {
            final url = placeIdFinderUrl;
            if (await canLaunch(url)) {
              await launch(
                url,
                forceSafariVC: false,
              );
            }
          },
          padding: EdgeInsets.all(20.0),
          color: colorDark,
          child: Text("Get PlaceID", style: TextStyle(color: Colors.white, fontSize: 20)),
        )
    );
  }
}
