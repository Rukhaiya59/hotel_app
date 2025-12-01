import 'package:get/get.dart';

import '../../../model/entity_amenities.dart';
import '../../../model/entity_guest.dart';

class ControllerSplitBill extends GetxController {
  final double totalAmount;
  final List<EntityGuest> guests;
  // final List<EntityAmenities> facilities;

  ControllerSplitBill({
    required this.totalAmount,
    required this.guests,
  });

  // ✅ Auto updated from tabs
  final RxList<Map<String, dynamic>> _finalResult =
      <Map<String, dynamic>>[].obs;

  List<Map<String, dynamic>> get finalResult => _finalResult;

  // ✅ These will be called automatically from child controllers
  void setFacilityResult(List<Map<String, dynamic>> r) {
    _finalResult.assignAll(r);
  }

  void setGuestResult(List<Map<String, dynamic>> r) {
    _finalResult.assignAll(r);
  }

  void setPercentResult(List<Map<String, dynamic>> r) {
    _finalResult.assignAll(r);
  }
}
