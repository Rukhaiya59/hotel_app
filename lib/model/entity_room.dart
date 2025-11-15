import 'package:objectbox/objectbox.dart';
import 'entity_amenities.dart';

@Entity()
class EntityRoom {
  @Id()
  int roomId = 0;

  String? roomUuid;
  String? hotelUuid;
  String? bookingUuid;
  String? number;
  String? floor;
  String? status;
  String? type;
  String? bedType;
  String? roomType;
  double? price;
  int? capacity;
  String? currency;
  String? createdOn;
  String? updatedOn;
  String? createdBy;

  // ✅ New field for storing facilities (as JSON)
  String? facilitiesJson;

  // Relationship
  final amenities = ToMany<EntityAmenities>();

  EntityRoom({
    this.roomId = 0,
    this.roomUuid,
    this.hotelUuid,
    this.bookingUuid,
    this.number,
    this.floor,
    this.status,
    this.type,
    this.bedType,
    this.roomType,
    this.price,
    this.capacity,
    this.currency,
    this.createdOn,
    this.updatedOn,
    this.createdBy,
    this.facilitiesJson, // 👈 include here
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'roomUuid': roomUuid,
      'hotelUuid': hotelUuid,
      'bookingUuid': bookingUuid,
      'number': number,
      'floor': floor,
      'status': status,
      'type': type,
      'bedType': bedType,
      'roomType': roomType,
      'price': price,
      'capacity': capacity,
      'currency': currency,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
      'createdBy': createdBy,
      'facilitiesJson': facilitiesJson ?? '[]', // 👈 safe default
    };
  }

  factory EntityRoom.fromJson(Map<String, dynamic> json) {
    final room = EntityRoom(
      roomId: json['roomId'] ?? 0,
      roomUuid: json['roomUuid'],
      hotelUuid: json['hotelUuid'],
      bookingUuid: json['bookingUuid'],
      number: json['number'],
      floor: json['floor'],
      status: json['status'],
      type: json['type'],
      bedType: json['bedType'],
      roomType: json['roomType'],
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : json['price']?.toDouble(),
      capacity: json['capacity'],
      currency: json['currency'],
      createdOn: json['createdOn'],
      updatedOn: json['updatedOn'],
      createdBy: json['createdBy'],
      facilitiesJson: json['facilitiesJson'] ?? '[]', // 👈 load JSON safely
    );

    if (json['amenities'] != null && json['amenities'] is List) {
      final amenitiesList = (json['amenities'] as List)
          .map((a) =>
          EntityAmenities.fromJson(a as Map<String, dynamic>))
          .toList();
      room.amenities.addAll(amenitiesList);
    }
    return room;
  }
}