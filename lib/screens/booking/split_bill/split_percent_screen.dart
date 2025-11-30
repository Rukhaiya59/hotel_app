import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/entity_guest.dart';

class SplitPercentScreen extends StatefulWidget {
  final double totalAmount;
  final List<EntityGuest> guests;

  const SplitPercentScreen({
    super.key,
    required this.totalAmount,
    required this.guests,
  });

  @override
  State<SplitPercentScreen> createState() => _SplitPercentScreenState();
}

class _SplitPercentScreenState extends State<SplitPercentScreen> {
  final Map<String, TextEditingController> ctrls = {};

  @override
  void initState() {
    super.initState();
    for (var g in widget.guests) {
      ctrls[g.guestUuid] = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Split By %")),
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
                        labelText: "${g.first} ${g.last} %",
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
                  double percent = double.tryParse(ctrl.text) ?? 0;
                  if (percent > 0) {
                    double amount =
                        (widget.totalAmount * percent) / 100.0;

                    results.add({
                      "guestUuid": key,
                      "percent": percent,
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
