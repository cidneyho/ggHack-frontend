import 'Service.dart';

class Reservation {
  int id;
  String customer;
  Service service;
  String provider;
  int bookDate;
  int bookTime;
  int numPeople;
  String status;

  Reservation ({
    this.id,
    this.customer,
    this.service,
    this.provider,
    this.bookDate,
    this.bookTime,
    this.numPeople,
    this.status,
  });

  factory Reservation.fromJson(Map<String, dynamic> json){
    return new Reservation (
      id: json['id'],
      customer: json['customer'],
      service: Service.fromJson(json['service']),
      provider: json['serviceOwner'],
      bookDate: int.parse(json['bookDate']), // TODO it will be just int
      bookTime: json['bookTime'],
      numPeople: json['numPeople'],
      status: json['status'],
    );
  }
}