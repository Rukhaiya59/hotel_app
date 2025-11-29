import 'package:objectbox/objectbox.dart';

import 'entity_booking.dart';
import 'entity_room.dart';
import 'entity_user.dart';

@Entity()
class EntityCleaningTask {
  int id;

  /// pending | done
  String status;

  /// stayover | checkout | manual
  String type;

  DateTime createdAt;
  DateTime? completedAt;

  /// Room linked with this cleaning task
  final room = ToOne<EntityRoom>();

  /// Optional booking (for checkout cleaning)
  final booking = ToOne<EntityBooking>();

  /// Which housekeeping user is assigned
  final user = ToOne<EntityUser>();

  EntityCleaningTask({
    this.id = 0,
    this.status = "pending",
    this.type = "stayover",
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
