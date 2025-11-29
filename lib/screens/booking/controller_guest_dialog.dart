import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/objectbox.g.dart';
import 'package:intl/intl.dart';
import '../../model/entity_guest.dart';
import '../../service/service_object_box.dart';
import '../../util/snackbar_util.dart';
import '../home/fragment/guest/controller_guest_crm.dart';

class ControllerGuestDialog extends GetxController {
  /// Function to show the Guest Input Dialog
  void showGuestDialog(
      BuildContext context,
      RxList<EntityGuest> guests, {
        EntityGuest? editGuest,
        int? index,
      }) {
    final firstCtrl = TextEditingController(text: editGuest?.first ?? "");
    final lastCtrl = TextEditingController(text: editGuest?.last ?? "");
    final phoneCtrl = TextEditingController(text: editGuest?.phone ?? "");
    final emailCtrl = TextEditingController(text: editGuest?.email ?? "");
    final idNumCtrl = TextEditingController(text: editGuest?.idValue ?? "");
    final dobCtrl = TextEditingController(text: editGuest?.dob ?? "");
    final idType = (editGuest?.idName ?? "Aadhar").obs;
    final gender = (editGuest?.gender ?? "Male").obs;
    // Guest Type
    final guestType = (editGuest?.guestType ?? "walkin").obs;

    // ADD THESE
    final RxList<String> prefsList = <String>[].obs;
    final RxList<String> tagList = <String>[].obs;


    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(editGuest == null ? "Add Guest" : "Edit Guest", style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstCtrl,
                decoration: const InputDecoration(labelText: "First Name"),
              ),
              TextField(
                controller: lastCtrl,
                decoration: const InputDecoration(labelText: "Last Name"),
              ),
              // TextField(
              //   controller: phoneCtrl,
              //   decoration: const InputDecoration(labelText: "Phone Number"),
              //   keyboardType: TextInputType.phone,
              // ),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) async {
                  if (value.length >= 10) {
                    final guest = await fetchGuestByPhone(value);

                    if (guest != null) {
                      // Auto-fill main fields
                      firstCtrl.text = guest.first;
                      lastCtrl.text = guest.last;
                      emailCtrl.text = guest.email ?? "";
                      gender.value = guest.gender;
                      guestType.value = guest.guestType ?? "walkin";

                      // ⭐ FIXED DOB
                      dobCtrl.text = guest.dob ?? "";

                      // ⭐ FIXED ID Details
                      idType.value = guest.idName ?? "";       // Aadhar / PAN / Passport
                      idNumCtrl.text = guest.idValue ?? "";    // ID Number

                      // ⭐ FIXED phone
                      phoneCtrl.text = guest.phone ?? "";

                      // Prefs & Tags
                      prefsList.value = decodeList(guest.preferencesJson);
                      tagList.value = decodeList(guest.tagsJson);

                      Get.snackbar(
                        "Guest Found",
                        "Auto-filled previous records",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green.withOpacity(0.8),
                        colorText: Colors.white,
                      );
                    }
                  }
                },

              ),

              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: dobCtrl,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Date of Birth"),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    dobCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
                  }
                },
              ),
              const SizedBox(height: 10),
              Obx(
                    () => DropdownButtonFormField<String>(
                  value: idType.value,
                  items: const [
                    DropdownMenuItem(value: "Aadhar", child: Text("Aadhar")),
                    DropdownMenuItem(
                      value: "Passport",
                      child: Text("Passport"),
                    ),
                    DropdownMenuItem(value: "PAN", child: Text("PAN")),
                  ],
                  onChanged: (v) => idType.value = v ?? "Aadhar",
                  decoration: const InputDecoration(labelText: "ID Type"),
                ),
              ),
                            TextField(
                controller: idNumCtrl,
                decoration: const InputDecoration(labelText: "ID Number"),
              ),
              const SizedBox(height: 10),
              Obx(
                    () => Row(
                  children: [
                    Radio<String>(
                      value: "Male",
                      groupValue: gender.value,
                      onChanged: (v) => gender.value = v!,
                    ),
                    const Text("Male"),
                    Radio<String>(
                      value: "Female",
                      groupValue: gender.value,
                      onChanged: (v) => gender.value = v!,
                    ),
                    const Text("Female"),
                    Radio<String>(
                      value: "Other",
                      groupValue: gender.value,
                      onChanged: (v) => gender.value = v!,
                    ),
                    const Text("Other"),
                  ],
                ),
              ),
              Obx(() => DropdownButtonFormField<String>(
                value: guestType.value,
                decoration: const InputDecoration(labelText: "Guest Type"),
                items: const [
                  DropdownMenuItem(value: "walkin", child: Text("Walk-in")),
                  DropdownMenuItem(value: "vip", child: Text("VIP")),
                  DropdownMenuItem(value: "corporate", child: Text("Corporate")),
                  DropdownMenuItem(value: "group", child: Text("Group")),
                  DropdownMenuItem(value: "blacklisted", child: Text("Blacklisted")),
                ],
                onChanged: (v) => guestType.value = v ?? "walkin",
              )),
            ],
          ),
        ),
        actions: [
          // TextButton(
          //   onPressed: () => Get.back(),
          //   child: Text(editGuest == null ? "Add Guest" : "save Changes"),
          // ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // if (firstCtrl.text.trim().isEmpty || phoneCtrl.text.trim().isEmpty) {
              //   SnackbarUtil.showError("Please fill all required fields");
              //   return;
              // }
              if (firstCtrl.text.trim().isEmpty || phoneCtrl.text.trim().isEmpty) {
                SnackbarUtil.showError("Please fill all required fields");
                return;
              }

// 🔥 ID VALIDATION BASED ON TYPE
              if (!validateId(idType.value, idNumCtrl.text.trim())) {
                SnackbarUtil.showError(
                    idType.value == "Aadhar"
                        ? "Aadhar must be 12 digits"
                        : idType.value == "PAN"
                        ? "PAN format invalid (ABCDE1234F)"
                        : "Passport format invalid (A1234567)"
                );
                return;
              }


              final newGuest = EntityGuest(
                guestId: editGuest?.guestId ?? DateTime.now().millisecondsSinceEpoch,
                guestUuid: editGuest?.guestUuid ?? "G-${DateTime.now().millisecondsSinceEpoch}",
                first: firstCtrl.text.trim(),
                last: lastCtrl.text.trim(),
                dob: dobCtrl.text.trim(),
                gender: gender.value,
                idName: idType.value,
                guestType: guestType.value,                        idValue: idNumCtrl.text.trim(),
                createdOn: editGuest?.createdOn ?? DateTime.now().toString(),
                createdBy: editGuest?.createdBy ?? "Admin",
                updatedOn: DateTime.now().toString(),
                hotelUuid: "H001",
                phone: phoneCtrl.text.trim(),
                email: emailCtrl.text.trim(),
              );
              // ⭐ SAVE TO OBJECTBOX ALSO ⭐
//               final boxGuest = Get.find<ServiceObjectBox>().store.box<EntityGuest>();
//               boxGuest.put(newGuest);
//
// // ⭐ UPDATE CRM UI ⭐
//               final crm = Get.find<ControllerGuestCRM>();
//               crm.updateGuestInUI(newGuest);
//
//               final crm = Get.find<ControllerGuestCRM>();
//               crm.updateGuestInUI(newGuest);
//               final crm = Get.put(ControllerGuestCRM(), permanent: false);
              final crm = Get.put(ControllerGuestCRM(), permanent: false);

              // SAVE
              final boxGuest = Get.find<ServiceObjectBox>().store.box<EntityGuest>();
              boxGuest.put(newGuest);

              crm.updateGuestInUI(newGuest);
              // ⭐ UPDATE ACTIVITY BOOKING SCREEN LIST
              if (editGuest == null) {
                guests.add(newGuest);
              } else {
                guests[index!] = newGuest;
              }

              guests.refresh();       // 🔥 FORCE UI UPDATE
              Get.back();
            },

            child: Text(editGuest == null ? "Add Guest" : "Save Changes"),
            // child: Text(editGuest == null ? "Add Guest" : "cancel Guest"),
          ),
        ],
      ),
    );
  }

  Future<EntityGuest?> fetchGuestByPhone(String phone) async {
    final boxGuest = Get.find<ServiceObjectBox>().store.box<EntityGuest>();

    return boxGuest
        .query(EntityGuest_.phone.equals(phone))
        .build()
        .findFirst();
  }
  List<String> decodeList(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      return List<String>.from(jsonDecode(jsonStr));
    } catch (_) {
      return [];
    }

  }
  bool validateId(String idType, String idNumber) {
    idNumber = idNumber.trim();

    if (idType == "Aadhar") {
      return RegExp(r'^\d{12}$').hasMatch(idNumber); // 12 digits
    }

    if (idType == "PAN") {
      return RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(idNumber.toUpperCase());
    }

    if (idType == "Passport") {
      return RegExp(r'^[A-PR-WY][0-9]{7}$').hasMatch(idNumber.toUpperCase());
    }

    return false;
  }

}
