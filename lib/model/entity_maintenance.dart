import 'package:objectbox/objectbox.dart';
import 'entity_room.dart';

@Entity()
class EntityMaintenance {
  @Id()
  int maintenanceId = 0;

  String? maintenanceUuid;
  String? roomUuid;
  String? floor;
  String? reason;
  String? startDate;
  String? endDate;
  String? createdOn;
  String? updatedOn;
  String? createdBy;
  String? assignedPersons;
  String? mobilenumber;

  final room = ToOne<EntityRoom>();

  EntityMaintenance({
    this.maintenanceId = 0,
    this.maintenanceUuid,
    this.roomUuid,
    this.floor,
    this.reason,
    this.startDate,
    this.endDate,
    this.createdOn,
    this.updatedOn,
    this.createdBy,
    this.assignedPersons,
    this.mobilenumber,
  });

  Map<String, dynamic> toMap() => {
    'maintenanceId': maintenanceId,
    'maintenanceUuid': maintenanceUuid,
    'roomUuid': roomUuid,
    'floor': floor,
    'reason': reason,
    'startDate': startDate,
    'endDate': endDate,
    'createdOn': createdOn,
    'updatedOn': updatedOn,
    'assignedPersons': assignedPersons,
    'mobilenumber': mobilenumber,
    'createdBy': createdBy,
  };
}