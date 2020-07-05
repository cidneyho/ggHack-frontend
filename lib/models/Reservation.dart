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

  Reservation({
    this.id,
    this.customer,
    this.service,
    this.provider,
    this.bookDate,
    this.bookTime,
    this.numPeople,
    this.status,
  });

  // e1 is later than e2
  static bool later(Reservation e1, Reservation e2) {
    return (e1.bookDate > e2.bookDate ||
        (e1.bookDate == e2.bookDate && e1.bookTime > e2.bookTime));
  }

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return new Reservation(
      id: json['id'],
      customer: json['customer'],
      service: Service.fromJson(json['service']),
      provider: json['serviceOwner'],
      bookDate: json['bookDate'],
      bookTime: json['bookTime'],
      numPeople: json['numPeople'],
      status: json['status'],
    );
  }
}
