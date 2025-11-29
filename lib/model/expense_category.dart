import 'package:objectbox/objectbox.dart';

@Entity()
class ExpenseCategory {
  int id;
  String name;

  ExpenseCategory({this.id = 0, required this.name});
}
