import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/entity_guest.dart';
import 'controller_split_guest.dart';

class SplitGuestScreen extends StatelessWidget {
  final double totalAmount;
  final List<EntityGuest> guests;

  const SplitGuestScreen({
    super.key,
    required this.totalAmount,
    required this.guests,
  });

  @override
  Widget build(BuildContext context) {
    final ControllerSplitGuest controller =Get.put(ControllerSplitGuest(
      totalAmount: totalAmount,
      guests: guests,
    ));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Total: ₹$totalAmount"),
            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: guests.map((g) {
                  final mode =
                  controller.paymentModes[g.guestUuid!]!;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${g.first} ${g.last}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Row(
                          children: [
                            // ✅ AMOUNT FIELD (UNLIMITED INPUT)
                            Expanded(
                              child: TextField(
                                controller: controller
                                    .amountCtrls[g.guestUuid]!,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Amount",
                                  border: OutlineInputBorder(),
                                  prefixText: "₹ ",
                                ),
                                onChanged: (v) {
                                  controller.updateAmount(
                                      g.guestUuid!, v);
                                },
                              ),
                            ),

                            const SizedBox(width: 8),

                            // ✅ PAYMENT MODE
                            Expanded(
                              child: Obx(
                                    () =>
                                    DropdownButtonFormField<String>(
                                      value: mode.value,
                                      decoration: const InputDecoration(
                                        labelText: "Mode",
                                        border: OutlineInputBorder(),
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                            value: "Cash",
                                            child: Text("Cash")),
                                        DropdownMenuItem(
                                            value: "UPI",
                                            child: Text("UPI")),
                                        DropdownMenuItem(
                                            value: "Card",
                                            child: Text("Card")),
                                        DropdownMenuItem(
                                            value: "Company",
                                            child: Text("Company")),
                                      ],
                                      onChanged: (v) {
                                        mode.value = v!;
                                        controller.updateAmount(
                                          g.guestUuid!,
                                          controller
                                              .amountCtrls[g.guestUuid!]!
                                              .text,
                                        );
                                      },
                                    ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        // ✅ TRANSACTION ID
                        TextField(
                          controller:
                          controller.txnCtrls[g.guestUuid]!,
                          decoration: const InputDecoration(
                            labelText:
                            "Transaction ID (optional for Cash)",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
