import 'package:objectbox/objectbox.dart';

@Entity()
class EntityAddress {
  @Id()
  int id = 0;
  String addrUuid;
  String hotelUuid;

  String addr1;
  String addr2;
  String state;
  String city;
  String country;
  String pinCode;

  EntityAddress({
    this.id = 0,
    required this.addrUuid,
    required this.hotelUuid,
    required this.addr1,
    required this.addr2,
    required this.state,
    required this.city,
    required this.country,
    required this.pinCode,
  });

  factory EntityAddress.fromJson(Map<String, dynamic> json) => EntityAddress(
    addrUuid: json["addrUuid"],
    hotelUuid: json["hotelUuid"],
    addr1: json["addr1"],
    addr2: json["addr2"],
    state: json["state"],
    city: json["city"],
    country: json["country"],
    pinCode: json["pinCode"],
  );

  Map<String, dynamic> toMap() => {
    "addrUuid": addrUuid,
    "hotelUuid": hotelUuid,
    "addr1": addr1,
    "addr2": addr2,
    "state": state,
    "city": city,
    "country": country,
    "pinCode": pinCode,
  };
}
