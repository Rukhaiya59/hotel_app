import 'dart:convert';
import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';

import '../../../../model/entity_booking.dart';
import '../../../../model/entity_guest.dart';
import '../../../../objectbox.g.dart';
import '../../../../service/service_object_box.dart';


class ControllerGuestCRM extends GetxController {
  late Box<EntityGuest> boxGuest;
  late Box<EntityBooking> boxBooking;

  /// Full list of guests
  final RxList<EntityGuest> guests = <EntityGuest>[].obs;

  /// List with search + filter applied
  final RxList<EntityGuest> filtered = <EntityGuest>[].obs;

  /// Search value
  final RxString searchQuery = ''.obs;

  /// guestType filter: vip, corporate, walkin, group, blacklisted, all
  final RxString filterType = 'all'.obs;

  @override
  void onInit() {
    super.onInit();

    final ob = Get.find<ServiceObjectBox>();
    boxGuest = ob.store.box<EntityGuest>();
    boxBooking = ob.store.box<EntityBooking>();

    loadGuests();

    /// reactive search + filter
    ever(searchQuery, (_) => applyFilters());
    ever(filterType, (_) => applyFilters());
  }

  //  Load all CRM guest profiles
  void loadGuests() {
    guests.value = boxGuest.getAll();
    // todo: shafik
    applyFilters();
  }



  //  Apply search + guestType filter
  void applyFilters() {
    final q = searchQuery.value.trim().toLowerCase();
    final type = filterType.value;

    final results = guests.where((g) {
      // Filter by guest type
      if (type != 'all' && g.guestType != type) {
        return false;
      }

      // Search by name/phone/email
      if (q.isNotEmpty) {
        if (!(
            g.first.toLowerCase().contains(q) ||
                g.last.toLowerCase().contains(q) ||
                (g.phone ?? '').toLowerCase().contains(q) ||
                (g.email ?? '').toLowerCase().contains(q)
        )) {
          return false;
        }
      }

      return true;
    }).toList();

    filtered.value = results;
  }

  void updateGuestInUI(EntityGuest updated) {
    final index = guests.indexWhere((g) => g.guestUuid == updated.guestUuid);
    if (index != -1) {
      guests[index] = updated;
    } else {
      guests.add(updated);
    }

    guests.refresh();
    applyFilters(); // updates search/filter list too
  }

  // Create OR Update CRM Guest from a Booking Guest
  EntityGuest createOrUpdateGuest(EntityGuest inputGuest, double billAmount) {
    // Prefer stable unique id: guestUuid (fall back to guestId if needed)
    final queryBuilder = (inputGuest.guestUuid != null && inputGuest.guestUuid.isNotEmpty)
        ? boxGuest.query(EntityGuest_.guestUuid.equals(inputGuest.guestUuid))
        : boxGuest.query(EntityGuest_.guestId.equals(inputGuest.guestId));

    final existing = queryBuilder.build().findFirst();

    if (existing == null) {
      // new guest: ensure defaults are set
      inputGuest.totalVisits = (inputGuest.totalVisits ?? 0) + 1;
      inputGuest.totalSpending = (inputGuest.totalSpending ?? 0.0) + billAmount;

      final id = boxGuest.put(inputGuest);
      return boxGuest.get(id)!;
    } else {
      // merge fields
      existing.first = inputGuest.first.isNotEmpty ? inputGuest.first : existing.first;
      existing.last = inputGuest.last.isNotEmpty ? inputGuest.last : existing.last;

      existing.phone = (inputGuest.phone != null && inputGuest.phone!.isNotEmpty)
          ? inputGuest.phone
          : existing.phone;

      existing.email = (inputGuest.email != null && inputGuest.email!.isNotEmpty)
          ? inputGuest.email
          : existing.email;

      existing.gender = inputGuest.gender.isNotEmpty ? inputGuest.gender : existing.gender;
      existing.dob = inputGuest.dob.isNotEmpty ? inputGuest.dob : existing.dob;

      existing.idName = inputGuest.idName.isNotEmpty ? inputGuest.idName : existing.idName;
      existing.idValue = inputGuest.idValue.isNotEmpty ? inputGuest.idValue : existing.idValue;

      // ⭐⭐⭐ MAIN FIX — GUEST TYPE UPDATE ⭐⭐⭐
      existing.guestType = inputGuest.guestType.isNotEmpty
          ? inputGuest.guestType
          : existing.guestType;

      // Notes
      existing.notes = (inputGuest.notes != null && inputGuest.notes!.isNotEmpty)
          ? inputGuest.notes
          : existing.notes;

      // Visits + Spending
      existing.totalVisits = (existing.totalVisits ?? 0) + 1;
      existing.totalSpending =
          (existing.totalSpending ?? 0.0) + billAmount;

      boxGuest.put(existing);
      return existing;
    }

  }


  //  Attach guest → booking
  void attachGuestToBooking(EntityBooking booking, EntityGuest guest) {
    boxBooking.put(booking);

    // Reverse relation: guest → booking
    guest.bookings.add(booking);
    boxGuest.put(guest);
  }

  // JSON helpers for preferences & tags

  List<String> decodeList(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      return List<String>.from(jsonDecode(jsonStr));
    } catch (_) {
      return [];
    }
  }

  String encodeList(List<String> list) {
    return jsonEncode(list);
  }

  // Update guest preferences list
  void updatePreferences(EntityGuest guest, List<String> prefs) {
    guest.preferencesJson = encodeList(prefs);
    boxGuest.put(guest);
    loadGuests();
  }

  // Update guest tags
  void updateTags(EntityGuest guest, List<String> tags) {
    guest.tagsJson = encodeList(tags);
    boxGuest.put(guest);
    loadGuests();
  }
}
