import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/entity_guest.dart';

class SplitGuestScreen extends StatefulWidget {
  final double totalAmount;
  final List<EntityGuest> guests;

  const SplitGuestScreen({
    super.key,
    required this.totalAmount,
    required this.guests,
  });

  @override
  State<SplitGuestScreen> createState() => _SplitGuestScreenState();
}

class _SplitGuestScreenState extends State<SplitGuestScreen> {
  final Map<String, TextEditingController> ctrls = {};

  @override
  void initState() {
    super.initState();
    for (var g in widget.guests) {
      ctrls[g.guestUuid!] = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Split By Guest")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Total: ₹${widget.totalAmount}"),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: widget.guests.map((g) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                      controller: ctrls[g.guestUuid]!,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "${g.first} ${g.last} Amount",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                final List<Map<String, dynamic>> results = [];

                ctrls.forEach((key, ctrl) {
                  double amount = double.tryParse(ctrl.text) ?? 0;
                  if (amount > 0) {
                    results.add({
                      "guestUuid": key,
                      "amount": amount,
                    });
                  }
                });

                Get.back(result: results);
              },
              child: const Text("Apply Split"),
            ),
          ],
        ),
      ),
    );
  }
}
