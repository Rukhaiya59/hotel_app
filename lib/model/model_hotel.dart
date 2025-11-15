import 'package:hotel/model/model_address.dart';

class ModelHotel {
  final String hotelUuid;
  final String name;
  final ModelAddress address;
  final String photo;
  final String mobile;
  final String email;

  ModelHotel({
    required this.hotelUuid,
    required this.name,
    required this.address,
    required this.photo,
    required this.mobile,
    required this.email,
  });

  factory ModelHotel.fromJson(Map<String, dynamic> json) {
    return ModelHotel(
      hotelUuid: json['hotelUuid'],
      name: json['name'],
      address: ModelAddress.fromJson(json['address']),
      photo: json['photo'],
      mobile: json['mobile'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hotelUuid': hotelUuid,
      'name': name,
      'address': address.toMap(),
      'photo': photo,
      'mobile': mobile,
      'email': email,
    };
  }
}
