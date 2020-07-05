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
  static int later(Reservation e1, Reservation e2) {
    var t1 = e1.bookDate*24 + e1.bookTime;
    var t2 = e2.bookDate*24 + e2.bookTime;
    return t1.compareTo(t2);
  }

  static int higher(Reservation e1, Reservation e2) {
    return -1 * e1.status.compareTo(e2.status);
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
