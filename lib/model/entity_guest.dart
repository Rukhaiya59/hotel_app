// entity_guest.dart
import 'package:objectbox/objectbox.dart';
import 'entity_booking.dart';

@Entity()
class EntityGuest {
  @Id()
  int id = 0; // ObjectBox primary key

  // Existing fields
  int guestId;
  String guestUuid;
  String first;
  String last;
  String dob;
  String gender;
  String idName;
  String idValue;
  String createdOn;
  String createdBy;
  String updatedOn;

  // New fields
  String hotelUuid; // Added for multi-branch support
  String? phone; // Added contact information
  String? email; // Added contact information
  String? address; // Added guest address
  String? nationality; // Added guest information
  String? notes; // Added for special requests/notes
//neww
  String guestType;
  double totalSpending;
  int totalVisits;
  String? preferencesJson;
  String? tagsJson;

  // Relationship with booking
  final bookings = ToMany<EntityBooking>();

  EntityGuest({
    this.id = 0,
    required this.guestId,
    required this.guestUuid,
    required this.first,
    required this.last,
    required this.dob,
    required this.gender,
    required this.idName,
    required this.idValue,
    required this.createdOn,
    required this.createdBy,
    required this.updatedOn,
    // New fields initialization
    required this.hotelUuid,
    this.phone,
    this.email,
    this.address,
    this.nationality,
    this.notes,
// New CRM fields default
    this.guestType = "walkin",
    this.totalSpending = 0.0,
    this.totalVisits = 0,
    this.preferencesJson,
    this.tagsJson,
  });


  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'guestId': guestId,
      'guestUuid': guestUuid,
      'first': first,
      'last': last,
      'dob': dob,
      'gender': gender,
      'idName': idName,
      'idValue': idValue,
      'createdOn': createdOn,
      'createdBy': createdBy,
      'updatedOn': updatedOn,
      'hotelUuid': hotelUuid,
      'phone': phone,
      'email': email,
      'address': address,
      'nationality': nationality,
      'notes': notes,
      'guestType': guestType,
      'totalSpending': totalSpending,
      'totalVisits': totalVisits,
      'preferencesJson': preferencesJson,
      'tagsJson': tagsJson,
      // Note: ToMany relationship 'bookings' is not typically included in a simple toMap,
      // as it would require converting a list of complex objects.
      // If needed, you would map over 'bookings' and call toMap() on each EntityBooking.
      // 'bookings': bookings.map((booking) => booking.toMap()).toList(),
    };
  }
}








