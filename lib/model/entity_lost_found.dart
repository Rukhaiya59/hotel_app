import 'package:objectbox/objectbox.dart';

@Entity()
class EntityFoundItem {
  @Id()
  int id = 0;

  String name;
  String location;
  String customerDetail;
  String dateFound;
  String status;
  String? hotelUuid;


  EntityFoundItem({
    this.id = 0,
    required this.name,
    required this.location,
    required this.customerDetail,
    required this.dateFound,
    required this.status
  });
}
