import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import '../../../model/entity_booking.dart';
import '../../../service/service_currency.dart';
import '../pdf/booking_pdf_generator.dart';

class BookingPrintOverview extends StatelessWidget {
  final EntityBooking booking;
  const BookingPrintOverview({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final currencyService = Get.find<ServiceCurrency>();
    final symbol = currencyService.symbol;

    final room = booking.room.target;
    final guests = booking.guest;
    final amenities = booking.amenities;
    final payments = booking.payment;

    final subTotal = booking.totalBill;
    final discount = booking.discountPrice ?? 0;
    final totalAfterDiscount = subTotal - discount;
    final tax = totalAfterDiscount * 0.10;
    final grandTotal = totalAfterDiscount + tax;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Invoice Preview",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () async {
              final pdf = await generateBookingPdf(booking);
              await Printing.layoutPdf(onLayout: (_) async => pdf);
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            width: 800,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black12,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ================= HEADER =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "RH POSS HOTEL",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text("Hotel Address, City, India"),
                        Text("Phone: +91 98765 43210"),
                        Text("Email: info@rhposs.com"),
                      ],
                    ),
                    const Text(
                      "HOTEL INVOICE",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ================= BILL INFO =================
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _info("Bill No", booking.bookingId.toString()),
                      _info("Invoice Date", booking.checkInDate),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ================= GUEST TABLE =================
                _tableHeaderRow([
                  "Guest Name",
                  "Guest Address",
                  "Contact Information",
                ]),
                _tableRow([
                  "${guests.first.first} ${guests.first.last}",
                  "India",
                  guests.first.phone ?? "-",
                ]),

                const SizedBox(height: 20),

                // ================= SERVICE TABLE =================
                _tableHeaderRow([
                  "Service Description",
                  "Qty",
                  "Unit Price",
                  "Total",
                ]),

                if (room != null)
                  _tableRow([
                    "${room.roomType} Room Stay",
                    "1",
                    "$symbol${room.price}",
                    "$symbol${room.price}",
                  ]),

                ...amenities.map(
                      (a) => _tableRow([
                    a.name ?? "",
                    "${a.qty}",
                    "$symbol${a.price}",
                    "$symbol${(a.qty ?? 1) * (a.price ?? 0)}",
                  ]),
                ),

                const SizedBox(height: 20),

                // ================= TOTAL SUMMARY =================
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    children: [
                      _summaryRowUI("Subtotal",
                          "$symbol${subTotal.toStringAsFixed(2)}"),
                      _summaryRowUI(
                          "Tax (10%)", "$symbol${tax.toStringAsFixed(2)}"),
                      _summaryRowUI(
                        "Total Due",
                        "$symbol${grandTotal.toStringAsFixed(2)}",
                        bold: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ================= PAYMENT INFO =================
                const Text(
                  "Payments",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),

                ...payments.map(
                      (p) => Text(
                    "${p.paymentMode} - $symbol${p.amount.toStringAsFixed(2)}",
                  ),
                ),

                const SizedBox(height: 20),

                // ================= TERMS =================
                const Text(
                  "Payment Instructions:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                    "Payment is due upon receipt. Kindly settle via cash, UPI or card."),

                const SizedBox(height: 10),

                const Text(
                  "Terms & Conditions:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                    "All charges are final. Any disputes must be raised within 7 days."),

                const SizedBox(height: 15),

                const Center(
                  child: Text(
                    "Thank you for choosing RH POSS HOTEL!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _info(String key, String value) {
    return Row(
      children: [
        Text(
          "$key: ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }

  Widget _tableHeaderRow(List<String> titles) {
    return Container(
      color: Colors.grey.shade300,
      child: Row(
        children: titles
            .map(
              (t) => Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                t,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _tableRow(List<String> values) {
    return Row(
      children: values
          .map(
            (v) => Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(v),
          ),
        ),
      )
          .toList(),
    );
  }

  Widget _summaryRowUI(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
          ),
        ],
      ),
    );
  }
}
