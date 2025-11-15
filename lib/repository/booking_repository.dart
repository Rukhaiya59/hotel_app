// import 'package:objectbox/objectbox.dart';
// import '../model/entity_booking.dart';
//
// class BookingRepository {
//   final Box<EntityBooking> bookingBox;
//
//   BookingRepository(Store store) : bookingBox = store.box<EntityBooking>();
//
//   EntityBooking? getFullBookingDetails(int bookingId) {
//     final booking = bookingBox.get(bookingId);
//     if (booking == null) return null;
//
//     final room = booking.room.target;
//     final guests = booking.guest.toList();
//     final amenities = booking.amenities.toList();
//     final payments = booking.payment.toList();
//     return booking;
//   }
// }
