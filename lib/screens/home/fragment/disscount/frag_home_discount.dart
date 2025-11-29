import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/model/entity_discount.dart';
import 'activity_add_disscount.dart';
import 'controller_discount.dart';

class FragHomeDiscount extends StatelessWidget {
  const FragHomeDiscount({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DiscountController());

    return Obx(() {
      if (controller.allDiscounts.isEmpty) {
        return const Center(child: Text("No Discounts Found"));
      }

      return ListView.builder(
        itemCount: controller.allDiscounts.length,
        itemBuilder: (_, index) {
          final d = controller.allDiscounts[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// LEFT TEXT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          d.description,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text("Type: ${d.discountType} | Value: ${d.value}"),
                        Text("Room: ${d.roomType ?? "All"} | Guest: ${d.guestType ?? "All"}"),
                        Text("Date: ${d.fromDate} → ${d.toDate}"),
                      ],
                    ),
                  ),

                  /// RIGHT ACTIONS
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (_) => ActivityAddDiscount(editDiscount: d),
                          );
                          controller.fetch();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _showDeleteConfirm(context, controller, d),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );

        },
      );
    });
  }

  /// ✅ DELETE CONFIRMATION DIALOG
  void _showDeleteConfirm(BuildContext context,
      DiscountController controller,
      EntityDiscount discount,) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Discount"),
        content: const Text("Are you sure you want to delete this discount?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("No")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              controller.delete(discount);
              Get.back();
            },
            child: const Text("Yes, Delete"),
          ),
        ],
      ),
    );

  }
}
