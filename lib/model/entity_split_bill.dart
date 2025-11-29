import 'package:objectbox/objectbox.dart';

@Entity()
class EntitySplitBill {
  int id = 0;

  String? type; // facility / guest / percentage
  String? label; // "Room Charges", "Laundry", "Guest 1", etc.
  double amount = 0.0;

  EntitySplitBill({
    this.type,
    this.label,
    required this.amount,
  });
}
