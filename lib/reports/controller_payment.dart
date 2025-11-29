import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hotel/model/entity_payment.dart';
import '../objectbox.g.dart';
import '../service/service_object_box.dart'; // path adjust if needed
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';


class ControllerPayment extends GetxController {
  late final Box<EntityPayment> _box;
  final ServiceObjectBox _obj = Get.find<ServiceObjectBox>();
  // Reactive lists / values
  var payments = <EntityPayment>[].obs;
  var filteredPayments = <EntityPayment>[].obs;
  var totalAmount = 0.0.obs;
  // Payment type summary: {'CASH': 1000.0, 'CARD': 2000.0}
  var paymentTypeSummary = <String, double>{}.obs;
  @override
  void onInit() {
    super.onInit();
    _box = _obj.box<EntityPayment>();
    loadAllPayments();
  }

  /// Load all payments from ObjectBox into memory (used for dropdown lists etc.)
  void loadAllPayments() {
    payments.value = _box.getAll();
    // default show all
    filteredPayments.value = List.from(payments);
    _computeTotals();
    _computePaymentTypeSummary();
  }

  // -- Helpers --
  // / Format DateTime to your model's string format: "yyyy-MM-dd HH:mm"
  String _formatDateTime(DateTime dt) {
    final df = DateFormat('yyyy-MM-dd HH:mm');
    return df.format(dt);
  }

  // Return start string inclusive and end string exclusive for date ranges
  // We will use lexical string between because your createdAt is in yyyy-MM-dd HH:mm
  List<String> _rangeStrings(DateTime start, DateTime endExclusive) {
    return [_formatDateTime(start), _formatDateTime(endExclusive)];
  }

  /// Compute simple total for current filteredPayments
  void _computeTotals() {
    double sum = 0.0;
    for (var p in filteredPayments) {
      sum += p.amount;
    }
    totalAmount.value = sum;
  }

  /// Compute payment type summary across filteredPayments (or pass all)
  void _computePaymentTypeSummary({List<EntityPayment>? source}) {
    final src = source ?? filteredPayments;
    final Map<String, double> map = {};
    for (var p in src) {
      final k = p.paymentMode.toUpperCase();
      map[k] = (map[k] ?? 0) + p.amount;
    }
    paymentTypeSummary.value = map;
  }

  // -- Queries using ObjectBox (string range queries on createdAt) --
  /// Generic date range query (inclusive start, exclusive end)
  Future<void> getReportByRange(
    DateTime startInclusive,
    DateTime endExclusive,
  ) async {
    final startStr = _formatDateTime(startInclusive);
    final endStr = _formatDateTime(endExclusive);

    final q = _box
        .query(
          EntityPayment_.createdAt
              .greaterOrEqual(startStr)
              .and(EntityPayment_.createdAt.lessThan(endStr)),
        )
        .build();

    final res = q.find();
    q.close();

    filteredPayments.value = res;
    _computeTotals();
    _computePaymentTypeSummary();
  }

  int serialNumber(int index) {
    return index + 1;
  }


  /// Daily report for given date (date's 00:00 to next day 00:00)
  Future<void> getDailyReport(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day, 0, 0);
    final end = start.add(Duration(days: 1));
    await getReportByRange(start, end);
  }

  /// Monthly report for given date: first day of month to first day of next month
  Future<void> getMonthlyReport(DateTime date) async {
    final start = DateTime(date.year, date.month, 1, 0, 0);
    final end = (date.month == 12)
        ? DateTime(date.year + 1, 1, 1, 0, 0)
        : DateTime(date.year, date.month + 1, 1, 0, 0);
    await getReportByRange(start, end);
  }

  /// Yearly report for given year
  Future<void> getYearlyReport(int year) async {
    final start = DateTime(year, 1, 1, 0, 0);
    final end = DateTime(year + 1, 1, 1, 0, 0);
    await getReportByRange(start, end);
  }

  // -- Payment type report (filter by a specific payment mode) --
  // /// Filter by payment mode (eg "CASH", "CARD", "UPI", "PENDING")
  // Future<void> getPaymentTypeReport(String paymentMode) async {
  //   final mode = paymentMode.toUpperCase();
  //   // Use a simple query for equality on paymentMode (case sensitive depends on stored data)
  //   final q = _box
  //       .query(EntityPayment_.paymentMode.equals(paymentMode))
  //       .build();
  //   final res = q.find();
  //   q.close();
  //
  //   filteredPayments.value = res;
  //   _computeTotals();
  //   _computePaymentTypeSummary();
  // }
  Future<void> exportRevenuePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) {
          return [

            pw.Center(
              child: pw.Text(
                "Revenue Report",
                style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),

            pw.Text("Total Amount: ₹${totalAmount.value.toStringAsFixed(2)}"),
            pw.SizedBox(height: 10),

            pw.Divider(),

            pw.Text("Payment Type Summary",
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),

            pw.Table.fromTextArray(
              headers: ["Mode", "Total"],
              data: paymentTypeSummary.entries
                  .map((e) => [e.key, e.value.toStringAsFixed(2)])
                  .toList(),
            ),

            pw.SizedBox(height: 20),

            pw.Text("Detailed Transactions",
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),

            pw.Table.fromTextArray(
              headers: ["Mode", "Date", "Amount"],
              data: filteredPayments.map((p) {
                return [
                  p.paymentMode,
                  formatDisplayDate(p.createdAt),
                  p.amount.toStringAsFixed(2)
                ];
              }).toList(),
            ),
          ];
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: "revenue_report.pdf",
    );
  }

  Future<void> getPaymentTypeReport(String paymentMode) async {
    final q = _box
        .query(
        EntityPayment_.paymentMode.contains(paymentMode, caseSensitive: false)
    )
        .build();
    final res = q.find();
    q.close();

    filteredPayments.value = res;
    _computeTotals();
    _computePaymentTypeSummary();
  }

  String formatDisplayDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      return DateFormat('yyyy-MM-dd HH:mm').format(dt);
    } catch (_) {
      return raw;
    }
  }


  // -- Utility: reset to show all
  void resetFilters() {
    filteredPayments.value = List.from(payments);
    _computeTotals();
    _computePaymentTypeSummary();
  }

  // -- Optional: export / print simple summary map
  Map<String, dynamic> getSummaryMap() {
    return {
      'total': totalAmount.value,
      'count': filteredPayments.length,
      'byPaymentType': paymentTypeSummary,
    };
  }

  void recomputeTypeSummary() {
    _computePaymentTypeSummary();
  }
}
