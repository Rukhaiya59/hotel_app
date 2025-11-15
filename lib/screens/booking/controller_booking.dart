// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hotel/enums/enum_booking_status.dart';
// import 'package:hotel/enums/enum_booking_type.dart';
// import 'package:hotel/enums/enum_room_status.dart';
// import 'package:hotel/model/entity_amenities.dart';
// import 'package:hotel/model/entity_booking.dart';
// import 'package:hotel/model/entity_guest.dart';
// import 'package:hotel/model/entity_payment.dart';
// import 'package:hotel/model/entity_room.dart';
// import 'package:hotel/objectbox.g.dart';
// import 'package:hotel/service/service_object_box.dart';
// import 'package:intl/intl.dart';
// import 'package:mongo_dart/mongo_dart.dart' as mongo;
//
// import '../../repository/repo_get_storage.dart';
// import '../../util/snackbar_util.dart';
// import 'print/booking_print_overview.dart';
//
// class ControllerBooking extends GetxController {
//   final EntityRoom initialRoom;
//
//   ControllerBooking({required this.initialRoom});
//
//   final RepoGetStorage _repoGetStorage = Get.find();
//   late Box<EntityBooking> boxBooking;
//   late Box<EntityRoom> boxRoom;
//   late Box<EntityGuest> boxGuest;
//   late Box<EntityPayment> boxPayment;
//   late Box<EntityAmenities> boxAmenities;
//
//   final Rx<EntityRoom> room = EntityRoom().obs; //  Reactive room object
//   final Rxn<EntityBooking> selectedBooking = Rxn<EntityBooking>();
//   final RxList<EntityGuest> rxListGuest = <EntityGuest>[].obs;
//   final RxList<EntityPayment> rxListPayment = <EntityPayment>[].obs;
//   final RxString paymentMethod = "Cash".obs;
//   final RxList<EntityAmenities> rxListAmenities = <EntityAmenities>[].obs;
//
//   late TextEditingController checkInCtrl;
//   late TextEditingController checkOutCtrl;
//   late TextEditingController totalCtrl;
//   late TextEditingController notesCtrl;
//   late TextEditingController tecDiscountDescription;
//   late TextEditingController tecDiscountPrice;
//   late TextEditingController tecPaidAmount;
//   late TextEditingController tecRemaining;
//
//   @override
//   void onInit() {
//     super.onInit();
//     final ob = Get.find<ServiceObjectBox>();
//
//     boxBooking = ob.store.box<EntityBooking>();
//     boxRoom = ob.store.box<EntityRoom>();
//     boxGuest = ob.store.box<EntityGuest>();
//     boxPayment = ob.store.box<EntityPayment>();
//     boxAmenities = ob.store.box<EntityAmenities>();
//
//     checkInCtrl = TextEditingController();
//     checkOutCtrl = TextEditingController();
//     totalCtrl = TextEditingController();
//     notesCtrl = TextEditingController();
//     tecDiscountDescription = TextEditingController();
//     tecDiscountPrice = TextEditingController();
//     tecPaidAmount = TextEditingController();
//     tecRemaining = TextEditingController();
//
//     room.value = initialRoom;
//
//     if (room.value.status == EnumRoomStatus.busy.name) {
//       getBookingDetails();
//     } else {
//       checkInCtrl.text = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
//       checkOutCtrl.text = DateFormat(
//         'yyyy-MM-dd HH:mm',
//       ).format(DateTime.now().add(const Duration(days: 1)));
//       totalCtrl.text = (room.value.price ?? 0).toStringAsFixed(2);
//       notesCtrl.text = "";
//     }
//   }
//
//   @override
//   void onClose() {
//     checkInCtrl.dispose();
//     checkOutCtrl.dispose();
//     totalCtrl.dispose();
//     notesCtrl.dispose();
//     super.onClose();
//   }
//
//   //  Save booking and update instantly
//   Future<EntityBooking> addBooking(EntityBooking booking) async {
//     final id = boxBooking.put(booking);
//     final savedBooking = boxBooking.get(id)!;
//     room.update((r) {
//       if (r != null) {
//         r.status = EnumRoomStatus.busy.name;
//         r.bookingUuid = booking.bookingUuid;
//       }
//     });
//     boxRoom.put(room.value);
//     room.refresh();
//     return savedBooking;
//   }
//
//   //  Update room status instantly + persist
//   void updateRoomStatus(EnumRoomStatus status) {
//     room.update((r) {
//       if (r != null) r.status = status.name;
//     });
//     boxRoom.put(room.value);
//     room.refresh(); //  Instantly rebuild UI
//   }
//
//   // prefill data if already booked
//   Future<void> getBookingDetails() async {
//     try {
//       if (room.value.bookingUuid == null) return;
//
//       final query = boxBooking
//           .query(EntityBooking_.bookingUuid.equals(room.value.bookingUuid!))
//           .build();
//       final booking = query.findFirst();
//       query.close();
//
//       if (booking != null) {
//         selectedBooking.value = booking;
//         rxListGuest.assignAll(booking.guest.toList());
//         rxListPayment.assignAll(booking.payment.toList());
//         rxListAmenities.assignAll(booking.amenities.toList());
//         // if (booking.discount.target != null) {
//         //   selectedDiscount.value = booking.discount.target;
//         // }
//
//         tecDiscountPrice.text = booking.discountPrice.toString();
//         tecDiscountDescription.text = booking.discountDesc ?? "";
//         checkInCtrl.text = booking.checkInDate;
//         checkOutCtrl.text = booking.checkOutDate;
//         totalCtrl.text = booking.totalBill.toStringAsFixed(2);
//         notesCtrl.text = booking.notes ?? '';
//         updateTotal();
//         Get.log("Prefilled booking data for room: ${room.value.roomUuid}");
//       }
//     } catch (e) {
//       Get.log("Error loading booking: $e");
//     }
//   }
//
//   //  Pick DateTime
//   Future<String?> pickDateTime(BuildContext context) async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );
//     if (date == null) return null;
//
//     final time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (time == null) return null;
//
//     final combined = DateTime(
//       date.year,
//       date.month,
//       date.day,
//       time.hour,
//       time.minute,
//     );
//     return DateFormat('yyyy-MM-dd HH:mm').format(combined);
//   }
//   Future<void> saveBooking() async {
//     if (rxListGuest.isEmpty) {
//       SnackbarUtil.showError("Please add at least one guest.");
//       return;
//     }
//
//     // 🟩 Create new booking
//     final booking = EntityBooking(
//       bookingUuid: mongo.ObjectId().oid,
//       totalBill: double.tryParse(totalCtrl.text) ?? 0.0,
//       discountPrice: double.tryParse(tecDiscountPrice.text) ?? 0.0,
//       discountDesc: tecDiscountDescription.text,
//       hotelUuid: _repoGetStorage.getHotelUuid()!,
//       checkInDate: checkInCtrl.text,
//       checkOutDate: checkOutCtrl.text,
//       bookingType: EnumBookingType.walkIn.toString(),
//       status: EnumBookingStatus.confirmed.toString(),
//       notes: notesCtrl.text,
//     );
//
//     // 🟨 Add guests, room, amenities, payments
//     booking.guest.addAll(rxListGuest);
//     booking.room.target = room.value;
//     booking.amenities.addAll(rxListAmenities);
//     booking.payment.addAll(rxListPayment);
//
//     // 🟦 Save booking in ObjectBox
//     final savedBooking = await addBooking(booking);
//
//     // 🟧 Update room status
//     updateRoomStatus(EnumRoomStatus.busy);
//     SnackbarUtil.showSuccess("Room booked successfully!");
//
//     // 🟨 Store selected booking for reference
//     selectedBooking.value = savedBooking;
//
//     // 🟪 Small delay to refresh UI (optional)
//     await Future.delayed(const Duration(milliseconds: 300));
//
//     // 🟩 Navigate to A4 Overview page
//     Get.to(() => BookingPrintOverview(booking: savedBooking));
//   }
//
//
//   Future<void> updateTotal() async {
//     double roomPrice = room.value.price ?? 0.0;
//     double discountPrice = double.tryParse(tecDiscountPrice.text) ?? 0.0;
//     double amenitiesPrice = 0.0;
//     // double paidAmount = double.tryParse(tecPaidAmount.text) ?? 0.0;
//     // double remaining = double.tryParse(tecRemaining.text) ?? 0.0;
//     for (EntityAmenities amenity in rxListAmenities) {
//       amenitiesPrice += amenity.price ?? 0.0;
//     }
//
//     double total = roomPrice + amenitiesPrice - discountPrice;
//     totalCtrl.text = total.toStringAsFixed(2);
//
//     double paidAmount = 0.0;
//     for (EntityPayment payment in rxListPayment) {
//       paidAmount += payment.amount;
//     }
//     tecRemaining.text = (total - paidAmount).toStringAsFixed(2);
//     tecPaidAmount.text = paidAmount.toStringAsFixed(2);
//   }
// }
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
import 'package:hotel/objectbox.g.dart';
import 'package:hotel/service/service_object_box.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

