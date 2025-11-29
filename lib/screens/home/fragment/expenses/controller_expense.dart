import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/model/expense_category.dart';
import 'package:hotel/screens/home/fragment/expenses/vendor/controller_vendor.dart';
import 'package:hotel/service/service_expense.dart';
import 'package:hotel/util/snackbar_util.dart';
import '../../../../enums/expense_filter.dart';
import '../../../../model/entity_expense.dart';
import '../../../../model/entity_vendor.dart';
import '../../../../service/service_expense_export.dart';
import '../../../../service/service_object_box.dart';

class ControllerExpense extends GetxController {
  late ExpenseService service;

  var categories = <ExpenseCategory>[].obs;
  var vendors = <Vendor>[].obs;
  var expenses = <Expense>[].obs;

  var loading = false.obs;

  // ----------------------------
  // FILTERS
  // ----------------------------
  var query = ''.obs;
  var selectedVendor = Rx<Vendor?>(null);
  var selectedCategory = Rx<ExpenseCategory?>(null);
  var dateFrom = Rx<DateTime?>(null);
  var dateTo = Rx<DateTime?>(null);
  var filterType = ExpenseFilterType.daily.obs;



  // ----------------------------
  // PAGINATION
  // ----------------------------
  var page = 1.obs;
  final int pageSize = 15;
  var totalPages = 1.obs;

  final _displayed = <Expense>[].obs;
  List<Expense> get expensesDisplayed => _displayed;

  // ----------------------------
  // SUMMARY CARDS
  // ----------------------------
  var todayExpense = 0.0.obs;
  var monthExpense = 0.0.obs;
  var totalExpense = 0.0.obs;

  // PIE CHART DATA
  Map<String, double> get categoryCount {
    final map = <String, double>{};
    for (var e in expenses) {
      final c = e.category.target?.name ?? "Unknown";
      map[c] = (map[c] ?? 0) + 1.0;
    }
    return map;
  }

  Map<String, double> get vendorCount {
    final map = <String, double>{};
    for (var e in expenses) {
      final v = e.vendor.target?.name ?? "Unknown";
      map[v] = (map[v] ?? 0) + 1.0;
    }
    return map;
  }

