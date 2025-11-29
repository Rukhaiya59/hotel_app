import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

import '../model/entity_booking.dart';
import '../service/service_object_box.dart';

class ControllerBookingHistory extends GetxController {
  late final Box<EntityBooking> boxBooking;

  var all = <EntityBooking>[].obs;
  var filtered = <EntityBooking>[].obs;

  // Summary
  var totalBookings = 0.obs;
  var totalRevenue = 0.0.obs;
  var totalDiscount = 0.0.obs;
  var totalPaid = 0.0.obs;
  var totalPending = 0.0.obs;

  final df = DateFormat("yyyy-MM-dd HH:mm");

  @override
  void onInit() {
    super.onInit();
    final ob = Get.find<ServiceObjectBox>();
    boxBooking = ob.box<EntityBooking>();
    load();
  }

  void load() {
    all.value = boxBooking.getAll();
    filtered.value = List.from(all);
    _summary();
  }

  DateTime parseDT(String s) {
    try {
      return df.parse(s);
    } catch (_) {
      return DateTime(2000);
    }
  }

  int getNights(EntityBooking b) {
    final ci = parseDT(b.checkInDate);
    final co = parseDT(b.checkOutDate);
    if (co.isBefore(ci)) return 0;
    final diff = co.difference(ci).inDays;
    return diff == 0 ? 1 : diff;
  }

  double getPaid(EntityBooking b) {
    double paid = 0.0;
    for (final p in b.payment) {
      paid += p.amount;
    }
    return paid;
  }

  double getPending(EntityBooking b) {
    final pending = (b.totalBill) - getPaid(b);
    return pending < 0 ? 0 : pending;
  }

  // ---------------- SUMMARY ----------------
  void _summary() {
    totalBookings.value = filtered.length;

    double rev = 0;
    double disc = 0;
    double paid = 0;
    double pend = 0;

    for (final b in filtered) {
      rev += b.totalBill;
      disc += b.discountPrice!;
      paid += getPaid(b);
      pend += getPending(b);
    }

    totalRevenue.value = rev;
    totalDiscount.value = disc;
    totalPaid.value = paid;
    totalPending.value = pend;
  }

  // ---------------- SEARCH ----------------
  void applySearch(String text) {
    text = text.toLowerCase();

    filtered.value = all.where((b) {
      final guest = getGuestName(b).toLowerCase();
      final phone = getGuestPhone(b).toLowerCase();
      final room = getRoomNo(b).toLowerCase();
      final id = b.bookingId.toString().toLowerCase();

      return guest.contains(text) ||
          phone.contains(text) ||
          room.contains(text) ||
          id.contains(text);
    }).toList();

    _summary();
  }

  // ---------------- DATE FILTER ----------------
  void applyDateFilter(String? v) {
    if (v == null) return;

    if (v == "All") {
      filtered.value = List.from(all);
    } else if (v == "Today") {
      final now = DateTime.now();
      filtered.value = all.where((b) {
        final ci = parseDT(b.checkInDate);
        return ci.year == now.year &&
            ci.month == now.month &&
            ci.day == now.day;
      }).toList();
    } else if (v == "7 Days") {
      final limit = DateTime.now().subtract(const Duration(days: 7));
      filtered.value = all.where((b) {
        final ci = parseDT(b.checkInDate);
        return ci.isAfter(limit);
      }).toList();
    } else if (v == "Month") {
      final now = DateTime.now();
      filtered.value = all.where((b) {
        final ci = parseDT(b.checkInDate);
        return ci.year == now.year && ci.month == now.month;
      }).toList();
    }

    _summary();
  }

  // ---------------- STATUS FILTER ----------------
  void applyStatusFilter(String? v) {
    if (v == null || v == "All") {
      filtered.value = List.from(all);
    } else {
      filtered.value =
          all.where((b) => (b.status.toLowerCase() == v.toLowerCase())).toList();
    }
    _summary();
  }

  // ---------------- UI HELPERS ----------------
  String getGuestName(EntityBooking b) {
    if (b.guest.isEmpty) return "Guest";
    final g = b.guest.first;
    return "${g.first} ${g.last}";
  }

  String getGuestPhone(EntityBooking b) {
    if (b.guest.isEmpty) return "";
    final g = b.guest.first;
    return g.phone ?? "";
  }

  String getRoomNo(EntityBooking b) {
    return b.room.target?.number ?? "-";
  }

  String fmt(String s) {
    try {
      return DateFormat("dd/MM/yyyy hh:mm a").format(parseDT(s));
    } catch (_) {
      return s;
    }
  }
}
