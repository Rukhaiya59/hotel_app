import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';
import '../../../../model/entity_inventory.dart';
import '../../../../repository/repo_get_storage.dart';
import '../../../../service/service_object_box.dart';

class ControllerInventory extends GetxController {
  late Box<EntityInventory> boxInventory;
  RxList<EntityInventory> inventoryList = <EntityInventory>[].obs;
  var searchQuery = "".obs;
  String hotelUuid = "";
  var showLowStock = false.obs;
  final RepoGetStorage _repoGetStorage = Get.find();

  @override
  void onInit() {
    super.onInit();
    hotelUuid = _repoGetStorage.getHotelUuid() ?? "";
    boxInventory = Get.find<ServiceObjectBox>().box<EntityInventory>();
    loadInventory();
  }

  void loadInventory() {
    inventoryList.value =
        boxInventory.getAll().where((e) => e.hotelUuid == hotelUuid).toList();
  }

  List<EntityInventory> get filteredInventory {
    List<EntityInventory> list = showLowStock.value
        ? inventoryList.where((e) => e.qty <= e.reorderLevel).toList()
        : inventoryList;

    if (searchQuery.value.isEmpty) return list;

    return list
        .where(
          (e) =>
      e.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          e.category.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          e.supplier.toLowerCase().contains(searchQuery.value.toLowerCase()),
    )
        .toList();
  }

  void addInventory(EntityInventory item) {
    item.hotelUuid = hotelUuid;
    item.createdOn = DateTime.now().toString();
    boxInventory.put(item);
    loadInventory();
  }

  void editInventory(EntityInventory item) {
    item.lastUpdatedOn = DateTime.now().toString();
    boxInventory.put(item);
    loadInventory();
  }

  void deleteInventory(int id) {
    boxInventory.remove(id);
    loadInventory();
  }
}
