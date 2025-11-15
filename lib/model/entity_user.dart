import 'package:objectbox/objectbox.dart';
import 'entity_key_value.dart';

@Entity()
class EntityUser {
  @Id()
  int id = 0;
  String userUuid;
  String hotelUuid;

  String? first;
  String? middle;
  String? last;
  String? mobile;
  String? mobile2;
  String? username;
  String? email;
  String? password;
  String? role;
  String? employeeId;
  List<String>? department;
  String? profilePhoto;

  ToMany<EntityKeyValue> listDoc = ToMany();

  EntityUser({
    this.id = 0,
    required this.userUuid,
    required this.hotelUuid,
    this.first,
    this.middle,
    this.last,
    this.mobile,
    this.mobile2,
    this.username,
    this.email,
    this.password,
    this.role,
    this.employeeId,
    this.department,
    this.profilePhoto,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userUuid': userUuid,
      'hotelUuid': hotelUuid,
      'first': first,
      'middle': middle,
      'last': last,
      'mobile': mobile,
      'mobile2': mobile2,
      'username': username,
      'email': email,
      'password': password,
      'role': role,
      'employeeId': employeeId,
      'department': department,
      'profilePhoto': profilePhoto,
    };
  }

  factory EntityUser.fromJson(Map<String, dynamic> json) {
    return EntityUser(
        id: json['id'] ?? 0,
        userUuid: json['userUuid'] ?? '',
        hotelUuid: json['hotelUuid'] ?? '',
        first: json['first'],
        middle: json['middle'],
        last: json['last'],
        mobile: json['mobile'],
        mobile2: json['mobile2'],
        username: json['username'],
        email: json['email'],
        password: json['password'],
        role: json['role'],
        employeeId: json['employeeId'],
        department: json['department'] != null
            ? List<String>.from(json['department'])
            : null,
        profilePhoto: json['profilePhoto'],
      )
      ..listDoc.addAll(
        json['listDoc'] != null
            ? (json['listDoc'] as List)
                  .map(
                    (i) => EntityKeyValue.fromJson(i as Map<String, dynamic>),
                  )
                  .toList()
            : [],
      );
  }
}
