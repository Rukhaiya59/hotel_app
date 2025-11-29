import 'package:objectbox/objectbox.dart';

@Entity()
class EntityDiscount {
  @Id()
  int discountId = 0;   // 👈 Your required format

  String title;
  String description;

  String discountType; // percentage, fixed
  double value;

  String? couponCode;
  bool isActive;

  String? roomType;
  int? floor;
  String? roomUuid;
  String? hotelUuid;

  String?guestType;
  String fromDate;
  String toDate;


  EntityDiscount({
    this.discountId = 0,
    required this.title,
    required this.description,
    required this.discountType,
    required this.value,
    this.couponCode,
    this.isActive = true,
    this.roomType,
    this.floor,
    this.roomUuid,
    this.hotelUuid,

    this.guestType,
    required this.fromDate,
    required this.toDate,
  });
}