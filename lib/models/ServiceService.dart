import 'ServiceList.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class ServiceService {

  Future<String> _loadServiceAssets() async {
    return await rootBundle.loadString('assets/data/sample.json');
  }

  Future<ServiceList> loadServices() async {
    String jsonString = await _loadServiceAssets();
    final jsonResponse = json.decode(jsonString);
    ServiceList services = new ServiceList.fromJson(jsonResponse);
    return services;
  }
}