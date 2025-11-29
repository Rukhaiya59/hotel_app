import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import '../objectbox.g.dart';
//
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
// class ServiceObjectBox extends GetxService {
//   late final Store store;
//
//   Future<ServiceObjectBox> init() async {
//     final dir = await getApplicationDocumentsDirectory();
//     final dbPath = '${dir.path}/hotel_db';
//
//     if (Store.isOpen(dbPath)) {
//       store = Store.attach(getObjectBoxModel(), dbPath);
//     } else {
//       store = Store(
//         getObjectBoxModel(),
//         directory: dbPath,
//       );
//     }
//
//     return this;
//   }
//
//   Box<T> box<T>() => store.box<T>();
//
//   @override
//   void onClose() {
//     // DO NOT CLOSE AUTOMATICALLY — prevent hot-reload crashes
//     // store.close();
//     super.onClose();
//   }
// }
