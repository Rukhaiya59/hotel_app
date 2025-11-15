import 'package:objectbox/objectbox.dart';

@Entity()
class EntityPayment {
  @Id()
  int paymentId = 0; // Internal ObjectBox ID

  String paymentUuid; // Unique external reference
  double amount; // Payment amount
  String currency; // e.g., "INR"

  String paymentMode; // "UPI", "CASH", "CARD", "NETBANKING"
  String? transactionId; // Gateway transaction reference
  String hotelUuid;
  String createdAt;

  EntityPayment({
    this.paymentId = 0,
    required this.paymentUuid,
    required this.amount,
    required this.currency,
    required this.paymentMode,
    this.transactionId,
    required this.hotelUuid,
    required this.createdAt,
  });

  // fromJson factory constructor
  factory EntityPayment.fromJson(Map<String, dynamic> json) {
    return EntityPayment(
      paymentId: json['paymentId'] ?? 0,
      paymentUuid: json['paymentUuid'],
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'],
      paymentMode: json['paymentMode'],
      transactionId: json['transactionId'],
      hotelUuid: json['hotelUuid'],
      createdAt: json['createdAt'],
    );
  }


  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'paymentId': paymentId,
      'paymentUuid': paymentUuid,
      'amount': amount,
      'currency': currency,
      'paymentMode': paymentMode,
      'transactionId': transactionId,
      'hotelUuid': hotelUuid,
      'createdAt': createdAt,
    };
  }}