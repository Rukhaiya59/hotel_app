import 'package:get/get.dart';
import 'package:hotel/screens/home/fragment/lost&found/frag_home_lost_and_found.dart';
import 'package:hotel/screens/home/fragment/maintenance/frag_home_maintenance.dart';
import 'package:hotel/screens/home/fragment/room/frag_home_room.dart';
import 'package:hotel/screens/home/fragment/setting/frag_home_setting.dart';
import 'package:hotel/screens/sample/activity_main.dart';
import '../screens/home/activity_home.dart';
import '../screens/home/fragment/booking/frag_home_booking.dart';
import '../screens/home/fragment/booking_history/Frag_booking_history.dart';
import '../screens/home/fragment/inventory/frag_home_inventory.dart';
import '../screens/home/fragment/task/frag_home_task.dart';
import '../screens/home/fragment/user/frag_home_user.dart';
import '../screens/login/activity_login.dart';
import '../screens/sample/binding_sample.dart';
import '../screens/splash/activity_splash.dart';


class AppRoute {
  static const splash = "/";
  static const sample = "/sample";
  static const home = "/home";
  static const login = "/login";
  static const userHome = "/userHome";
  static const roomHome = "/roomHome";

  // static const task= "/task";
  // static const lostFound = "/lostFound";
  static const booking = "/booking";
  static const bookingHistory = "/bookingHistory";
  static const inventory = "/inventory";
  static const maintenance = "/maintenance";

  static const setting ="/setting";//

  static final pages = <GetPage>[
    GetPage(name: splash, page: () => ActivitySplash()),
    GetPage(name: sample, page: () => const ActivitySample(),binding: BindingSample(),),
    GetPage(name: home, page: () => const ActivityHome()),
    GetPage(name: login, page: () => const ActivityLogin()),
    GetPage(name: userHome, page: () => const FragHomeUser()),
    // GetPage(name: task, page: () =>  const FragHomeTask()),
    // GetPage(name: lostFound, page: () =>const  FragHomeLostAndFound()),
    GetPage(name: roomHome, page: () => const FragHomeRoom()),
    GetPage(name: setting, page: () => const FragHomeSetting()),
    GetPage(name: booking, page: () => const FragHomeBooking()),
    GetPage(name: bookingHistory, page: () => const FragBookingHistory()),
    GetPage(name: inventory, page:()=> const FragHomeInventory()),
    GetPage(name: maintenance, page:()=> const FragHomeMaintenance())



  ];
}
