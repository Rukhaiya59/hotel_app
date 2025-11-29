// import 'package:objectbox/objectbox.dart';
// import 'package:uuid/uuid.dart';
//
// @Entity()
// class EntityInventory {
//   @Id()
//   int id = 0;
//
//   int inventoryId;
//   String inventoryUuid;
//   String hotelUuid;
//   String name;
//   String category;
//   int qty;
//   String unit;
//   double price;
//   int reorderLevel;
//   String supplier;
//   String createdOn;
//   String createdBy;
//   String lastUpdatedOn;
//
//   EntityInventory({
//     this.id = 0,
//     this.inventoryId = 0,
//     String? inventoryUuid,
//     required this.hotelUuid,
//     required this.name,
//     required this.category,
//     required this.qty,
//     required this.unit,
//     required this.price,
//     required this.reorderLevel,
//     required this.supplier,
//     required this.createdOn,
//     required this.createdBy,
//     String? lastUpdatedOn,
//
//   })  : inventoryUuid = inventoryUuid ?? Uuid().v4(),
//         lastUpdatedOn = lastUpdatedOn ?? DateTime.now().toString();
//
//   double get totalValue => qty * price;
//   bool get isLowStock => qty <= reorderLevel;
// }
import 'package:objectbox/objectbox.dart';
import 'package:uuid/uuid.dart';

import 'entity_vendor.dart';

@Entity()
class EntityInventory {
  @Id()
  int id = 0;

  String inventoryUuid;
  String hotelUuid;
  String name;
  String category;
  int qty;
  String unit;
  double price;
  int reorderLevel;
  String supplier;
  String createdOn;
  String createdBy;
  String lastUpdatedOn;
  final vendor = ToOne<Vendor>();

  EntityInventory({
    this.id = 0,
    String? inventoryUuid,
    required this.hotelUuid,
    required this.name,
    required this.category,
    required this.qty,
    required this.unit,
    required this.price,
    required this.reorderLevel,
    required this.supplier,
    required this.createdOn,
    required this.createdBy,
    String? lastUpdatedOn,
  })  : inventoryUuid = inventoryUuid ?? Uuid().v4(),
        lastUpdatedOn = lastUpdatedOn ?? DateTime.now().toString();
}
