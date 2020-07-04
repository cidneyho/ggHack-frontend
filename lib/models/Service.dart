import 'package:gghack/helpers/Constants.dart';
import 'dart:convert';

class Service {
  int id;
  String owner;
  String name;
  String address;
  String introduction;
  String type = "";
  double longitude = 0;
  double latitude = 0;
  double rating = 0;
  String image;
  int maxCapacity;
  int startTime;
  int closeTime;
  String placeId;
  List<List<int>> freeSlots;
  List<List<int>> popularTimes;

  static String _convert(dynamic input) {
    if(input is int) {
      // print("Type conversion: this owner is int");
      return input.toString();
    } else {
      // print("Type conversion: this owner is String");
      return input;
    }
  }

  Service ({
    this.id,
    this.owner,
    this.name,
    this.address,
    this.introduction,
    this.type,
    this.longitude,
    this.latitude,
    this.rating,
    this.image,
    this.maxCapacity,
    this.startTime,
    this.closeTime,
    this.placeId,
    this.freeSlots,
    this.popularTimes,
  });

  factory Service.fromJson(Map<String, dynamic> json){
    return new Service (
      id: json['id'],
      owner: _convert(json['owner']),
      name: json['name'],
      address: json['address'],
      introduction: json['introduction'],
      type: json['type'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      rating: json['rating'],
      image: json['image'],
      maxCapacity: json['maxCapacity'],
      startTime: json['startTime'],
      closeTime: json['closeTime'],
      placeId: json['placeId'],
      freeSlots: List<dynamic>.from(json['freeSlots']).map(
              (list) => List<int>.from(list)
      ).toList(),
      popularTimes: List<dynamic>.from(json['popularTimes']).map(
            (list) => List<int>.from(list)
      ).toList(),
    );
  }
}