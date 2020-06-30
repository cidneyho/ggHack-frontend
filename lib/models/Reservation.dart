import 'Service.dart';

class Reservation {
  int reservationId;
  String customer;
  Service service;
  String provider;
  String bookDate;  //'2020-07-11'
  String bookTime;  //'18:00'
  String status;

  Reservation ({
    this.reservationId,
    this.customer,
    this.service,
    this.provider,
    this.bookDate,
    this.bookTime,
    this.status,
  });

  factory Reservation.fromJson(Map<String, dynamic> json){
    return new Reservation (
      reservationId: json['id'],
      customer: json['customer'],
      service: Service.fromJson(json['service']),
      provider: json['serviceOwner'],
      bookDate: json['bookDate'],
      bookTime: json['bookTime'],
      status: json['status'],
    );
  }
}