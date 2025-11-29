import 'package:get/get.dart';
import '../../../../model/entity_booking.dart';
import '../../../../model/entity_room.dart';
import '../../../../service/service_object_box.dart';
import '../../../../util/snackbar_util.dart';
import '../../../booking/controller_cancel_reason.dart';


class ControllerReservation extends GetxController {
  late final boxBooking;
  late final boxRoom;

  @override
  void onInit() {
    final ob = Get.find<ServiceObjectBox>();
    boxBooking = ob.store.box<EntityBooking>();
    boxRoom = ob.store.box<EntityRoom>();
    super.onInit();
  }

  // ------------------------------------------------------------
  //  SAFE DATE PARSER (prevents app crash)
  // ------------------------------------------------------------
  DateTime _safeDate(String dateStr) {
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return DateTime.now();
    }
  }

  // ------------------------------------------------------------
  //  AUTO CHECK-IN
  // ------------------------------------------------------------
  Future<void> autoCheckIn(EntityBooking booking) async {
    if (booking == null) return;

    // already checked in?
    if (booking.status.toLowerCase() == "checkedin") {
      SnackbarUtil.showError("Already Checked-in");
      return;
    }

    // update booking status
    booking.status = "checkedin";
    booking.actualCheckInAt = DateTime.now.toString();
    boxBooking.put(booking);

    // update room status
    final room = booking.room.target;
    if (room != null) {
      room.status = "busy";
      room.bookingUuid = booking.bookingUuid;
      boxRoom.put(room);
    }

    SnackbarUtil.showSuccess("Checked-in successfully!");
    update();
  }

  // ------------------------------------------------------------
  //  CANCEL RESERVATION WITH REASON POP-UP
  // ------------------------------------------------------------
  Future<void> cancelReservation(EntityBooking booking) async {
    if (booking == null) return;

    // open reason dialog
    final reasonCtrl = Get.put(ControllerCancelReason());
    final reason = await reasonCtrl.showCancelReasonDialog(Get.context!);

    if (reason == null) return; // dialog closed

    // save backup for undo
    final oldStatus = booking.status;
    final oldReason = booking.cancelReason;
    final oldCancelledAt = booking.cancelledAt;

    booking.status = "cancelled";
    booking.cancelReason = reason.isEmpty ? "No reason" : reason;
    booking.cancelledAt = DateTime.now().toIso8601String();
    boxBooking.put(booking);

    // free room
    final room = booking.room.target;
    if (room != null) {
      room.status = "available";
      room.bookingUuid = null;
      boxRoom.put(room);
    }

    SnackbarUtil.showUndo(
      message: "Reservation cancelled",
      undoText: "UNDO",
      onUndo: () {
        booking.status = oldStatus;
        booking.cancelReason = oldReason;
        booking.cancelledAt = oldCancelledAt;

        boxBooking.put(booking);

        if (room != null) {
          room.status = "reserved";
          room.bookingUuid = booking.bookingUuid;
          boxRoom.put(room);
        }

        SnackbarUtil.showSuccess("Cancellation restored!");
      },
    );

    update();
  }

  // ------------------------------------------------------------
  //  CHECK IF ROOM IS DOUBLE BOOKED FOR GIVEN DATE RANGE
  // ------------------------------------------------------------
  bool isRoomAvailable({
    required EntityRoom room,
    required String checkIn,
    required String checkOut,
    int ignoreBookingId = 0,
  }) {
    final ci = _safeDate(checkIn);
    final co = _safeDate(checkOut);

    final all = boxBooking.getAll();

    for (var b in all) {
      if (b.bookingId == ignoreBookingId) continue; // skip editing booking

      final r = b.room.target;
      if (r == null) continue;
      if (r.id != room.roomId) continue;

      final bCi = _safeDate(b.checkInDate);
      final bCo = _safeDate(b.checkOutDate);

      final overlap =
      (ci.isBefore(bCo) && co.isAfter(bCi));

      if (overlap && b.status.toLowerCase() != "cancelled") {
        return false;
      }
    }

    return true;
  }

  // ------------------------------------------------------------
  //  FORCE REFRESH AFTER UPDATE
  // ------------------------------------------------------------
  void refreshReservations() {
    update();
  }
}
