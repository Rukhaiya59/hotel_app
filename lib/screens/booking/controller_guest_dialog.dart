// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hotel/util/snackbar_util.dart';
// import 'package:intl/intl.dart';
//
// import '../../model/entity_guest.dart';
//
// class ControllerGuestDialog extends GetxController {
//   /// Function to show the Guest Input Dialog
//   void showGuestDialog(BuildContext context, RxList<EntityGuest> guests) {
//     final firstCtrl = TextEditingController();
//     final lastCtrl = TextEditingController();
//     final phoneCtrl = TextEditingController();
//     final emailCtrl = TextEditingController();
//     final idNumCtrl = TextEditingController();
//     final dobCtrl = TextEditingController();
//
//     final idType = "Aadhar".obs;
//     final gender = "Male".obs;
//
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         title: const Text("Add Guest", style: TextStyle(fontWeight: FontWeight.bold)),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: firstCtrl,
//                 decoration: const InputDecoration(labelText: "First Name"),
//               ),
//               TextField(
//                 controller: lastCtrl,
//                 decoration: const InputDecoration(labelText: "Last Name"),
//               ),
//               TextField(
//                 controller: phoneCtrl,
//                 decoration: const InputDecoration(labelText: "Phone Number"),
//                 keyboardType: TextInputType.phone,
//               ),
//               TextField(
//                 controller: emailCtrl,
//                 decoration: const InputDecoration(labelText: "Email"),
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               TextField(
//                 controller: dobCtrl,
//                 readOnly: true,
//                 decoration: const InputDecoration(labelText: "Date of Birth"),
//                 onTap: () async {
//                   final picked = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime(2000),
//                     firstDate: DateTime(1900),
//                     lastDate: DateTime.now(),
//                   );
//                   if (picked != null) {
//                     dobCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
//                   }
//                 },
//               ),
//               const SizedBox(height: 10),
//               Obx(() => DropdownButtonFormField<String>(
//                 value: idType.value,
//                 items: const [
//                   DropdownMenuItem(value: "Aadhar", child: Text("Aadhar")),
//                   DropdownMenuItem(value: "Passport", child: Text("Passport")),
//                   DropdownMenuItem(value: "PAN", child: Text("PAN")),
//                 ],
//                 onChanged: (v) => idType.value = v ?? "Aadhar",
//                 decoration: const InputDecoration(labelText: "ID Type"),
//               )),
//               TextField(
//                 controller: idNumCtrl,
//                 decoration: const InputDecoration(labelText: "ID Number"),
//               ),
//               const SizedBox(height: 10),
//               Obx(() => Row(
//                 children: [
//                   Radio<String>(
//                       value: "Male",
//                       groupValue: gender.value,
//                       onChanged: (v) => gender.value = v!),
//                   const Text("Male"),
//                   Radio<String>(
//                       value: "Female",
//                       groupValue: gender.value,
//                       onChanged: (v) => gender.value = v!),
//                   const Text("Female"),
//                   Radio<String>(
//                       value: "Other",
//                       groupValue: gender.value,
//                       onChanged: (v) => gender.value = v!),
//                   const Text("Other"),
//                 ],
//               )),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//               onPressed: () => Get.back(),
//               child: const Text("Cancel", style: TextStyle(color: Colors.red))),
//           ElevatedButton(
//             onPressed: () {
//               // ✅ Validation before adding guest
//               if (firstCtrl.text.trim().isEmpty || phoneCtrl.text.trim().isEmpty) {
//                 SnackbarUtil.showError( "Please fill all required fields");
//                 return;
//               }
//
//               guests.add(
//                 EntityGuest(
//                   guestId: DateTime.now().millisecondsSinceEpoch,
//                   guestUuid: "G-${DateTime.now().millisecondsSinceEpoch}",
//                   first: firstCtrl.text.trim(),
//                   last: lastCtrl.text.trim(),
//                   dob: dobCtrl.text.trim(),
//                   gender: gender.value,
//                   idName: idType.value,
//                   idValue: idNumCtrl.text.trim(),
//                   createdOn: DateTime.now().toString(),
//                   createdBy: "Admin",
//                   updatedOn: DateTime.now().toString(),
//                   hotelUuid: "H001",
//                   phone: phoneCtrl.text.trim(),
//                   email: emailCtrl.text.trim(),
//                 ),
//               );
//
//               Get.back();
//
//               SnackbarUtil.showSuccess("Guest Added Successfully");
//             },
//             child: const Text("Add Guest"),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../model/entity_guest.dart';
import '../../util/snackbar_util.dart';

class ControllerGuestDialog extends GetxController {
  /// Function to show the Guest Input Dialog
  void showGuestDialog(BuildContext context, RxList<EntityGuest> guests) {
    final firstCtrl = TextEditingController();
    final lastCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final idNumCtrl = TextEditingController();
    final dobCtrl = TextEditingController();

    final idType = "Aadhar".obs;
    final gender = "Male".obs;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Add Guest",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstCtrl,
                decoration: const InputDecoration(labelText: "First Name"),
              ),
              TextField(
                controller: lastCtrl,
                decoration: const InputDecoration(labelText: "Last Name"),
              ),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: dobCtrl,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Date of Birth"),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    dobCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
                  }
                },
              ),
              const SizedBox(height: 10),
              Obx(
                    () => DropdownButtonFormField<String>(
                  value: idType.value,
                  items: const [
                    DropdownMenuItem(value: "Aadhar", child: Text("Aadhar")),
                    DropdownMenuItem(
                      value: "Passport",
                      child: Text("Passport"),
                    ),
                    DropdownMenuItem(value: "PAN", child: Text("PAN")),
                  ],
                  onChanged: (v) => idType.value = v ?? "Aadhar",
                  decoration: const InputDecoration(labelText: "ID Type"),
                ),
              ),
              TextField(
                controller: idNumCtrl,
                decoration: const InputDecoration(labelText: "ID Number"),
              ),
              const SizedBox(height: 10),
              Obx(
                    () => Row(
                  children: [
                    Radio<String>(
                      value: "Male",
                      groupValue: gender.value,
                      onChanged: (v) => gender.value = v!,
                    ),
                    const Text("Male"),
                    Radio<String>(
                      value: "Female",
                      groupValue: gender.value,
                      onChanged: (v) => gender.value = v!,
                    ),
                    const Text("Female"),
                    Radio<String>(
                      value: "Other",
                      groupValue: gender.value,
                      onChanged: (v) => gender.value = v!,
                    ),
                    const Text("Other"),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              // ✅ Validation before adding guest
              if (firstCtrl.text.trim().isEmpty ||
                  phoneCtrl.text.trim().isEmpty) {
                SnackbarUtil.showError("Please fill all required fields");
                return;
              }

              guests.add(
                EntityGuest(
                  guestId: DateTime.now().millisecondsSinceEpoch,
                  guestUuid: "G-${DateTime.now().millisecondsSinceEpoch}",
                  first: firstCtrl.text.trim(),
                  last: lastCtrl.text.trim(),
                  dob: dobCtrl.text.trim(),
                  gender: gender.value,
                  idName: idType.value,
                  idValue: idNumCtrl.text.trim(),
                  createdOn: DateTime.now().toString(),
                  createdBy: "Admin",
                  updatedOn: DateTime.now().toString(),
                  hotelUuid: "H001",
                  phone: phoneCtrl.text.trim(),
                  email: emailCtrl.text.trim(),
                ),
              );

              Get.back();

              SnackbarUtil.showSuccess("Guest Added Successfully");
            },
            child: const Text("Add Guest"),
          ),
        ],
      ),
    );
  }
}
