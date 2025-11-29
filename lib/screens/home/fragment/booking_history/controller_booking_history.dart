import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';
import '../../../../model/entity_booking.dart';
import '../../../../model/entity_room_change_history.dart';
import '../../../../service/service_object_box.dart';

class ControllerBookingHistory extends GetxController {
  late Box<EntityBooking> boxBooking;
  late Box<EntityRoomChangeHistory> boxRoomChange;

  final RxList<EntityBooking> allBookings = <EntityBooking>[].obs;
  final RxList<EntityBooking> filteredBookings = <EntityBooking>[].obs;
  final RxList<EntityRoomChangeHistory> roomChangeHistory =
      <EntityRoomChangeHistory>[].obs;

  final RxString filter = "Today".obs;

  @override
  void onInit() {
    final ob = Get.find<ServiceObjectBox>();
    boxBooking = ob.store.box<EntityBooking>();
    boxRoomChange = ob.store.box<EntityRoomChangeHistory>();


    fetchAllBookings();
    super.onInit();
  }

  Future<void> fetchAllBookings() async {
    allBookings.value = boxBooking.getAll();
    applyFilter();
  }
  void fetchRoomChangeHistory() {
    roomChangeHistory.value = boxRoomChange.getAll();
  }

  /// Apply filter to UI
  void applyFilter() {
    final now = DateTime.now();

    switch (filter.value) {
      case "Today":
        filteredBookings.value = allBookings.where((b) {
          final date = DateTime.tryParse(b.checkInDate ?? "");
          if (date == null) return false;
          return date.day == now.day &&
              date.month == now.month &&
              date.year == now.year;
        }).toList();
        break;

      case "This Week":
        final weekAgo = now.subtract(const Duration(days: 7));

        filteredBookings.value = allBookings.where((b) {
          final date = DateTime.tryParse(b.checkInDate ?? "");
          if (date == null) return false;
          return date.isAfter(weekAgo);
        }).toList();
        break;

      case "This Month":
        filteredBookings.value = allBookings.where((b) {
          final date = DateTime.tryParse(b.checkInDate ?? "");
          if (date == null) return false;
          return date.month == now.month &&
              date.year == now.year;
        }).toList();
        break;
      case "Room Change":
        fetchRoomChangeHistory();
        break;


      case "All":
        filteredBookings.value = allBookings;
        break;
    }
  }

  /// Change filter
  void setFilter(String newFilter) {
    filter.value = newFilter;
    applyFilter();
  }
}