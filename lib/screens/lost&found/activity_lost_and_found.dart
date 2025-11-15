import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class FragLostFoundCreate extends StatelessWidget {
  final ControllerLostFoundCreate controller = Get.put(ControllerLostFoundCreate());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Add Found Item")),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(controller: controller.name, decoration: InputDecoration(labelText: "Item Name")),
            TextField(controller: controller.location, decoration: InputDecoration(labelText: "Location")),
            TextField(controller: controller.customerDetail, decoration: InputDecoration(labelText: "Customer Detail")),
            SizedBox(height: 10),
            Obx(() => Row(
              children: [
                Text("Status: ${controller.status.value}"),
                Spacer(),
                DropdownButton<String>(
                  value: controller.status.value,
                  items: ["claim", "unclaim"].map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
                  onChanged: (v) { if(v!=null) controller.status.value=v; },
                ),
              ],
            )),
            ElevatedButton(
              onPressed: () => controller.saveItem(),
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
