import 'package:objectbox/objectbox.dart';

@Entity()
class EntityAmenities{
  @Id()
  int amenitiesId = 0;

  String? amenitiesUuid;
  String? hotelUuid;
  String? name;
  double? price;
  int? qty;
  String? description;
  String? createdOn;
  String? updatedOn;
  String? createdBy;

  EntityAmenities({
    this.amenitiesId = 0,
    this.amenitiesUuid,
    this.hotelUuid,
    this.name,
    this.price,
    this.qty,
    this.description,
    this.createdOn,
    this.updatedOn,
    this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'amenitiesId': amenitiesId,
      'amenitiesUuid': amenitiesUuid,
      'hotelUuid': hotelUuid,
      'name': name,
      'price': price,
      'qty': qty,
      'description': description,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
      'createdBy': createdBy,
    };
  }

  factory EntityAmenities.fromJson(Map<String, dynamic> map) {
    return EntityAmenities(
      amenitiesId: map['amenitiesId']?.toInt() ?? 0,
      amenitiesUuid: map['amenitiesUuid'],
      hotelUuid: map['hotelUuid'],
      name: map['name'],
      price: map['price']?.toDouble(),
      qty: map['qty']?.toInt(),
      description: map['description'],
      createdOn: map['createdOn'],
      updatedOn: map['updatedOn'],
      createdBy: map['createdBy'],
    );
  }
}
