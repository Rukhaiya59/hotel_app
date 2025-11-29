// import 'dart:typed_data';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart';
// import '../../../../model/entity_booking.dart';
//
// Future<Uint8List> generateBookingPdf(EntityBooking booking) async {
//   final pdf = pw.Document();
//   // final currencyService = Get.find<ServiceCurrency>();
//
//   final symbol = "Rs.";
//   final room = booking.room.target;
//   final guests = booking.guest;
//   final amenities = booking.amenities;
//   final payments = booking.payment;
//
//   pdf.addPage(
//     pw.MultiPage(
//       pageFormat: PdfPageFormat.a4,
//       margin: const pw.EdgeInsets.all(25),
//       build: (context) => [
//         pw.Center(
//           child: pw.Text(
//             "RH Poss Hotel",
//             style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
//           ),
//         ),
//         pw.Center(child: pw.Text("Bill Preview")),
//         pw.SizedBox(height: 20),
//
//         _sectionTitle("Booking Details"),
//         _keyValue("Booking ID", booking.bookingId.toString()),
//         _keyValue("Check-In", booking.checkInDate),
//         _keyValue("Check-Out", booking.checkOutDate),
//         _keyValue("Booking Type", booking.bookingType.toString()),
//         _keyValue("Status", booking.status.toString()),
//         if (booking.notes != null) _keyValue("Notes", booking.notes ?? ''),
//
//         pw.SizedBox(height: 10),
//
//         _sectionTitle("Room Details"),
//         if (room != null) ...[
//           _keyValue("Room No", room.roomId.toString()),
//           _keyValue("Room Type", room.roomType ?? ""),
//           _keyValue(
//             "Rate/Night",
//             "${symbol} ${room.price?.toStringAsFixed(2)}",
//           ),
//         ],
//
//         pw.SizedBox(height: 10),
//
//         _sectionTitle("Guests (${guests.length})"),
//         ...guests.map(
//           (g) => pw.Padding(
//             padding: const pw.EdgeInsets.only(bottom: 4),
//             child: pw.Text(
//               " ${g.first} ${g.last} (${g.gender},",
//               style: const pw.TextStyle(fontSize: 12),
//             ),
//           ),
//         ),
//
//         pw.SizedBox(height: 10),
//
//         _sectionTitle("Amenities"),
//         if (amenities.isEmpty) pw.Text("No amenities selected"),
//         ...amenities.map(
//           (a) => pw.Padding(
//             padding: const pw.EdgeInsets.only(bottom: 4),
//             child: pw.Text(
//               " ${a.name} (${symbol} ${(a.price ?? 0).toStringAsFixed(2)}) x ${a.qty}",
//               style: const pw.TextStyle(fontSize: 12),
//             ),
//           ),
//         ),
//
//         pw.SizedBox(height: 10),
//
//         _sectionTitle("Payments"),
//         if (payments.isEmpty) pw.Text("No payments recorded"),
//         ...payments.map(
//           (p) => pw.Padding(
//             padding: const pw.EdgeInsets.only(bottom: 6),
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Text(
//                   " ${p.paymentMode} - ${symbol} ${p.amount.toStringAsFixed(2)} (${p.currency})",
//                 ),
//                 if (p.transactionId != null)
//                   pw.Text(
//                     "Txn ID: ${p.transactionId}",
//                     style: const pw.TextStyle(
//                       color: PdfColors.grey,
//                       fontSize: 10,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//
//         pw.Divider(),
//
//         _sectionTitle("Summary"),
//         _row("Total Bill", "${symbol} ${booking.totalBill.toStringAsFixed(2)}"),
//         _row("Discount", "${symbol} ${booking.discountPrice ?? 0}"),
//
//         _row(
//           "Total:",
//           "${symbol} ${(booking.totalBill - (booking.discountPrice ?? 0)).toStringAsFixed(2)}",
//           style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
//         ),
//       ],
//     ),
//   );
//
//   return pdf.save();
// }
//
// pw.Widget _sectionTitle(String title) => pw.Padding(
//   padding: const pw.EdgeInsets.only(top: 10, bottom: 5),
//   child: pw.Text(
//     title,
//     style: pw.TextStyle(
//       fontSize: 14,
//       fontWeight: pw.FontWeight.bold,
//       color: PdfColors.black,
//     ),
//   ),
// );
//
// pw.Widget _keyValue(String key, String value) => pw.Padding(
//   padding: const pw.EdgeInsets.symmetric(vertical: 2),
//   child: pw.Row(
//     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//     children: [
//       pw.Text(
//         "$key:",
//         style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey),
//       ),
//       pw.Text(value, style: const pw.TextStyle(fontSize: 11)),
//     ],
//   ),
// );
//
// pw.Widget _row(String key, String value, {pw.TextStyle? style}) => pw.Padding(
//   padding: const pw.EdgeInsets.symmetric(vertical: 2),
//   child: pw.Row(
//     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//     children: [
//       pw.Text(key, style: style),
//       pw.Text(value, style: style),
//     ],
//   ),
// );
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
