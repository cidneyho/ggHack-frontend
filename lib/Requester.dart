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
  //                    Shared among Customer and Provider                    //
  //////////////////////////////////////////////////////////////////////////////
  // Create Account [backend: DONE]
  /// Successful: returns the login token <string>
  /// Otherwise: throws exception
  Future<String> createAccount(
      String email, String username, String password1, String password2) async {

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


  // Login [backend: DONE]
  /// Successful: returns the login token <string>
  /// Otherwise: throws exception
  Future<String> login(
      String email, String username, String password) async {

    var uri = Uri.https(baseUrl, '/rest-auth/login');

    final response = await http.post(
      uri,
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'email': email,
      }),
    );
    if (response.statusCode == 200) {
      return response.body.toString();
    } else {
      throw Exception('Failed to customerLogin: statusCode ${response.statusCode}');
    }
  }


  // Render all services (no authentication needed) [backend: DONE; frontend: tested-OK]
  /// Successful: returns the <ServiceList> parsed from json
  /// Otherwise: throws exception
  Future<ServiceList> renderServiceList() async {

    var uri = Uri.https(baseUrl, '/customer/services');

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return ServiceList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to renderServiceList: statusCode ${response.statusCode}');
    }
  }


  // Search for services (no authentication needed) [backend: DONE]
  // ?? 'Partial match' is not allowed, so we'd better just use the current
  // frontend one instead of calling the API / using the following.
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



  //////////////////////////////////////////////////////////////////////////////
  //                               For Customer                               //
  //////////////////////////////////////////////////////////////////////////////
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


  // Make a reservation [backend: DONE]
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


  // Customer render reservation list [backend: DONE]
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
          'Failed to customerRenderReservationList: statusCode ${response.statusCode}');
    }
  }


  // Render a reservation [backend: DONE]
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
  // Create services [backend: DONE]
  /// Successful: returns 0
  /// Otherwise: throws exception
  // TODO change the signature to "receive a service object" directly? (maybe create user's models too, so we keep a user object to render sth in the side bar)
  Future<int> createService(
      String token,
      String serviceName, int ownerId, String address, String introduction,
      String type, double longitude, double latitude, double rating,
      String imageUrl, int maxCapacity) async {

    var uri = Uri.https(baseUrl, '/provider/services');

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Authorization' : 'Token $token'
      },
      body: jsonEncode({
        //"id": 2, // It doesn't make sense to know the service ID in advance.
        "name": serviceName,
        "owner": ownerId,
        "address": address,
        "introduction": introduction,
        "type": type,
        "longitude": longitude,
        "latitude": latitude,
        "rating": rating,
        "image": imageUrl,
        "maxCapacity": maxCapacity,
      }),
    );
    if (response.statusCode == 201) {
      return 0;
    } else {
      throw Exception('Failed to makeReservation: statusCode ${response.statusCode}');
    }
  }


  // Render detail created service [backend: DONE]
  /// Same as customerRenderService
  /// Successful: returns a <Service> object from json
  /// Otherwise: throws exception
  Future<Service> providerRenderService(int serviceId) async {
    return customerRenderService(serviceId);
  }

  // Provider render reservation list [backend: DONE]
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


  // Generate the content for QR code [frontend-only]
  /// *Not related to backend*
  /// Note that the QR code contains just the reservationId
  /// because the check-in API requires log-in and PUT method
  /// So we can't simply scan it with camera, and have to do it with
  String generateQrCodeString(int reservationId) {
    String qrCodeString = reservationId.toString();
    return qrCodeString;
  }


  // Check in for user with QR code scanning [backend: Done]
  /// Successful: returns 0
  /// Otherwise: throws exception
  Future<int> checkInQrCode(String token, String qrCodeString) async {
    return checkInReservation(token, int.parse(qrCodeString));
  }


  // Check in for user after scanning the QR code [backend: Done]
  /// Successful: returns 0
  /// Otherwise: throws exception
  Future<int> checkInReservation(String token, int reservationId) async {
    var uri = Uri.https(baseUrl, '/provider/reservations/$reservationId');

    final response = await http.put(
      uri,
      headers: <String, String>{
        'Authorization' : 'Token $token'
      },
      body: jsonEncode({
        "status": "CP",
      }),
    );
    if (response.statusCode == 200) {
      return 0;
    } else {
      throw Exception('Failed to checkInReservation: statusCode ${response.statusCode}');
    }
  }


  // Customer no-show
  /// Successful: returns 0
  /// Otherwise: throws exception
  Future<int> noShowReservation(String token, int reservationId) async {
    var uri = Uri.https(baseUrl, '/provider/reservations/$reservationId');

    final response = await http.put(
      uri,
      headers: <String, String>{
        'Authorization' : 'Token $token'
      },
      body: jsonEncode({
        "status": "MS",
      }),
    );
    if (response.statusCode == 200) {
      return 0;
    } else {
      throw Exception('Failed to noShowReservation: statusCode ${response.statusCode}');
    }
  }
}