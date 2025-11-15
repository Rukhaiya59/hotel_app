import 'package:get/get.dart';
import '../../../../model/entity_lost_found.dart';
import '../../../../service/service_object_box.dart';

class ControllerLostAndFound extends GetxController {
  final boxFoundItem = Get.find<ServiceObjectBox>().box<EntityFoundItem>();
  RxList<EntityFoundItem> rxListFoundItems = <EntityFoundItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFoundItems();
  }

  Future<void> loadFoundItems() async{
    rxListFoundItems.value = boxFoundItem.getAll();
  }

  Future<void> addFoundItem(EntityFoundItem item)async {
    boxFoundItem.put(item);
    loadFoundItems();
  }

  Future<void> updateStatus(EntityFoundItem item, String status)async {
    item.status = status;
    boxFoundItem.put(item);
    loadFoundItems();
  }

  Future<void> deleteItem(EntityFoundItem item) async{
    boxFoundItem.remove(item.id);
    loadFoundItems();
  }
}

