import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller_task.dart';

class FragHomeTask extends StatelessWidget {
  const FragHomeTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ControllerTask controller = Get.put(ControllerTask());

    return Obx(() {
      if (controller.rxListTask.isEmpty) {
        return const Center(child: Text("No tasks yet"));
      }
      return ListView.builder(
        itemCount: controller.rxListTask.length,
        itemBuilder: (context, index) {
          final task = controller.rxListTask[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(task.title),
              subtitle: Text(
                "Assigned to: ${task.assignedToName}\nTime: ${task.timeRequired}",
              ),
            ),
          );
        },
      );
    });
  }
}
