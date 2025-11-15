import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../model/entity_tax.dart';
import '../home/fragment/tax/controller_hotel_tax.dart';


class TaxForm extends StatefulWidget {
  final EntityTax? editTax;
  const TaxForm({super.key, this.editTax});

  @override
  State<TaxForm> createState() => _TaxFormState();
}

class _TaxFormState extends State<TaxForm> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final percentCtrl = TextEditingController();

  bool appliesRoom = false;
  bool appliesService = false;
  bool isCompound = false;
  bool isInclusive = false;
  bool isActive = true;

  DateTime? validFrom;
  DateTime? validTo;

  List<String> roomTypes = ["Deluxe", "Suite", "Super Deluxe"];
  List<String> selectedTypes = [];

  @override
  void initState() {
    if (widget.editTax != null) {
      final t = widget.editTax!;
      nameCtrl.text = t.taxName;
      percentCtrl.text = t.percentage.toString();
      appliesRoom = t.appliesToRoomRate;
      appliesService = t.appliesToServiceCharge;
      isCompound = t.isCompound;
      isInclusive = t.isInclusive;
      isActive = t.isActive;
      validFrom = t.validFrom != null ? DateTime.parse(t.validFrom!) : null;
      validTo = t.validTo != null ? DateTime.parse(t.validTo!) : null;
      selectedTypes = t.roomTypes?.split(",") ?? [];
    }
    super.initState();
  }

  Future pickDate(bool isFrom) async {
    final pick = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (pick != null) {
      setState(() {
        if (isFrom) {
          validFrom = pick;
        } else {
          validTo = pick;
        }
      });
    }
  }

  void save() {
    if (!_formKey.currentState!.validate()) return;

    final tax = EntityTax(
      id: widget.editTax?.id ?? 0,
      taxName: nameCtrl.text.trim(),
      percentage: double.parse(percentCtrl.text.trim()),
      appliesToRoomRate: appliesRoom,
      appliesToServiceCharge: appliesService,
      isCompound: isCompound,
      isInclusive: isInclusive,
      isActive: isActive,
      validFrom: validFrom != null ? DateFormat("yyyy-MM-dd").format(validFrom!) : null,
      validTo: validTo != null ? DateFormat("yyyy-MM-dd").format(validTo!) : null,
      roomTypes: selectedTypes.isEmpty ? null : selectedTypes.join(","),
      taxUuid: widget.editTax?.taxUuid,
    );

    Get.find<ControllerTax>().saveTax(tax);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.editTax == null ? "Add Tax" : "Edit Tax")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Tax Name"),
                validator: (v) => v!.isEmpty ? "Enter name" : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: percentCtrl,
                decoration: const InputDecoration(labelText: "Percentage"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Enter percentage" : null,
              ),

              SwitchListTile(
                value: appliesRoom,
                onChanged: (v) => setState(() => appliesRoom = v),
                title: const Text("Applies to Room Rate"),
              ),
              SwitchListTile(
                value: appliesService,
                onChanged: (v) => setState(() => appliesService = v),
                title: const Text("Applies to Service Charge"),
              ),
              SwitchListTile(
                value: isCompound,
                onChanged: (v) => setState(() => isCompound = v),
                title: const Text("Compound Tax"),
              ),
              SwitchListTile(
                value: isInclusive,
                onChanged: (v) => setState(() => isInclusive = v),
                title: const Text("Inclusive Tax"),
              ),
              SwitchListTile(
                value: isActive,
                onChanged: (v) => setState(() => isActive = v),
                title: const Text("Active"),
              ),

              const SizedBox(height: 20),
              Text("Room Types"),
              Wrap(
                spacing: 6,
                children: roomTypes.map((type) {
                  final selected = selectedTypes.contains(type);
                  return FilterChip(
                    label: Text(type),
                    selected: selected,
                    onSelected: (v) {
                      setState(() {
                        if (v) selectedTypes.add(type);
                        else selectedTypes.remove(type);
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => pickDate(true),
                      child: Text(validFrom == null ? "Valid From" : validFrom!.toString().split(" ")[0]),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => pickDate(false),
                      child: Text(validTo == null ? "Valid To" : validTo!.toString().split(" ")[0]),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: save,
                child: const Text("Save Tax"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
