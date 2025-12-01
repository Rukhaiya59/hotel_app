// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../model/entity_guest.dart';
// import '../../../model/entity_amenities.dart';
// import 'controller_split_bill.dart';
// import 'controller_split_facility.dart';
//
// class SplitFacilityScreen extends StatelessWidget {
//   final double totalAmount;
//   final List<EntityGuest> guests;
//   final List<EntityAmenities> facilities;
//
//   const SplitFacilityScreen({
//     super.key,
//     required this.totalAmount,
//     required this.guests,
//     required this.facilities,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final ControllerSplitFacility controller = Get.put(
//       ControllerSplitFacility(
//         totalAmount: totalAmount,
//         guests: guests,
//         facilities: facilities,
//       ),
//     );
//
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Obx(
//               () => Text(
//                 "Selected Facilities Total: ₹${controller.selectedFacilityTotal.value.toStringAsFixed(2)}",
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             Expanded(
//               child: ListView(
//                 children: facilities.map((f) {
//                   final key = f.name ?? "";
//
//                   return Obx(
//                     () => CheckboxListTile(
//                       title: Text("${f.name} (₹${f.price})"),
//                       value: controller.selectedFacilities[key]?.value ?? false,
//                       onChanged: (v) {
//                         controller.toggleFacility(key, v ?? false);
//                       },
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//
//             const Divider(),
//
//             Expanded(
//               child: ListView(
//                 children: guests.map((g) {
//                   final mode = controller.paymentModes[g.guestUuid!]!;
//
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 14),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "${g.first} ${g.last}",
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//
//                         const SizedBox(height: 4),
//
//                         Obx(
//                               () => Text(
//                                 "Selected Facilities Total: ₹${controller.selectedFacilityTotal.value.toStringAsFixed(2)}",
//                           ),
//                         ),
//
//
//                         const SizedBox(height: 6),
//
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Obx(
//                                 () => DropdownButtonFormField<String>(
//                                   value: mode.value,
//                                   decoration: const InputDecoration(
//                                     labelText: "Mode",
//                                     border: OutlineInputBorder(),
//                                   ),
//                                   items: const [
//                                     DropdownMenuItem(
//                                       value: "Cash",
//                                       child: Text("Cash"),
//                                     ),
//                                     DropdownMenuItem(
//                                       value: "UPI",
//                                       child: Text("UPI"),
//                                     ),
//                                     DropdownMenuItem(
//                                       value: "Card",
//                                       child: Text("Card"),
//                                     ),
//                                     DropdownMenuItem(
//                                       value: "Company",
//                                       child: Text("Company"),
//                                     ),
//                                   ],
//                                   onChanged: (v) => mode.value = v!,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//
//                         const SizedBox(height: 6),
//
//                         TextField(
//                           controller: controller.txnCtrls[g.guestUuid]!,
//                           decoration: const InputDecoration(
//                             labelText: "Transaction ID (optional for Cash)",
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//
//           ],
//         // ),
//       ),
//     );
//   }
// }
