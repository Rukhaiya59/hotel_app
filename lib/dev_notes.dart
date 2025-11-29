/*
dart run build_runner build --delete-conflicting-outputs
import 'package:mongo_dart/mongo_dart.dart' as mongo;
mongo_dart: ^0.10.5
uuid: mongo.ObjectId().oid;

final query = _boxUser
  .query(EntityUser_.username.equals(email) & EntityUser_.password.equals(password))
  .build();
final user = query.findFirst();
if (user == null) { /invalid credential/ }

get hotelUuid, branchUuids
final RepoGetStorage _repoGetStorage = Get.find();
_repoGetStorage.getHotelUuid()

decoration: BoxDecoration(gradient: AppTheme.gradient(isDark: themeService.isDarkMode))
    final query = boxUser.query(EntityUser_.role.equals("Housekeeping")).build();
    rxUsers.value = query.find();

*/