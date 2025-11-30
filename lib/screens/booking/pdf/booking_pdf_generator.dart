import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../../model/entity_booking.dart';

Future<Uint8List> generateBookingPdf(EntityBooking booking) async {
  final pdf = pw.Document();

  final symbol = "₹";
  final room = booking.room.target;
  final guests = booking.guest;
  final amenities = booking.amenities;
  final payments = booking.payment;

  final subTotal = booking.totalBill;
  final discount = booking.discountPrice ?? 0;
  final total = subTotal - discount;
  final tax = total * 0.10;
  final grandTotal = total + tax;

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (context) => [

        // ================= HEADER =================
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "RH POSS HOTEL",
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text("Hotel Address, City, India"),
                pw.Text("Phone: +91 98765 43210"),
                pw.Text("Email: info@rhposs.com"),
              ],
            ),
            pw.Text(
              "HOTEL INVOICE",
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),

        pw.SizedBox(height: 20),

        // ================= BILL INFO =================
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _kv("Bill No:", booking.bookingId.toString()),
              _kv("Invoice Date:", booking.checkInDate),
            ],
          ),
        ),

        pw.SizedBox(height: 18),

        // ================= GUEST TABLE =================
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.black),
          columnWidths: {
            0: const pw.FlexColumnWidth(),
            1: const pw.FlexColumnWidth(),
            2: const pw.FlexColumnWidth(),
          },
          children: [
            _tableHeader([
              "Guest Name",
              "Guest Address",
              "Contact Information",
            ]),
            pw.TableRow(
              children: [
                _cell("${guests.first.first} ${guests.first.last}"),
                _cell("India"),
                _cell(guests.first.phone ?? "-"),
              ],
            ),
          ],
        ),

        pw.SizedBox(height: 22),

        // ================= SERVICE TABLE =================
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.black),
          columnWidths: {
            0: const pw.FlexColumnWidth(3),
            1: const pw.FlexColumnWidth(),
            2: const pw.FlexColumnWidth(),
            3: const pw.FlexColumnWidth(),
          },
          children: [
            _tableHeader([
              "Service Description",
              "Qty",
              "Unit Price",
              "Total",
            ]),

            if (room != null)
              _tableRow([
                "${room.roomType} Room Stay",
                "1",
                "$symbol${room.price?.toStringAsFixed(0)}",
                "$symbol${room.price?.toStringAsFixed(0)}",
              ]),

            ...amenities.map(
                  (a) => _tableRow([
                a.name ?? "",
                "${a.qty}",
                "$symbol${a.price}",
                "$symbol${(a.qty ?? 1) * (a.price ?? 0)}",
              ]),
            ),
          ],
        ),

        pw.SizedBox(height: 20),

        // ================= TOTAL SUMMARY =================
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.black),
          columnWidths: {
            0: const pw.FlexColumnWidth(3),
            1: const pw.FlexColumnWidth(),
          },
          children: [
            _summaryRow("Subtotal", "$symbol${subTotal.toStringAsFixed(2)}"),
            _summaryRow("Tax (10%)", "$symbol${tax.toStringAsFixed(2)}"),
            _summaryRow(
              "Total Due",
              "$symbol${grandTotal.toStringAsFixed(2)}",
              bold: true,
            ),
          ],
        ),

        pw.SizedBox(height: 22),

        // ================= PAYMENTS =================
        pw.Text(
          "Payments",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        ...payments.map(
              (p) => pw.Text(
            "${p.paymentMode} - $symbol{p.amount.toStringAsFixed(2)}",
          ),
        ),

        pw.SizedBox(height: 18),

        // ================= PAYMENT INSTRUCTIONS =================
        pw.Text(
          "Payment Instructions:",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          "Payment is due upon receipt. Kindly settle via cash, UPI or card.",
        ),

        pw.SizedBox(height: 10),

        // ================= TERMS =================
        pw.Text(
          "Terms & Conditions:",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          "All charges are final. Any changes or disputes must be raised within 7 days.",
        ),

        pw.SizedBox(height: 14),

        pw.Center(
          child: pw.Text(
            "Thank you for choosing RH POSS HOTEL!",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
      ],
    ),
  );

  return pdf.save();
}

// ================= HELPER METHODS =================

pw.Widget _kv(String k, String v) => pw.Row(
  children: [
    pw.Text(k, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
    pw.SizedBox(width: 4),
    pw.Text(v),
  ],
);

pw.TableRow _tableHeader(List<String> titles) {
  return pw.TableRow(
    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
    children: titles
        .map(
          (t) => pw.Padding(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(
          t,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
      ),
    )
        .toList(),
  );
}

pw.TableRow _tableRow(List<String> values) {
  return pw.TableRow(
    children: values
        .map(
          (v) => pw.Padding(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(v),
      ),
    )
        .toList(),
  );
}

pw.Widget _cell(String text) => pw.Padding(
  padding: const pw.EdgeInsets.all(8),
  child: pw.Text(text),
);

pw.TableRow _summaryRow(String label, String value, {bool bold = false}) {
  return pw.TableRow(
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(
          label,
          style:
          pw.TextStyle(fontWeight: bold ? pw.FontWeight.bold : null),
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(
          value,
          style:
          pw.TextStyle(fontWeight: bold ? pw.FontWeight.bold : null),
        ),
      ),
    ],
  );
}
