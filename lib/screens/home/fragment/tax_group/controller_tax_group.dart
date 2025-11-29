import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';
import 'package:hotel/model/entity_tax.dart';
import 'package:hotel/service/service_object_box.dart';

import '../../../../util/snackbar_util.dart';

class ControllerTaxGroup extends GetxController {
  final rxTaxList = <EntityTax>[].obs;
  late final Box<EntityTax> boxTax;

  Rx<EntityTax?> selectedTax = Rx<EntityTax?>(null);

  final tax = ToOne<EntityTax>();

  @override
  void onInit() {
    super.onInit();
    boxTax = Get.find<ServiceObjectBox>().box<EntityTax>();
    fetchAll();
  }

  void openCreate() {
    selectedTax.value = null;
  }

  void openEdit(EntityTax tax) {
    selectedTax.value = tax;
  }

  void closeForm() {
    selectedTax.value = null;
  }


  void fetchAll() {
    rxTaxList.assignAll(boxTax.getAll());
  }

  void deleteTax(EntityTax tax) {
    if (tax.id != 0) {
      boxTax.remove(tax.id);
      fetchAll();
      SnackbarUtil.showSuccess("Tax deleted successfully");
    }
  }

  EntityTax? getByUuid(String? uuid) {
    if (uuid == null) return null;
    return rxTaxList.firstWhereOrNull((t) => t.taxUuid == uuid);
  }
}
