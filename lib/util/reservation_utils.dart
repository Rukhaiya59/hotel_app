// // File: lib/utils/reservation_utils.dart
// // Helpers to compute reservation states
// import '../model/entity_booking.dart';
// import '../model/entity_room.dart';
// import '../objectbox.g.dart';
//
// bool bookingCoversDate(EntityBooking booking, DateTime date) {
//   try {
//     final ci = DateTime.parse(booking.checkInDate);
//     final co = DateTime.parse(booking.checkOutDate);
//     return !date.isBefore(ci) && date.isBefore(co);
//   } catch (_) {
//     return false;
//   }
// }
//
// EntityBooking? currentBookingForRoomToday(Box<EntityBooking> boxBooking, EntityRoom room, DateTime date) {
//   if (room.bookingUuid == null) return null;
//   final q = boxBooking.query(EntityBooking_.bookingUuid.equals(room.bookingUuid!)).build();
//   try {
//     final b = q.findFirst();
//     if (b == null) return null;
//     if (bookingCoversDate(b, date)) return b;
//     return null;
//   } finally {
//     q.close();
//   }
// }
//
// enum VisualRoomState { available, reserved, occupied, cleaning, unknown }
//
// VisualRoomState roomVisualState(Box<EntityBooking> boxBooking, EntityRoom room, DateTime date) {
//   final b = currentBookingForRoomToday(boxBooking, room, date);
//   if (b == null) {
//     // fallback to room.status
//     switch ((room.status ?? "").toLowerCase()) {
//       case "busy":
//       case "occupied":
//         return VisualRoomState.occupied;
//       case "cleaning":
//       case "dirty":
//         return VisualRoomState.cleaning;
//       default:
//         return VisualRoomState.available;
//     }
//   }
//
//   final s = b.status.toLowerCase();
//   if (s == "checkedin" || s == "confirmed") return VisualRoomState.occupied;
//   if (s == "reserved") return VisualRoomState.reserved;
//   return VisualRoomState.occupied;
// }
// File: lib/utils/reservation_utils.dart
// Helpers to compute reservation states

import '../model/entity_booking.dart';
import '../model/entity_room.dart';
import '../objectbox.g.dart';

bool bookingCoversDate(EntityBooking booking, DateTime date) {
  try {
    final ci = DateTime.parse(booking.checkInDate);
    final co = DateTime.parse(booking.checkOutDate);
    return !date.isBefore(ci) && date.isBefore(co);
  } catch (_) {
    return false;
  }
}

EntityBooking? currentBookingForRoomToday(
    Box<EntityBooking> boxBooking, EntityRoom room, DateTime date) {
  if (room.bookingUuid == null) return null;

  final q = boxBooking
      .query(EntityBooking_.bookingUuid.equals(room.bookingUuid!))
      .build();

  try {
    final b = q.findFirst();
    if (b == null) return null;
    if (bookingCoversDate(b, date)) return b;
    return null;
  } finally {
    q.close();
  }
}

enum VisualRoomState { available, reserved, occupied, cleaning, unknown }

VisualRoomState roomVisualState(
    Box<EntityBooking> boxBooking, EntityRoom room, DateTime date) {
  // 1️⃣ Check if any booking applies today
  final b = currentBookingForRoomToday(boxBooking, room, date);

  if (b != null) {
    final s = (b.status ?? "").toLowerCase();

    // Reserved booking → room empty but reserved
    if (s == "reserved") {
      return VisualRoomState.reserved;
    }

    // Checked-in guest → room occupied
    if (s == "checkedin" || s == "confirmed") {
      return VisualRoomState.occupied;
    }
  }

  // 2️⃣ NO active booking today → use only physical room condition
  switch (room.status) {
    case "busy":
      return VisualRoomState.occupied;

    case "cleaning":
      return VisualRoomState.cleaning;

    case "blocked":
      return VisualRoomState.reserved;

    default:
      return VisualRoomState.available;
  }
}
