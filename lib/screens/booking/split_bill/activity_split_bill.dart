
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/entity_guest.dart';
import '../../../model/entity_amenities.dart';
import 'controller_split_bill.dart';
import 'split_guest_screen.dart';
import 'split_percent_screen.dart';

class SplitBillScreen extends StatelessWidget {
  final double totalAmount;
  final List<EntityGuest> guests;
  final List<EntityAmenities> facilities;

  const SplitBillScreen({
    super.key,
    required this.totalAmount,
    required this.guests,
    required this.facilities,
  });

  @override
  Widget build(BuildContext context) {
    final ControllerSplitBill controller =
    Get.put(ControllerSplitBill(
      totalAmount: totalAmount,
      guests: guests,
    ));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Split Bill"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "By Guest"),
              Tab(text: "By %"),
            ],
          ),
        ),

        body: TabBarView(
          children: [

            SplitGuestScreen(
              totalAmount: totalAmount,
              guests: guests,
            ),

            SplitPercentScreen(
              totalAmount: totalAmount,
              guests: guests,
            ),
          ],
        ),

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton(
            // onPressed: () {
            //   if (controller.finalResult == null ||
            //       controller.finalResult!.isEmpty) {
            //     Get.snackbar(
            //       "Error",
            //       "Please apply split in any one tab",
            //     );
            //     return;
            //   }
            //
            //   Get.back(result: controller.finalResult);
            // },
            onPressed: () {
              if (controller.finalResult.isEmpty) {
                Get.snackbar(
                  "Error",
                  "Please enter guest split amount",
                );
                return;
              }

              Get.back(result: controller.finalResult);
            },

            child: const Text("Apply Split"),
          ),
        ),
      ),
    );
  }
}
