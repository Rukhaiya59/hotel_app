import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/reports/controller_occupancy.dart';

class FragHomeOccupancy extends StatelessWidget {
  const FragHomeOccupancy({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ControllerOccupancy());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Occupancy Report"),
        centerTitle: true,
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _box("Total Rooms", controller.totalRooms.value),
              _box("Occupied Rooms", controller.occupiedRooms.value),
              _box("Vacant Rooms", controller.vacantRooms.value),
              _box("Cleaning Rooms", controller.cleaningRooms.value),
              _box("Blocked Rooms", controller.blockedRooms.value),

              const SizedBox(height: 20),

              _percentBox(
                "Occupancy %",
                controller.occupancyPercent.value.toStringAsFixed(2),
              ),
              _percentBox(
                "Vacancy %",
                controller.vacancyPercent.value.toStringAsFixed(2),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _box(String title, int value) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _percentBox(String title, String percent) {
    return Card(
      color: Colors.blue.shade50,
      child: ListTile(
        title: Text(title),
        trailing: Text(
          "$percent%",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
