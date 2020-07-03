/// This file is the frontend API for all networking requests
/// Fetch data: https://flutter.dev/docs/cookbook/networking/fetch-data
/// Send data: https://flutter.dev/docs/cookbook/networking/send-data
///
/// Notes ("Kengs" in Mandarin) for developer: If you encounter
/// "type '(HttpException) => Null' is not a subtype of type '(dynamic) => dynamic'",
/// there may be a url mismatch. Check the slashes at the end of each API function...
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
  // Create Account
  /// Successful: returns the login token <string>
  /// Otherwise: throws exception
  Future<String> createAccount(
      String email, String username, String password1, String password2) async {

    var uri = Uri.https(baseUrl, '/rest-auth/registration/');

    final response = await http.post(
      uri,
      headers: {
        "content-type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password1': password1,
        'password2': password2,
      }),
    );
    if (response.statusCode == 201) {
      print("createCustomerAccount returned ok: username=$username");
      return json.decode(response.body)['key'];
    } else {
      throw Exception('Failed to createCustomerAccount: statusCode ${response.statusCode}');
    }
  }


  // Login
  /// Successful: returns the login token <string>
  /// Otherwise: throws exception
  Future<String> login(String username, String password) async {

    var uri = Uri.https(baseUrl, '/rest-auth/login/');

    final response = await http.post(
      uri,
      headers: {
        "content-type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      print("login returned ok: username=$username");
      return json.decode(response.body)['key'];
    } else {
      throw Exception('Failed to customerLogin: statusCode ${response.statusCode}');
    }
  }


  // Render all services (no authentication needed)
  /// Successful: returns the <ServiceList> parsed from json
  /// Otherwise: throws exception
  Future<ServiceList> renderServiceList() async {

    var uri = Uri.https(baseUrl, '/customer/services');

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      print("renderServiceList returned ok");
      return ServiceList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to renderServiceList: statusCode ${response.statusCode}');
    }
  }


  // Search for services (no authentication needed)
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
  // Render service homepage (for customer/user) (no authentication needed)
  /// Successful: returns a <Service> object from json
  /// Otherwise: throws exception
  Future<Service> customerRenderService(int serviceId) async {

    var uri = Uri.https(baseUrl, '/customer/services/$serviceId');

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      print("customerRenderService returned ok: id=$serviceId");
      return Service.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to customerRenderService: statusCode ${response.statusCode}');
    }
  }


  // Make a reservation
  /// Successful: returns the <Reservation>
  /// Otherwise: throws exception
  /// Note: backend accepts form data only (and only for this function).
  Future<Reservation> makeReservation(
      String token, String serviceName, int bookDate, int bookTime) async {
    print("try making reservation: date=$bookDate, time=$bookTime");
    var uri = Uri.https(baseUrl, '/customer/reservations');
    var map = new Map<String, String>();
    map['service'] = serviceName;
    map['bookDate'] = bookDate.toString();
    map['bookTime'] = bookTime.toString();
    map['numPeople'] = '1';

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Authorization' : 'Token $token',
        "Accept": "application/json",
      },
      body: map,
    );
    if (response.statusCode == 201) {
      print("makeReservation returned ok: serviceName=$serviceName");
      return new Reservation.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to makeReservation: statusCode ${response.statusCode}');
    }
  }


  // Cancel reservation
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
    if (response.statusCode == 204) {
      print("cancelReservation returned ok: reservationId=$reservationId");
      return 0;
    } else {
      throw Exception('Failed to cancelReservation: statusCode ${response.statusCode}');
    }
  }


  // Customer render reservation list
  /// Successful: returns <ReservationList> containing all reservations of the user
  /// Otherwise: throws exception
  Future<ReservationList> customerRenderReservationList(String token) async {
    var uri = Uri.https(baseUrl, '/customer/reservations');

    final response = await http.get(
        uri,
      headers: <String, String>{
        'Authorization' : 'Token $token',
        "Accept": "application/json",
      },
    );
    if (response.statusCode == 200) {
      print("customerRenderReservationList returned ok");
      return ReservationList.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to customerRenderReservationList: statusCode ${response.statusCode}');
    }
  }


  // Render a reservation
  /// Successful: returns the corresponding <Reservation>
  /// Otherwise: throws exception
  Future<Reservation> renderSpecificReservation(String token, int reservationId) async {
    var uri = Uri.https(baseUrl, '/customer/reservations/$reservationId');

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Authorization' : 'Token $token',
        "Accept": "application/json",
      },
    );
    if (response.statusCode == 200) {
      print("renderSpecificReservation returned ok: reservationId=$reservationId");
      return Reservation.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to renderSpecificReservation: statusCode ${response.statusCode}');
    }
  }



  //////////////////////////////////////////////////////////////////////////////
  //                               For Provider                               //
  //////////////////////////////////////////////////////////////////////////////
  // Create services
  /// Successful: returns 0
  /// Otherwise: throws exception
  Future<Service> createService(String token, Service service) async {

    var uri = Uri.https(baseUrl, '/provider/services');
    var map = new Map<String, dynamic>();
    map['name'] = service.name;
    map['address'] = service.address;
    map['introduction'] = service.introduction;
    map['type'] = service.type;
    map['longitude'] = service.longitude.toString();
    map['latitude'] = service.latitude.toString();
    map['rating'] = service.rating.toString();
    map['image'] = service.image;
    map['maxCapacity'] = service.maxCapacity.toString();
    map['startTime'] = service.startTime.toString();
    map['closeTime'] = service.closeTime.toString();
    map['placeId'] = service.placeId;

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Authorization' : 'Token $token',
        "Accept": "application/json",
      },
      body: map,
    );
    if (response.statusCode == 201) {
      print("createService returned ok: name=${service.name}");
      service = Service.fromJson(json.decode(response.body));
      return service;
    } else {
      throw Exception('Failed to createService: statusCode ${response.statusCode}');
    }
  }


  // Render detail created service
  /// Same as customerRenderService
  /// Successful: returns a <Service> object from json
  /// Otherwise: throws exception
  Future<Service> providerRenderService(int serviceId) async {
    print("(providerRenderService leads to customerRenderService)");
    return customerRenderService(serviceId);
  }


  // Provider render reservation list
  /// Successful: returns <ReservationList> containing all reservations of the user
  /// Otherwise: throws exception
  Future<ReservationList> providerRenderReservationList(String token) async {
    var uri = Uri.https(baseUrl, '/provider/reservations');

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Authorization' : 'Token $token',
        "Accept": "application/json",
      },
    );
    if (response.statusCode == 200) {
      print("providerRenderReservationList returned ok");
      return ReservationList.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to providerRenderReservationList: statusCode ${response.statusCode}');
    }
  }


  // Check in for user after scanning the QR code
  /// Successful: returns 0
  /// Otherwise: throws exception
  Future<int> checkInReservation(String token, int reservationId) async {

    var uri = Uri.https(baseUrl, '/provider/reservations/$reservationId');
    var map = new Map<String, dynamic>();
    map['status'] = "CP";

    final response = await http.put(
      uri,
      headers: <String, String>{
        'Authorization' : 'Token $token',
      },
      body: map,
    );
    if (response.statusCode == 200) {
      print("checkInReservation returned ok: reservationId=$reservationId");
      return 0;
    } else {
      throw Exception('Failed to checkInReservation: statusCode ${response.statusCode}');
    }
  }


  // Generate the content for QR code
  /// *Not related to backend*
  /// Note that the QR code contains just the reservationId
  /// because the check-in API requires log-in and PUT method
  /// So we can't simply scan it with camera, and have to do it with
  String generateQrCodeString(int reservationId) {
    String qrCodeString = reservationId.toString();
    return qrCodeString;
  }


  // Customer no-show
  /// Successful: returns 0
  /// Otherwise: throws exception
  Future<int> noShowReservation(String token, int reservationId) async {
    var uri = Uri.https(baseUrl, '/provider/reservations/$reservationId');
    var map = new Map<String, dynamic>();
    map['status'] = "MS";

    final response = await http.put(
      uri,
      headers: <String, String>{
        'Authorization' : 'Token $token',
//        "content-type": "application/json",
        },
      body: map,
    );
    if (response.statusCode == 200) {
      print("noShowReservation returned ok: reservationId=$reservationId");
      return 0;
    } else {
      throw Exception('Failed to noShowReservation: statusCode ${response.statusCode}');
    }
  }
}