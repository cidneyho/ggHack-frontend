import 'ServiceList.dart';
import 'package:gghack/Requester.dart';

class ServiceService {

  Future<ServiceList> loadServices() async {
    return Requester().renderServiceList();
  }
}