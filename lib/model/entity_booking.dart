// entity_booking.dart
import 'package:objectbox/objectbox.dart';

import 'entity_amenities.dart';
import 'entity_guest.dart';
import 'entity_payment.dart';
import 'entity_room.dart';

@Entity()
class EntityBooking {
  @Id()
  int bookingId; // ObjectBox primary key

  String bookingUuid;
  double totalBill;

  double? discountPrice;
  String? discountDesc;

  // New fields
  String hotelUuid;
  String checkInDate; // Added check-in date
  String checkOutDate; // Added check-out date
  String bookingType; // Added (Walk-in, Corporate, Group)
  String status; // Added (Confirmed, Checked-In, Checked-Out, Cancelled)
  String? notes; // Added for internal notes

  // Link to guest
  final guest = ToMany<EntityGuest>();
  final room = ToOne<EntityRoom>();
  final amenities = ToMany<EntityAmenities>();
  final payment = ToMany<EntityPayment>();

  EntityBooking({
    this.bookingId = 0,
    required this.bookingUuid,
    required this.totalBill,

    this.discountPrice,
    this.discountDesc,

    required this.hotelUuid,
    required this.checkInDate,
    required this.checkOutDate,
    this.bookingType = 'Walk-in',
    this.status = 'Confirmed',
    this.notes,
  });

  // fromJson
  factory EntityBooking.fromJson(Map<String, dynamic> json) {
    return EntityBooking(
      bookingId: json['bookingId'] ?? 0,
      bookingUuid: json['bookingUuid'],
      totalBill: json['totalBill'],
      discountPrice: json['discountPrice'],
      discountDesc: json['discountDesc'],
      hotelUuid: json['hotelUuid'],
      checkInDate: json['checkInDate'],
      checkOutDate: json['checkOutDate'],
      bookingType: json['bookingType'] ?? 'Walk-in',
      status: json['status'] ?? 'Confirmed',
      notes: json['notes'],
    );
    // Note: ToMany and ToOne relations are not handled in this basic fromJson.
    // They are typically populated after the object is created and put into the ObjectBox store.
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'bookingUuid': bookingUuid,
      'totalBill': totalBill,
      'discountPrice': discountPrice,
      'discountDesc': discountDesc,
      'hotelUuid': hotelUuid,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'bookingType': bookingType,
      'status': status,
      'notes': notes,
      // Note: ToMany and ToOne relations are not serialized to JSON directly.
      // You would typically serialize their IDs or UUIDs if needed.
      // For example:
      // 'guestIds': guest.map((g) => g.guestId).toList(),
      // 'roomId': room.target?.roomId,
    };
    }


}