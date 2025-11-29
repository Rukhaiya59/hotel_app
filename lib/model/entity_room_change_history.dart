import 'package:objectbox/objectbox.dart';

@Entity()
class EntityRoomChangeHistory {
  @Id()
  int id = 0;

  int bookingId;

  String oldRoomNo;
  String newRoomNo;

  String oldRoomCheckIn;
  String oldRoomCheckOut;

  String newRoomCheckIn;
  String? newRoomCheckOut;

  String reason;
  String changedAt;

  EntityRoomChangeHistory({
    this.id = 0,
    required this.bookingId,
    required this.oldRoomNo,
    required this.newRoomNo,
    required this.oldRoomCheckIn,
    required this.oldRoomCheckOut,
    required this.newRoomCheckIn,
    this.newRoomCheckOut,
    required this.reason,
    required this.changedAt,
  });
}
