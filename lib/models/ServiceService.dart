import 'ServiceList.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gghack/helpers/Constants.dart';

class ServiceService {

  Future<ServiceList> loadServices() async {
    final response = await http.get(serviceListUrl);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final jsonResponse = json.decode(response.body);
      ServiceList services = new ServiceList.fromJson(jsonResponse);
      return services;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load services');
    }
  }
}