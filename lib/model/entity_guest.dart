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
  });

  // fromJson factory method
  factory EntityGuest.fromJson(Map<String, dynamic> json) {
    return EntityGuest(
      id: json['id'] ?? 0,
      guestId: json['guestId'],
      guestUuid: json['guestUuid'],
      first: json['first'],
      last: json['last'],
      dob: json['dob'],
      gender: json['gender'],
      idName: json['idName'],
      idValue: json['idValue'],
      createdOn: json['createdOn'],
      createdBy: json['createdBy'],
      updatedOn: json['updatedOn'],
      hotelUuid: json['hotelUuid'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      nationality: json['nationality'],
      notes: json['notes'],
    );
  }

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
      // Note: 'bookings' is a ToMany relationship and is not typically included in JSON serialization.
      // ObjectBox manages this relation separately. If you need to serialize it,
      // you would need a more complex logic, for example:
      // 'bookings': bookings.map((booking) => booking.toMap()).toList(),
      // But this can lead to circular dependencies if EntityBooking also serializes EntityGuest.
    };
    }
}