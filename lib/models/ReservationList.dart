import 'Reservation.dart';

class ReservationList {
  List<Reservation> reservations = new List();

  ReservationList({this.reservations});

  int changeStatus(int id, String status) {
    int counter = 0;
    reservations = reservations.map((e) {
      if (e != null && e.id == id) {
        e.status = status;
        counter += 1;
      }
      return e;
    }).toList();
    return counter;
  }

  // Sort reservations by status (Pending > others) and chronologically
  void sortReservations() {
    reservations.sort((e1, e2) => ((e1.status != "PD" && e2.status == "PD") ||
            ((e1.status == "PD" && e2.status == "PD") &&
                Reservation.later(e1, e2)) ||
            (e1.status != "PD" &&
                e2.status != "PD" &&
                Reservation.later(e1, e2)))
        ? 1
        : 0);
  }

  void sortReservationsChronologically() {
    reservations.sort((e1, e2) => Reservation.later(e1, e2)
        ? 1
        : 0);
  }

  void sortReservationsByStatus() {
    reservations.sort((e1, e2) => ((e1.status == e2.status && Reservation.later(e1, e2))
        || e2.status == "PD"
        || (e2.status == "CP" && e1.status == "MS"))
        ? 1
        : 0);
  }

  factory ReservationList.fromJson(List<dynamic> parsedJson) {
    List<Reservation> reservations = new List<Reservation>();
    reservations = parsedJson.map((i) => Reservation.fromJson(i)).toList();
    return new ReservationList(
      reservations: reservations,
    );
  }
}
