import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../model/entity_booking.dart';
import '../../objectbox.g.dart';
import '../../service/service_object_box.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ControllerCheckinCheckout extends GetxController {
  late final Box<EntityBooking> box;
  final obj = Get.find<ServiceObjectBox>();

  var all = <EntityBooking>[].obs;
  var filteredList = <EntityBooking>[].obs;

  var totalCheckins = 0.obs;
  var totalCheckouts = 0.obs;
  var earlyCheckins = 0.obs;
  var earlyCheckouts = 0.obs;

  final df = DateFormat("yyyy-MM-dd HH:mm");

  @override
  void onInit() {
    super.onInit();
    box = obj.box<EntityBooking>();
    load();
  }

  void load() {
    all.value = box.getAll();
    filteredList.value = List.from(all);
    summary();
  }

  DateTime parseDT(String s) {
    try {
      return df.parse(s);
    } catch (_) {
      return DateTime(2000);
    }
  }

  bool isEarlyCheckin(EntityBooking b) {
    final ci = parseDT(b.checkInDate);
    final std = DateTime(ci.year, ci.month, ci.day, 12);
    return ci.isBefore(std);
  }

  bool isEarlyCheckout(EntityBooking b) {
    final co = parseDT(b.checkOutDate);
    final std = DateTime(co.year, co.month, co.day, 11);
    return co.isBefore(std);
  }
  Future<void> exportReportPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) {
          return [

            pw.Center(
              child: pw.Text(
                "Check-in / Checkout Report",
                style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),

            pw.Text("Summary", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),

            pw.Text("Total Check-ins: ${totalCheckins.value}"),
            pw.Text("Total Check-outs: ${totalCheckouts.value}"),
            pw.Text("Early Check-ins: ${earlyCheckins.value}"),
            pw.Text("Early Check-outs: ${earlyCheckouts.value}"),

            pw.SizedBox(height: 20),
            pw.Divider(),

            pw.Text("Detailed Report",
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),

            pw.Table.fromTextArray(
              headers: ["Guest", "Room", "Check-in", "Check-out", "Status"],
              data: filteredList.map((b) {
                return [
                  getGuestName(b),
                  getRoomNo(b),
                  fmt(b.checkInDate),
                  fmt(b.checkOutDate),
                  b.status,
                ];
              }).toList(),
            )
          ];
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: "checkin_checkout_report.pdf",
    );
  }

  // Summary calculation
  void summary() {
    totalCheckins.value =
        filteredList.where((b) => b.status == "Checked-In").length;

    totalCheckouts.value =
        filteredList.where((b) => b.status == "Checked-Out").length;

    earlyCheckins.value = filteredList
        .where((b) => b.status == "Checked-In" && isEarlyCheckin(b))
        .length;

    earlyCheckouts.value = filteredList
        .where((b) => b.status == "Checked-Out" && isEarlyCheckout(b))
        .length;
  }
  void applySearch(String text) {
    text = text.toLowerCase();

    filteredList.value = all.where((b) {
      final guest = getGuestName(b).toLowerCase();
      final room = getRoomNo(b).toLowerCase();
      final id = b.bookingId.toString().toLowerCase();

      return guest.contains(text) ||
          room.contains(text) ||
          id.contains(text);
    }).toList();

    summary();  // <-- Correct place
  }



  // ------------------ DATE FILTERS ----------
  void applyDateFilter(String? v) {
    if (v == "All Dates") {
      filteredList.value = List.from(all);
    }

    if (v == "Today") {
      final now = DateTime.now();
      filteredList.value = all.where((b) {
        final ci = parseDT(b.checkInDate);
        return ci.year == now.year && ci.month == now.month && ci.day == now.day;
      }).toList();
    }

    if (v == "7 Days") {
      final limit = DateTime.now().subtract(const Duration(days: 7));
      filteredList.value = all.where((b) {
        final ci = parseDT(b.checkInDate);
        return ci.isAfter(limit);
      }).toList();
    }

    if (v == "Month") {
      final now = DateTime.now();
      filteredList.value = all.where((b) {
        final ci = parseDT(b.checkInDate);
        return ci.year == now.year && ci.month == now.month;
      }).toList();
    }

    summary();
  }

  // ------------------ STATUS FILTER -----------------
  void applyTypeFilter(String? v) {
    if (v == "All Checkins") {
      filteredList.value = List.from(all);
    }
    if (v == "Checked-In") {
      filteredList.value = all.where((b) => b.status == "Checked-In").toList();
    }
    if (v == "Checked-Out") {
      filteredList.value = all.where((b) => b.status == "Checked-Out").toList();
    }
    if (v == "Early-In") {
      filteredList.value =
          all.where((b) => b.status == "Checked-In" && isEarlyCheckin(b)).toList();
    }
    if (v == "Early-Out") {
      filteredList.value =
          all.where((b) => b.status == "Checked-Out" && isEarlyCheckout(b)).toList();
    }

    summary();
  }

  // ------------------ EXPORT (CSV) -----------------
  // void exportCSV() {
  //   final buffer = StringBuffer();
  //   buffer.writeln("Guest,Room,Check-in,Check-out,Status");
  //
  //   for (var b in filteredList) {
  //     buffer.writeln(
  //         "${getGuestName(b)},${getRoomNo(b)},${fmt(b.checkInDate)},${fmt(b.checkOutDate)},${b.status}");
  //   }
  //
  //   // Save CSV file logic — I'll add based on platform if you want.
  // }

  // // ------------------ BACKUP (JSON) -----------------
  // void createBackup() {
  //   final mapList = all.map((b) => b.toMap()).toList();
  //   final jsonStr = const JsonEncoder.withIndent("  ").convert(mapList);
  //
  //   // file writing code — will add if needed
  // }

  // UI helpers
  String getGuestName(EntityBooking b) {
    if (b.guest.isEmpty) return "Guest";
    final g = b.guest.first;
    return "${g.first} ${g.last}";
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

