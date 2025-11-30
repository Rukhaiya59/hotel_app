import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';
import '../../../model/entity_amenities.dart';
import '../../../service/service_currency.dart';
import '../../../service/service_object_box.dart';
import '../../../widgets/delete_dailog.dart';

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
                        return Obx(() {
                          final int existingIndex = selected.indexWhere(
                                (item) =>
                            item['amenity'].amenitiesId ==
                                amenity.amenitiesId,
                          );

                          final bool isSelected = existingIndex != -1;

                          final RxInt count = isSelected
                              ? selected[existingIndex]['count']
                              : 0.obs;

                          return ListTile(
                            leading: Checkbox(
                              value: isSelected,
                              onChanged: (val) {
                                if (val == true) {
                                  if (!isSelected) {
                                    selected.add({
                                      'amenity': amenity,
                                      'count': 1.obs,
                                    });
                                    selected
                                        .refresh(); // 🔥 force UI update
                                  }
                                } else {
                                  if (isSelected) {
                                    selected.removeAt(existingIndex);
                                    selected
                                        .refresh(); // 🔥 force UI update
                                  }
                                }
                              },
                            ),
                            title: Text(amenity.name ?? ''),
                            subtitle: Text(
                              "${Get.find<ServiceCurrency>().symbol}${(amenity.price ?? 0).toStringAsFixed(2)} | ${amenity.description ?? ''}",
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelected) ...[
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle,
                                        color: Colors.red),
                                    onPressed: () {
                                      if (count.value > 1) {
                                        count.value--;
                                      } else {
                                        selected.removeAt(existingIndex);
                                      }
                                      selected
                                          .refresh(); // 🔥 fixes slow UI update
                                    },
                                  ),
                                  Text(
                                    count.value.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle,
                                        color: Colors.green),
                                    onPressed: () {
                                      count.value++;
                                      selected
                                          .refresh(); // 🔥 instant UI update
                                    },
                                  ),
                                ],
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    final confirm = await showDeleteConfirmation(
                                      title: amenity.name ?? "Amenity",
                                      message: "Do you want to delete ${amenity.name}?",
                                    );
                                    if (confirm) {
                                      boxAmenities.remove(amenity.amenitiesId);
                                      getAllAmenities();
                                      if (isSelected) {
                                        selected.removeAt(existingIndex);
                                        selected
                                            .refresh(); // 🔥 instant UI update
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        });
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
                decoration: InputDecoration(
                  labelText: "Price (${Get.find<ServiceCurrency>().symbol})",//currency
                ),
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
