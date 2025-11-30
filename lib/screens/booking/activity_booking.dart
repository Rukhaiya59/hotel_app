import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/screens/booking/dailogs/edit_amenity_dailog.dart';
import 'package:hotel/screens/booking/print/booking_print_overview.dart';
import 'package:hotel/util/app_color.dart';
import 'package:hotel/util/snackbar_util.dart';
import 'package:hotel/widgets/primary_button.dart';
import 'package:hotel/widgets/text_header.dart';
import '../../enums/enum_room_status.dart';
import '../../model/entity_booking.dart';
import '../../model/entity_room.dart';
import '../../service/service_currency.dart';
import '../room/ameneties/contoller_amenities.dart';
import 'controller_booking.dart';
import 'dailogs/dailog_discount_show.dart';
import 'dailogs/edit_payment_dialog.dart';
import 'split_bill/activity_split_bill.dart';
import 'controller_guest_dialog.dart';
import 'controller_payment_dialog.dart';

class ActivityBooking extends StatelessWidget {
  final EntityBooking? editBooking;

  const ActivityBooking({super.key, this.editBooking});

  @override
  Widget build(BuildContext context) {
    final EntityRoom room = editBooking?.room.target ?? Get.arguments;
    final ControllerBooking controller = Get.put(
      ControllerBooking(initialRoom: room),
    );
    final ControllerGuestDialog guestDialog = Get.put(ControllerGuestDialog());
    final ControllerPaymentDialog paymentDialog = Get.put(
      ControllerPaymentDialog(),
    );
    final ControllerAmenities controllerAmenities = Get.put(
      ControllerAmenities(),
    );
    // final ControllerCancelReason cancelReasonCtrl = Get.put(
    //   ControllerCancelReason(),
    // );

    final currencyService = Get.find<ServiceCurrency>();

    if (editBooking != null) {
      controller.loadExistingReservation(editBooking!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            "Room Booking - ${controller.room.value.status?.toUpperCase()}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        backgroundColor: EnumRoomStatus.getColor(
          controller.room.value.status.toString(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextHeader(message: "Guest Details"),
                      const SizedBox(height: 10),

                      Expanded(
                        child: Obx(() {
                          if (controller.rxListGuest.isEmpty) {
                            return const Center(child: Text("No guest added"));
                          }
                          return ListView.builder(
                            itemCount: controller.rxListGuest.length,
                            itemBuilder: (_, i) {
                              final guest = controller.rxListGuest[i];
                              return ListTile(
                                title: Text("${guest.first} ${guest.last}"),
                                subtitle: Text(
                                  "${guest.phone} | ${guest.email}",
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        guestDialog.showGuestDialog(
                                          context,
                                          controller.rxListGuest,
                                          editGuest: guest,
                                          index: i,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () =>
                                          controller.rxListGuest.removeAt(i),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: PrimaryButton(
                          type: ActionType.add,
                          onPressed: () => guestDialog.showGuestDialog(
                            context,
                            controller.rxListGuest,
                          ),
                          color: LightColor.primaryStart,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),

                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextHeader(message: "Booking Details"),
                        const SizedBox(height: 10),

                        // CHECK-IN / CHECK-OUT ROW
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.checkInCtrl,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'Check-In',
                                  prefixIcon: Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(),
                                ),
                                onTap: () async {
                                  final selected = await controller
                                      .pickDateTime(context);
                                  if (selected != null) {
                                    controller.checkInCtrl.text = selected;
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: controller.checkOutCtrl,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: "Check-Out",
                                  border: OutlineInputBorder(),
                                ),
                                onTap: () async {
                                  final selected = await controller
                                      .pickDateTime(context);
                                  if (selected != null) {
                                    controller.checkOutCtrl.text = selected;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // AUTO DISCOUNT BANNER
                        Obx(() {
                          if (controller.autoDiscount.value == 0) {
                            return const SizedBox();
                          }
                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Auto Discount: ${currencyService.symbol}${controller.autoDiscount.value.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 10),
                        // PAYMENT + AMENITIES BUTTON ROW
                        Row(
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.payment),
                              label: const Text("Add Payment"),
                              onPressed: () async {
                                final selected = await paymentDialog
                                    .showPaymentDialog(
                                      context,
                                      controller.rxListPayment,
                                    );
                                controller.updateTotal();
                              },
                            ),
                            const SizedBox(width: 10),

                            ElevatedButton.icon(
                              icon: const Icon(Icons.room_service),
                              label: const Text("Add Amenities"),
                              onPressed: () async {
                                final selected = await controllerAmenities
                                    .showAmenitiesDialog(
                                      preSelected: controller.rxListAmenities,
                                    );
                                controller.rxListAmenities.assignAll(selected);
                                controller.updateTotal();
                              },
                            ),
                          ], // End of button Row
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Amenities",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(() {
                          if (controller.rxListAmenities.isEmpty) {
                            return const Text("No amenities selected");
                          }
                          double totalAmenityCost =
                              controller.rxListAmenities.fold(
                            0.0,
                            (sum, item) =>
                                sum + ((item.price ?? 0) * (item.qty ?? 1)),
                          );
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...controller.rxListAmenities.map(
                                (a) => ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(a.name ?? "Unnamed Amenity"),
                              subtitle: Text(
                                "${currencyService.symbol}${a.price?.toStringAsFixed(2) ?? '0.00'} × ${a.qty ?? 1}",
                              ),

                              trailing: Row( // <-- Start of trailing Row
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      showEditSelectedAmenityDialog(a);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      controller.rxListAmenities.remove(a);
                                      controller.updateTotal();
                                    },
                                  ),
                                 ], // <-- End of children for trailing Row
                               ), // <-- End of trailing Row
                                ), // <-- End of ListTile
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Amenities Total: ${currencyService.symbol}${totalAmenityCost.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 10),
                        const Text(
                          "Payments",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(() {
                          if (controller.rxListPayment.isEmpty) {
                            return const Text("No payment added");
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...controller.rxListPayment.map(
                                (p) => ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(p.paymentMode),
                                  subtitle: Text(
                                    "${currencyService.symbol}${p.amount.toStringAsFixed(2)}",
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // ⭐ EDIT ICON
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () {
                                          showEditPaymentDialog(p);
                                        },
                                      ),

                                      // DELETE ICON
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          controller.rxListPayment.remove(p);
                                          controller.updateTotal();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 10),

                        // NOTES
                        TextField(
                          controller: controller.notesCtrl,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: "Notes",
                            border: OutlineInputBorder(),
                          ),
                        ),
                    ]),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              flex: 1,
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Obx(() {
                    final roomRate = controller.roomRate;
                    final amenityTotal = controller.amenitiesTotal;
                    final discount = controller.autoDiscount.value;
                    final total = controller.totalBill;
                    final paid = controller.paidAmount;
                    final remaining = controller.remainingAmount;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Bill Summary",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        _summaryRow(
                          "Room Rate",
                          "₹${roomRate.toStringAsFixed(2)}",
                        ),
                        const SizedBox(height: 8),

                        _summaryRow(
                          "Amenities Total",
                          "₹${amenityTotal.toStringAsFixed(2)}",
                        ),
                        const SizedBox(height: 8),

                        _summaryRow(
                          "Discount",
                          "-₹${discount.toStringAsFixed(2)}",
                        ),
                        const Divider(thickness: 1.2),
                        const SizedBox(height: 6),

                        _summaryRow(
                          "TOTAL BILL",
                          "₹${total.toStringAsFixed(2)}",
                          isBold: true,
                          fontSize: 18,
                        ),

                        const SizedBox(height: 20),
                        const Text(
                          "Advance Payment",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),

                        _summaryRow(
                          "Paid",
                          "₹${paid.toStringAsFixed(2)}",
                          color: Colors.green,
                        ),
                        _summaryRow(
                          "Remaining",
                          "₹${remaining.toStringAsFixed(2)}",
                          color: Colors.red,
                        ),

                        const SizedBox(height: 22),

                        // ============================
                        // ACTION BUTTONS
                        // ============================
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            SizedBox(
                              width: 150,
                              child: ElevatedButton.icon(
                                onPressed: () => controller.saveBooking(),
                                icon: const Icon(Icons.book_online),
                                label: Obx(
                                  () => controller.selectedBooking.value == null
                                      ? const Text("Book Room")
                                      : const Text("Save"),
                                ),
                              ),
                            ),

                            SizedBox(
                              width: 150,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  final booking =
                                      controller.selectedBooking.value;
                                  if (booking != null) {
                                    Get.to(
                                      () => BookingPrintOverview(
                                        booking: booking,
                                      ),
                                    );
                                  } else {
                                    SnackbarUtil.showError(
                                      "No booking to preview.",
                                    );
                                  }
                                },
                                icon: const Icon(Icons.print),
                                label: const Text("Preview Bill"),
                              ),
                            ),

                            SizedBox(
                              width: 150,
                              child: ElevatedButton.icon(
                                onPressed: () => controller.checkoutBooking(),
                                icon: const Icon(Icons.logout),
                                label: const Text("Checkout"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent,
                                ),
                              ),
                            ),

                            SizedBox(
                              width: 150,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    controller.openRoomChangeDialog(context),
                                icon: const Icon(Icons.swap_horiz),
                                label: const Text("Change Room"),
                              ),
                            ),

                            SizedBox(
                              width: 150,
                              child: ElevatedButton.icon(
                                onPressed: () => controller.cancelBooking(context),
                                icon: const Icon(Icons.cancel),
                                label: const Text("Cancel"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                ),


                              ),
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.call_split),
                              label: const Text("Split Bill"),
                              onPressed: () async {

                                await controller.updateTotal(); // ensure latest totals

                                final result = await Get.to(
                                      () => SplitBillScreen(
                                    totalAmount: double.tryParse(controller.totalCtrl.text) ??
                                        controller.totalBill,
                                    guests: controller.rxListGuest.toList(),
                                    facilities: controller.rxListAmenities.toList(),
                                  ),
                                );

                                if (result != null) {
                                  controller.autoCreateSplitPayments(result);
                                  await controller.updateTotal();
                                }
                              },

                            ),
                            SizedBox(
                              width: 150,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.percent),
                                label: const Text("View Discount"),
                                onPressed: () =>
                                    DiscountSelectDialog.show(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
      ]  ),
    )
      );
  }
}

// ============
// SUMMARY ROW
// ============
Widget _summaryRow(
  String label,
  String value, {
  bool isBold = false,
  double fontSize = 14,
  Color? color,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          color: color,
        ),
      ),

    ],

  );
}
