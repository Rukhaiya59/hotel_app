import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hotel/screens/room/controller_create_room.dart';
import 'package:hotel/util/snackbar_util.dart';
import '../../widgets/secondary_button.dart';
import 'package:hotel/service/service_currency.dart';

import 'maintanance/controller_maintenance.dart';

class ActivityCreateRoom extends StatelessWidget {
  final String? roomUuid;
  const ActivityCreateRoom({super.key, this.roomUuid});

  @override
  Widget build(BuildContext context) {
    final ControllerCreateRoom createCtrl = Get.put(
      ControllerCreateRoom(roomUuid: roomUuid),
    );
    final ControllerMaintenanceDialog maintenanceCtrl = Get.put(
      ControllerMaintenanceDialog(),
    );
    final currencyService = Get.find<ServiceCurrency>();//currency

    //  Auto load maintenance when screen opens with roomUuid
    if (roomUuid != null && roomUuid!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        maintenanceCtrl.loadMaintenanceByRoom(roomUuid!);
      });
    }

    final formKey = GlobalKey<FormState>();
    final editing = createCtrl.editingRoom.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(editing == null ? "Create Room" : "Update Room"),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(result: false),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Form(
            key: formKey,
            child: Obx(
                  () => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: createCtrl.numberCtrl,
                    decoration: InputDecoration(
                      label: const Text("Room Number"),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 12),
                  // Floor Number
                  TextFormField(
                    controller: createCtrl.floorCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: const Text("Floor Number"),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 12),

                  // Price + Currency
                  Row(
                    children: const [],
                  ),
                  const SizedBox(height: 12),
                  // Base Price
                  TextFormField(
                    controller: createCtrl.basePriceCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (v) =>
                        createCtrl.updateTotalPrice(fromBaseChange: true),
                    decoration: InputDecoration(
                      label: Obx(() => Text(
                          "Base Price (${currencyService.symbol} per 24 hrs)")),//currency
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: createCtrl.capacityCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      label: const Text("Capacity"),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 12),
                  // Room Type
                  DropdownButtonFormField<String>(
                    initialValue: createCtrl.selectedRoomType.value,
                    items: createCtrl.roomTypes
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                    onChanged: (v) => createCtrl.selectedRoomType.value =
                        v ?? createCtrl.roomTypes.first,
                    decoration: InputDecoration(
                      label: const Text("Room Type"),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Bed Type
                  DropdownButtonFormField<String>(
                    initialValue: createCtrl.selectedBedType.value,
                    items: createCtrl.bedTypes
                        .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                        .toList(),
                    onChanged: (v) => createCtrl.selectedBedType.value =
                        v ?? createCtrl.bedTypes.first,
                    decoration: InputDecoration(
                      label: const Text("Bed Type"),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Status
                  DropdownButtonFormField<String>(
                    initialValue: createCtrl.selectedStatus.value,
                    items: createCtrl.statuses
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) => createCtrl.selectedStatus.value =
                        v ?? createCtrl.statuses.first,
                    decoration: InputDecoration(
                      label: const Text("Status"),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  // ---------------- Facilities Section ----------------
                  const SizedBox(height: 12),
                  const Text(
                    "Facilities",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: createCtrl.facilityNameCtrl,
                          decoration: const InputDecoration(
                            labelText: "Facility Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: createCtrl.facilityPriceCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Price",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: createCtrl.addFacility,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Obx(() {
                    final facilities = createCtrl.facilityList;
                    if (facilities.isEmpty) {
                      return const Text(
                        "No facilities added",
                        style: TextStyle(color: Colors.grey),
                      );
                    }
                    return Column(
                      children: facilities.asMap().entries.map((entry) {
                        final index = entry.key;
                        final f = entry.value;
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.settings),
                            title: Text(f['name']),
                            subtitle: Obx(() => Text(   "${currencyService.symbol}${(f['price'] is num ? f['price'] : 0.0).toStringAsFixed(2)}", )),//currency
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => createCtrl.removeFacility(index),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                  // ---------------- End Facilities Section ----------------
                  const SizedBox(height: 8),

                  // Total Price (Read-only)
                  Obx(
                        () => TextField(
                      controller: createCtrl.priceCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Total Price (${currencyService.symbol})",//currency
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),

                  // Save Button
                  SecondaryButton(
                    text: editing == null ? "Save Room" : "Update Room",
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        createCtrl.saveRoom();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.build, color: Colors.white),
                    label: const Text("Maintenance"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () async {
                      final uuid =
                          createCtrl.editingRoom.value?.roomUuid ??
                              createCtrl.roomUuid ??
                              '';
                      if (uuid.isEmpty) {
                        SnackbarUtil.showError("Please save the room first");
                        return;
                      }
                      await maintenanceCtrl.showAddMaintenanceDialog(
                        context,
                        uuid,
                      );
                    },
                  ),

                  Obx(() {
                    final records = maintenanceCtrl.maintenanceList;
                    if (records.isEmpty) return const SizedBox();

                    final m = records.first;
                    final assigned = m.assignedPersons != null
                        ? jsonDecode(m.assignedPersons!)
                        : [];
                    final p = assigned.isNotEmpty ? assigned.first : {};

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text("🛠 Reason: ${m.reason ?? ''}"),
                        subtitle: Text(
                          "👷 ${p['name'] ?? ''} (${p['phone'] ?? ''})\n"
                              "📅 ${m.startDate?.split('T').first ?? ''} → ${m.endDate?.split('T').first ?? ''}",
                        ),
                        trailing: ElevatedButton.icon(
                          icon: const Icon(Icons.done, color: Colors.white),
                          label: const Text("Done"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            maintenanceCtrl.markMaintenanceDone(
                              m.roomUuid ?? '',
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}