import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/entity_guest.dart';
import '../../../model/entity_amenities.dart';

class SplitBillScreen extends StatefulWidget {
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
  State<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  // For Percentage
  final percentCtrl = TextEditingController();

  // For Guest Split
  Map<String, double> guestSplit = {};

  // For Facility Split
  Map<String, double> facilitySplit = {};

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);

    // Default guest split equal
    if (widget.guests.isNotEmpty) {
      double perGuest = widget.totalAmount / widget.guests.length;
      for (var g in widget.guests) {
        guestSplit[g.first] = perGuest;
      }
    }

    // Facility wise split
    for (var f in widget.facilities) {
      facilitySplit[f.name ?? "Item"] = (f.price ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Split Bill"),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: "By Facility"),
            Tab(text: "By Guest"),
            Tab(text: "By %"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          buildFacilitySplit(),
          buildGuestSplit(),
          buildPercentageSplit(),
        ],
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: () {
            final result = _collectSplitResult();
            Get.back(result: result);   // 🔥 IMPORTANT
          },
          child: const Text("Apply Split"),
        ),
      ),
    );
  }

  // ---------------- FACILITY TAB -----------------
  Widget buildFacilitySplit() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: widget.facilities.map((f) {
        return ListTile(
          title: Text(f.name ?? ""),
          trailing: Text("₹${(f.price ?? 0).toStringAsFixed(2)}"),
        );
      }).toList(),
    );
  }

  // ---------------- GUEST TAB -----------------
  Widget buildGuestSplit() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: widget.guests.map((g) {
        return ListTile(
          title: Text("${g.first} ${g.last}"),
          subtitle: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Amount"),
            onChanged: (v) {
              guestSplit[g.first] = double.tryParse(v) ?? 0;
            },
            controller: TextEditingController(
              text: guestSplit[g.first]?.toStringAsFixed(2),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ---------------- PERCENTAGE TAB -----------------
  Widget buildPercentageSplit() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            controller: percentCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Enter % to split (e.g. 50)",
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {});
            },
            child: const Text("Calculate"),
          ),
          const SizedBox(height: 20),
          if (percentCtrl.text.isNotEmpty)
            Text(
              "Amount: ₹${((double.tryParse(percentCtrl.text) ?? 0) / 100 * widget.totalAmount).toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18),
            )
        ],
      ),
    );
  }

  // Collect final split
  List<Map<String, dynamic>> _collectSplitResult() {
    List<Map<String, dynamic>> finalSplit = [];

    // Guest Split
    guestSplit.forEach((key, value) {
      finalSplit.add({
        "label": key,
        "amount": value,
      });
    });

    return finalSplit;
  }
}
