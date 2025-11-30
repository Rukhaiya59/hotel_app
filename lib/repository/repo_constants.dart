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
            icon: Icons.meeting_room
            ,
            title: EnumDrawerMenu.room.value.tr),
        ModelIconString(
          icon: Icons.local_offer,
          title: EnumDrawerMenu.discount.value.tr,
        ),
        ModelIconString(
          icon: Icons.attach_money,
          title: EnumDrawerMenu.expense.value.tr,
        ),

        ModelIconString(
            icon:Icons.assessment,
            title: EnumDrawerMenu.report.value.tr),
        ModelIconString(
          icon: Icons.inventory_2,
          title: EnumDrawerMenu.inventory.value.tr,
        ),
        ModelIconString(
          icon:Icons.fact_check,
          title: EnumDrawerMenu.booking.value.tr,
        ),
        ModelIconString(
          icon: Icons.event_available,
          title: EnumDrawerMenu.reservation.value.tr,
        ),
        ModelIconString(
          icon: Icons.cleaning_services,
          title: EnumDrawerMenu.cleanOps.value.tr,
        ),

        ModelIconString(
          icon: Icons.receipt_long,
          title: EnumDrawerMenu.hotelLogs.value.tr,
        ),
        ModelIconString(
          icon:Icons.recent_actors,
          title: EnumDrawerMenu.guest.value.tr,
        ),


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
          icon: Icons.event_available_sharp,
          title: EnumDrawerMenu.reservation.value.tr,
        ),
        ModelIconString(
          icon: Icons.add_task,
          title: EnumDrawerMenu.cleanOps.value.tr,
        ),

        ModelIconString(
          icon: Icons.receipt_long,
          title: EnumDrawerMenu.hotelLogs.value.tr,
        ),
        ModelIconString(
          icon: Icons.person,
          title: EnumDrawerMenu.guest.value.tr,
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
      ];
      listReturn.addAll(listOwner);
    }

    if (strUserRole == EnumRole.manager.value) {
      List<ModelIconString> listOwner = [
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
