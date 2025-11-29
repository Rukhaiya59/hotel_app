import '../../model/entity_expense.dart';
import '../../model/entity_vendor.dart';
import '../model/expense_category.dart';
import 'service_object_box.dart';

class ExpenseService {
  final ServiceObjectBox obx;

  ExpenseService(this.obx);

  // ----------------------------------
  // CATEGORY
  // ----------------------------------
  List<ExpenseCategory> getCategories() =>
      obx.box<ExpenseCategory>().getAll();

  int addCategory(ExpenseCategory c) =>
      obx.box<ExpenseCategory>().put(c);

  void deleteCategory(int id) =>
      obx.box<ExpenseCategory>().remove(id);

  // ----------------------------------
  // EXPENSE
  // ----------------------------------
  List<Expense> getExpenses() =>
      obx.box<Expense>().getAll();

  int addExpense(Expense e) {
    return obx.box<Expense>().put(e);
  }

  void deleteExpense(int id) =>
      obx.box<Expense>().remove(id);

  // ----------------------------------
  // VENDOR
  // ----------------------------------
  List<Vendor> getVendors() =>
      obx.box<Vendor>().getAll();

  int addVendor(Vendor v) =>
      obx.box<Vendor>().put(v);

  void deleteVendor(int id) =>
      obx.box<Vendor>().remove(id);
  void deleteAllCategories() {
    obx.box<ExpenseCategory>().removeAll();
  }

}
