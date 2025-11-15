import 'package:objectbox/objectbox.dart';
import 'package:uuid/uuid.dart';

@Entity()
class EntityTax {
  @Id()
  int id = 0;

  String taxName;
  double percentage;

  bool appliesToRoomRate;
  bool appliesToServiceCharge;
  bool isCompound;
  bool isInclusive;
  bool isActive;

  String? validFrom;
  String? validTo;

  String? roomTypes; // "Deluxe,Suite"

  @Unique()
  String taxUuid;

  EntityTax({
    this.id = 0,
    required this.taxName,
    required this.percentage,
    this.appliesToRoomRate = false,
    this.appliesToServiceCharge = false,
    this.isCompound = false,
    this.isInclusive = false,
    this.isActive = true,
    this.validFrom,
    this.validTo,
    this.roomTypes,
    String? taxUuid,
  }) : taxUuid = taxUuid ?? const Uuid().v4();
}
