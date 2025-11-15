import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel/util/snackbar_util.dart';
import 'package:objectbox/objectbox.dart';

import '../../model/entity_amenities.dart';
import '../../model/entity_room.dart';
import '../../service/service_object_box.dart';

class ControllerRoom extends GetxController {
  late Box<EntityRoom> boxRoom;
  final RxList<EntityRoom> rxListRooms = <EntityRoom>[].obs;

  @override
  void onInit() {
    final ob = Get.find<ServiceObjectBox>();
    boxRoom = ob.box<EntityRoom>();
    getAllRooms();
    super.onInit();
  }

  /// Fetch all rooms
  void getAllRooms() {
    debugPrint("getAllRooms()");
    var listRoom = boxRoom.getAll();
    for (EntityRoom roomItem in listRoom) {
      debugPrint("roomItem: ${json.encode(roomItem.toMap())}");
    }
    rxListRooms.value = listRoom;
  }

  /// Delete room by ID
  void deleteRoom(int id) {
    boxRoom.remove(id);
  }

  /// Search in amenities
  bool _searchAmenities(List<EntityAmenities> amenities, String query) {
    for (final amenity in amenities) {
      if (amenity.name?.toLowerCase().contains(query) ?? false) {
        return true;
      }
    }
    return false;
  }

  /// Get room by ID
  EntityRoom? getRoomById(int id) {
    try {
      return boxRoom.get(id);
    } catch (e) {
      debugPrint('Error getting room by ID: $e');
      return null;
    }
  }

  /// Add new room
  void addRoom(EntityRoom room) {
    boxRoom.put(room);
    getAllRooms();
    SnackbarUtil.showSuccess("Room added successfully");
  }

  /// Update existing room
  void updateRoom(EntityRoom room) {
    boxRoom.put(room);
    getAllRooms();
    SnackbarUtil.showSuccess("Room updated successfully");

  }

  /// Refresh rooms data
  void refreshRooms() {
    getAllRooms();
  }
}