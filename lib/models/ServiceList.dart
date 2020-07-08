import 'package:geolocator/geolocator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'Service.dart';

class ServiceList {
  List<Service> services = new List<Service>();

  ServiceList({
    this.services
  });

  // Calculate the distance in meters
  Future<double> _calculateDistance(Service service, Position position) async {
    return await Geolocator().distanceBetween(
      service.latitude, service.longitude, position.latitude, position.longitude
    );
  }

  // Sorted by distance: from near to far
  Future<void> sortByDistance(Position position) async {
    for(int i = 0; i < services.length; ++i) {
      this.services[i].distance = await _calculateDistance(services[i], position);
      print(this.services[i].name + this.services[i].distance.toString());
    }
    this.services.sort((a, b) => a.compareTo(b));
  }

  factory ServiceList.fromJson(List<dynamic> parsedJson) {
    List<Service> services = new List<Service>();
    services = parsedJson.map((i) => Service.fromJson(i)).toList();
    return new ServiceList(
      services: services,
    );
  }
}