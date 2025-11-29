import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

import '../model/entity_inventory.dart';
import '../repository/repo_get_storage.dart';
import '../service/service_object_box.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class ControllerInventorys extends GetxController {
  late final Box<EntityInventory> box;
  final obj = Get.find<ServiceObjectBox>();
  final repo = Get.find<RepoGetStorage>();

  var all = <EntityInventory>[].obs;
  var filtered = <EntityInventory>[].obs;

  var hotelUuid = '';

  // filters
  var search = ''.obs;
  var showOnlyLowStock = false.obs;

  // summary
  var totalItems = 0.obs;
  var lowStockItems = 0.obs;
  var totalValue = 0.0.obs;

  final dfDisplay = DateFormat('dd/MM/yyyy');

  @override
  void onInit() {
    super.onInit();
    box = obj.box<EntityInventory>();
    hotelUuid = repo.getHotelUuid() ?? '';
    load();
  }

  void load() {
    all.value = box
        .getAll()
        .where((e) => e.hotelUuid == hotelUuid || hotelUuid.isEmpty)
        .toList();
    _applyFilters();
  }

  // ---------------- FILTERS ----------------

  void applySearch(String text) {
    search.value = text;
    _applyFilters();
  }

  void toggleLowStock(bool v) {
    showOnlyLowStock.value = v;
    _applyFilters();
  }

  void _applyFilters() {
    List<EntityInventory> data = List.from(all);

    if (showOnlyLowStock.value) {
      data = data.where((e) => e.qty <= e.reorderLevel).toList();
    }

    if (search.value.isNotEmpty) {
      final t = search.value.toLowerCase();
      data = data
          .where((e) =>
      e.name.toLowerCase().contains(t) ||
          e.category.toLowerCase().contains(t) ||
          e.supplier.toLowerCase().contains(t))
          .toList();
    }

    filtered.value = data;
    _summary();
  }

  // ---------------- SUMMARY ----------------

  void _summary() {
    totalItems.value = filtered.length;
    lowStockItems.value =
        filtered.where((e) => e.qty <= e.reorderLevel).length;
    double tv = 0;
    for (final e in filtered) {
      tv += (e.qty * e.price);
    }
    totalValue.value = tv;
  }

  String fmtDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      return dfDisplay.format(dt);
    } catch (_) {
      return raw;
    }
  }

  // ---------------- PDF EXPORT ----------------

  Future<void> exportPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) {
          return [
            pw.Center(
              child: pw.Text(
                "Inventory Report",
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 15),

            pw.Text(
              "Summary",
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text("Total Items: ${totalItems.value}"),
            pw.Text("Low Stock Items: ${lowStockItems.value}"),
            pw.Text(
              "Total Inventory Value: ${totalValue.value.toStringAsFixed(2)}",
            ),

            pw.SizedBox(height: 18),
            pw.Divider(),
            pw.SizedBox(height: 8),

            pw.Text(
              "Detailed Inventory List",
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),

            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
              headers: [
                "Name",
                "Category",
                "Qty",
                "Unit",
                "Price",
                "Total",
                "Supplier",
                "Updated",
              ],
              data: filtered.map((e) {
                final total = e.qty * e.price;
                return [
                  e.name,
                  e.category,
                  e.qty.toString(),
                  e.unit,
                  e.price.toStringAsFixed(2),
                  total.toStringAsFixed(2),
                  e.supplier,
                  fmtDate(e.lastUpdatedOn),
                ];
              }).toList(),
            ),
          ];
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: "inventory_report.pdf",
    );
  }
}
