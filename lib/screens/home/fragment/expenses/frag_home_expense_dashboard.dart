import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/model/expense_category.dart';
import 'package:hotel/service/service_currency.dart';
import 'package:hotel/widgets/category_pie_chart.dart';
import 'package:hotel/widgets/chargeable_bar_chart.dart';
import 'package:hotel/widgets/expense_line_chart.dart';
import 'package:intl/intl.dart';

import '../../../../enums/expense_filter.dart';
import '../../../../model/entity_vendor.dart';
import '../../../../widgets/delete_dailog.dart';
import 'frag_home_expense_add.dart';
import 'controller_expense.dart';
import 'package:hotel/screens/home/fragment/expenses/vendor/activity_add_vendor.dart';
import 'package:hotel/screens/home/fragment/expenses/vendor/controller_vendor.dart';

class ActivityExpenseDashboard extends StatelessWidget {
  String _filterLabel(ExpenseFilterType f) {
    switch (f) {
      case ExpenseFilterType.daily:
        return "Daily";
      case ExpenseFilterType.weekly:
        return "Weekly";
      case ExpenseFilterType.monthly:
        return "Monthly";
      case ExpenseFilterType.yearly:
        return "Yearly";
      case ExpenseFilterType.all:
        return "All";
    }
  }

  final ControllerExpense expenseCtrl = Get.put(ControllerExpense());
  final VendorController vendorCtrl = Get.put(VendorController());
  final ServiceCurrency currency = Get.find<ServiceCurrency>();

  ActivityExpenseDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _filterBar(context),
                  const SizedBox(height: 20),
                  Expanded(child: _expenseTable(context)),
                ],
              ),
            ),

          const SizedBox(width: 20),

            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 250,
                      padding: const EdgeInsets.all(12),
                      decoration: _box(context),
                      child: ChargeableBarChart(
                        data: expenseCtrl.weeklyChargeableData,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 300,
                      padding: const EdgeInsets.all(12),
                      decoration: _box(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Category & Vendor",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: CategoryPieChart(
                                    data: expenseCtrl.categoryCount,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 220,
                      padding: const EdgeInsets.all(12),
                      decoration: _box(context),
                      child: ExpenseLineChart(
                        data: expenseCtrl.lineChartData,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------
  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text("Expense Dashboard"),
      elevation: 1,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      actions: [
        TextButton.icon(
          onPressed: () async {
            await expenseCtrl.loadAll();
            Get.dialog(AddExpensePopup());
          },
          icon: Icon(Icons.add, color: Colors.blue),
          label: const Text("Add Expense"),
        ),
        const SizedBox(width: 10),
        TextButton.icon(
          onPressed: () {
            Get.dialog(AddVendorPopup());
          },
          icon: const Icon(Icons.store, color: Colors.green),
          label: const Text("Add Vendor"),
        ),
        TextButton.icon(
          onPressed: () => expenseCtrl.showExportOptions(),
          icon: const Icon(Icons.download, color: Colors.purple),
          label: const Text("Export"),
        ),
        TextButton.icon(
          onPressed: () => expenseCtrl.deleteAllVendorsAndCategories(),
          icon: const Icon(Icons.delete_forever, color: Colors.red),
          label: const Text("Delete All"),
        ),

        const SizedBox(width: 20),
      ],
    );
  }

  // -------------------------------------------------------
  Widget _filterBar(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search expenses, vendor...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                isDense: true,
              ),
              onChanged: (v) => expenseCtrl.setQuery(v),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<Vendor?>(
              isExpanded: true,
              decoration: _dropDecoration(context, "Vendor"),
              value: expenseCtrl.selectedVendor.value,
              items: [
                const DropdownMenuItem<Vendor?>(
                  value: null,
                  child: Text("All Vendors"),
                ),
                ...vendorCtrl.vendorList.map(
                      (v) => DropdownMenuItem<Vendor?>(
                    value: v,
                    child: Text(v.name),
                  ),
                ),
              ],
              onChanged: (Vendor? v) {
                expenseCtrl.setVendor(v);
              },
            ),

          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<ExpenseCategory?>(
              isExpanded: true,
              decoration: _dropDecoration(context, "Category"),
              value: expenseCtrl.selectedCategory.value,
              items: [
                const DropdownMenuItem(value: null, child: Text("All Categories")),
                ...expenseCtrl.categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
              ],
              onChanged: (c) => expenseCtrl.setCategory(c),
            ),
          ),
          const SizedBox(width: 10),
          DropdownButton<ExpenseFilterType>(
            value: expenseCtrl.filterType.value,
            items: ExpenseFilterType.values.map((f) {
              return DropdownMenuItem(
                value: f,
                child: Text(_filterLabel(f)),
              );
            }).toList(),
            onChanged: (v) {
              expenseCtrl.filterType.value = v!;
              expenseCtrl.applyQuickFilter();
            },
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: () async {
              final now = DateTime.now();
              final range = await showDateRangePicker(
                context: Get.context!,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                initialDateRange: DateTimeRange(
                  start: expenseCtrl.dateFrom.value ??
                      now.subtract(const Duration(days: 30)),
                  end: expenseCtrl.dateTo.value ?? now,
                ),
              );
              if (range != null) {
                expenseCtrl.setDateRange(range.start, range.end);
              }
            },
            icon: const Icon(Icons.date_range),
            label: const Text("Date"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade50,
            ),
          ),
        ],
      );
    });
  }

  // -------------------------------------------------------
  InputDecoration _dropDecoration(BuildContext context, String label) {
    return InputDecoration(
      filled: true,
      fillColor: Theme.of(context).cardColor,
      labelText: label,
      border: const OutlineInputBorder(),
      isDense: true,
    );
  }

  // -------------------------------------------------------
  Widget _expenseTable(BuildContext context) {
    return Obx(() {
      final list = expenseCtrl.expensesDisplayed;
      return Container(
        decoration: _box(context),
        child: Column(
          children: [
            _tableHeader(context),
            Expanded(
              child: list.isEmpty
                  ? const Center(child: Text("No records found"))
                  : ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) => _row(context, list[i]),
              ),
            ),
            _paginationBar(),
          ],
        ),
      );
    });
  }

  // -------------------------------------------------------
  Widget _tableHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text("Vendor")),
          Expanded(flex: 3, child: Text("Description")),
          Expanded(flex: 2, child: Text("Amount")),
          Expanded(flex: 2, child: Text("Payment")),
          Expanded(flex: 2, child: Text("Date")),
          Expanded(flex: 1, child: Text("Action")),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  Widget _row(BuildContext context, e) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(e.vendor.target?.name ?? "-")),
          Expanded(flex: 3, child: Text(e.description)),
          Expanded(
            flex: 2,
            child: Text("${currency.symbol} ${e.amount.toStringAsFixed(2)}"),
          ),
          Expanded(flex: 2, child: Text(e.paymentType)),
          Expanded(
            flex: 2,
            child: DateTime.tryParse(e.date) != null
                ? Text(DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(e.date)))
                : Text(e.date),

          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirmed = await showDeleteConfirmation(
                  title: "Expense",
                  message: "Do you really want to delete this expense?",
                );

                if (confirmed) {
                  expenseCtrl.deleteExpense(e.id);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  Widget _paginationBar() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: expenseCtrl.prevPage,
            ),
            Text(
                "Page ${expenseCtrl.page.value} / ${expenseCtrl.totalPages.value}"),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: expenseCtrl.nextPage,
            ),
          ],
        ),
      );
    });
  }

  // -------------------------------------------------------
  BoxDecoration _box(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(blurRadius: 5, color: Colors.black12),
      ],
    );
  }
}
