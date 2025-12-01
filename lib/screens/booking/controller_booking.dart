import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/enums/enum_booking_status.dart';
import 'package:hotel/enums/enum_booking_type.dart';
import 'package:hotel/enums/enum_room_status.dart';
import 'package:hotel/model/entity_amenities.dart';
import 'package:hotel/model/entity_booking.dart';
import 'package:hotel/model/entity_guest.dart';
import 'package:hotel/model/entity_payment.dart';
import 'package:hotel/model/entity_room.dart';
import 'package:hotel/model/entity_split_bill.dart';
import 'package:hotel/objectbox.g.dart';
import 'package:hotel/service/service_currency.dart';
import 'package:hotel/service/service_object_box.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../../model/entity_discount.dart';
import '../../model/model_task.dart';
import '../../repository/repo_get_storage.dart';
import '../../util/snackbar_util.dart';
import 'controller_cancel_reason.dart';
import '../../model/entity_room_change_history.dart';
import 'dailogs/dailog_room_change.dart';

class ControllerBooking extends GetxController {
  final EntityRoom initialRoom;

  ControllerBooking({required this.initialRoom});

  final RepoGetStorage _repoGetStorage = Get.find();
  late Box<EntityBooking> boxBooking;
  late Box<EntityRoom> boxRoom;
  late Box<EntityGuest> boxGuest;
  late Box<EntityPayment> boxPayment;
  late Box<EntityAmenities> boxAmenities;
  late Box<EntityDiscount> boxDiscount;
  late Box<EntityRoomChangeHistory> boxRoomChange; // change history

  RxList<EntityDiscount> activeDiscounts = <EntityDiscount>[].obs;
  RxDouble autoDiscount = 0.0.obs;
  final Rxn<EntityDiscount> selectedDiscount =
      Rxn<EntityDiscount>(); // discount

  final Rx<EntityRoom> room = EntityRoom().obs;
  final Rxn<EntityBooking> selectedBooking = Rxn<EntityBooking>();
  final RxList<EntityGuest> rxListGuest = <EntityGuest>[].obs;
  final RxList<EntityPayment> rxListPayment = <EntityPayment>[].obs;
  final RxString paymentMethod = "Cash".obs;
  final RxList<EntityAmenities> rxListAmenities = <EntityAmenities>[].obs;

  late TextEditingController checkInCtrl;
  late TextEditingController checkOutCtrl;
  late TextEditingController totalCtrl;
  late TextEditingController notesCtrl;
  late TextEditingController tecDiscountDescription;
  late TextEditingController tecDiscountPrice;
  late TextEditingController tecPaidAmount;
  late TextEditingController tecRemaining;
  late Box<EntitySplitBill> boxSplitBill; //split bill

  @override
  void onInit() {
    super.onInit();
    final ob = Get.find<ServiceObjectBox>();
    boxDiscount = ob.store.box<EntityDiscount>();
    boxBooking = ob.store.box<EntityBooking>();
    boxRoom = ob.store.box<EntityRoom>();
    boxGuest = ob.store.box<EntityGuest>();
    boxPayment = ob.store.box<EntityPayment>();
    boxAmenities = ob.store.box<EntityAmenities>();
    boxDiscount = ob.store.box<EntityDiscount>();
    boxRoomChange = ob.store
        .box<EntityRoomChangeHistory>(); // room change history
    boxSplitBill = ob.store.box<EntitySplitBill>(); //split bill

    checkInCtrl = TextEditingController();
    checkOutCtrl = TextEditingController();
    totalCtrl = TextEditingController();
    notesCtrl = TextEditingController();
    tecDiscountDescription = TextEditingController();
    tecDiscountPrice = TextEditingController();
    tecPaidAmount = TextEditingController();
    tecRemaining = TextEditingController();

    loadActiveDiscounts();

    room.value = initialRoom;

    if (room.value.status == EnumRoomStatus.busy.name) {
      getBookingDetails();
    } else {
      checkInCtrl.text = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
      checkOutCtrl.text = DateFormat(
        'yyyy-MM-dd HH:mm',
      ).format(DateTime.now().add(const Duration(days: 1)));
      totalCtrl.text = (room.value.price ?? 0).toStringAsFixed(2);
      notesCtrl.text = "";
    }
  }

