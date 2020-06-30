/// Usage:
///   import 'package:gghack/RequesterUnitTest.dart';
///   UnitTest.testCustomer();
import 'Requester.dart';
import 'package:gghack/models/ServiceList.dart';
import 'package:gghack/models/Service.dart';
import 'package:gghack/models/ReservationList.dart';
import 'package:gghack/models/Reservation.dart';
import 'package:gghack/helpers/Constants.dart';

class UnitTest {
  static String t = "";  // Change this if you
  static String email = "email$t@gmail.com";
  static String username = "admin$t";
  static String password1 = "mimahaomafan";
  static String password2 = password1;
  static String token = "a6fbd9b31598748cb38063de23062d208cfbb1ec";
  static String bookDate = "2020-07-12";
  static String bookTime = "18:00";
  static ServiceList serviceList;
  static Service service;
  static ReservationList reservationList;
  static Reservation reservation;

  static String serviceName = "Kate's Boba Shop 2";
  static String address = "In your heart <3";
  static String introduction = "Kate enjoys making boba so much that she decided to quit UST and start her own business, but this is her own business. ^^";
  static String type = "CL";
  static double longitude = 25.001741;
  static double latitude = 121.463034;
  static double rating = 5.0;
  static String imageUrl = "https://www.moshimoshi-nippon.jp/wp/wp-content/uploads/2019/03/TP-TEA.png";
  static int maxCapacity = 3;


  //////////////////////////////////////////////////////////////////////////////
  //                    Shared among Customer and Provider                    //
  //////////////////////////////////////////////////////////////////////////////

  static Future<void> testCreateAccount() async {
    token = await Requester().createAccount(
        email, username, password1, password2);
    print("[P] testCreateAccount " + token);
  }

  static Future<void> testLogin() async {
    token = await Requester().login(email, username, password1);
    print("[P] testLogin " + token);
  }

  static Future<void> testRenderServiceList() async {
    serviceList = await Requester().renderServiceList();
    print("[P] testRenderServiceList len="
        + serviceList.services.length.toString());
  }

  //////////////////////////////////////////////////////////////////////////////
  //                               For Customer                               //
  //////////////////////////////////////////////////////////////////////////////
  static Future<void> testCustomerRenderService() async {
    service = await Requester().customerRenderService(
        service.serviceId);
    print("[P] testCustomerRenderService " + service.name);
  }

  static Future<void> testMakeReservation() async {
    fillService();
    print("Try making reservation to ${service.name}");
    print("   Token $token");
    print("   date $bookDate");
    print("   time $bookTime");
    int code = await Requester().makeReservation(
        token, service.name, bookDate, bookTime);
    print("[P] testMakeReservation code=" + code.toString());
  }

  static Future<void> testCancelReservation() async {
    int code = await Requester().cancelReservation(
        token, reservation.reservationId);
    print("[P] testCancelReservation code=" + code.toString());
  }

  static Future<void> testCustomerRenderReservationList() async {
    reservationList = await Requester().customerRenderReservationList(token);
    print("[P] testRenderReservationList len="
        + reservationList.reservations.length.toString());
  }

  static Future<void> testRenderSpecificReservation() async {
    reservation = await Requester().renderSpecificReservation(
        token, reservation.reservationId);
    print("[P] testRenderSpecificReservation: " + reservation.reservationId.toString());
  }

  //////////////////////////////////////////////////////////////////////////////
  //                               For Provider                               //
  //////////////////////////////////////////////////////////////////////////////
  static fillService() async {
    service = new Service (
      serviceId: -1,
      name: serviceName,
      address: address,
      introduction: introduction,
      photo: imageUrl,
      time: optime,
      slots: freeslots,
      reservation: reservationInfo,
      type: type,
      longitude: longitude,
      latitude: latitude,
      rating: rating,
      maxCapacity: maxCapacity,
    );
  }
  static Future<void> testCreateService() async {
    fillService();
    service = await Requester().createService(
      token, service
    );
    print("[P] testCreateService " + service.name);
  }

  static Future<void> testProviderRenderService() async {
    service = await Requester().providerRenderService(
        service.serviceId);
    print("[P] testProviderRenderService service=" + service.name);
  }

  static Future<void> testProviderRenderReservationList() async {
    reservationList = await Requester().providerRenderReservationList(token);
    print("[P] testProviderRenderReservationList len=" + reservationList.reservations.length.toString());
  }

  static Future<void> testCheckInReservation() async {
    int code = await Requester().checkInReservation(
        token, reservation.reservationId
    );
    print("[P] testCheckInReservation code=$code");
  }

  static Future<void> testNoShowReservation() async {
    int code = await Requester().noShowReservation(
        token, reservation.reservationId
    );
    print("[P] testNoShowReservation code=$code");
  }


  //////////////////////////////////////////////////////////////////////////////
  //                           Aggregated Functions                           //
  //////////////////////////////////////////////////////////////////////////////
  static bool _onError(Object error) {
    print("[F] " + error.toString());
    return false;
  }


  static Future<void> testCustomer() async {
//    await testCreateAccount().catchError(onError); // P
    await testLogin().catchError(_onError); // P
    await testRenderServiceList().catchError(_onError); // P
    await testCustomerRenderService().catchError(_onError); // P
  }


  static Future<void> testProvider() async {
    await testLogin().catchError(_onError);  // P
//    await testCreateService().catchError(_onError);  // P
    await testProviderRenderService().catchError(_onError);  // P
  }


  static Future<void> testMakeAndCancelReservation() async {
    await testLogin().catchError(_onError);  // P
    // TODO Solve the following 'F's

    // Make a reservation and cancel it
    await testMakeReservation().catchError(_onError);  // F
    await testCustomerRenderReservationList().catchError(_onError);  // P
    await testProviderRenderReservationList().catchError(_onError);  // P

    await testRenderSpecificReservation().catchError(_onError);  // F

    await testCancelReservation().catchError(_onError);  // F
    await testCustomerRenderReservationList().catchError(_onError);  // P
    await testProviderRenderReservationList().catchError(_onError);  // P
  }


  static Future<void> testCheckInNoShowReservation() async {
    // Make a reservation and check in it
    await testMakeReservation().catchError(_onError);
    await testCheckInReservation().catchError(_onError);

    // Make a reservation and no-show it
    await testMakeReservation().catchError(_onError);
    await testNoShowReservation().catchError(_onError);
  }

}