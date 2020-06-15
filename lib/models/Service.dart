import 'package:gghack/helpers/Constants.dart';

class Service {
  String name;
  String address;
  String introduction;
  String photo;
  List<int> time;
  List<List<int>> slots;

  Service ({
    this.name,
    this.address,
    this.introduction,
    this.photo,
    this.time,
    this.slots,
  });

  factory Service.fromJson(Map<String, dynamic> json){
    return new Service (
        name: json['name'],
        address: json['address'],
        introduction: "to be done",
        photo: json['photo'],
        time: optime,
        slots: freeslots,
    );
  }
}