import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/widgets/primary_button.dart';
import '../../../../util/app_color.dart';
import '../../../inventory/activity_inventory.dart';
import 'controller_inventory.dart';

class FragHomeInventory extends StatelessWidget {
  const FragHomeInventory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ControllerInventory controller = Get.put(ControllerInventory());

    return Obx(() {
      final list = controller.filteredInventory;
      final totalItems = list.length;
      final lowStock = list.where((e) => e.qty <= e.reorderLevel).length;
      final totalValue = list.fold<double>(0, (sum, e) => sum + e.price * e.qty);

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => controller.showLowStock.value = false,
                  child: _summaryCard("Total Items", totalItems.toString()),
                ),
                GestureDetector(
                  onTap: () => controller.showLowStock.value = true,
                  child: _summaryCard("Low Stock", lowStock.toString()),
                ),
                GestureDetector(
                  onTap: () => Get.snackbar(
                      "Total Value", "₹${totalValue.toStringAsFixed(2)}"),
                  child: _summaryCard(
                      "Total Value", "₹${totalValue.toStringAsFixed(2)}"),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => controller.searchQuery.value = v,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                return Card(
                  color: item.qty <= item.reorderLevel ? Colors.red[100] : null,
                  margin: const EdgeInsets.all(6),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text(
                        "Qty: ${item.qty} | Price: ₹${item.price} | Total: ₹${(item.qty * item.price).toStringAsFixed(2)}\nCreated By: ${item.createdBy} | On: ${item.createdOn.split(' ')[0]}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              InventoryForm.showEditForm(context, controller, item),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => controller.deleteInventory(item.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PrimaryButton(
                type: ActionType.add,
                color: LightColor.primaryStart,
                onPressed: () =>
                    InventoryForm.showAddForm(context, controller),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _summaryCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(value),
          ],
        ),
      ),
    );
  }
}
