/// This page is replaced by the pop-up dialog for now.
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'helpers/Constants.dart';
import 'helpers/Style.dart';
import 'models/Reservation.dart';


class QrCodePage extends StatelessWidget {
  final Reservation reservation;
  QrCodePage({this.reservation});

  @override
  Widget build(BuildContext context) {

    // box containing date, time, provider, service, and qr code
    final infoBox = Container(
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
                '07-0${reservation.bookDate} ${reservation.bookTime}:00',
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                reservation.service.address,
                style: TextStyle(fontSize: 25),
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

    return Scaffold(
      appBar: AppBar(
        elevation: 0.2,
        centerTitle: true,
        title: Text(reservation.service.name),
        flexibleSpace: Container(
          decoration: getGradientBox(),
        ),
      ),
      body: Center(
        child: infoBox,
      ),
    );
  }
}
