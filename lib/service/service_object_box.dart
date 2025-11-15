import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';
import '../objectbox.g.dart';

class ServiceObjectBox extends GetxService {
  late final Store store;

  Future<ServiceObjectBox> init() async {
    store = Store(getObjectBoxModel(), directory: "hotel");

    return this;
  }

  Box<T> box<T>() => store.box<T>();

  @override
  void onClose() {
    store.close();
    super.onClose();
  }
}
