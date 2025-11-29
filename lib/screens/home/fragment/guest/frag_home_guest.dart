import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../model/entity_guest.dart';
import 'activity_guest_profile.dart';
import 'controller_guest_crm.dart';

class FragHomeGuest extends StatelessWidget {
  const FragHomeGuest({super.key});

  @override
  Widget build(BuildContext context) {
    final ControllerGuestCRM crm = Get.put(ControllerGuestCRM());

    return Column(
      children: [
        //  SEARCH BAR
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: (v) => crm.searchQuery.value = v,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Search guest by name, phone, email...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),

        //  FILTER CHIPS
        SizedBox(
          height: 45,
          child: Obx(() {
            return ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                _filterChip("all", "All", crm),
                _filterChip("vip", "VIP", crm),
                _filterChip("corporate", "Corporate", crm),
                _filterChip("group", "Group", crm),
                _filterChip("walkin", "Walk-in", crm),
                _filterChip("blacklisted", "Blacklisted", crm),
              ],
            );
          }),
        ),

        const SizedBox(height: 8),

        // 👤 GUEST LIST
        Expanded(
          child: Obx(() {
            if (crm.filtered.isEmpty) {
              return const Center(
                child: Text(
                  "No guest profiles found",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: crm.filtered.length,
              itemBuilder: (_, i) => _guestCard(crm.filtered[i]),
            );
          }),
        ),
      ],
    );
  }

  //  FILTER CHIP
  Widget _filterChip(String key, String label, ControllerGuestCRM crm) {
    final bool selected = crm.filterType.value == key;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => crm.filterType.value = key,
        selectedColor: Colors.blue,
        backgroundColor: Colors.grey.shade300,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  //  GUEST CARD (CRM)
  Widget _guestCard(EntityGuest g) {
    final tags = _safeTags(g.tagsJson);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          "${g.first} ${g.last}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Phone: ${g.phone ?? 'N/A'}"),
            Text("Email: ${g.email ?? 'N/A'}"),
            Text("Type: ${g.guestType.toUpperCase()}"),

            const SizedBox(height: 5),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(width: 6),
                Text("Visits: ${g.totalVisits}"),
              ],
            ),

            Row(
              children: [
                Icon(Icons.payments, size: 16, color: Colors.green.shade700),
                const SizedBox(width: 6),
                Text("Spent: ₹${g.totalSpending.toStringAsFixed(2)}"),
              ],
            ),

            if (tags.isNotEmpty) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                children: tags.map((t) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      t,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {;
        Get.to(() => ActivityGuestProfile(guest: g));
        },
      ),
    );
  }

  // Safely decode tag list
  List<String> _safeTags(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      return List<String>.from(jsonDecode(jsonStr));
    } catch (_) {
      return [];
    }
  }
}
