import 'package:gghack/helpers/Constants.dart';

class Service {
  int serviceId;
  String name;
  String address;
  String introduction;
  String photo;
  List<int> time;
  List<List<int>> slots;
  String reservation;
  String type;
  double longitude;
  double latitude;
  double rating;
  int maxCapacity;


  Service ({
    this.serviceId,
    this.name,
    this.address,
    this.introduction,
    this.photo,
    this.time,
    this.slots,
    this.reservation,
    this.type,
    this.longitude,
    this.latitude,
    this.rating,
    this.maxCapacity,
  });

  factory Service.fromJson(Map<String, dynamic> json){
    return new Service (
        serviceId: json['id'],
        name: json['name'],
        address: json['address'],
        introduction: json['introduction'],
        photo: json['image'],
        time: optime,
        slots: freeslots,
        reservation: reservationInfo,
        type: json['type'],
        longitude: json['longitude'],
        latitude: json['latitude'],
        rating: json['rating'],
        maxCapacity: json['maxCapacity'],
    );
  }
}