import 'package:objectbox/objectbox.dart';

@Entity()
class EntityTask {
  int id;
  String title;
  String description;
  String timeRequired;
  String assignedToUuid;
  String assignedToName;

  DateTime createdAt;
  EntityTask({
    this.id = 0,
    required this.title,
    required this.description,
    required this.timeRequired,
    required this.assignedToUuid,
    required this.assignedToName,
    required this.createdAt,
  });
}
