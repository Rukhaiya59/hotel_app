import '../../service/service_object_box.dart';
import '../model/entity_vendor.dart';

class VendorService {
  final ServiceObjectBox obx;

  VendorService(this.obx);

  List<Vendor> getVendors() => obx.box<Vendor>().getAll();

  int addVendor(Vendor v) => obx.box<Vendor>().put(v);

  void deleteVendor(int id) => obx.box<Vendor>().remove(id);

  // ✅ NEW: PERMANENT DELETE ALL VENDORS
  void deleteAllVendors() {
    obx.box<Vendor>().removeAll();
  }
}
