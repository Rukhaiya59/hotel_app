import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../model/entity_guest.dart';
import '../../../../util/app_color.dart';

class ActivityGuestProfile extends StatelessWidget {
  final EntityGuest guest;

  const ActivityGuestProfile({super.key, required this.guest});

  @override
  Widget build(BuildContext context) {
    final bookings = guest.bookings;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? DarkColor.background : LightColor.background,
      appBar: AppBar(
        title: const Text("Guest Profile"),
        backgroundColor:
        isDark ? DarkColor.primaryStart : LightColor.primaryStart,
        elevation: 1,
      ),

      body: Row(
        children: [
          // LEFT PANEL — INFO
          // LEFT PANEL — INFO
          Container(
            width: 360,
            color: isDark ? DarkColor.background : Colors.white,
            child: SingleChildScrollView(     // 👈 FIX OVERFLOW
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: LightColor.lightBlue,
                      child: Text(
                        guest.first[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 42,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Center(
                    child: Text(
                      "${guest.first} ${guest.last}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? DarkColor.titleTextColor
                            : LightColor.titleTextColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getTypeColor(guest.guestType),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        guest.guestType.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ==== All other content here ====
                  _info("Phone", guest.phone ?? "N/A", isDark),
                  _info("Email", guest.email ?? "N/A", isDark),
                  _info("Gender", guest.gender, isDark),
                  _info("DOB", guest.dob, isDark),
                  _info("ID Type", guest.idName, isDark),
                  _info("ID Number", guest.idValue, isDark),
                  _info("Nationality", guest.nationality ?? "N/A", isDark),

                  const Divider(),

                  Text(
                    "Statistics",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: isDark
                          ? DarkColor.titleTextColor
                          : LightColor.titleTextColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _stat("Total Visits", guest.totalVisits.toString(),
                      Icons.calendar_month, Colors.blue, isDark),

                  _stat(
                      "Total Spending",
                      "₹${guest.totalSpending.toStringAsFixed(2)}",
                      Icons.payments,
                      Colors.green,
                      isDark),

                  _stat(
                      "Last Visit",
                      bookings.isNotEmpty ? bookings.last.checkInDate : "No visit",
                      Icons.history,
                      Colors.orange,
                      isDark),

                  const Divider(),

                  Text(
                    "Preferences & Tags",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: isDark
                          ? DarkColor.titleTextColor
                          : LightColor.titleTextColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 6,
                    children: [
                      ..._decodeList(guest.preferencesJson)
                          .map((e) => _chip(e, LightColor.lightBlue)),
                      ..._decodeList(guest.tagsJson)
                          .map((e) => _chip(e, Colors.orange.shade400)),
                    ],
                  ),

                  const SizedBox(height: 20),

                ],
              ),
            ),
          ),

          // RIGHT PANEL — BOOKING HISTORY
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: isDark ? DarkColor.background : Colors.white,
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(18),
                      child: Text(
                        "Booking History",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const Divider(),

                    Expanded(
                      child: ListView.builder(
                        itemCount: bookings.length,
                        itemBuilder: (_, i) {
                          final b = bookings[i];
                          return ListTile(
                            leading: const Icon(Icons.hotel, size: 26),
                            title: Text(
                              "Room: ${b.room.target?.number ?? 'N/A'}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "${b.checkInDate} → ${b.checkOutDate}\nTotal: ₹${b.totalBill.toStringAsFixed(2)}",
                            ),
                            trailing: Text(
                              b.status.toUpperCase(),
                              style: TextStyle(
                                color: _getStatusColor(b.status),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ========== Reusable components ==========

  Widget _info(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? DarkColor.subTitleTextColor
                      : LightColor.subTitleTextColor)),
          Text(value,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              )),
        ],
      ),
    );
  }

  Widget _stat(String title, String value, IconData icon, Color color,
      bool isDark) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text),
    );
  }

  List<String> _decodeList(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      return List<String>.from(jsonDecode(jsonStr));
    } catch (e) {
      return [];
    }
  }
}

// ========== Helpers ==========

Color _getTypeColor(String type) {
  switch (type.toLowerCase()) {
    case "vip":
      return Colors.amber;
    case "corporate":
      return Colors.blue;
    case "group":
      return Colors.deepPurple;
    case "blacklisted":
      return Colors.red;
    default:
      return Colors.grey;
  }
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case "confirmed":
      return Colors.green;
    case "cancelled":
      return Colors.red;
    case "checkedout":
      return Colors.orange;
    default:
      return Colors.blueGrey;
  }
}
