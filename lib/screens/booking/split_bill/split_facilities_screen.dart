import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/entity_guest.dart';
import '../../../model/entity_amenities.dart';

class SplitFacilityScreen extends StatefulWidget {
  final double totalAmount;
  final List<EntityGuest> guests;
  final List<EntityAmenities> facilities;

  const SplitFacilityScreen({
    super.key,
    required this.totalAmount,
    required this.guests,
    required this.facilities,
  });

  @override
  State<SplitFacilityScreen> createState() => _SplitFacilityScreenState();
}

class _SplitFacilityScreenState extends State<SplitFacilityScreen> {
  final Map<String, bool> selected = {};

  @override
  void initState() {
    super.initState();
    for (var f in widget.facilities) {
      selected[f.name!] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double facilityTotal = widget.facilities.fold(
      0.0,
          (s, f) => s + (selected[f.name!]! ? (f.price ?? 0) : 0),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Split By Facility")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Selected Facilities Total: ₹$facilityTotal"),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: widget.facilities.map((f) {
                  return CheckboxListTile(
                    title: Text("${f.name} (₹${f.price})"),
                    value: selected[f.name],
                    onChanged: (v) {
                      setState(() {
                        selected[f.name!] = v!;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                double perGuest = facilityTotal / widget.guests.length;

                final results = widget.guests.map((g) {
                  return {
                    "guestUuid": g.guestUuid,
                    "amount": perGuest,
                  };
                }).toList();

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
