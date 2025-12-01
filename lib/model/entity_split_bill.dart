import 'package:objectbox/objectbox.dart';

@Entity()
class EntitySplitBill {
  int id = 0;

  String? hotelUuid;     // ✅ which hotel this split belongs to
  String? bookingUuid;  // ✅ kis booking ka split
  String? guestUuid;    // ✅ kis guest ka hissa
  String? type;         // guest / facility / percent
  String? label;        // Guest Name / Facility Name
  double amount = 0.0;
  String? paymentMode;
  String? transactionId;   //  NEW FIELD
  String? createdAt;   //

  EntitySplitBill({
    this.hotelUuid,
    this.bookingUuid,
    this.guestUuid,
    this.type,
    this.label,
    this.paymentMode,
    this.transactionId,   // ✅ NEW
    this.createdAt,
    required this.amount,
  });
}
