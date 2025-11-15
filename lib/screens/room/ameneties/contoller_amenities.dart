import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';

import '../../../model/entity_amenities.dart';
import '../../../service/service_object_box.dart';

class ControllerAmenities extends GetxController {
  late Box<EntityAmenities> boxAmenities;

  final RxList<EntityAmenities> allAmenities = <EntityAmenities>[].obs;

  @override
  void onInit() {
    final ob = Get.find<ServiceObjectBox>();
    boxAmenities = ob.box<EntityAmenities>();
    getAllAmenities();
    super.onInit();
  }

  void getAllAmenities() {
    allAmenities.value = boxAmenities.getAll();
  }

  void addAmenity(EntityAmenities amenity) {
    boxAmenities.put(amenity);
    getAllAmenities();
  }

  Future<List<EntityAmenities>> showAmenitiesDialog({
    List<EntityAmenities>? preSelected,
  }) async {
    final RxList<Map<String, dynamic>> selected = <Map<String, dynamic>>[].obs;
    final RxString searchQuery = ''.obs;
    if (preSelected != null) {
      for (var a in preSelected) {
        selected.add({'amenity': a, 'count': (a.qty ?? 1).obs});
      }
    }

    await Get.dialog(
      Material(
        type: MaterialType.transparency,
        child: AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Select Amenities"),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.blue),
                onPressed: () => showCreateAmenityDialog(),
              ),
            ],
          ),
          content: SizedBox(
            width: 350,
            height: 400,
            child: Column(
              children: [
                // 🔍 Search Bar
                TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search amenities...',
                  ),
                  onChanged: (val) => searchQuery.value = val,
                ),
                const SizedBox(height: 10),

                // 🧾 Amenity List
                Expanded(
                  child: Obx(() {
                    final filteredList = allAmenities
                        .where(
                          (a) =>
                      a.name?.toLowerCase().contains(
                        searchQuery.value.toLowerCase(),
                      ) ??
                          false,
                    )
                        .toList();

                    return ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final amenity = filteredList[index];
                        final existingIndex = selected.indexWhere(
                              (item) => item['amenity'].name == amenity.name,
                        );
                        final isSelected = existingIndex != -1;

                        // Quantity observable
                        final RxInt count = isSelected
                            ? selected[existingIndex]['count']
                            : 0.obs;

                        return Obx(
                              () => ListTile(
                            leading: Checkbox(
                              value: selected.any(
                                    (s) => s['amenity'].name == amenity.name,
                              ),
                              onChanged: (val) {
                                if (val == true) {
                                  if (existingIndex == -1) {
                                    selected.add({
                                      'amenity': amenity,
                                      'count': 1.obs,
                                    });
                                  }
                                } else {
                                  if (existingIndex != -1) {
                                    selected.removeAt(existingIndex);
                                  }
                                }
                              },
                            ),
                            title: Text(amenity.name ?? ''),
                            subtitle: Text(
                              "${amenity.price ?? 0}₹ | ${amenity.description ?? ''}",
                            ),
                            trailing:
                            selected.any(
                                  (s) => s['amenity'].name == amenity.name,
                            )
                                ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    if (count.value > 1) {
                                      count.value--;
                                    } else {
                                      selected.removeAt(existingIndex);
                                    }
                                  },
                                ),
                                Text(
                                  count.value.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle,
                                    color: Colors.green,
                                  ),
                                  onPressed: () => count.value++,
                                ),
                              ],
                            )
                                : null,
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final result = selected.map((e) {
                  final amenity = e['amenity'] as EntityAmenities;
                  amenity.qty = e['count'].value;
                  return amenity;
                }).toList();
                Get.back(result: result);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      ),
    );
    return selected.map((e) {
      final amenity = e['amenity'] as EntityAmenities;
      amenity.qty = e['count'].value;
      return amenity;
    }).toList();
  }

  void showCreateAmenityDialog() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    Get.dialog(
      Material(
        type: MaterialType.transparency,
        child: AlertDialog(
          title: const Text("Create Amenity"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Amenity Name"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Price (₹)"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: "Description"),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: Get.back, child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.trim().isNotEmpty) {
                  addAmenity(
                    EntityAmenities(
                      name: nameCtrl.text.trim(),
                      price: double.tryParse(priceCtrl.text) ?? 0,
                      description: descCtrl.text.trim(),
                    ),
                  );
                  Get.back();
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
