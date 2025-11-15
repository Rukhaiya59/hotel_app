import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hotel/screens/booking/print/booking_print_overview.dart';
import 'package:hotel/util/app_color.dart';
import 'package:hotel/util/snackbar_util.dart';
import 'package:hotel/widgets/primary_button.dart';
import 'package:hotel/widgets/text_header.dart';
import '../../enums/enum_room_status.dart';
import '../../model/entity_room.dart';
import '../../service/service_currency.dart';
import '../room/ameneties/contoller_amenities.dart';
import 'controller_booking.dart';
import 'controller_guest_dialog.dart';
import 'controller_payment_dialog.dart';

class ActivityBooking extends StatelessWidget {
  const ActivityBooking({super.key});

  @override
  Widget build(BuildContext context) {
    final EntityRoom room = Get.arguments;
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
    final currencyService = Get.find<ServiceCurrency>();//currency

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
            // LEFT PANEL - GUEST DETAILS
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
                              final itemGuest = controller.rxListGuest[i];
                              return ListTile(
                                title: Text(
                                  "${itemGuest.first} ${itemGuest.last}",
                                ),
                                subtitle: Text(
                                  "${itemGuest.phone} | ${itemGuest.email}",
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () =>
                                      controller.rxListGuest.removeAt(i),
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

            // RIGHT PANEL - BOOKING DETAILS
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
                        const TextHeader(
                          message: "Booking & Payment Details",
                        ),

                        const SizedBox(height: 10),

                        // CHECK-IN / CHECK-OUT
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.checkInCtrl,
                                readOnly: true,

                                decoration: const InputDecoration(
                                  labelText: 'Check-In Date & Time',
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
                                  labelText: "Check-Out Date & Time",
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
                        const SizedBox(height: 10),

                        // DISCOUNT DETAILS
                        const TextHeader(message: "Discount Details"),
                        const SizedBox(height: 6),
                        TextField(
                          controller: controller.tecDiscountDescription,
                          decoration: const InputDecoration(
                            labelText: "Discount Description",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: controller.tecDiscountPrice,
                          decoration: InputDecoration(
                        labelText: "Discount Price (${currencyService.symbol})",//currency
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (v) {
                            controller.updateTotal();
                          },
                        ),
                        const SizedBox(height: 10),

                        // PAYMENTS & AMENITIES
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
                                debugPrint("selected: ${selected.length}");
                                // controller.rxListPayment.value = selected;
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
                                controller.rxListAmenities.assignAll(
                                  selected,
                                );
                                controller.updateTotal();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // SHOW SELECTED AMENITIES
                        const Text(
                          "Selected Amenities",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Obx(() {
                          if (controller.rxListAmenities.isEmpty) {
                            return const Text("No amenities selected");
                          }

                          double totalAmenityCost = controller.rxListAmenities
                              .fold(
                            0.0,
                                (sum, item) =>
                            sum +
                                ((item.price ?? 0) * (item.qty ?? 1)),
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
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      controller.rxListAmenities.remove(a);
                                      controller.updateTotal();
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 4.0,
                                  left: 8,
                                ),
                                child: Text(
                                  "Total Amenities Cost: ₹${totalAmenityCost.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 10),

                        // PAYMENTS LIST
                        Obx(() {
                          if (controller.rxListPayment.isEmpty) {
                            return const Text("No payment added");
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...controller.rxListPayment.map(
                                    (a) => ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(a.paymentMode),
                            subtitle: Text(
                                        "${currencyService.symbol}${a.amount.toStringAsFixed(2)}"),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      controller.rxListPayment.remove(a);
                                      controller.updateTotal();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 10),

                        // NOTES & TOTAL
                        TextField(
                          controller: controller.notesCtrl,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: "Notes",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                readOnly: true,
                                controller: controller.totalCtrl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                               labelText: "Total Bill (${currencyService.symbol})",//currency
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: controller.tecPaidAmount,
                                keyboardType: TextInputType.number,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: "Paid Amount (${currencyService.symbol})",//currency
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                readOnly: true,
                                controller: controller.tecRemaining,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: "Remaining Amount (${currencyService.symbol})",//currency
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // 🟩 1️⃣ BOOK ROOM BUTTON
                            ElevatedButton.icon(
                              onPressed: () {
                                controller.saveBooking();
                              },
                              icon: const Icon(Icons.book_online),
                              label: const Text("Book Room"),
                            ),

                            // 🟨 2️⃣ PREVIEW BILL BUTTON (👉 ye naya add karna hai)
                            ElevatedButton.icon(
                              onPressed: () {
                                final booking = controller.selectedBooking.value;
                                if (booking != null) {
                                  Get.to(() => BookingPrintOverview(booking: booking));
                                } else {
                                  SnackbarUtil.showError("No booking found to print overview.");
                                }
                              },
                              icon: const Icon(Icons.print),
                              label: const Text("Preview Bill"),
                            ),


                            ElevatedButton.icon(
                              onPressed: () {
                                controller.updateRoomStatus(EnumRoomStatus.cleaning);
                                SnackbarUtil.showSuccess("Room marked for cleaning");
                              },
                              icon: const Icon(Icons.logout),
                              label: const Text("Checkout"),
                            ),

                            // 🟦 4️⃣ CLEANING DONE BUTTON
                            ElevatedButton.icon(
                              onPressed: () {
                                controller.updateRoomStatus(EnumRoomStatus.available);
                                SnackbarUtil.showSuccess("Room is now available");
                              },
                              icon: const Icon(Icons.cleaning_services),
                              label: const Text("Cleaning Done"),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                    ),
                  ),
                ),
            ],

      ),
    ));
  }
}
