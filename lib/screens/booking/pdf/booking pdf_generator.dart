import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../../../model/entity_booking.dart';
import '../../../service/service_currency.dart';

Future<Uint8List> generateBookingPdf(EntityBooking booking) async {
  final pdf = pw.Document();
  final currencyService = Get.find<ServiceCurrency>();//currency
  final symbol = currencyService.symbol;//currency
  final room = booking.room.target;
  final guests = booking.guest;
  final amenities = booking.amenities;
  final payments = booking.payment;

  var currency;
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(25),
      build: (context) => [
        pw.Center(
          child: pw.Text(
            "RH Poss Hotel",
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Center(
          child: pw.Text("Bill Preview)",
          ),
        ),
        pw.SizedBox(height: 20),

        _sectionTitle("Booking Details"),
        _keyValue("Booking ID", booking.bookingId.toString()),
        _keyValue("Check-In", booking.checkInDate),
        _keyValue("Check-Out", booking.checkOutDate),
        _keyValue("Booking Type", booking.bookingType.toString()),
        _keyValue("Status", booking.status.toString()),
        if (booking.notes != null)
          _keyValue("Notes", booking.notes ?? ''),

        pw.SizedBox(height: 10),
        _sectionTitle("Room Details"),
        if (room != null) ...[
          _keyValue("Room No", room.roomId.toString()),
          _keyValue("Room Type", room.roomType ??""),
          _keyValue("Rate/Night", "${symbol[currency]}${room.price?.toStringAsFixed(2)}($currency)"),
        ],

        pw.SizedBox(height: 10),
        _sectionTitle("Guests (${guests.length})"),
        ...guests.map((g) => pw.Text(
            " ${g.first} ${g.last} (${g.gender}, ${g.nationality ?? 'N/A'})",
            style: const pw.TextStyle(fontSize: 12))),

        pw.SizedBox(height: 10),
        _sectionTitle("Amenities"),
        if (amenities.isEmpty)
          pw.Text("No amenities selected"),
        ...amenities.map((a) => pw.Text(
  "${a.name} (${symbol[currency]}${a.price?.toStringAsFixed(2)})×${a.qty}",
            style: const pw.TextStyle(fontSize: 12))),

        pw.SizedBox(height: 10),
        _sectionTitle("Payments"),
        if (payments.isEmpty)
          pw.Text("No payments recorded"),
        ...payments.map((p) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
                "${p.paymentMode} - ${symbol[currency]}${p.amount.toStringAsFixed(2)} (${p.currency})"),            if (p.transactionId != null)
              pw.Text("Txn ID: ${p.transactionId}",
                  style: const pw.TextStyle(
                      color: PdfColors.grey, fontSize: 10)),
          ],
        )),

        pw.Divider(),
        _sectionTitle("Summary"),
        _keyValue("Total Bill", "${symbol[currency]}${booking.totalBill.toStringAsFixed(2)}"),        if (booking.discountPrice != null && booking.discountPrice! > 0)
          _keyValue("Discount",
              "${booking.discountPrice} (${booking.discountDesc ?? ''})"),
        pw.Text(
          "Total: ${symbol[currency]}${(booking.totalBill - (booking.discountPrice ?? 0)).toStringAsFixed(2)}",          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
      ],
    ),
  );

  return pdf.save();
}

pw.Widget _sectionTitle(String title) => pw.Padding(
  padding: const pw.EdgeInsets.only(top: 10, bottom: 5),
  child: pw.Text(title,
      style: pw.TextStyle(
          fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
);

pw.Widget _keyValue(String key, String value) => pw.Padding(
  padding: const pw.EdgeInsets.symmetric(vertical: 2),
  child: pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text("$key:",
          style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey)),
      pw.Text(value, style: const pw.TextStyle(fontSize: 11)),
    ],
  ),
);