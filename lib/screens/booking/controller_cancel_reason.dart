import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControllerCancelReason extends GetxController {
  final TextEditingController reasonCtrl = TextEditingController();

  @override
  void onClose() {
    reasonCtrl.dispose();
    super.onClose();
  }
  Future<String?> showCancelReasonDialog(BuildContext context) async {
    reasonCtrl.clear();

    return await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Cancel Booking"),
          content: TextField(
            controller: reasonCtrl,
            decoration: const InputDecoration(
              labelText: "Reason for cancellation",
              hintText: "Enter reason (optional)",
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Close"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx, reasonCtrl.text.trim());
              },
              child: const Text("Confirm Cancel"),
            ),
          ],
        );
      },
    );
  }
}
