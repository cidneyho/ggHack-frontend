import 'Reservation.dart';

class ReservationList {
  List<Reservation> reservations = new List();

  ReservationList({
    this.reservations
  });

  factory ReservationList.fromJson(List<dynamic> parsedJson) {
    List<Reservation> reservations = new List<Reservation>();
    reservations = parsedJson.map((i) => Reservation.fromJson(i)).toList();
    return new ReservationList(
      reservations: reservations,
    );
  }
}