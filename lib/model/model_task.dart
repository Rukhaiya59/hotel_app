import 'package:objectbox/objectbox.dart';
import 'entity_room.dart';
import 'entity_booking.dart';

@Entity()
class EntityTask {
  @Id()
  int id = 0;

  String taskType;      // e.g. "maintenance", "cleaning_checkout"
  String status;        // e.g. "pending", "done"
  String createdAt;

  String? scheduledAt;    // when cleaning should happen
  String? completedAt;
  // maintenance fields
  String? reason;
  String? startDate;    // ISO string
  String? endDate;      // ISO string
  String? assignedPerson;
  String? mobileNumber;

  // expense fields
  double? expenseAmount;
  String? expenseNote;


  // relations
  final room = ToOne<EntityRoom>();
  final booking = ToOne<EntityBooking>();

  // constructor with named parameters - IMPORTANT: include all fields you will set
  EntityTask({
    this.id = 0,
    required this.taskType,
    this.status = 'pending',
    String? createdAt,
    this.scheduledAt,
    this.completedAt,
    this.reason,
    this.startDate,
    this.endDate,
    this.assignedPerson,
    this.mobileNumber,
    this.expenseAmount,
    this.expenseNote

  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();
}
