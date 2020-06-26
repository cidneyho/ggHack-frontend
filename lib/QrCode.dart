import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'helpers/Constants.dart';


class QrCodePage extends StatelessWidget {

  // box containing date, time, provider, service, and qr code
  final infoBox = Container(
      padding: const EdgeInsets.all(16),
      color: Colors.green,
      height: 330,
      width: 280,
      child: Column (
        children: <Widget>[
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
                '06-12 15:00',
                style: TextStyle(fontSize: 25),
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
                'Service X',
                style: TextStyle(fontSize: 25),
            ),
          ),
          SizedBox(height: 20),
          Container(
            color: Colors.white,
            child: QrImage(
              data: "https://github.com/cidneyho",
              version: QrVersions.auto,
              size: 200,
            ),
          ),
        ],
      )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR code demo'),
      ),
      body: Center(
        child: infoBox,
      ),
    );
  }
}
