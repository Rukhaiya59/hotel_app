// entity_booking.dart
import 'package:objectbox/objectbox.dart';

import 'entity_amenities.dart';
import 'entity_guest.dart';
import 'entity_payment.dart';
import 'entity_room.dart';

@Entity()
class EntityBooking {
  @Id()
  int id = 0;
  int bookingId; // ObjectBox primary key

  String bookingUuid;
  double totalBill;

  double? discountPrice;
  String? discountDesc;
  // ✅ TAX (ADDED)
  double? taxAmount;
  String? taxDescription;

  // New fields
  String hotelUuid;
  String checkInDate; // Added check-in date
  String checkOutDate; // Added check-out date
  String bookingType; // Added (Walk-in, Corporate, Group)
  String status; // Added (Confirmed, Checked-In, Checked-Out, Cancelled)
  String? notes; // Added for internal notes

  //neww
  String cleaningTime;
  bool cleaningTaskCreated;
  String? cancelledAt;
  String? cancelReason;
  String? actualCheckInAt;
  String? actualCheckOutAt;
  bool reminderTMinus1Sent;
  bool reminderOnDaySent;

  // Link to guest
  final guest = ToMany<EntityGuest>();
  final room = ToOne<EntityRoom>();
  final amenities = ToMany<EntityAmenities>();
  final payment = ToMany<EntityPayment>();

  EntityBooking({
    this.id = 0,
    this.bookingId = 0,
    required this.bookingUuid,
    required this.totalBill,
    this.discountPrice,
    this.discountDesc,
    this.taxAmount,
    this.taxDescription,

    required this.hotelUuid,
    required this.checkInDate,
    required this.checkOutDate,
    this.bookingType = 'Walk-in',
    this.status = 'Confirmed',
    this.notes,
    this.reminderTMinus1Sent = false,
    this.reminderOnDaySent = false,
  }) : cleaningTime = DateTime.now().toString(),
       cleaningTaskCreated = false;

  // fromJson
  factory EntityBooking.fromJson(Map<String, dynamic> json) =>
      EntityBooking(
          id: json['id'] ?? 0,
          bookingId: json['bookingId'] ?? 0,
          bookingUuid: json['bookingUuid'],
          totalBill: (json['totalBill'] as num).toDouble(),
          discountPrice: (json['discountPrice'] as num?)?.toDouble(),
          discountDesc: json['discountDesc'],
          taxAmount: (json['taxAmount'] as num?)?.toDouble(),
          taxDescription: json['taxDescription'],
          hotelUuid: json['hotelUuid'],
          checkInDate: json['checkInDate'],
          checkOutDate: json['checkOutDate'],
          bookingType: json['bookingType'] ?? 'Walk-in',
          status: json['status'] ?? 'Confirmed',
          notes: json['notes'],
          reminderTMinus1Sent: json['reminderTMinus1Sent'] ?? false,
          reminderOnDaySent: json['reminderOnDaySent'] ?? false,
        )
        ..cleaningTime = json['cleaningTime'] ?? DateTime.now().toString()
        ..cleaningTaskCreated = json['cleaningTaskCreated'] ?? false
        ..cancelledAt = json['cancelledAt']
        ..cancelReason = json['cancelReason']
        ..actualCheckInAt = json['actualCheckInAt']
        ..actualCheckOutAt = json['actualCheckOutAt'];
  // Note: ToMany and ToOne relations are not handled in this fromJson.
  // They are typically populated after the object is created and put into the ObjectBox store.
  // For example, by linking them using their IDs from the JSON.

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingId': bookingId,
      'bookingUuid': bookingUuid,
      'totalBill': totalBill,
      'discountPrice': discountPrice,
      'discountDesc': discountDesc,
      'taxAmount': taxAmount,
      'taxDescription': taxDescription,
      'hotelUuid': hotelUuid,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'bookingType': bookingType,
      'status': status,
      'notes': notes,
      'cleaningTime': cleaningTime,
      'cleaningTaskCreated': cleaningTaskCreated,
      'cancelledAt': cancelledAt,
      'cancelReason': cancelReason,
      'actualCheckInAt': actualCheckInAt,
      'actualCheckOutAt': actualCheckOutAt,
      'reminderTMinus1Sent': reminderTMinus1Sent,
      'reminderOnDaySent': reminderOnDaySent,
      // Note: Relations are not serialized directly.
      // You would typically serialize their IDs/UUIDs or a nested map.
      'room': room.target?.toMap(), // Assumes EntityRoom has toMap()
      'guests': guest
          .map((g) => g.toMap())
          .toList(), // Assumes EntityGuest has toMap()
      'amenities': amenities
          .map((a) => a.toMap())
          .toList(), // Assumes EntityAmenities has toMap()
      'payments': payment
          .map((p) => p.toMap())
          .toList(), // Assumes EntityPayment has toMap()
    };
  }
}