import '../../repository/repo_get_storage.dart';
import '../../util/snackbar_util.dart';
import 'print/booking_print_overview.dart';

class ControllerBooking extends GetxController {
  final EntityRoom initialRoom;

  ControllerBooking({required this.initialRoom});

  final RepoGetStorage _repoGetStorage = Get.find();
  late Box<EntityBooking> boxBooking;
  late Box<EntityRoom> boxRoom;
  late Box<EntityGuest> boxGuest;
  late Box<EntityPayment> boxPayment;
  late Box<EntityAmenities> boxAmenities;

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

  @override
  void onInit() {
    super.onInit();
    final ob = Get.find<ServiceObjectBox>();

    boxBooking = ob.store.box<EntityBooking>();
    boxRoom = ob.store.box<EntityRoom>();
    boxGuest = ob.store.box<EntityGuest>();
    boxPayment = ob.store.box<EntityPayment>();
    boxAmenities = ob.store.box<EntityAmenities>();

    checkInCtrl = TextEditingController();
    checkOutCtrl = TextEditingController();
    totalCtrl = TextEditingController();
    notesCtrl = TextEditingController();
    tecDiscountDescription = TextEditingController();
    tecDiscountPrice = TextEditingController();
    tecPaidAmount = TextEditingController();
    tecRemaining = TextEditingController();

    room.value = initialRoom;

    if (room.value.status == EnumRoomStatus.busy.name) {
      getBookingDetails();
    } else {
      checkInCtrl.text = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
      checkOutCtrl.text = DateFormat('yyyy-MM-dd HH:mm')
          .format(DateTime.now().add(const Duration(days: 1)));
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
    super.onClose();
  }

  //booking id

  // 🔥 Add this inside ControllerBooking class (NOT outside)
  int generateBookingId() {
    final repo = _repoGetStorage;
    final now = DateTime.now();

    final lastDateStr = repo.getLastBookingDate();
    final resetType = repo.getResetBookingType();
    final lastNumber = repo.getLastBookingNumber();

    DateTime? lastDate =
    lastDateStr.isEmpty ? null : DateTime.tryParse(lastDateStr);

    bool reset = false;

    switch (resetType) {
      case "Daily":
        reset = lastDate == null ||
            now.difference(lastDate).inDays >= 1;
        break;

      case "Weekly":
        reset = lastDate == null ||
            (now.weekday == DateTime.monday &&
                lastDate.weekday != DateTime.monday);
        break;

      case "Monthly":
        reset = lastDate == null ||
            now.month != lastDate.month ||
            now.year != lastDate.year;
        break;

      case "Quarterly":
        int cq = ((now.month - 1) ~/ 3) + 1;
        int lq = lastDate == null ? 0 : ((lastDate.month - 1) ~/ 3) + 1;
        reset =
            lastDate == null || cq != lq || now.year != lastDate.year;
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
//booking id

  // 🟢 Add Booking and update instantly
  Future<EntityBooking> addBooking(EntityBooking booking) async {
    final id = boxBooking.put(booking);
    final savedBooking = boxBooking.get(id)!;
    room.update((r) {
      if (r != null) {
        r.status = EnumRoomStatus.busy.name;
        r.bookingUuid = booking.bookingUuid;
      }
    });
    boxRoom.put(room.value);
    room.refresh();
    return savedBooking;
  }

  // 🟣 Update room status instantly
  void updateRoomStatus(EnumRoomStatus status) {
    room.update((r) {
      if (r != null) r.status = status.name;
    });
    boxRoom.put(room.value);
    room.refresh();
  }

  // 🟤 Prefill data for already booked room
  Future<void> getBookingDetails() async {
    try {
      if (room.value.bookingUuid == null) return;

      final query = boxBooking
          .query(EntityBooking_.bookingUuid.equals(room.value.bookingUuid!))
          .build();
      final booking = query.findFirst();
      query.close();

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
        notesCtrl.text = booking.notes ?? '';
        updateTotal();
        Get.log("Prefilled booking data for room: ${room.value.roomUuid}");
      }
    } catch (e) {
      Get.log("Error loading booking: $e");
    }
  }

  // 🟠 Pick DateTime
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

  // 🟩 Save Booking Flow (merged with your JSON + print navigation)
  Future<void> saveBooking() async {
    if (rxListGuest.isEmpty) {
      SnackbarUtil.showError("Please add at least one guest.");
      return;
    }

    final booking = EntityBooking(
      bookingId: generateBookingId(),//booking id
      bookingUuid: mongo.ObjectId().oid,
      totalBill: double.tryParse(totalCtrl.text) ?? 0.0,
      discountPrice: double.tryParse(tecDiscountPrice.text) ?? 0.0,
      discountDesc: tecDiscountDescription.text,
      hotelUuid: _repoGetStorage.getHotelUuid()!,
      checkInDate: checkInCtrl.text,
      checkOutDate: checkOutCtrl.text,
      bookingType: EnumBookingType.walkIn.name,
      status: EnumBookingStatus.confirmed.name,
      notes: notesCtrl.text,
    );

    // 🟨 Logging for debugging
    debugPrint("Booking Data: ${json.encode(booking.toMap())}");

    booking.guest.addAll(rxListGuest);
    for (var g in rxListGuest) {
      debugPrint("Guest: ${json.encode(g.toMap())}");
    }

    booking.room.target = room.value;
    debugPrint("Room: ${json.encode(room.value.toMap())}");

    booking.amenities.addAll(rxListAmenities);
    for (var a in rxListAmenities) {
      debugPrint("Amenity: ${json.encode(a.toMap())}");
    }

    booking.payment.addAll(rxListPayment);
    for (var p in rxListPayment) {
      debugPrint("Payment: ${json.encode(p.toMap())}");
    }

    // 🟦 Save to ObjectBox
    final savedBooking = await addBooking(booking);

    // 🟧 Update Room Status
    updateRoomStatus(EnumRoomStatus.busy);
    SnackbarUtil.showSuccess("Room booked successfully!");

    selectedBooking.value = savedBooking;

    // 🟪 Optional UI refresh delay
    await Future.delayed(const Duration(milliseconds: 300));

    // 🟩 Navigate to Print Overview
    Get.to(() => BookingPrintOverview(booking: savedBooking));
  }

  // 🟫 Update total + remaining
  Future<void> updateTotal() async {
    double roomPrice = room.value.price ?? 0.0;
    double discountPrice = double.tryParse(tecDiscountPrice.text) ?? 0.0;
    double amenitiesPrice = 0.0;

    for (EntityAmenities amenity in rxListAmenities) {
      amenitiesPrice += amenity.price ?? 0.0;
    }

    double total = roomPrice + amenitiesPrice - discountPrice;
    totalCtrl.text = total.toStringAsFixed(2);

    double paidAmount = 0.0;
    for (EntityPayment payment in rxListPayment) {
      paidAmount += payment.amount;
    }

    tecRemaining.text = (total - paidAmount).toStringAsFixed(2);
    tecPaidAmount.text = paidAmount.toStringAsFixed(2);
  }
}
