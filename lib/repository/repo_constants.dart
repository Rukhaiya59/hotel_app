import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../enums/enum_drawer_menu.dart';
import '../enums/enum_role.dart';
import '../model/model_icon_string.dart';

class RepoConstants {
  static List<ModelIconString> getSampleListForRole(String strUserRole) {
    debugPrint("getSampleListForRole: strUserRole: $strUserRole");
    List<ModelIconString> listReturn = [];

    if (strUserRole == EnumRole.owner.value) {
      List<ModelIconString> listOwner = [
        ModelIconString(
          icon: Icons.dashboard,
          title: EnumDrawerMenu.dashboard.value.tr,
        ),
        ModelIconString(
          icon: Icons.person,
          title: EnumDrawerMenu.user.value.tr,
        ),
        ModelIconString(
            icon: Icons.room,
            title: EnumDrawerMenu.room.value.tr),
        ModelIconString(
          icon: Icons.build,
          title: EnumDrawerMenu.maintenance.value.tr,
        ),
        ModelIconString(
            icon: Icons.receipt_long,
            title: EnumDrawerMenu.tax.value.tr),
      ];

      listReturn.addAll(listOwner);
      
    }

    if (strUserRole == EnumRole.receptionist.value) {
      List<ModelIconString> listOwner = [
        ModelIconString(
          icon: Icons.list_alt,
          title: EnumDrawerMenu.booking.value.tr,
        ),

        ModelIconString(
          icon: Icons.room_outlined,
          title: EnumDrawerMenu.bookingHistory.value.tr,
        ),
      ];
      listReturn.addAll(listOwner);
    }
    if (strUserRole == EnumRole.accountant.value) {
      List<ModelIconString> listOwner = [
        ModelIconString(
          icon: Icons.dashboard,
          title: EnumDrawerMenu.dashboard.value.tr,
        ),
      ];
      listReturn.addAll(listOwner);
    }

    if (strUserRole == EnumRole.housekeeping.value) {
      List<ModelIconString> listOwner = [
        ModelIconString(
          icon: Icons.dashboard,
          title: EnumDrawerMenu.dashboard.value.tr,
        ),
      ];
      listReturn.addAll(listOwner);
    }

    if (strUserRole == EnumRole.manager.value) {
      List<ModelIconString> listOwner = [
        // ModelIconString(
        //   icon: Icons.dashboard,
        //   title: EnumDrawerMenu.dashboard.value.tr,
        // ),
    // ModelIconString(
    // icon: Icons.task,
    // title: EnumDrawerMenu.task.value.tr,
    // ),
    //     ModelIconString(
    //       icon: Icons.find_in_page,
    //       title: EnumDrawerMenu.lostFound.value.tr,
    //     ),
        ModelIconString(
          icon: Icons.inventory,
          title: EnumDrawerMenu.inventory.value.tr,
        ),
      ];
      listReturn.addAll(listOwner);
    }
    listReturn.add(
        ModelIconString(
          icon: Icons.settings,
          title: EnumDrawerMenu.setting.value.tr,
        ),
    );
    listReturn.add(
      ModelIconString(
        icon: Icons.logout,
        title: EnumDrawerMenu.logout.value.tr,
      ),
    );
    return listReturn;
  }
}