  // BAR CHART (weekly totals)
  List<double> get weeklyChargeableData {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: 6));

    final list = List<double>.filled(7, 0);

    for (var e in expenses) {
      final expenseDate = DateTime.parse(e.date);
      if (expenseDate.isBefore(start)) continue;
      int index = expenseDate.weekday - 1;
      list[index] += e.amount;
    }

    return list;
  }

  // ----------------------------
  // FORM FIELDS (Add Expense Popup)
  // ----------------------------
  final title = TextEditingController();
  final amount = TextEditingController();
  final notes = TextEditingController();

  var selectedVendorForForm = Rx<Vendor?>(null);
  var selectedCategoryForForm = Rx<ExpenseCategory?>(null);

  var selectedDate = DateTime.now().obs;
  var paymentType = "Cash".obs;
  var isRefundable = true.obs;

  // ------------------------------------------------
  // INIT
  // ------------------------------------------------
  @override
  void onInit() {
    service = ExpenseService(Get.find<ServiceObjectBox>());
    loadAll();
    super.onInit();
  }

  // ------------------------------------------------
  // LOAD DATA
  // ------------------------------------------------
  Future<void> loadAll() async {
    loading(true);

    await Future.delayed(Duration(milliseconds: 50)); // give objectbox time

    categories.value = service.getCategories();
    vendors.value = service.getVendors();
    expenses.value = service.getExpenses();

    selectedCategory.value = null;
    selectedCategoryForForm.value = null;

    _applyFilters();
    _calculateSummary();

    loading(false);
  }

  // LINE CHART : Daily totals for last 7 days
  List<double> get lineChartData {
    final list = List<double>.filled(7, 0);
    final now = DateTime.now();

    for (var e in expenses) {
      final expenseDate = DateTime.parse(e.date);
      int diff = now.difference(expenseDate).inDays;
      if (diff >= 0 && diff < 7) {
        int index = 6 - diff; // latest day on the right side
        list[index] += e.amount;
      }
    }
    return list;
  }


  void applyQuickFilter() {
    _applyFilters();
    _calculateSummary();
  }

  // ------------------------------------------------
  // EXPORT METHODS
  // ------------------------------------------------
  void exportToCSV() {
    ServiceExpenseExport.exportToCSV(expensesDisplayed);
  }
  void exportToPDF() {
    ServiceExpenseExport.exportToPDF(expensesDisplayed);
  }

  // ------------------------------------------------
  // FILTER METHODS
  // ------------------------------------------------
  void setQuery(String q) {
    query.value = q;
    _applyFilters();
  }

  void setVendor(Vendor? v) {
    selectedVendor.value = v;
    _applyFilters();
  }

  void setCategory(ExpenseCategory? c) {
    selectedCategory.value = c;
    _applyFilters();
  }

  void setDateRange(DateTime? from, DateTime? to) {
    dateFrom.value = from;
    dateTo.value = to;
    _applyFilters();
  }

  List<Expense> get _filteredList {
    final q = query.value.toLowerCase();
    final now = DateTime.now();

    return expenses.where((e) {
      // --------- FILTER BY DATE RANGE TYPE ----------
      final expenseDate = DateTime.parse(e.date);
      switch (filterType.value) {
        case ExpenseFilterType.daily:
          if (!(expenseDate.year == now.year &&
              expenseDate.month == now.month &&
              expenseDate.day == now.day)) return false;
          break;
        case ExpenseFilterType.weekly:
          final monday = now.subtract(Duration(days: now.weekday - 1));
          final sunday = monday.add(Duration(days: 6));
          if (expenseDate.isBefore(monday) || expenseDate.isAfter(sunday)) return false;
          break;
        case ExpenseFilterType.monthly:
          if (!(expenseDate.year == now.year && expenseDate.month == now.month))
            return false;
          break;
        case ExpenseFilterType.yearly:
          if (expenseDate.year != now.year) return false;
          break;
        case ExpenseFilterType.all:
          break;
      }

      // --------- VENDOR FILTER ----------
      if (selectedVendor.value != null &&
          e.vendor.targetId != selectedVendor.value!.id) return false;

      // --------- CATEGORY FILTER ----------
      if (selectedCategory.value != null &&
          e.category.targetId != selectedCategory.value!.id) return false;

      // --------- SEARCH ----------
      if (q.isNotEmpty) {
        final full = (e.description + " " + (e.vendor.target?.name ?? "")).toLowerCase();
        if (!full.contains(q)) return false;
      }

      return true;
    }).toList();
  }

  // ------------------------------------------------
  // APPLY FILTER + PAGINATION
  // ------------------------------------------------
  void _applyFilters() {
    List<Expense> list = _filteredList;

    totalPages.value = (list.length / pageSize).ceil().clamp(1, 9999);

    if (page.value > totalPages.value) page.value = totalPages.value;

    int start = (page.value - 1) * pageSize;
    int end = start + pageSize;
    if (end > list.length) end = list.length;

    _displayed.value = (list.isEmpty || start >= end) ? <Expense>[] : list.sublist(start, end);
  }

  void nextPage() {
    if (page.value < totalPages.value) {
      page.value++;
      _applyFilters();
    }
  }

  void prevPage() {
    if (page.value > 1) {
      page.value--;
      _applyFilters();
    }
  }

  void goToPage(int p) {
    page.value = p;
    _applyFilters();
  }

  // ------------------------------------------------
  // SUMMARY CARDS
  // ------------------------------------------------
  void _calculateSummary() {
    final now = DateTime.now();

    todayExpense.value = expenses.where((e) {
      if (e.date.isEmpty) return false;
      try {
        final expenseDate = DateTime.parse(e.date);
        return expenseDate.year == now.year && expenseDate.month == now.month && expenseDate.day == now.day;
      } catch (_) {
        return false;
      }
    }).fold(0.0, (s, e) => s + e.amount);

    monthExpense.value = expenses.where((e) {
      if (e.date.isEmpty) return false;
      try {
        final expenseDate = DateTime.parse(e.date);
        return expenseDate.year == now.year && expenseDate.month == now.month;
      } catch (_) {
        return false;
      }
    }).fold(0.0, (s, e) => s + e.amount);

    totalExpense.value = expenses.fold(0.0, (s, e) => s + e.amount);
  }

  // ------------------------------------------------
  // ADD EXPENSE (Popup)
  // ------------------------------------------------
  void addExpenseFromForm() {
    if (title.text.trim().isEmpty ||
        amount.text.trim().isEmpty ||
        selectedVendorForForm.value == null ||
        selectedCategoryForForm.value == null) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    final exp = Expense(
      description: title.text.trim(),
      amount: double.tryParse(amount.text.trim()) ?? 0.0,
      date: selectedDate.value.toIso8601String(),
      // notes: notes.text.trim(),
      paymentType: paymentType.value,
      isRefundable: isRefundable.value,
    );

    // RELATIONS: set both vendor and category before saving
    exp.vendor.target = selectedVendorForForm.value;
    exp.category.target = selectedCategoryForForm.value;

    // Save expense (ExpenseService.addExpense simply puts the Expense; relation saved too)
    service.addExpense(exp);

    clearForm();
    loadAll();
    Get.back();
    SnackbarUtil.showSuccess( "Expense added");
  }

  // ------------------------------------------------
  // DELETE EXPENSE
  // ------------------------------------------------
  void deleteExpense(int id) {
    service.deleteExpense(id);
    loadAll();
  }

  // ------------------------------------------------
  // CLEAR FORM
  // ------------------------------------------------
  void clearForm() {
    title.clear();
    amount.clear();
    notes.clear();

    selectedVendorForForm.value = null;
    selectedCategoryForForm.value = null;

    selectedDate.value = DateTime.now();
    paymentType.value = "Cash";
    isRefundable.value = true;
  }
  void showExportOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text("Export to Excel (CSV)"),
              onTap: () {
                Get.back();
                ServiceExpenseExport.exportToCSV(expensesDisplayed);
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text("Export to PDF"),
              onTap: () {
                Get.back();
                ServiceExpenseExport.exportToPDF(expensesDisplayed);
              },
            ),
          ],
        ),
      ),
    );
  }
  Future<void> deleteAllVendorsAndCategories() async {
    final confirmed = await Get.defaultDialog<bool>(
      title: "⚠ Danger Zone",
      middleText:
      "This will permanently delete ALL vendors and categories.\nThis action CANNOT be undone!",
      textCancel: "Cancel",
      textConfirm: "Delete All",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    if (confirmed == true) {
      service.deleteAllCategories(); // ✅ delete categories
      Get.find<VendorController>().service.deleteAllVendors(); // ✅ delete vendors

      await loadAll();
      Get.find<VendorController>().loadVendors();

      SnackbarUtil.showSuccess(
          "All vendors & categories deleted permanently");
    }
  }


}
