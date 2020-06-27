import 'package:gghack/helpers/Constants.dart';

class Service {
  String name;
  String address;
  String introduction;
  String photo;
  List<int> time;
  List<List<int>> slots;
  String reservation;

  Service ({
    this.name,
    this.address,
    this.introduction,
    this.photo,
    this.time,
    this.slots,
    this.reservation,
  });

  factory Service.fromJson(Map<String, dynamic> json){
    return new Service (
        name: json['name'],
        address: json['address'],
        introduction: json['introduction'],
        photo: json['image'],
        time: optime,
        slots: freeslots,
        reservation: reservationInfo,
    );
  }
}