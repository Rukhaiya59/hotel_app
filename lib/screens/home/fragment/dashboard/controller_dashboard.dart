import 'package:get/get.dart' hide Condition;
import 'package:intl/intl.dart';
import 'package:hotel/model/entity_booking.dart';
import 'package:hotel/model/entity_room.dart';
import 'package:hotel/objectbox.g.dart';
import 'package:hotel/service/service_object_box.dart';

class ControllerDashboard extends GetxController {
  final objectBox = Get.find<ServiceObjectBox>();

  // Revenues
  var dailyRevenue = 0.0.obs;
  var weeklyRevenue = 0.0.obs;
  var monthlyRevenue = 0.0.obs;
  var totalRevenue = 0.0.obs;

  // Bookings
  var totalBookings = 0.obs;
  var dailyBookings = 0.obs;
  var weeklyBookings = 0.obs;
  var monthlyBookings = 0.obs;

  // Room status summary
  var roomStatusCount = <String, int>{}.obs;

  // For the bar chart: month -> revenue (Jan, Feb, ...)
  var monthlyRevenueMap = <String, double>{}.obs;

  // For weekly room sales line graph (Mon..Sun)
  final List<String> weekDays = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  var weekRevenue = <double>[].obs; // length 7

  // Cashflow style: inflow only (abhi sirf sales, expenses module jab aaega tab outflow add)
  var weekInflow = <double>[].obs; // same as weekRevenue for now
  var weekOutflow = <double>[].obs; // all zero for now

  // Loading + date filter
  var isLoading = false.obs;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void onInit() {
    super.onInit();
    fetchReportData();
  }

  void fetchReportData({DateTime? start, DateTime? end}) {
    isLoading(true);
    startDate = start;
    endDate = end;

    try {
      final boxBooking = objectBox.store.box<EntityBooking>();
      final boxRoom = objectBox.store.box<EntityRoom>();

      // -------------------------------------------------------------------
      // 1) Load BOOKINGS with optional date-range filter using ObjectBox query
      // -------------------------------------------------------------------
      Query<EntityBooking> q;

      if (start == null && end == null) {
        // No filter -> all bookings (but via query, not getAll())
        q = boxBooking.query().build();
      } else {
        // Filter on checkInDate (stored as "yyyy-MM-dd HH:mm")
        Condition<EntityBooking>? cond;

        if (start != null) {
          // from start date 00:00
          final s = DateTime(start.year, start.month, start.day);
          final startStr = DateFormat('yyyy-MM-dd HH:mm').format(s);
          cond = EntityBooking_.checkInDate.greaterOrEqual(startStr);
        }

        if (end != null) {
          // till end date 23:59:59
          final e = DateTime(end.year, end.month, end.day, 23, 59, 59);
          final endStr = DateFormat('yyyy-MM-dd HH:mm').format(e);
          final cEnd = EntityBooking_.checkInDate.lessOrEqual(endStr);
          cond = (cond == null) ? cEnd : (cond & cEnd);
        }

        q = boxBooking.query(cond!).build();
      }

      final allBookings = q.find();
      q.close();

      // -------------------------------------------------------------------
      // 2) Prepare date ranges for stats
      // -------------------------------------------------------------------
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

      // Monday as start of week
      final weekStart = todayStart.subtract(Duration(days: now.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

      final monthStart = DateTime(now.year, now.month, 1);
      final monthEnd = DateTime(now.year, now.month + 1, 1)
          .subtract(const Duration(seconds: 1));

      double total = 0, daily = 0, weekly = 0, monthly = 0;
      int dailyCount = 0, weeklyCount = 0, monthlyCount = 0;

      // For monthly bar chart
      final Map<String, double> monthMapRaw = {};

      // For weekly line graph (Mon..Sun - current calendar week)
      final List<double> weeklyArray = List<double>.filled(7, 0.0);

      // -------------------------------------------------------------------
      // 3) Loop over filtered bookings once and compute everything
      // -------------------------------------------------------------------
      for (final b in allBookings) {
        final checkIn = DateTime.tryParse(b.checkInDate);
        if (checkIn == null) continue;

        final bill = b.totalBill;
        total += bill;

        // Today
        if (!checkIn.isBefore(todayStart) && !checkIn.isAfter(todayEnd)) {
          daily += bill;
          dailyCount++;
        }

        // Current calendar week (Mon..Sun)
        if (!checkIn.isBefore(weekStart) && !checkIn.isAfter(weekEnd)) {
          weekly += bill;
          weeklyCount++;

          final idx = checkIn.weekday - 1; // 1..7 -> 0..6
          if (idx >= 0 && idx < 7) {
            weeklyArray[idx] += bill;
          }
        }

        // Current month
        if (!checkIn.isBefore(monthStart) && !checkIn.isAfter(monthEnd)) {
          monthly += bill;
          monthlyCount++;
        }

        // Monthly chart per calendar month of this year
        if (checkIn.year == now.year) {
          final monthKey = DateFormat('MMM').format(checkIn); // Jan, Feb, ...
          monthMapRaw[monthKey] = (monthMapRaw[monthKey] ?? 0) + bill;
        }
      }

      // -------------------------------------------------------------------
      // 4) Assign revenue + booking counts
      // -------------------------------------------------------------------
      totalRevenue.value = total;
      dailyRevenue.value = daily;
      weeklyRevenue.value = weekly;
      monthlyRevenue.value = monthly;

      totalBookings.value = allBookings.length;
      dailyBookings.value = dailyCount;
      weeklyBookings.value = weeklyCount;
      monthlyBookings.value = monthlyCount;

      // -------------------------------------------------------------------
      // 5) Prepare monthly bar chart in Jan..Dec order
      // -------------------------------------------------------------------
      final orderedMonthMap = <String, double>{};
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      for (final m in months) {
        if (monthMapRaw.containsKey(m)) {
          orderedMonthMap[m] = monthMapRaw[m]!;
        }
      }
      monthlyRevenueMap.assignAll(orderedMonthMap);

      // -------------------------------------------------------------------
      // 6) Weekly revenue & cashflow arrays (always length 7)
      // -------------------------------------------------------------------
      weekRevenue.value = weeklyArray;
      weekInflow.value = List<double>.from(weeklyArray);
      weekOutflow.value = List<double>.filled(7, 0.0); // hook expenses later

      // -------------------------------------------------------------------
      // 7) Room status summary (rooms are usually small → getAll is fine)
      // -------------------------------------------------------------------
      final rooms = boxRoom.getAll();
      final Map<String, int> statusMap = {
        'available': 0,
        'busy': 0,
        'cleaning': 0,
        'blocked': 0,
        'unknown': 0,
      };

      for (final r in rooms) {
        final status = (r.status ?? 'unknown').toLowerCase();
        if (!statusMap.containsKey(status)) {
          statusMap['unknown'] = (statusMap['unknown'] ?? 0) + 1;
        } else {
          statusMap[status] = (statusMap[status] ?? 0) + 1;
        }
      }

      roomStatusCount.assignAll(statusMap);
    } finally {
      isLoading(false);
    }
  }
}
