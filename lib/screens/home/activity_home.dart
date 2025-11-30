import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/commons/loader.dart';
import 'package:hotel/enums/enum_drawer_menu.dart';
import 'package:hotel/model/model_icon_string.dart';
import 'package:hotel/screens/home/histoy/activity_all_history.dart';
import 'package:hotel/screens/home/fragment/expenses/frag_home_expense_dashboard.dart';
import 'package:hotel/screens/home/fragment/guest/frag_home_guest.dart';
import 'package:hotel/screens/home/fragment/reservation/frag_home_reservation.dart';
import 'package:hotel/screens/home/fragment/room/frag_home_room.dart';
import 'package:hotel/screens/home/fragment/setting/frag_home_setting.dart';
import 'package:hotel/screens/home/fragment/user/frag_home_user.dart';
import '../../houskeeping/frag_home_housekeeping.dart';
import '../../reports/activity_report.dart';
import '../../util/app_color.dart';
import '../../util/static_method.dart';
import '../../widgets/primary_button.dart';
import 'controller_home.dart';
import 'fragment/booking/frag_home_booking.dart';
import 'fragment/dashboard/frag_home_dashboard.dart';
import 'fragment/disscount/activity_add_disscount.dart';
import 'fragment/disscount/frag_home_discount.dart';
import 'fragment/inventory/frag_home_inventory.dart';
import 'fragment/user/controller_user.dart';

class ActivityHome extends StatelessWidget {
  const ActivityHome({super.key});

  @override
  Widget build(BuildContext context) {
    ControllerHome controller = Get.put(ControllerHome());

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.black26,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 5),
                  Center(
                    child: Image.asset(
                      "assets/images/rh.png",
                      width: 120,     // adjust size as needed
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.all(20),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white.withValues(alpha: 0.15),
                  //     shape: BoxShape.circle,
                  //   ),
                  //   child: Icon(Icons.hotel, size: 60, color: Colors.white),
                  // ),

                  // const SizedBox(height: 10),
                  // const Text(
                  //   "HMS",
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 22,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),

                  const SizedBox(height: 20),
                  Expanded(
                    child: Obx(() {
                      return ListView.builder(
                        itemCount: controller.rxListDrawer.length,
                        itemBuilder: (context, index) {
                          ModelIconString itemModelIconString =
                              controller.rxListDrawer[index];
                          return ListTile(
                            leading: Icon(itemModelIconString.icon),
                            title: Text(itemModelIconString.title),
                            onTap: () {
                              Get.back();
                              if (EnumDrawerMenu.logout.value.tr ==
                                  itemModelIconString.title) {
                                // SnackbarUtil.showError
                                controller.logout();
                                return;
                              }
                              controller.rxSelectedDrawer.value =
                                  itemModelIconString;
                            },
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 8,
            child: Obx(() {
              debugPrint(
                "rxSelectedDrawer: called: title: ${controller.rxSelectedDrawer
                    .value.title}",
              );
              if (controller.rxSelectedDrawer.value.title ==
                  EnumDrawerMenu.dashboard.value.tr) {
                return FragHomeDashboard();
              }
              if (controller.rxSelectedDrawer.value.title ==
                  EnumDrawerMenu.user.value.tr) {
                Get.delete<ControllerUser>();
                return FragHomeUser();
              }
              if (controller.rxSelectedDrawer.value.title ==
                  EnumDrawerMenu.room.value.tr) {
                return FragHomeRoom();
              }
              if (controller.rxSelectedDrawer.value.title ==
                  EnumDrawerMenu.setting.value.tr) {
                return FragHomeSetting();
              }
              // if (controller.rxSelectedDrawer.value.title ==
              //     EnumDrawerMenu.task.value.tr) {
              //   return FragHomeTask();
              // }
              // if (controller.rxSelectedDrawer.value.title ==
              //     EnumDrawerMenu.lostFound.value.tr) {
              //   return FragHomeLostAndFound();
              // }

              // if (controller.rxSelectedDrawer.value.title ==
              //     EnumDrawerMenu.cleaning.value.tr) {
              //   return FragHousekeepingHistory();
              // }
              if (controller.rxSelectedDrawer.value.title ==
                  EnumDrawerMenu.reservation.value.tr) {
                return FragHomeReservation();
              }
              if (controller.rxSelectedDrawer.value.title ==
                  EnumDrawerMenu.guest.value.tr) {
                return FragHomeGuest();
              }
              if (controller.rxSelectedDrawer.value.title ==
                  EnumDrawerMenu.booking.value.tr) {
                return FragHomeBooking();
              }
              if (controller.rxSelectedDrawer.value.title ==
                  EnumDrawerMenu.hotelLogs.value.tr) {
                return ActivityAllHistory();
              }
              if (controller.rxSelectedDrawer.value.title ==
                  EnumDrawerMenu.inventory.value.tr) {
                return FragHomeInventory();
              }
              if (controller.rxSelectedDrawer.value.title ==
                  EnumDrawerMenu.report.value.tr) {
                return ActivityReport();
              }

              // if (controller.rxSelectedDrawer.value.title ==
              //     EnumDrawerMenu.maintenance.value.tr) {
              //   return ActivityMaintenanceHistory();
              // }
              if (controller.rxSelectedDrawer.value.title ==
                  EnumDrawerMenu.discount.value.tr) {
                return FragHomeDiscount();
              }

              if (controller.rxSelectedDrawer.value.title ==
                  EnumDrawerMenu.expense.value.tr) {
                return ActivityExpenseDashboard();
              }
              if (controller.rxSelectedDrawer.value.title ==
                  EnumDrawerMenu.cleanOps.value.tr) {
                return FragHomeHousekeeping();
              }
              return const SizedBox();
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        if (controller.rxSelectedDrawer.value.title ==
            EnumDrawerMenu.user.value.tr) {
          return PrimaryButton(
            type: ActionType.refresh,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey        // DARK = WHITE BUTTON
                  : Colors.grey,        // LIGHT = BLACK BUTTON            onPressed: () async {
             onPressed: () async{  Loader.showLoader();
              await StaticMethod.loadUsersFromJson(controller.boxUser);
              ModelIconString selectedItem = controller.rxListDrawer.firstWhere(
                (item) {
                  debugPrint("item.title: ${item.title}");
                  return item.title == EnumDrawerMenu.user.value.tr;
                },
              );
              debugPrint("refresh: selectedItem: ${selectedItem.title}");
              controller.rxSelectedDrawer.trigger(selectedItem);
              Loader.hideLoader();
            },
          );
        }  if (controller.rxSelectedDrawer.value.title ==
            EnumDrawerMenu.discount.value.tr) {
          return PrimaryButton(
            type: ActionType.add,
            color: LightColor.primaryStart,
            onPressed: () {
              Get.dialog(
                const ActivityAddDiscount(),
                barrierDismissible: false,
              );
            },
          );
        }

        return const SizedBox();
      }));
        }}
