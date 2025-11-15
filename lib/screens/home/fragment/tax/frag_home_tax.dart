import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller_hotel_tax.dart';
import '../../../tax/tax.dart'; // <-- your TaxForm path, keep as is

class FragmentTax extends StatelessWidget {
  const FragmentTax({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ControllerTax());
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Taxes"),
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
      ),

      body: Obx(() {
        if (controller.taxList.isEmpty) {
          return Center(
            child: Text(
              "No Taxes Found",
              style: theme.textTheme.titleMedium,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.taxList.length,
          itemBuilder: (_, i) {
            final tax = controller.taxList[i];

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text("${tax.taxName} (${tax.percentage}%)"),
                subtitle: Text(
                  "${tax.appliesToRoomRate ? 'Room ' : ''}"
                      "${tax.appliesToServiceCharge ? 'Service ' : ''}",
                ),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Get.to(() => TaxForm(editTax: tax));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        controller.deleteTax(tax);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const TaxForm()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
