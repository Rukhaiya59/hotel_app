import 'package:get/get.dart';
import 'package:hotel/screens/home/fragment/room/frag_home_room.dart';
import 'package:hotel/screens/home/fragment/setting/frag_home_setting.dart';
import 'package:hotel/screens/sample/activity_main.dart';
import '../screens/home/activity_home.dart';
import '../screens/home/fragment/booking/frag_home_booking.dart';
import '../screens/home/fragment/booking_history/Frag_booking_history.dart';
import '../screens/home/fragment/inventory/frag_home_inventory.dart';
import '../screens/home/fragment/maintenance/activity_maintenance_history.dart';
import '../screens/home/fragment/user/frag_home_user.dart';
import '../screens/login/activity_login.dart';
import '../screens/sample/binding_sample.dart';
import '../screens/splash/activity_splash.dart';
import '../screens/home/fragment/tax_group/activity_create_tax.dart';
import '../screens/splash/binding_splash.dart';


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
  static const createTax = "/createTax";


  static final pages = <GetPage>[
    GetPage(
      name: AppRoute.splash,
      page: () => const ActivitySplash(),
      binding: BindingSplash(),
    ),
    GetPage(name: sample, page: () => const ActivitySample(), binding: BindingSample()),
    GetPage(name: home, page: () => const ActivityHome()),
    GetPage(name: login, page: () => const ActivityLogin()),
    GetPage(name: userHome, page: () => const FragHomeUser()),
    GetPage(name: roomHome, page: () => const FragHomeRoom()),
    GetPage(name: setting, page: () => const FragHomeSetting()),
    GetPage(name: booking, page: () => const FragHomeBooking()),
    GetPage(name: bookingHistory, page: () => const FragBookingHistory()),
    GetPage(name: inventory, page:()=> const FragHomeInventory()),
    GetPage(name: maintenance, page:()=> ActivityMaintenanceHistory()),
    GetPage(name: createTax, page:()=> const ActivityCreateTax()),
  ];

}