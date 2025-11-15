import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controlller_task_create.dart';

class ActivityTask extends StatelessWidget {
 const ActivityTask({super.key});

  @override
  Widget build(BuildContext context) {
    ControllerTaskCreate controller = Get.put(ControllerTaskCreate());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Task"),
        centerTitle: true,
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller.title,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.description,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.timeRequired,
              decoration: const InputDecoration(labelText: "Time Required"),
            ),
            const SizedBox(height: 10),
            DropdownButton(
              isExpanded: true,
              value: controller.selectedUser.value,
              hint: const Text("Select Staff"),
              items: controller.rxUsers.map((user) {
                return DropdownMenuItem(
                  value: user,
                  child: Text("${user.first} ${user.last}"),
                );
              }).toList(),
              onChanged: (value) {
                controller.selectedUser.value = value as dynamic;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.saveTask,
              child: const Text("Assign Task"),
            ),
          ],
        )),
      ),
    );
  }
}
