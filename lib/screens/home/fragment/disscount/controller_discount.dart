import 'package:get/get.dart';
import 'package:hotel/objectbox.g.dart';
import 'package:hotel/service/service_object_box.dart';
import 'package:hotel/model/entity_discount.dart';

class DiscountController extends GetxController {
  late Box<EntityDiscount> discountBox;

  final RxList<EntityDiscount> allDiscounts = <EntityDiscount>[].obs;

  @override
  void onInit() {
    super.onInit();
    final store = Get.find<ServiceObjectBox>().store;
    discountBox = store.box<EntityDiscount>();
    fetch();
  }

  /// ✅ FETCH FROM DB
  void fetch() {
    final data = discountBox.getAll();
    allDiscounts.assignAll(data);
  }

  /// ✅ ADD + AUTO REFRESH
  void addDiscount(EntityDiscount discount) {
    discountBox.put(discount);
    fetch(); //  VERY IMPORTANT
  }

  /// ✅ DELETE + AUTO REFRESH
  void delete(EntityDiscount discount) {
    discountBox.remove(discount.discountId);
    fetch(); // 🔥 VERY IMPORTANT
  }

  /// ✅ UPDATE + AUTO REFRESH
  void updateDiscount(EntityDiscount discount) {
    discountBox.put(discount);
    fetch(); // VERY IMPORTANT
  }
}
