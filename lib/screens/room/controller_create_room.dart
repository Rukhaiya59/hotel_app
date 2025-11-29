import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/enums/enum_room_status.dart';
import 'package:hotel/objectbox.g.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../../model/entity_amenities.dart';
import '../../model/entity_room.dart';
import '../../repository/repo_get_storage.dart';
import '../../service/service_object_box.dart';
import '../../util/app_translation.dart';
import '../../util/snackbar_util.dart';
import '../../util/static_method.dart';

class ControllerCreateRoom extends GetxController {
  final String? roomUuid;

  ControllerCreateRoom({this.roomUuid});

  late Box<EntityRoom> boxRoom;
  final RepoGetStorage _repoGetStorage = Get.find();

  // Text controllers
  final TextEditingController numberCtrl = TextEditingController();
  final TextEditingController capacityCtrl = TextEditingController();
  final TextEditingController floorCtrl = TextEditingController();
  final TextEditingController basePriceCtrl = TextEditingController(); // 👈 base price
  final TextEditingController priceCtrl = TextEditingController(); // 👈 total price
  final TextEditingController facilityPriceCtrl = TextEditingController();
  final TextEditingController facilityNameCtrl = TextEditingController();

  // Lists
  final RxList<Map<String, dynamic>> facilityList = <Map<String, dynamic>>[].obs;

  // Dropdown values
  final RxString selectedRoomType = 'Standard'.obs;
  final RxString selectedBedType = 'Single'.obs;
  final RxString selectedStatus = EnumRoomStatus.available.name.tr.obs;
  final RxString selectedCurrency = 'INR'.obs;

  final RxList<EntityAmenities> selectedAmenities = <EntityAmenities>[].obs;
  final Rx<EntityRoom?> editingRoom = Rx<EntityRoom?>(null);
  final RxString roomUuidObs = ''.obs;

  double basePrice = 0.0;
  double totalPrice = 0.0;

  List<String> get statuses => [
    EnumRoomStatus.available.name.tr,
    EnumRoomStatus.busy.name.tr,
    EnumRoomStatus.cleaning.name.tr,
    EnumRoomStatus.blocked.name.tr,
  ];

  List<String> get roomTypes => [
    'Standard',
    'Deluxe',
    'Executive',
    'Suite',
    'Family',
    'Presidential',
  ];

  List<String> get bedTypes => [
    'Single',
    'Double',
    'Twin',
    'Queen',
    'King',
    'Suite',
    'Dormitory',
  ];

  List<String> get currencies => ['INR', 'USD', 'EUR', 'GBP'];

  @override
  void onInit() {
    final ob = Get.find<ServiceObjectBox>();
    boxRoom = ob.box<EntityRoom>();
    getRoomByUuid();
    super.onInit();
  }

  Future<void> getRoomByUuid() async {
    if (roomUuid == null) return;
    final query = boxRoom.query(EntityRoom_.roomUuid.equals(roomUuid!)).build();
    final room = query.findFirst();
    if (room != null) {
      editRoom(room);
    }
  }

  /// Add Facility
  void addFacility() {
    if (facilityNameCtrl.text.isNotEmpty && facilityPriceCtrl.text.isNotEmpty) {
      final facilityPrice = double.tryParse(facilityPriceCtrl.text.trim()) ?? 0.0;

      facilityList.add({
        'name': facilityNameCtrl.text.trim(),
        'price': facilityPrice,
      });

      facilityNameCtrl.clear();
      facilityPriceCtrl.clear();

      updateTotalPrice();
    } else {
      SnackbarUtil.showError( "Please enter both facility name and price");
    }
  }

  /// Remove Facility
  void removeFacility(int index) {
    if (index >= 0 && index < facilityList.length) {
      facilityList.removeAt(index);
      updateTotalPrice();
    }
  }

  /// Update Total Price (Base + Facilities)
  /// Update Total Price (Base + Facilities)
  void updateTotalPrice({bool fromBaseChange = false}) {
    if (fromBaseChange) {
      basePrice = double.tryParse(basePriceCtrl.text.trim()) ?? 0.0;
    }

    double facilitiesTotal = 0.0;
    for (final f in facilityList) {
      facilitiesTotal += (f['price'] as double);
    }

    totalPrice = basePrice + facilitiesTotal;
    priceCtrl.text = totalPrice.toStringAsFixed(2);
  }


  /// Save room data
  void saveRoom() {
    String now = StaticMethod.getCurrentDateTimeToString();
    final room = editingRoom.value ?? EntityRoom();

    if (editingRoom.value == null) room.roomUuid = mongo.ObjectId().oid;
    room.hotelUuid = _repoGetStorage.getHotelUuid();
    room.bookingUuid = null;
    room.number = numberCtrl.text;
    room.floor = floorCtrl.text;

    String? statusKey = AppTranslation.getKeyFromValue(selectedStatus.value);
    room.status = statusKey;

    room.type = selectedRoomType.value;
    room.bedType = selectedBedType.value;
    room.roomType = selectedRoomType.value;
    room.price = double.tryParse(priceCtrl.text) ?? 0;
    room.capacity = int.tryParse(capacityCtrl.text.trim()) ?? 0;
    room.currency = selectedCurrency.value;

    room.createdOn = now;
    room.updatedOn = now;
    room.createdBy = _repoGetStorage.getUserUuid();
    room.facilitiesJson = jsonEncode(facilityList);

    room.amenities.clear();
    room.amenities.addAll(selectedAmenities);
    boxRoom.put(room);

    Get.log("Room saved: ${json.encode(room.toMap())}");
    Get.back(result: true);
  }

  /// Edit existing room
  void editRoom(EntityRoom room) {
    editingRoom.value = room;

    numberCtrl.text = room.number ?? '';
    capacityCtrl.text = room.capacity?.toString() ?? '';
    floorCtrl.text = room.floor ?? '';
    basePriceCtrl.text = room.price?.toString() ?? '';
    priceCtrl.text = room.price?.toString() ?? '';

    basePrice = room.price ?? 0.0;

    selectedRoomType.value = roomTypes.contains(room.type) ? room.type! : roomTypes.first;
    selectedBedType.value = bedTypes.contains(room.bedType) ? room.bedType! : bedTypes.first;
    selectedStatus.value = statuses.contains(room.status) ? room.status! : statuses.first;
    selectedCurrency.value = currencies.contains(room.currency) ? room.currency! : currencies.first;

    selectedAmenities.assignAll(room.amenities);

    if (room.facilitiesJson != null && room.facilitiesJson!.isNotEmpty) {
      facilityList.value = List<Map<String, dynamic>>.from(jsonDecode(room.facilitiesJson!));
      updateTotalPrice();
    }
  }

  /// Clear form
  void clearForm() {
    editingRoom.value = null;
    numberCtrl.clear();
    floorCtrl.clear();
    priceCtrl.clear();
    basePriceCtrl.clear();
    selectedRoomType.value = roomTypes.first;
    selectedBedType.value = bedTypes.first;
    selectedStatus.value = statuses.first;
    selectedCurrency.value = currencies.first;
    selectedAmenities.clear();
    facilityList.clear();
  }

  @override
  void onClose() {
    numberCtrl.dispose();
    floorCtrl.dispose();
    priceCtrl.dispose();
    capacityCtrl.dispose();
    basePriceCtrl.dispose();
    super.onClose();
  }
}
