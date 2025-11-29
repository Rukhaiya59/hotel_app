import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/model/entity_tax.dart';

import '../../../../../../../util/app_route.dart';
import 'controller_tax_group.dart';

class FragHomeTaxGroup extends StatelessWidget {
  const FragHomeTaxGroup({super.key});

  static const double _wideScreenBreakpoint = 600.0;

  @override
  Widget build(BuildContext context) {
    final ControllerTaxGroup controller = Get.put(ControllerTaxGroup());
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tax Groups",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Obx(() {
            if (controller.rxTaxList.isEmpty) {
              return _buildEmpty(theme);
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > _wideScreenBreakpoint) {
                  return _buildTable(controller, theme);
                } else {
                  return _buildList(controller, theme);
                }
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildEmpty(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 90,
            color: theme.disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            "No tax groups found",
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.disabledColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tap + button to add a tax group.",
            style: TextStyle(color: theme.disabledColor),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(ControllerTaxGroup controller, ThemeData theme) {
    return Align(
      alignment: Alignment.topLeft, // ✅ upar-left se start
      child: Container(
        width: double.infinity,      // ✅ card poori screen width (content area)
        margin: const EdgeInsets.only(right: 16), // optional right gap
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.dividerColor.withOpacity(0.4)),
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: double.infinity,  // ✅ header row bhi full width
            child: DataTable(
              headingRowColor: MaterialStateProperty.resolveWith(
                    (states) =>
                    theme.colorScheme.secondaryContainer.withOpacity(0.2),
              ),
              // optional: thoda spacing clean look ke liye
              columnSpacing: 32,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 48,
              columns: const [
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Percent")),
                DataColumn(label: Text("SGST/CGST")),
                DataColumn(label: Text("Included")),
                DataColumn(label: Text("Active")),
                DataColumn(label: Text("Actions")),
              ],
              rows: controller.rxTaxList.map((t) {
                return DataRow(
                  cells: [
                    DataCell(Text(t.taxProductName ?? "N/A")),
                    DataCell(Text("${t.taxPercentage?.toStringAsFixed(2) ?? '0'}%")),
                    DataCell(_statusIcon(t.isSgstCgst ?? false)),
                    DataCell(_statusIcon(t.isIncludeInRate ?? false)),
                    DataCell(_statusIcon(t.isActive ?? true)),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () =>
                                Get.toNamed(AppRoute.createTax, arguments: t),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => controller.deleteTax(t),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildList(ControllerTaxGroup controller, ThemeData theme) {
    return ListView.separated(
      itemCount: controller.rxTaxList.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, i) {
        final t = controller.rxTaxList[i];

        return ListTile(
          title: Text(t.taxProductName ?? "N/A"),
          subtitle: Text("${t.taxPercentage?.toStringAsFixed(1) ?? 0}%"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Get.toNamed(AppRoute.createTax, arguments: t),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => controller.deleteTax(t),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statusIcon(bool val) {
    return Icon(
      val ? Icons.check_circle : Icons.cancel,
      color: val ? Colors.green : Colors.red,
      size: 20,
    );
  }
}