  @override
  void onClose() {
    checkInCtrl.dispose();
    checkOutCtrl.dispose();
    totalCtrl.dispose();
    notesCtrl.dispose();
    tecDiscountDescription.dispose();
    tecDiscountPrice.dispose();
    tecPaidAmount.dispose();
    tecRemaining.dispose();
    super.onClose();
  }

  void loadActiveDiscounts() {
    final list = boxDiscount
        .query(EntityDiscount_.isActive.equals(true))
        .build()
        .find();

    activeDiscounts.value = list;
  }

  // Booking ID Generator
  int generateBookingId() {
    final repo = _repoGetStorage;
    final now = DateTime.now();

    final lastDateStr = repo.getLastBookingDate();
    final resetType = repo.getResetBookingType();
    final lastNumber = repo.getLastBookingNumber();

    DateTime? lastDate = lastDateStr.isEmpty
        ? null
        : DateTime.tryParse(lastDateStr);

    bool reset = false;

    switch (resetType) {
      case "Daily":
        reset = lastDate == null || now.difference(lastDate).inDays >= 1;
        break;

      case "Weekly":
        reset =
            lastDate == null ||
            (now.weekday == DateTime.monday &&
                lastDate.weekday != DateTime.monday);
        break;

      case "Monthly":
        reset =
            lastDate == null ||
            now.month != lastDate.month ||
            now.year != lastDate.year;
        break;

      case "Quarterly":
        int cq = ((now.month - 1) ~/ 3) + 1;
        int lq = lastDate == null ? 0 : ((lastDate.month - 1) ~/ 3) + 1;
        reset = lastDate == null || cq != lq || now.year != lastDate.year;
        break;

      case "Yearly":
        reset = lastDate == null || now.year != lastDate.year;
        break;
    }

    if (reset) {
      repo.setLastBookingDate(now.toIso8601String());
      repo.setLastBookingNumber(1);
      return 1;
    } else {
      final next = lastNumber + 1;
      repo.setLastBookingNumber(next);
      return next;
    }
  }

  Future<EntityBooking> addBooking(EntityBooking booking) async {
    final id = boxBooking.put(booking);
    final savedBooking = boxBooking.get(id)!;

    // ROOM STATUS LOGIC
    if (booking.status == EnumBookingStatus.confirmed.name) {
      // Guest is staying -> room busy
      room.update((r) {
        if (r != null) {
          r.status = EnumRoomStatus.busy.name;
          r.bookingUuid = booking.bookingUuid;
        }
      });
    } else {
      // Reservation -> room must stay available
      room.update((r) {
        if (r != null) {
          r.status = EnumRoomStatus.available.name;
          r.bookingUuid = null;
        }
      });
    }

    boxRoom.put(room.value);
    room.refresh();

    return savedBooking;
  }

