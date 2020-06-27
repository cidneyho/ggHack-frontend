/// This file is the frontend API for all networking requests
/// Fetch data: https://flutter.dev/docs/cookbook/networking/fetch-data
/// Send data: https://flutter.dev/docs/cookbook/networking/send-data
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:gghack/models/ServiceList.dart';
import 'package:gghack/models/Service.dart';
import 'package:gghack/models/Reservation.dart';
import 'package:gghack/models/ReservationList.dart';
import 'package:gghack/helpers/Constants.dart';

class Requester {
  //////////////////////////////////////////////////////////////////////////////
  //                               For Customer                               //
  //////////////////////////////////////////////////////////////////////////////
  // Create Account [backend not done]
  /// Successful: returns the login token <string>
  /// Otherwise: throws exception
  Future<String> customerCreateAccount(
      String username, String email, String password1, String password2) async {

    var uri = Uri.https(baseUrl, '/rest-auth/registration');

    final response = await http.post(
      uri,
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password1': password1,
        'password2': password2,
      }),
    );
    if (response.statusCode == 201) {
      return response.body.toString();
    } else {
      throw Exception('Failed to createCustomerAccount: statusCode ${response.statusCode}');
    }
  }

  // 等後端寫完 [backend not done]
  //Future<ServiceList> customerLogin() async {
  //
  //}

  // Render all services (no authentication needed) [backend: DONE; frontend: tested-OK]
  /// Successful: returns the <ServiceList> parsed from json
  /// Otherwise: throws exception
  Future<ServiceList> renderServiceList() async {

    var uri = Uri.https(baseUrl, '/customer/services');

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return ServiceList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to searchService: statusCode ${response.statusCode}');
    }
  }

  // Search for services (no authentication needed) [backend: DONE]
  // ?? 'Partial match' is not allowed, so we'd better just use the current
  // frontend one instead of calling the following.
  /// Successful: returns the <ServiceList> parsed from json
  /// Otherwise: throws exception
//  Future<ServiceList> searchService(String query) async {
//
//    var uri = Uri.https(baseUrl, '/customer/services', { 'q' : query });
//
//    final response = await http.get(uri);
//    if (response.statusCode == 200) {
//      return ServiceList.fromJson(json.decode(response.body));
//    } else {
//      throw Exception('Failed to searchService: statusCode ${response.statusCode}');
//    }
//  }

  // Render service homepage (for customer/user) (no authentication needed) [backend: DONE]
  /// Successful: returns a <Service> object from json
  /// Otherwise: throws exception
  Future<Service> customerRenderService(int serviceId) async {

    var uri = Uri.https(baseUrl, '/customer/services/$serviceId');

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return Service.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to customerRenderService: statusCode ${response.statusCode}');
    }
  }

  // Make a reservation [backend: done]
  /// Successful: returns 0
  /// Otherwise: throws exception
  Future<int> makeReservation(
      String token, int serviceId, String startTime, String endTime) async {

    var uri = Uri.https(baseUrl, '/customer/reservations');

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Authorization' : 'Token $token'
      },
      body: jsonEncode(<String, String>{
        'provider': serviceId.toString(),
        'startTime': startTime,
        'endTime': endTime,
      }),
    );
    if (response.statusCode == 201) {
      return 0;
    } else {
      throw Exception('Failed to makeReservation: statusCode ${response.statusCode}');
    }
  }

  // Cancel reservation [backend: DONE]
  /// Successful: returns 0
  /// Otherwise: throws exception
  Future<int> cancelReservation(String token, int reservationId) async {

    var uri = Uri.https(baseUrl, '/customer/reservations/$reservationId');

    final http.Response response = await http.delete(
      uri,
      headers: <String, String>{
        'Authorization' : 'Token $token'
      },
    );
    if (response.statusCode == 201) {
      return 0;
    } else {
      throw Exception('Failed to cancelReservation: statusCode ${response.statusCode}');
    }
  }

  // Customer render reservation list [backend: not done]
  /// Successful: returns <ReservationList> containing all reservations of the user
  /// Otherwise: throws exception
  Future<ReservationList> customerRenderReservationList(String token) async {
    var uri = Uri.https(baseUrl, '/customer/reservations/');

    final response = await http.get(
        uri,
      headers: <String, String>{
        'Authorization' : 'Token $token'
      },
    );
    if (response.statusCode == 200) {
      return ReservationList.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to renderReservationList: statusCode ${response.statusCode}');
    }
  }

  // Render a reservation [backend: not done]
  /// Successful: returns the corresponding <Reservation>
  /// Otherwise: throws exception
  Future<Reservation> renderSpecificReservation(String token, int reservationId) async {
    var uri = Uri.https(baseUrl, '/customer/reservations/$reservationId');

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Authorization' : 'Token $token'
      },
    );
    if (response.statusCode == 200) {
      return Reservation.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to renderSpecificReservation: statusCode ${response.statusCode}');
    }
  }


  //////////////////////////////////////////////////////////////////////////////
  //                               For Provider                               //
  //////////////////////////////////////////////////////////////////////////////
  // Wait for backend
//  Future<int> createService(String token) async {
//
//    var uri = Uri.https(baseUrl, '/provider/services');
//
//    final response = await http.post(
//      uri,
//      headers: <String, String>{
//        'Authorization' : 'Token $token'
//      },
//      body: jsonEncode(<String, String>{
//        'provider': serviceId.toString(),
//        'startTime': startTime,
//        'endTime': endTime,
//      }),
//    );
//    if (response.statusCode == 201) {
//      return 0;
//    } else {
//      throw Exception('Failed to makeReservation: statusCode ${response.statusCode}');
//    }
//  }


  // Render detail created service [backend: DONE]
  /// Same as customerRenderService
  /// Successful: returns a <Service> object from json
  /// Otherwise: throws exception
  Future<Service> providerRenderService(int serviceId) async {
    return customerRenderService(serviceId);
  }

  // Provider render reservation list [backend: not done]
  /// Successful: returns <ReservationList> containing all reservations of the user
  /// Otherwise: throws exception
  Future<ReservationList> providerRenderReservationList(String token) async {
    var uri = Uri.https(baseUrl, '/provider/reservations/');

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Authorization' : 'Token $token'
      },
    );
    if (response.statusCode == 200) {
      return ReservationList.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to providerRenderReservationList: statusCode ${response.statusCode}');
    }
  }

  // The others: wait for backend
}