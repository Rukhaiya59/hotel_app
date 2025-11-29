import 'package:get/get.dart';
import 'package:hotel/model/entity_booking.dart';
import 'package:hotel/model/entity_guest.dart';
import 'package:hotel/objectbox.g.dart';
import 'package:hotel/service/service_object_box.dart';

class ControllerGuestHistory extends GetxController {
  late Box<EntityGuest> boxGuest;
  late Box<EntityBooking> boxBooking;

  final RxList<EntityGuest> allGuests = <EntityGuest>[].obs;
  final RxList<Map<String, dynamic>> guestHistoryList =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    final ob = Get.find<ServiceObjectBox>();
    boxGuest = ob.box<EntityGuest>();
    boxBooking = ob.box<EntityBooking>();

    loadGuests();
    super.onInit();
  }

  void loadGuests() {
    allGuests.value = boxGuest.getAll();
  }

  /// 🔍 SEARCH guest
  void searchGuests(String query) {
    query = query.toLowerCase();
    allGuests.value = boxGuest
        .getAll()
        .where((g) =>
    g.first.toLowerCase().contains(query) ||
        g.last.toLowerCase().contains(query) ||
        g.phone!.toLowerCase().contains(query))
        .toList();
  }

  /// 📌 Load booking history of selected guest
  void loadGuestHistory(EntityGuest guest) {
    final allBookings = boxBooking.getAll();

    final guestBookings = allBookings.where((b) {
      return b.guest.any((g) => g.first == guest.first && g.phone == guest.phone);
    }).toList();

    guestHistoryList.value = guestBookings.map((b) {
      return {
        "bookingId": b.bookingId,
        "room": b.room.target?.number ?? "N/A",
        "checkIn": b.checkInDate,
        "checkOut": b.checkOutDate,
        "total": b.totalBill,
        "discount": b.discountPrice,
        "paid": b.payment.fold(0.0, (sum, p) => sum + p.amount),
        "pending": b.totalBill -
            (b.payment.fold(0.0, (sum, p) => sum + p.amount)),
        "status": b.status,
      };
    }).toList();
  }
}
