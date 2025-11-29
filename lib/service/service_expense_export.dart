import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;

import '../model/entity_expense.dart';
import '../util/snackbar_util.dart';

class ServiceExpenseExport {

  // ================= CSV EXPORT =================
  static Future<void> exportToCSV(List<Expense> expenses) async {
    try {
      if (expenses.isEmpty) {
        SnackbarUtil.showError("No expenses to export");
        return;
      }

      final List<List<String>> rows = [];

      rows.add([
        "Vendor",
        "Category",
        "Description",
        "Amount",
        "Payment",
        "Date",
        "Refundable"
      ]);

      for (var e in expenses) {
        rows.add([
          e.vendor.target?.name ?? "-",
          e.category.target?.name ?? "-",
          e.description,
          e.amount.toStringAsFixed(2),
          e.paymentType,
          e.date,
          e.isRefundable ? "Yes" : "No",
        ]);
      }

      final csvData = rows.map((e) => e.join(",")).join("\n");

      final dir = await getApplicationDocumentsDirectory(); // ✅ WORKS ON WINDOWS & ANDROID
      final file = File("${dir.path}/expense_report.csv");

      await file.writeAsString(csvData);

      await Share.shareXFiles([XFile(file.path)]);

      SnackbarUtil.showSuccess("CSV exported successfully\nSaved at:\n${file.path}");

    } catch (e) {
      SnackbarUtil.showError("CSV Export Failed: ${e.toString()}");
    }
  }

  // ================= PDF EXPORT =================
  static Future<void> exportToPDF(List<Expense> expenses) async {
    try {
      if (expenses.isEmpty) {
        SnackbarUtil.showError("No expenses to export");
        return;
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          build: (context) => [
            pw.Text("Expense Report",
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                )),
            pw.SizedBox(height: 12),

            pw.Table.fromTextArray(
              headers: [
                "Vendor",
                "Category",
                "Description",
                "Amount",
                "Payment",
                "Date",
                "Refundable"
              ],
              data: expenses.map((e) {
                return [
                  e.vendor.target?.name ?? "-",
                  e.category.target?.name ?? "-",
                  e.description,
                  e.amount.toStringAsFixed(2),
                  e.paymentType,
                  e.date,
                  e.isRefundable ? "Yes" : "No",
                ];
              }).toList(),
            ),
          ],
        ),
      );

      final dir = await getApplicationDocumentsDirectory(); // ✅ UNIVERSAL PATH
      final file = File("${dir.path}/expense_report.pdf");

      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([XFile(file.path)]);

      SnackbarUtil.showSuccess("PDF exported successfully\nSaved at:\n${file.path}");

    } catch (e) {
      SnackbarUtil.showError("PDF Export Failed: ${e.toString()}");
    }
  }
}
