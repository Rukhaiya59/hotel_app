import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/model/expense_category.dart';
import 'controller_expense.dart';
import 'package:hotel/screens/home/fragment/expenses/vendor/controller_vendor.dart';

class AddExpensePopup extends StatelessWidget {
  final ControllerExpense ctrl = Get.find<ControllerExpense>();
  final VendorController vendorCtrl = Get.find<VendorController>();
  AddExpensePopup({super.key});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add Expense",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Vendor Dropdown
              Obx(() {
                return DropdownButtonFormField(
                  value: ctrl.selectedVendorForForm.value,
                  decoration: InputDecoration(
                    labelText: "Select Vendor",
                    border: OutlineInputBorder(),
                  ),
                  items: vendorCtrl.vendorList
                      .map((v) =>
                      DropdownMenuItem(value: v, child: Text(v.name)))
                      .toList(),
                  onChanged: (v) =>
                  ctrl.selectedVendorForForm.value = v,
                );
              }),

              const SizedBox(height: 15),

              // Category Dropdown (FIXED)
              Obx(() {
                return DropdownButtonFormField<ExpenseCategory?>(
                  value: ctrl.selectedCategoryForForm.value,
                  decoration: const InputDecoration(
                    labelText: "Select Category",
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text("Select Category"),
                    ),
                    ...ctrl.categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat.name),
                      );
                    }).toList(),
                  ],
                  onChanged: (cat) {
                    ctrl.selectedCategoryForForm.value = cat;
                  },
                );
              }),




              const SizedBox(height: 15),

              // Description / Title
              TextField(
                controller: ctrl.title,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // Amount
              TextField(
                controller: ctrl.amount,
                decoration: InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 15),

              // Payment Type
              Obx(() {
                return DropdownButtonFormField(
                  value: ctrl.paymentType.value,
                  decoration: InputDecoration(
                    labelText: "Payment Type",
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    "Cash",
                    "Card",
                    "Online",
                    "UPI",
                    "Cheque"
                  ]
                      .map((p) =>
                      DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) => ctrl.paymentType.value = v!,
                );
              }),

              const SizedBox(height: 15),

              // Refundable Switch
              Obx(() {
                return SwitchListTile(
                  title: Text("Refundable"),
                  value: ctrl.isRefundable.value,
                  onChanged: (v) => ctrl.isRefundable.value = v,
                );
              }),

              const SizedBox(height: 15),

              // Date Picker
              // Obx(() {
              //   return Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text("Date: ${ctrl.selectedDate.value.toString().split(' ')[0]}"),
              //       ElevatedButton(
              //         onPressed: () async {
              //           final picked = await showDatePicker(
              //             context: context,
              //             firstDate: DateTime(2000),
              //             lastDate: DateTime(2100),
              //             initialDate: ctrl.selectedDate.value,
              //           );
              //           if (picked != null) {
              //             ctrl.selectedDate.value = picked;
              //           }
              //         },
              //         child: Text("Pick"),
              //       )
              //     ],
              //   );
              // }),
              Obx(() {
                return GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: ctrl.selectedDate.value,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),

                      // IMPORTANT → this forces proper Windows-style small date picker
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                    );

                    if (picked != null) {
                      ctrl.selectedDate.value = picked;
                    }
                  },

                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          ctrl.selectedDate.value.toString().split(' ')[0],
                          style: const TextStyle(fontSize: 15),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 25),

              // Save Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text("Cancel"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: ctrl.addExpenseFromForm,
                    child: Text("Save"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
