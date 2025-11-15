import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';
import '../../../../model/entity_booking.dart';
import '../../../../service/service_object_box.dart';

class ControllerBookingHistory extends GetxController {
  late Box<EntityBooking> boxBooking;
  final RxList<EntityBooking> allBookings = <EntityBooking>[].obs;

  @override
  void onInit() {
    final ob = Get.find<ServiceObjectBox>();
    boxBooking = ob.store.box<EntityBooking>();
    fetchAllBookings();
    super.onInit();
  }

  /// Fetch all bookings
  void fetchAllBookings() {
    allBookings.value = boxBooking.getAll();
  }

  /// Delete booking by ID
  void deleteBooking(int bookingId) {
    boxBooking.remove(bookingId);
    fetchAllBookings();
  }
}
