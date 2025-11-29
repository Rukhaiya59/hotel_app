import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../model/entity_user.dart';
import '../../../../widgets/text_bold.dart';
import '../../../../widgets/text_small.dart';
import 'controller_user.dart';

class FragHomeUser extends StatelessWidget {
  const FragHomeUser({super.key});

  @override
  Widget build(BuildContext context) {
    final ControllerUser controller = Get.put(ControllerUser());

    return Obx(() {
      if (controller.rxListUser.isEmpty) {
        return Center(child: Text("no_record".tr));
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        itemCount: controller.rxListUser.length,
        itemBuilder: (context, index) {
          final EntityUser user = controller.rxListUser[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.person),
              title: TextBold(
                message: "${user.first ?? ''} ${user.last ?? ''}", style: TextStyle(),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (user.role != null) Text(user.role!),
                  if (user.email != null) TextSmall(message: user.email ?? '', style: TextStyle(),),
                  if (user.department != null && user.department!.isNotEmpty)
                    TextSmall(message: "Dept: ${user.department!.join(', ')}", style: TextStyle(),),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  Get.defaultDialog(
                    title: "User Info",
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Username: ${user.username ?? ''}\nMobile: ${user.mobile ?? ''}\nEmployee ID: ${user.employeeId ?? ''}",
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    });
  }
}
