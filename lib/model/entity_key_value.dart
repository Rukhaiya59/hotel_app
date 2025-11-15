import 'package:objectbox/objectbox.dart';

@Entity()
class EntityKeyValue {
  @Id()
  int keyValueId;
  String keyValueUuid;

  String? name;
  String? value;

  EntityKeyValue({
    this.keyValueId = 0,
    required this.keyValueUuid,
    this.name,
    this.value,
  });

  factory EntityKeyValue.fromJson(Map<String, dynamic> json) => EntityKeyValue(
        keyValueId: json["keyValueId"] ?? 0,
        keyValueUuid: json["keyValueUuid"],
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toMap() => {
        "keyValueUuid": keyValueUuid,
        "name": name,
        "value": value,
      };
}
