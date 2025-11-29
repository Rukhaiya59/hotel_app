import 'package:objectbox/objectbox.dart';

import 'entity_vendor.dart';
import 'expense_category.dart';

@Entity()
class Expense {
  int id;
  String description;
  double amount;
  String date;
  String paymentType;
  bool isRefundable;
  String? hotelUuid;

  // RELATIONS
  final vendor = ToOne<Vendor>();
  final category = ToOne<ExpenseCategory>();

  Expense({
    this.id = 0,
    required this.description,
    required this.amount,
    required this.date,

    required this.paymentType,
    this.isRefundable = true,
    this.hotelUuid,
  });
}
