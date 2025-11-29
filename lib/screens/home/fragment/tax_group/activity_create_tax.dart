import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/model/entity_tax.dart';

import 'controller_create_tax.dart';


class ActivityCreateTax extends StatelessWidget {
  const ActivityCreateTax({super.key});

  @override
  Widget build(BuildContext context) {
    final EntityTax? editTax = Get.arguments as EntityTax?;
    final ControllerCreateTax controller =
    Get.put(ControllerCreateTax(editTax: editTax));

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(editTax == null ? "Add New Tax" : "Edit Tax"),
        centerTitle: true,
        elevation: 0,
      ),

      //  Full screen page, but content center me card ke andar
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔹 TAX DETAILS TITLE
                      Text(
                        "Tax Details",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      /// 🔹 TAX DETAILS CARD
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: controller.nameC,
                                decoration: const InputDecoration(
                                  labelText: "Tax Group Name (e.g., VAT, GST)*",
                                  prefixIcon: Icon(Icons.receipt_long),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: controller.percentC,
                                keyboardType:
                                const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                decoration: const InputDecoration(
                                  labelText: "Tax Percentage (%)*",
                                  prefixIcon: Icon(Icons.percent),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// 🔹 TAX SETTINGS TITLE
                      Text(
                        "Tax Settings",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      /// 🔹 TAX SETTINGS CARD
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Column(
                            children: [
                              Obx(
                                    () => CheckboxListTile(
                                  value: controller.isSgstCgst.value,
                                  onChanged: (v) => controller.isSgstCgst.value =
                                      v ?? false,
                                  title: const Text("Enable SGST / CGST Split"),
                                  controlAffinity:
                                  ListTileControlAffinity.leading,
                                ),
                              ),
                              const Divider(height: 0),

                              Obx(
                                    () => CheckboxListTile(
                                  value: controller.isActive.value,
                                  onChanged: (v) =>
                                  controller.isActive.value = v ?? false,
                                  title: const Text("Tax is Active"),
                                  controlAffinity:
                                  ListTileControlAffinity.leading,
                                ),
                              ),
                              const Divider(height: 0),

                              Obx(
                                    () => CheckboxListTile(
                                  value: controller.isPrintOnBill.value,
                                  onChanged: (v) =>
                                  controller.isPrintOnBill.value =
                                      v ?? false,
                                  title: const Text("Hide Tax Details on Bill"),
                                  controlAffinity:
                                  ListTileControlAffinity.leading,
                                ),
                              ),
                              const Divider(height: 0),

                              Obx(
                                    () => CheckboxListTile(
                                  value: controller.isIncludeInRate.value,
                                  onChanged: (v) =>
                                  controller.isIncludeInRate.value =
                                      v ?? false,
                                  title: const Text("Include in Rate on Bill"),
                                  controlAffinity:
                                  ListTileControlAffinity.leading,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      ///  BOTTOM BUTTONS (CANCEL + SAVE)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Get.back(),
                            child: const Text("Cancel"),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: controller.save,
                            icon: const Icon(Icons.save),
                            label: Text(
                              editTax == null ? "Save Tax" : "Update Tax",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