  Future<void> getBookingDetails() async {
    try {
      if (room.value.bookingUuid == null) return;

      final booking = boxBooking
          .query(EntityBooking_.bookingUuid.equals(room.value.bookingUuid!))
          .build()
          .findFirst();

      if (booking != null) {
        selectedBooking.value = booking;

        rxListGuest.assignAll(booking.guest.toList());
        rxListPayment.assignAll(booking.payment.toList());
        rxListAmenities.assignAll(booking.amenities.toList());

        tecDiscountPrice.text = booking.discountPrice.toString();
        tecDiscountDescription.text = booking.discountDesc ?? "";
        checkInCtrl.text = booking.checkInDate;
        checkOutCtrl.text = booking.checkOutDate;
        totalCtrl.text = booking.totalBill.toStringAsFixed(2);
        notesCtrl.text = booking.notes ?? "";
        updateTotal();
        Get.log(json.encode(booking.toMap()));
      }
    } catch (e) {
      Get.log("Error loading booking: $e");
    }
  }
Future<void> saveBooking() async {
    if (rxListGuest.isEmpty) {
      SnackbarUtil.showError("Please add at least one guest.");
      return;
    }

    final bool isEdit = selectedBooking.value != null;

    //  CASE 1 : EDIT EXISTING BOOKING
    if (isEdit) {
      final booking = selectedBooking.value!;

      booking.checkInDate = checkInCtrl.text;
      booking.checkOutDate = checkOutCtrl.text;
      booking.totalBill = double.tryParse(totalCtrl.text) ?? 0.0;
      booking.notes = notesCtrl.text;

      booking.discountPrice =
          double.tryParse(tecDiscountPrice.text) ?? 0.0;
      booking.discountDesc = tecDiscountDescription.text;

      // ✅ CLEAR OLD & RE-ADD UPDATED DATA
      booking.guest.clear();
      booking.amenities.clear();
      booking.payment.clear();

      booking.guest.addAll(rxListGuest);
      booking.amenities.addAll(rxListAmenities);
      booking.payment.addAll(rxListPayment);

      // ✅ JUST UPDATE — NO NEW BOOKING
      boxBooking.put(booking);

      updateTotal();

      SnackbarUtil.showSuccess("Booking updated successfully!");
      return;
    }

    // -------------------------------
    // ✅ CASE 2 : NEW BOOKING
    // -------------------------------
    final now = DateTime.now();
    final ciNew = DateTime.parse(checkInCtrl.text);

    final bookingStatus = ciNew.isAfter(now)
        ? EnumBookingStatus.reserved.name
        : EnumBookingStatus.confirmed.name;

    final booking = EntityBooking(
      bookingId: generateBookingId(),
      bookingUuid: mongo.ObjectId().oid,
      totalBill: double.tryParse(totalCtrl.text) ?? 0.0,
      discountPrice: double.tryParse(tecDiscountPrice.text) ?? 0.0,
      discountDesc: tecDiscountDescription.text,
      hotelUuid: _repoGetStorage.getHotelUuid()!,
      taxDescription: "Auto Applied Tax",
      checkInDate: checkInCtrl.text,
      checkOutDate: checkOutCtrl.text,
      bookingType: EnumBookingType.walkIn.name,
      status: bookingStatus,
      notes: notesCtrl.text,
    );

    booking.cleaningTaskCreated = false;
    booking.cleaningTime =
        DateTime.now().add(const Duration(minutes: 1)).toString();

    booking.guest.addAll(rxListGuest);
    booking.amenities.addAll(rxListAmenities);
    booking.payment.addAll(rxListPayment);
    booking.room.target = room.value;

    final bookingId = boxBooking.put(booking);
    final savedBooking = boxBooking.get(bookingId)!;
    selectedBooking.value = savedBooking;

    //  ROOM STATUS ONLY FOR NEW BOOKING
    if (bookingStatus == EnumBookingStatus.confirmed.name) {
      room.value.status = EnumRoomStatus.busy.name;
      room.value.bookingUuid = savedBooking.bookingUuid;
    } else {
      room.value.status = EnumRoomStatus.available.name;
      room.value.bookingUuid = null;
    }

    boxRoom.put(room.value);
    room.refresh();

    SnackbarUtil.showSuccess("Room booked successfully!");
  }


  Future<String?> pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return null;

