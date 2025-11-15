class ModelAddress {
  final int id;
  final String addrUuid;
  final String hotelUuid;
  final String addr1;
  final String addr2;
  final String state;
  final String city;
  final String country;
  final String pinCode;

  ModelAddress({
    required this.id,
    required this.addrUuid,
    required this.hotelUuid,
    required this.addr1,
    required this.addr2,
    required this.state,
    required this.city,
    required this.country,
    required this.pinCode,
  });

  factory ModelAddress.fromJson(Map<String, dynamic> json) {
    return ModelAddress(
      id: json['id'],
      addrUuid: json['addrUuid'],
      hotelUuid: json['hotelUuid'],
      addr1: json['addr1'],
      addr2: json['addr2'],
      state: json['state'],
      city: json['city'],
      country: json['country'],
      pinCode: json['pinCode'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'addrUuid': addrUuid,
      'hotelUuid': hotelUuid,
      'addr1': addr1,
      'addr2': addr2,
      'state': state,
      'city': city,
      'country': country,
      'pinCode': pinCode,
    };
  }
}
