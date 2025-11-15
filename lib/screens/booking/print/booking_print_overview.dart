import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import '../../../model/entity_booking.dart';
import '../../../service/service_currency.dart';
import '../pdf/booking pdf_generator.dart';


class BookingPrintOverview extends StatelessWidget {
  final EntityBooking booking;
  const BookingPrintOverview({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final currencyService = Get.find<ServiceCurrency>();//currency
    final symbol = currencyService.symbol;//currency

    final room = booking.room.target;
    final guests = booking.guest;
    final amenities = booking.amenities;
    final payments = booking.payment;

    return Scaffold(
      appBar: AppBar(
        title: const Text(" Print Bill" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
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
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text("RH Poss Hotel",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              const Divider(),
              _row("Booking ID", booking.bookingId.toString()),   // <-- FIXED
              _row("Check-In", booking.checkInDate),
              _row("Check-Out", booking.checkOutDate),
              _row("Type", booking.bookingType.toString()),
              _row("Status", booking.status.toString()),
              if (booking.notes != null) _row("Notes", booking.notes!),
              const Divider(),
              if (room != null)
                _row("Room No", room.number ?? room.roomUuid!),
              const Divider(),
              Text("Guests (${guests.length})",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              ...guests.map((g) => Text(" ${g.first} ${g.last} (${g.gender})")),
              const Divider(),
              Text("Amenities",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              ...amenities.map((a) => Text(" ${a.name} ($symbol${a.price}) × ${a.qty}")),//currency

              const Divider(),
              Text("Payments",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              ...payments.map((p) => Text(" ${p.paymentMode} - $symbol${p.amount.toStringAsFixed(2)}")),//currency

              const Divider(),
              _row("Total Bill", "$symbol${booking.totalBill.toStringAsFixed(2)}"),//currency
              if (booking.discountPrice != null)
                _row("Discount", "$symbol${booking.discountPrice}"),//currency
              const SizedBox(height: 8),
              Text(
                "Total: $symbol${(booking.totalBill - (booking.discountPrice ?? 0)).toStringAsFixed(2)}",//currency
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String key, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(key, style: const TextStyle(color: Colors.grey)),
        Text(value,
            style:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    ),
  );
}




























