import 'Reservation.dart';

class ReservationList {
  List<Reservation> reservations = new List();

  ReservationList({
    this.reservations
  });

  int changeStatus(int id, String status) {
    int counter = 0;
    reservations = reservations.map((e) {
      if(e != null && e.id == id) {
        e.status = status;
        counter += 1;
      }
      return e;
    }).toList();
    return counter;
  }

  factory ReservationList.fromJson(List<dynamic> parsedJson) {
    List<Reservation> reservations = new List<Reservation>();
    reservations = parsedJson.map((i) => Reservation.fromJson(i)).toList();
    return new ReservationList(
      reservations: reservations,
    );
  }
}