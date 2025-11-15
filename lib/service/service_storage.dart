import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ServiceStorage extends GetxService {
  late final GetStorage _box;

  Future<ServiceStorage> init() async {
    _box = GetStorage();
    /*
  final dir = await getApplicationDocumentsDirectory();
  String fileName = 'GetStorage';
  final _file = File('${dir.path}/$fileName.bak');
  debugPrint(_file.path);
    * */
    return this;
  }

  T? read<T>(String key) => _box.read<T>(key);

  Future<void> write(String key, dynamic value) => _box.write(key, value);

  Future<void> remove(String key) => _box.remove(key);

  Future<void> clear() => _box.erase();
}