    final combined = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    return DateFormat('yyyy-MM-dd HH:mm').format(combined);
  }

  // AUTO CHECK-IN
  void autoCheckIn(EntityBooking booking) {
    booking.status = EnumBookingStatus.confirmed.name;
    booking.actualCheckInAt = DateTime.now().toString();
    boxBooking.put(booking);

    final r = booking.room.target;
    if (r != null) {
      r.status = EnumRoomStatus.busy.name;
      r.bookingUuid = booking.bookingUuid;
      boxRoom.put(r);
    }

    selectedBooking.value = booking;
    room.refresh();
    SnackbarUtil.showSuccess("Checked in successfully!");
  }

  void openRoomChangeDialog(BuildContext context) {
    Get.dialog(
      RoomChangeDialog(
        currentRoom: room.value,
        onRoomSelected: (newRoom, reason) {
          changeRoom(newRoom, reason);
        },
      ),
    );
  }

  // updated change room method
  void changeRoom(EntityRoom newRoom, String reason) {
    final booking = selectedBooking.value!;
    final oldRoom = booking.room.target!;

    final oldRoomCheckIn = booking.checkInDate;
    final oldRoomCheckOut = DateTime.now().toIso8601String();

    //  RELEASE OLD ROOM
    oldRoom.status = EnumRoomStatus.available.name;
    oldRoom.bookingUuid = null;

    //  ASSIGN NEW ROOM
    newRoom.status = booking.status == EnumBookingStatus.reserved.name
        ? EnumRoomStatus.available.name
        : EnumRoomStatus.busy.name;

    newRoom.bookingUuid = booking.bookingUuid;
    booking.room.target = newRoom;

    final newRoomCheckIn = DateTime.now().toIso8601String();

    //  SAVE ROOM CHANGE HISTORY
    final history = EntityRoomChangeHistory(
      bookingId: booking.bookingId,
      oldRoomNo: oldRoom.number ?? "-",
      newRoomNo: newRoom.number ?? "-",
      oldRoomCheckIn: oldRoomCheckIn,
      oldRoomCheckOut: oldRoomCheckOut,
      newRoomCheckIn: newRoomCheckIn,
      reason: reason,
      changedAt: DateTime.now().toIso8601String(),
    );

    boxRoomChange.put(history);

    //  SAVE DATA
    boxRoom.put(oldRoom);
    boxRoom.put(newRoom);
    boxBooking.put(booking);

    room.value = newRoom;

    // ✅ AUTO UPDATE BILL
    updateTotal();

    SnackbarUtil.showSuccess("Room changed successfully!");
  }


  Future<void> updateTotal() async {
    double roomPrice = roomRate; // ✅ duration included
    double amenitiesPrice = 0.0;

    // FIX: apply qty properly
    for (var a in rxListAmenities) {
      amenitiesPrice += ((a.price ?? 0) * (a.qty ?? 1));
    }

    // correct discount
    autoDiscount.value = calculateDiscount(roomPrice);

    double taxableAmount = roomPrice + amenitiesPrice - autoDiscount.value;

    // if you add tax later
    double taxTotal = 0.0;

    double finalTotal = taxableAmount + taxTotal;

    totalCtrl.text = finalTotal.toStringAsFixed(2);

    // SUM OF SPLIT / PAYMENTS
    double paidAmount = 0.0;
    for (var p in rxListPayment) {
      paidAmount += p.amount;
    }

    tecPaidAmount.text = paidAmount.toStringAsFixed(2);
    tecRemaining.text = (finalTotal - paidAmount).toStringAsFixed(2);
  }

  double calculateDiscount(double roomPrice) {
    if (selectedDiscount.value == null) return 0.0;

    final dis = selectedDiscount.value!;

    if (dis.discountType == "percentage") {
      return roomPrice * (dis.value / 100);
    } else {
      return dis.value;
    }
  }

  void loadExistingReservation(EntityBooking b) {
    selectedBooking.value = b;
    room.value = b.room.target!;
    checkInCtrl.text = b.checkInDate;
    checkOutCtrl.text = b.checkOutDate;
    notesCtrl.text = b.notes ?? "";
    totalCtrl.text = b.totalBill.toStringAsFixed(2);
    tecDiscountPrice.text = b.discountPrice?.toString() ?? "0";
    tecDiscountDescription.text = b.discountDesc ?? "";
    rxListGuest.assignAll(b.guest.toList());
    rxListAmenities.assignAll(b.amenities.toList());
    rxListPayment.assignAll(b.payment.toList());
    updateTotal();
  }

  // CANCEL BOOKING (stay)
  Future<void> cancelBooking(BuildContext context) async {
    final booking = selectedBooking.value;
    if (booking == null) {
      SnackbarUtil.showError("No active booking to cancel.");
      return;
    }

    final reasonCtrl = Get.put(ControllerCancelReason());
    final reason = await reasonCtrl.showCancelReasonDialog(context);

    if (reason == null) return;

    final roomEntity = booking.room.target;
    if (roomEntity == null) return;

    final oldStatus = booking.status;
    final oldReason = booking.cancelReason;
    final oldCancelled = booking.cancelledAt;

    booking.status = "cancelled";
    booking.cancelReason = reason;
    booking.cancelledAt = DateTime.now().toIso8601String();

    boxBooking.put(booking);

    roomEntity.status = EnumRoomStatus.available.name;
    roomEntity.bookingUuid = null;
    boxRoom.put(roomEntity);
    room.refresh();

    SnackbarUtil.showUndo(
      message: "Booking cancelled",
      onUndo: () {
        booking.status = oldStatus;
        booking.cancelReason = oldReason;
        booking.cancelledAt = oldCancelled;

        boxBooking.put(booking);

        roomEntity.status = oldStatus == "reserved"
            ? EnumRoomStatus.available.name
            : EnumRoomStatus.busy.name;

        roomEntity.bookingUuid = booking.bookingUuid;

        boxRoom.put(roomEntity);
        room.refresh();

        SnackbarUtil.showSuccess("Cancellation reversed");
      },
    );
  }

  // CANCEL RESERVATION (only reservation)
  Future<void> cancelReservation(BuildContext context) async {
    final booking = selectedBooking.value;

    if (booking == null) {
      SnackbarUtil.showError("No booking selected.");
      return;
    }

    // Do NOT allow cancellation of completed stays
    if (booking.status == EnumBookingStatus.cancelled.name) {
      SnackbarUtil.showError("Checked-out bookings cannot be cancelled.");
      return;
    }

    final reasonCtrl = Get.find<ControllerCancelReason>();
    final reason = await reasonCtrl.showCancelReasonDialog(context);

    if (reason == null) return;

    final roomEntity = booking.room.target;
    if (roomEntity == null) return;

    // Save previous state for undo
    final prevStatus = booking.status;
    final prevRoomStatus = roomEntity.status;
    final prevCancelReason = booking.cancelReason;
    final prevCancelledAt = booking.cancelledAt;

    // Apply CANCELLATION
    booking.status = EnumBookingStatus.cancelled.name;
    booking.cancelReason = reason;
    booking.cancelledAt = DateTime.now().toIso8601String();

    boxBooking.put(booking);

    // Update room state
    roomEntity.status = EnumRoomStatus.available.name;
    roomEntity.bookingUuid = null;
    boxRoom.put(roomEntity);
    room.refresh();

    SnackbarUtil.showUndo(
      message: "Reservation cancelled",
      undoText: "UNDO",
      onUndo: () {
        // Revert booking
        booking.status = prevStatus;
        booking.cancelReason = prevCancelReason;
        booking.cancelledAt = prevCancelledAt;
        boxBooking.put(booking);

        // Restore old room state
        roomEntity.status = prevRoomStatus;
        roomEntity.bookingUuid = prevStatus == EnumBookingStatus.reserved.name
            ? null
            : booking.bookingUuid;

        boxRoom.put(roomEntity);
        room.refresh();

        SnackbarUtil.showSuccess("Cancellation undone");
      },
    );
  }

  // CHECKOUT
  void checkoutBooking() {
    final booking = selectedBooking.value;
    if (booking == null) {
      SnackbarUtil.showError("No active booking to checkout.");
      return;
    }

    if (booking.status == EnumBookingStatus.reserved.name) {
      SnackbarUtil.showError("Cannot checkout a reservation.");
      return;
    }

    if ((double.tryParse(tecRemaining.text) ?? 0) > 0) {
      SnackbarUtil.showError("Please clear payment before checkout.");
      return;
    }

    final roomEntity = booking.room.target!;
    final task = EntityTask(
      taskType: "cleaning_checkout",
      status: "pending",
      reason: "Checkout Cleaning",
      createdAt: DateTime.now().toIso8601String(),
    );

    task.booking.target = booking;
    task.room.target = roomEntity;

    final boxTask = Get.find<ServiceObjectBox>().store.box<EntityTask>();
    boxTask.put(task);

    roomEntity.status = EnumRoomStatus.cleaning.name;
    boxRoom.put(roomEntity);

    // new added field for change room history
    final historyList = boxRoomChange
        .query(EntityRoomChangeHistory_.bookingId.equals(booking.bookingId))
        .build()
        .find();

    if (historyList.isNotEmpty) {
      final last = historyList.last;
      last.newRoomCheckOut = DateTime.now().toIso8601String();
      boxRoomChange.put(last);
    }

    SnackbarUtil.showSuccess("Checkout successful. Cleaning task created.");
  }

  // ---------------------- SUMMARY GETTERS FOR UI ----------------------

  double get roomRate {
    final double perDayPrice =
        double.tryParse(room.value.price?.toString() ?? "0") ?? 0.0;

    final int days = getStayDays();

    return perDayPrice * days;   // ✅ PER DAY × NO. OF DAYS
  }


  //
  // double get amenitiesTotal {
  //   double total = 0.0;
  //   for (var a in rxListAmenities) {
  //     total += (a.price ?? 0) * (a.qty ?? 1);
  //   }
  //   return total;
  // }
  double get amenitiesTotal {
    double total = 0.0;
    for (var a in rxListAmenities) {
      total += (a.price ?? 0) * (a.qty ?? 1);
    }
    return total;
  }

  double get totalBill {
    return double.tryParse(totalCtrl.text) ?? 0.0;
  }

  double get paidAmount {
    return rxListPayment.fold(0.0, (sum, p) => sum + (p.amount));
  }

  double get remainingAmount {
    return totalBill - paidAmount;
  }

  int getStayDays() {
    try {
      final checkIn = DateTime.parse(checkInCtrl.text);
      final checkOut = DateTime.parse(checkOutCtrl.text);

      final diff = checkOut.difference(checkIn).inHours;

      //  Minimum 1 day charge
      final days = (diff / 24).ceil();
      return days < 1 ? 1 : days;
    } catch (e) {
      return 1; // fallback safety
    }
  }

  void showEditPaymentDialog(EntityPayment payment) {
    final currencyService = Get.find<ServiceCurrency>();

    final amtCtrl = TextEditingController(text: payment.amount.toString());
    final txnCtrl = TextEditingController(text: payment.transactionId ?? "");
    final RxString selectedMode = payment.paymentMode.obs;

    final List<String> paymentModes = [
      'Cash',
      'Credit Card',
      'Debit Card',
      'UPI',
      'Net Banking',
      'Wallet',
    ];

    Get.dialog(
      Material(
        type: MaterialType.transparency,
        child: AlertDialog(
          title: const Text("Edit Payment"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Payment Mode',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                initialValue: selectedMode.value,
                items: paymentModes.map((mode) {
                  return DropdownMenuItem(value: mode, child: Text(mode));
                }).toList(),
                onChanged: (value) {
                  if (value != null) selectedMode.value = value;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: txnCtrl,
                decoration: const InputDecoration(labelText: "Transaction ID"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: amtCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Amount (${currencyService.symbol})",
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: Get.back, child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                payment.paymentMode = selectedMode.value;
                payment.transactionId = txnCtrl.text;
                payment.amount = double.tryParse(amtCtrl.text) ?? 0;
                boxPayment.put(payment);   // ✅ DATABASE UPDATE
                rxListPayment.refresh();
                updateTotal();

                Get.back();
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  void addSplitPayments(double cash, double card, double upi) {
    final repo = Get.find<RepoGetStorage>();
    final hotelUuid = repo.getHotelUuid() ?? "";
    final currency = Get.find<ServiceCurrency>().currency.value;

    // CASH
    if (cash > 0) {
      rxListPayment.add(
        EntityPayment(
          paymentUuid: "P-${DateTime.now().millisecondsSinceEpoch}",
          paymentMode: "Cash",
          amount: cash,
          currency: currency,
          hotelUuid: hotelUuid,
          createdAt: DateTime.now().toString(),
        ),
      );
    }

    // CARD
    if (card > 0) {
      rxListPayment.add(
        EntityPayment(
          paymentUuid: "P-${DateTime.now().millisecondsSinceEpoch}",
          paymentMode: "Card",
          amount: card,
          currency: currency,
          hotelUuid: hotelUuid,
          createdAt: DateTime.now().toString(),
        ),
      );
    }

    // UPI
    if (upi > 0) {
      rxListPayment.add(
        EntityPayment(
          paymentUuid: "P-${DateTime.now().millisecondsSinceEpoch}",
          paymentMode: "UPI",
          amount: upi,
          currency: currency,
          hotelUuid: hotelUuid,
          createdAt: DateTime.now().toString(),
        ),
      );
    }

    updateTotal();
  }

  void autoCreateSplitPayments(List<Map<String, dynamic>> result) {
    final booking = selectedBooking.value;
    if (booking == null) {
      SnackbarUtil.showError("Booking not found for split.");
      return;
    }

    // ✅ Clear old payments
    rxListPayment.clear();

    // ✅ Clear old splits of this booking
    final oldSplits = boxSplitBill
        .query(EntitySplitBill_.bookingUuid.equals(booking.bookingUuid))
        .build()
        .find();

    for (var s in oldSplits) {
      boxSplitBill.remove(s.id);
    }

    double totalSplitAmount = 0;

    // ✅ Create new split + payment
    for (var r in result) {
      final double amt = (r["amount"] as num).toDouble();
      totalSplitAmount += amt;

      final split = EntitySplitBill(
        hotelUuid: _repoGetStorage.getHotelUuid(),
        bookingUuid: booking.bookingUuid,
        guestUuid: r["guestUuid"], // 👈 yahin add hua
        type: r["type"] ?? "guest",
        label: r["label"] ?? "Split",
        paymentMode: r["paymentMode"] ?? "Cash", // 👈 real payment mode
        amount: amt,
        createdAt: DateTime.now().toIso8601String(),
      );

      // ✅ SAVE SPLIT IN DB
      boxSplitBill.put(split);

      // ✅ Create payment also
      rxListPayment.add(
        EntityPayment(
          paymentMode: split.paymentMode!,
          amount: amt,
          paymentUuid: DateTime.now().microsecondsSinceEpoch.toString(),
          hotelUuid: _repoGetStorage.getHotelUuid()!,
          currency: "INR",
          createdAt: DateTime.now().toString(),
        ),
      );
    }

    // ✅ Safety adjustment
    final double billTotal = totalBill;

    if (totalSplitAmount != billTotal && rxListPayment.isNotEmpty) {
      final double diff = billTotal - totalSplitAmount;
      rxListPayment.last.amount += diff;

      // last split adjusting
      final lastSplit = boxSplitBill
          .query(EntitySplitBill_.bookingUuid.equals(booking.bookingUuid))
          .build()
          .find()
          .last;

      lastSplit.amount += diff;
      boxSplitBill.put(lastSplit);
    }

    updateTotal();
    SnackbarUtil.showSuccess("Split Bill Saved Successfully!");
  }
}
