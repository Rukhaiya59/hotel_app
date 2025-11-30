import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../model/entity_user.dart';
import '../../controller_home.dart';
import 'controller_setting.dart';

class FragHomeSetting extends StatelessWidget {
  const FragHomeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final ControllerSetting controller = Get.put(ControllerSetting());
    final ControllerHome homeController = Get.find();
    final RxBool showProfile = false.obs;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Text(
              "Theme",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Text(
                    "Toggle Theme",
                    style: TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.brightness_6),
                    onPressed: () {
                      controller.serviceTheme.toggle();
                    },
                  ),
                ],
              ),
            ),


            Text(
              "Profile",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Obx(() => ListTile(
              tileColor: Colors.grey.withOpacity(0.12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: const Text(
                "View Profile",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              trailing: Icon(
                showProfile.value
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
              onTap: () {
                showProfile.value = !showProfile.value;
              },
            )),

            Obx(() {
              if (!showProfile.value) return const SizedBox.shrink();
              final EntityUser user = homeController.rxUser.value;

              return Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  " ${user.first} ${user.last}\n",
                      // "Role: ${user.role}\n"
                      // "Employee ID: ${user.employeeId}",
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }),

            const SizedBox(height: 25),

            Text(
              "Language",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Obx(
                  () => DropdownButtonFormField<Locale>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: controller.currentLocale.value,
                items: const [
                  DropdownMenuItem(
                    value: Locale('en', 'US'),
                    child: Text('English'),
                  ),
                  DropdownMenuItem(
                    value: Locale('hi', 'IN'),
                    child: Text('Hindi'),
                  ),
                  DropdownMenuItem(
                    value: Locale('mr', 'IN'),
                    child: Text('Marathi'),
                  ),
                  DropdownMenuItem(
                    value: Locale('ur', 'PK'),
                    child: Text('Urdu'),
                  ),
                ],
                onChanged: (Locale? locale) async {
                  if (locale == null) return;

                  await controller.changeLanguage(
                      "${locale.languageCode}_${locale.countryCode}");
                  controller.currentLocale.value = locale;
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Currency",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Obx(
                  () => DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: controller.currentCurrency.value,
                items: const [
                  DropdownMenuItem(value: "INR", child: Text("₹ INR")),
                  DropdownMenuItem(value: "AED", child: Text("د.إ AED")),
                  DropdownMenuItem(value: "SAR", child: Text("﷼ SAR")),
                  DropdownMenuItem(value: "QAR", child: Text("ر.ق QAR")),
                  DropdownMenuItem(value: "KWD", child: Text("د.ك KWD")),
                  DropdownMenuItem(value: "BHD", child: Text(".د.ب BHD")),
                  DropdownMenuItem(value: "OMR", child: Text("ر.ع OMR")),
                  DropdownMenuItem(value: "GBP", child: Text("£ GBP")),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  controller.changeCurrency(value);
                },
              ),
            ),

            const SizedBox(height: 24),
            Text(
              "Reset Booking",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Obx(
                  () => DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: controller.resetBookingType.value,
                items: controller.resetBookingOptions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;

                  controller.resetBookingType.value = value;

                  final box = GetStorage();
                  box.write('resetBookingType', value);
                },
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
