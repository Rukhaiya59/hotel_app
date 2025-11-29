import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/service/service_currency.dart';

import '../../../../reports/controller_inventorys.dart';

class FragHomeInventorys extends StatelessWidget {
  const FragHomeInventorys({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ControllerInventorys());
    final currencyService = Get.find<ServiceCurrency>();
    final symbol = currencyService.symbol;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TopFilterBar(controller: ctrl),
          const SizedBox(height: 12),
          _SummaryRow(controller: ctrl, symbol: symbol),
          const SizedBox(height: 12),
          Expanded(
            child: Obx(() {
              final list = ctrl.filtered;
              if (list.isEmpty) {
                return const Center(child: Text("No inventory records"));
              }

              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final e = list[i];
                  final total = e.qty * e.price;
                  final isLow = e.qty <= e.reorderLevel;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: isLow ? Colors.red.shade50 : null,
                    child: ListTile(
                      title: Text(
                        e.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Category: ${e.category}  |  Supplier: ${e.supplier}",
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Qty: ${e.qty} ${e.unit}  |  Reorder @ ${e.reorderLevel}",
                            style: TextStyle(
                              fontSize: 12,
                              color: isLow ? Colors.red : Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Price: $symbol${e.price.toStringAsFixed(2)}  |  Total: $symbol${total.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Created By: ${e.createdBy}",
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ---------------- TOP FILTER BAR ----------------

class _TopFilterBar extends StatelessWidget {
  final ControllerInventorys controller;

  const _TopFilterBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // 🔍 Search
            Expanded(
              flex: 2,
              child: TextField(
                onChanged: controller.applySearch,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search item, category, supplier...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Low stock filter
            Obx(
                  () => Row(
                children: [
                  const Text(
                    "Low Stock",
                    style: TextStyle(fontSize: 12),
                  ),
                  Switch(
                    value: controller.showOnlyLowStock.value,
                    onChanged: controller.toggleLowStock,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Export PDF
            ElevatedButton.icon(
              onPressed: controller.exportPdf,
              icon: const Icon(Icons.picture_as_pdf, size: 18),
              label: const Text("Export"),
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final ControllerInventorys controller;
  final String symbol;

  const _SummaryRow({
    required this.controller,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Row(
        children: [
          _box("Items", controller.totalItems.value.toString()),
          const SizedBox(width: 8),
          _box("Low Stock", controller.lowStockItems.value.toString()),
          const SizedBox(width: 8),
          _box(
            "Total Value",
            "$symbol${controller.totalValue.value.toStringAsFixed(2)}",
          ),
        ],
      ),
    );
  }

  Widget _box(String title, String value) {
    return Expanded(
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
