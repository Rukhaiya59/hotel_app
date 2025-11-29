import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hotel/screens/room/controller_create_room.dart';
import 'package:hotel/screens/room/maintenance/controller_maintenanace.dart';
import 'package:hotel/util/snackbar_util.dart';
import '../../service/service_currency.dart';
import '../../widgets/secondary_button.dart';

class ActivityCreateRoom extends StatelessWidget {
  final String? roomUuid;
  const ActivityCreateRoom({super.key, this.roomUuid});

  @override
  Widget build(BuildContext context) {
    final ControllerCreateRoom createCtrl =
    Get.put(ControllerCreateRoom(roomUuid: roomUuid));
    final ControllerMaintenanceDialog maintenanceCtrl =
    Get.put(ControllerMaintenanceDialog());

    final currencyService = Get.find<ServiceCurrency>();
    final formKey = GlobalKey<FormState>();
    final editing = createCtrl.editingRoom.value;

    if (roomUuid != null && roomUuid!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        maintenanceCtrl.loadMaintenanceByRoom(roomUuid!);
      });
    }

    Color tileFill = Theme.of(context).cardColor.withOpacity(0.12);

    InputDecoration fieldDec(String label) {
      return InputDecoration(
        labelText: label,
        filled: true,
        fillColor: tileFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      );
    }

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
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // -------------------
              // ROOM DETAILS
              // -------------------
              const SizedBox(height: 25),
              const Text(
                "Room Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: createCtrl.numberCtrl,
                decoration: fieldDec("Room Number"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: createCtrl.floorCtrl,
                keyboardType: TextInputType.number,
                decoration: fieldDec("Floor Number"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: createCtrl.basePriceCtrl,
                keyboardType: TextInputType.number,
                onChanged: (v) =>
                    createCtrl.updateTotalPrice(fromBaseChange: true),
                decoration: fieldDec(
                  "Base Price (${currencyService.symbol} per 24 hrs)",
                ),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: createCtrl.capacityCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: fieldDec("Capacity"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),

              // -------------------
              // CONFIGURATION
              // -------------------
              const SizedBox(height: 25),
              const Text(
                "Configuration",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: createCtrl.selectedRoomType.value,
                decoration: fieldDec("Room Type"),
                items: createCtrl.roomTypes
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) => createCtrl.selectedRoomType.value = v ?? '',
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: createCtrl.selectedBedType.value,
                decoration: fieldDec("Bed Type"),
                items: createCtrl.bedTypes
                    .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                    .toList(),
                onChanged: (v) => createCtrl.selectedBedType.value = v ?? '',
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: createCtrl.selectedStatus.value,
                decoration: fieldDec("Status"),
                items: createCtrl.statuses
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => createCtrl.selectedStatus.value = v ?? '',
              ),

              // -------------------
              // FACILITIES
              // -------------------
              const SizedBox(height: 25),
              const Text(
                "Facilities",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: createCtrl.facilityNameCtrl,
                      decoration: fieldDec("Facility Name"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: createCtrl.facilityPriceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: fieldDec("Price"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: createCtrl.addFacility,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Obx(() {
                final facilities = createCtrl.facilityList;
                if (facilities.isEmpty) {
                  return const Text("No facilities added",
                      style: TextStyle(color: Colors.grey));
                }

                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: facilities.asMap().entries.map((entry) {
                    final index = entry.key;
                    final f = entry.value;

                    return Container(
                      width: 150,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.settings, size: 20),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  f['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${currencyService.symbol}${(f['price'] is num ? f['price'] : 0.0).toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.green),
                          ),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.delete,
                                  color: Colors.red, size: 20),
                              onPressed: () =>
                                  createCtrl.removeFacility(index),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }),

              // -------------------
              // TOTAL PRICE
              // -------------------
              const SizedBox(height: 25),
              const Text(
                "Total Price",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: createCtrl.priceCtrl,
                readOnly: true,
                decoration:
                fieldDec("Total Price (${currencyService.symbol})"),
              ),

              const SizedBox(height: 20),

              SecondaryButton(
                text: editing == null ? "Save Room" : "Update Room",
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    createCtrl.saveRoom();
                  }
                },
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: const Icon(Icons.build),
                label: const Text("Maintenance"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
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
                      context, uuid);
                },
              ),

              // -------------------
              // MAINTENANCE CARD WITH DONE BUTTON
              // -------------------
              Obx(() {
                final tasks = maintenanceCtrl.maintenanceList;
                if (tasks.isEmpty) return const SizedBox();

                final t = tasks.first;
                final room = t.room.target;

                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(1, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("🛠 Reason: ${t.reason ?? ''}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),

                      Text("🏨 Room: ${room?.number ?? ''} (Floor: ${room?.floor ?? ''})"),
                      Text("👷 Assigned: ${t.assignedPerson ?? '-'} (${t.mobileNumber ?? '-'})"),
                      Text("📅 ${t.startDate?.split('T').first ?? ''} → ${t.endDate?.split('T').first ?? ''}"),

                      if (t.expenseAmount != null && t.expenseAmount! > 0)
                        Text("💰 Expense: ₹${t.expenseAmount}"),

                      if (t.expenseNote != null && t.expenseNote!.isNotEmpty)
                        Text("📝 Note: ${t.expenseNote}"),

                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () {
                              maintenanceCtrl.markMaintenanceDone(
                                  room?.roomUuid ?? "");
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.done,
                                    color: Colors.green, size: 18),
                                SizedBox(width: 5),
                                Text(
                                  "Done",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
