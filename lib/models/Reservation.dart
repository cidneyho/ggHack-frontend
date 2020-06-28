import 'Service.dart';

class Reservation {
  int reservationId;
  String customerEmail;
  Service service;
  String providerEmail;
  String startTime;
  String endTime;
  String status;

  Reservation ({
    this.reservationId,
    this.customerEmail,
    this.service,
    this.providerEmail,
    this.startTime,
    this.endTime,
    this.status,
  });

  factory Reservation.fromJson(Map<String, dynamic> json){
    return new Reservation (
      reservationId: json['id'],
      customerEmail: json['customer'],
      service: Service.fromJson(json['service']),
      providerEmail: json['serviceOwner'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      status: json['status'],
    );
  }
}