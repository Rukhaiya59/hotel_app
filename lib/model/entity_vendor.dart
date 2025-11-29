import 'package:objectbox/objectbox.dart';

@Entity()
class Vendor {
  int id;

  String name;
  String? categoryName;
  String? phone;
  String? companyName;
  double? defaultPrice; // ✅ ADD THIS


  Vendor({
    this.id = 0,
    required this.name,
    this.categoryName,
    this.phone,
    this.companyName,
  });
}
