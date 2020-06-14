import 'Service.dart';

class ServiceList {
  List<Service> services = new List();

  ServiceList({
    this.services
  });

  factory ServiceList.fromJson(List<dynamic> parsedJson) {
    List<Service> services = new List<Service>();
    services = parsedJson.map((i) => Service.fromJson(i)).toList();
    return new ServiceList(
      services: services,
    );
  }
}