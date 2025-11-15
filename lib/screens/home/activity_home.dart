import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/commons/loader.dart';
import 'package:hotel/enums/enum_drawer_menu.dart';
import 'package:hotel/model/model_icon_string.dart';
import 'package:hotel/screens/home/fragment/maintenance/frag_home_maintenance.dart';
import 'package:hotel/screens/home/fragment/room/frag_home_room.dart';
import 'package:hotel/screens/home/fragment/setting/frag_home_setting.dart';
import 'package:hotel/screens/home/fragment/user/frag_home_user.dart';
import '../../util/app_color.dart';
import '../../util/static_method.dart';
import '../../widgets/primary_button.dart';
import 'controller_home.dart';
import 'fragment/booking/frag_home_booking.dart';
import 'fragment/booking_history/Frag_booking_history.dart';
import 'fragment/dashboard/frag_home_dashboard.dart';
import 'fragment/inventory/frag_home_inventory.dart';
import 'fragment/tax/frag_home_tax.dart';
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
            flex: 2,
            child: Container(
              // decoration: BoxDecoration(
              //   gradient: AppTheme.gradient(
              //     isDark: Theme.of(context).brightness == Brightness.dark,
              //   ),
              // ),
              color: Colors.black26,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 25),
                  Center(
                    child: Text(
                      "HMS",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  Divider(
                    color: Colors.white24, // subtle divider
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
              if (controller.rxSelectedDrawer.value.title ==
                  EnumDrawerMenu.booking.value.tr) {
                return FragHomeBooking();
              }
              if (controller.rxSelectedDrawer.value.title ==
                  EnumDrawerMenu.bookingHistory.value.tr) {
                return FragBookingHistory();
              }
              if (controller.rxSelectedDrawer.value.title ==
                  EnumDrawerMenu.inventory.value.tr) {
                return FragHomeInventory();
              }
              if (controller.rxSelectedDrawer.value.title ==
                  EnumDrawerMenu.tax.value.tr) {
                return FragmentTax();
              }

              if (controller.rxSelectedDrawer.value.title ==
                  EnumDrawerMenu.maintenance.value.tr) {
                return FragHomeMaintenance();
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
            color: LightColor.primaryStart,
            onPressed: () async {
              Loader.showLoader();
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
        // } else if (controller.rxSelectedDrawer.value.title ==
        //     EnumDrawerMenu.task.value.tr) {
        //   return PrimaryButton(
        //     type: ActionType.add,
        //     color: LightColor.primaryStart,
        //     onPressed: () => Get.to(() => ActivityTask()),
        //   );
        // } else if (controller.rxSelectedDrawer.value.title ==
        //     EnumDrawerMenu.lostFound.value.tr) {
        //   return PrimaryButton(
        //     type: ActionType.add,
        //     color: LightColor.primaryStart,
        //     onPressed: () => Get.to(() => FragLostFoundCreate()),
        //   );
        }
        return const SizedBox();
      }),
    );
  }
}
