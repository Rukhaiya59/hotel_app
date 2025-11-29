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
  int bookingId;  // ObjectBox primary key

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
      // ✅ TAX
      'taxAmount': taxAmount,
      'taxDescription': taxDescription,

      'actualCheckInAt': actualCheckInAt,
      'actualCheckOutAt': actualCheckOutAt,
      'reminderTMinus1Sent': reminderTMinus1Sent,
      'reminderOnDaySent': reminderOnDaySent,

      // You would typically serialize their IDs or UUIDs if needed.
      // For example:
      // 'guestIds': guest.map((g) => g.guestId).toList(),
      // 'roomId': room.target?.roomId,
      'cleaningTime': cleaningTime,
      'cleaningTaskCreated': cleaningTaskCreated,
      'cancelledAt': cancelledAt,
      'cancelReason': cancelReason,
      'room': room.target?.toMap(),
      // Assuming EntityRoom has a toMap/toJson method
      'guests': guest.map((g) => g.toMap()).toList(),
      // Assuming EntityGuest has a toMap/toJson method
      'amenities': amenities.map((a) => a.toMap()).toList(),
      // Assuming EntityAmenities has a toMap/toJson method
      'payments': payment.map((p) => p.toMap()).toList(),
      // Assuming EntityPayment has a toMap/toJson method
    };
  }
}





