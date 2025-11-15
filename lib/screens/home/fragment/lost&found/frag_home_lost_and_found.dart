import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller_lost_and_found.dart';

class FragHomeLostAndFound extends StatelessWidget {
  const FragHomeLostAndFound({super.key});


  @override
  Widget build(BuildContext context) {
     ControllerLostAndFound controller = Get.put(ControllerLostAndFound());

    return Obx(() {
      final items = controller.rxListFoundItems;
      if (items.isEmpty) return Center(child: Text("No items found"));
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(item.name.toString()),
              subtitle: Text(
                  "Location: ${item.location}\n"
                      "Customer: ${item.customerDetail}\n"
                      "Date: ${item.dateFound}\n"
                      "Status: ${item.status}"
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (String? value) {
                  if (value == null) return;

                  if (value == 'claim' || value == 'unclaim') {
                    controller.updateStatus(item, value);
                    controller.loadFoundItems(); // <--- explicitly refresh UI
                  } else if (value == 'delete') {
                    controller.deleteItem(item);
                    controller.loadFoundItems(); // <--- refresh UI
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'claim', child: Text('Mark Claim')),
                  PopupMenuItem(value: 'unclaim', child: Text('Mark Unclaim')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ),
          );
        },
      );
    } );}
}
