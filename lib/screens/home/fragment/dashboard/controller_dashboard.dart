// lib/controller/controller_frag_dashboard.dart
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hotel/model/entity_booking.dart';
import 'package:hotel/model/entity_room.dart';
import 'package:hotel/service/service_object_box.dart';

class ControllerDashboard extends GetxController {
  final objectBox = Get.find<ServiceObjectBox>();

  // Revenues
  var dailyRevenue = 0.0.obs;
  var weeklyRevenue = 0.0.obs;
  var monthlyRevenue = 0.0.obs;
  var totalRevenue = 0.0.obs;

  // For the bar chart: Map of month -> revenue
  var monthlyRevenueMap = <String, double>{}.obs;

  // Bookings
  var totalBookings = 0.obs;
  var dailyBookings = 0.obs;
  var weeklyBookings = 0.obs;
  var monthlyBookings = 0.obs;

  // Room status summary
  var roomStatusCount = <String, int>{}.obs;

  // Loading + date filter
  var isLoading = false.obs;
  DateTime? startDate;
  DateTime? endDate;

  void fetchReportData({DateTime? start, DateTime? end}) {
    isLoading(true);
    startDate = start;
    endDate = end;

    final boxBooking = objectBox.store.box<EntityBooking>();
    final boxRoom = objectBox.store.box<EntityRoom>();

    final allBookings = boxBooking.getAll();

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final monthStart = DateTime(now.year, now.month, 1);

    double total = 0, daily = 0, weekly = 0, monthly = 0;

    // Reset counters
    int dailyCount = 0, weeklyCount = 0, monthlyCount = 0;

    final Map<String, double> monthMap = {};

    for (var b in allBookings) {
      final checkIn = DateTime.tryParse(b.checkInDate);
      if (checkIn == null) continue;

      // Revenue sums
      total += b.totalBill;
      if (checkIn.isAfter(todayStart)) {
        daily += b.totalBill;
        dailyCount++;
      }
      if (checkIn.isAfter(weekStart)) {
        weekly += b.totalBill;
        weeklyCount++;
      }
      if (checkIn.isAfter(monthStart)) {
        monthly += b.totalBill;
        monthlyCount++;
      }

      // Monthly chart data
      final monthKey = DateFormat('MMM').format(checkIn);
      monthMap[monthKey] = (monthMap[monthKey] ?? 0) + b.totalBill;
    }

    // Assign reactive values
    totalRevenue.value = total;
    dailyRevenue.value = daily;
    weeklyRevenue.value = weekly;
    monthlyRevenue.value = monthly;
    monthlyRevenueMap.assignAll(monthMap);

    totalBookings.value = allBookings.length;
    dailyBookings.value = dailyCount;
    weeklyBookings.value = weeklyCount;
    monthlyBookings.value = monthlyCount;

    // Room Status
    final rooms = boxRoom.getAll();
    final Map<String, int> statusMap = {
      'available': 0,
      'busy': 0,
      'cleaning': 0,
      'blocked': 0,
      'unknown': 0,
    };

    for (var r in rooms) {
      final status = (r.status ?? 'unknown').toLowerCase();
      statusMap[status] = (statusMap[status] ?? 0) + 1;
    }

    roomStatusCount.assignAll(statusMap);
    isLoading(false);
  }

  @override
  void onInit() {
    fetchReportData();
    super.onInit();
    }
}