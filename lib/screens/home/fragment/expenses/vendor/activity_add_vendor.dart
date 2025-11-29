import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller_vendor.dart';

class AddVendorPopup extends StatelessWidget {
  final VendorController ctrl = Get.find();

  AddVendorPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Add Vendor",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              TextField(
                controller: ctrl.name,
                decoration: InputDecoration(
                  labelText: "Vendor Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: ctrl.category,
                decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: ctrl.phone,
                decoration: InputDecoration(
                  labelText: "Phone (optional)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 15),

              TextField(
                controller: ctrl.company,
                decoration: InputDecoration(
                  labelText: "Company Name (optional)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      ctrl.clearForm();
                      Get.back();
                    },
                    child: Text("Cancel"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      ctrl.addVendor();
                      Get.back();
                    },
                    child: Text("Save Vendor"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
