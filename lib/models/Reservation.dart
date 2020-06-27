import 'package:gghack/helpers/Constants.dart';

class Reservation {
  String name;
  String qrCode;
  List<int> startTime;
  List<int> endTime;

  Reservation ({
    this.name,
    this.qrCode,
    this.startTime,
    this.endTime,
  });

  factory Reservation.fromJson(Map<String, dynamic> json){
    return new Reservation (
      name: json['name'],
      qrCode: json['qr-code'],
      startTime: json['start-time'],
      endTime: json['end-time'],
    );
  }
}