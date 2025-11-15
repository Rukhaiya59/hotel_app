import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';

import '../../../../model/entity_tax.dart';

class ControllerTax extends GetxController {
  late Box<EntityTax> boxTax;
  var taxList = <EntityTax>[].obs;

  @override
  void onInit() {
    boxTax = Get.find<Box<EntityTax>>();
    fetchTaxes();
    super.onInit();
  }

  void fetchTaxes() {
    taxList.value = boxTax.getAll();
  }

  void saveTax(EntityTax tax) {
    boxTax.put(tax);
    fetchTaxes();
  }

  void deleteTax(EntityTax tax) {
    boxTax.remove(tax.id);
    fetchTaxes();
  }
}
