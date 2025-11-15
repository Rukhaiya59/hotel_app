import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'server_controller.dart';

class ServerPage extends StatelessWidget {
  final ServerController controller = Get.put(ServerController());
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(" Server")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              return Row(
                children: [
                  ElevatedButton(
                    onPressed: controller.isRunning.value
                        ? null
                        : () => controller.startServer(),
                    child: Text("Start Server"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: controller.isRunning.value
                        ? controller.stopServer
                        : null,
                    child: Text("Stop Server"),
                  ),
                ],
              );
            },),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                        hintText: "Enter message to send"),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (messageController.text.trim().isNotEmpty) {
                      controller.sendMessage(messageController.text.trim());
                      messageController.clear();
                    }
                  },
                  child: Text("Send"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(controller.messages[index]),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}