import 'package:objectbox/objectbox.dart';
import 'package:uuid/uuid.dart';

@Entity()
class EntityTax {
  @Id()
  int id;

  /// Tax group name (VAT, GST, Room Tax, Service Tax)
  String taxProductName;

  /// Percentage value (e.g., 5, 9, 12, 18)
  double taxPercentage;

  /// True → Split into SGST + CGST (50/50)
  bool isSgstCgst;

  /// True → Tax is active
  bool isActive;

  /// True → Hide tax detail on printed bill
  bool isHideTaxDetail;

  /// True → Price already includes tax (inclusive tax)
  bool isIncludeInRate;

  /// True → Print tax on bill
  bool isPrintOnBill;

  /// Unique UUID for syncing / linking
  @Unique()
  String taxUuid;

  /// MongoDB sync support
  String? mongoId;

  /// Whether synced to cloud
  bool isSync;

  EntityTax({
    this.id = 0,
    required this.taxProductName,
    required this.taxPercentage,
    this.isSgstCgst = false,
    this.isActive = true,
    this.isHideTaxDetail = false,
    this.isIncludeInRate = false,
    this.isPrintOnBill = true,
    String? taxUuid,
    this.mongoId,
    this.isSync = false,
  }) : taxUuid = taxUuid ?? const Uuid().v4();

  // Convert to JSON (for cloud sync)
  Map<String, dynamic> toJson() => {
    "id": id,
    "taxUuid": taxUuid,
    "taxProductName": taxProductName,
    "taxPercentage": taxPercentage,
    "isSgstCgst": isSgstCgst,
    "isActive": isActive,
    "isHideTaxDetail": isHideTaxDetail,
    "isIncludeInRate": isIncludeInRate,
    "isPrintOnBill": isPrintOnBill,
    "mongoId": mongoId,
    "isSync": isSync,
  };

  // Load from JSON
  factory EntityTax.fromJson(Map<String, dynamic> json) {
    return EntityTax(
      id: json["id"] ?? 0,
      taxProductName: json["taxProductName"] ?? "",
      taxPercentage: (json["taxPercentage"] is int)
          ? (json["taxPercentage"] as int).toDouble()
          : json["taxPercentage"]?.toDouble() ?? 0.0,
      isSgstCgst: json["isSgstCgst"] ?? false,
      isActive: json["isActive"] ?? true,
      isHideTaxDetail: json["isHideTaxDetail"] ?? false,
      isIncludeInRate: json["isIncludeInRate"] ?? false,
      isPrintOnBill: json["isPrintOnBill"] ?? true,
      taxUuid: json["taxUuid"],
      mongoId: json["mongoId"],
      isSync: json["isSync"] ?? false,
    );
  }
}
