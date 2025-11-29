import '../service/service_storage.dart';
class RepoGetStorage {
  final ServiceStorage storage;

  RepoGetStorage({required this.storage});

  String? getLocale() {
    return storage.read("locale");
  }

  Future<void> setLocale(String? locale) async {
    await storage.write("locale", locale);
  }

  String? getThemeMode() {
    return storage.read("themeMode");
  }

  Future<void> setThemeMode(String? themeMode) async {
    await storage.write("themeMode", themeMode);
  }

  // String? getHotelUuid() {
  //   return storage.read("a");
  // }
  //
  // Future<void> setHotelUuid(String? value) async {
  //   await storage.write("a", value);
  // }
  String? getHotelUuid() {
    return storage.read("hotelUuid");
  }

  Future<void> setHotelUuid(String? value) async {
    await storage.write("hotelUuid", value);
  }


  String? getHotelJsonString() {
    return storage.read("b");
  }

  Future<void> setHotelJsonString(String? value) async {
    await storage.write("b", value);
  }

  String? getUser() {
    return storage.read("c");
  }

  Future<void> setUser(String? value) async {
    await storage.write("c", value);
  }


  Future<void> setUserUuid(String? value) async {
    await storage.write("d", value);
  }
// --- Booking Reset ---
  String getLastBookingDate() => storage.read("lastBookingDate") ?? "";
  Future<void> setLastBookingDate(String value) async =>
      await storage.write("lastBookingDate", value);

  int getLastBookingNumber() => storage.read("lastBookingNumber") ?? 0;
  Future<void> setLastBookingNumber(int value) async =>
      await storage.write("lastBookingNumber", value);

  String getResetBookingType() => storage.read("resetBookingType") ?? "Daily";
  Future<void> setResetBookingType(String value) async =>
      await storage.write("resetBookingType", value);

  String? getUserUuid() {
    return storage.read("d");
  }

  Future<void> setCurrency(String? value) async {
    await storage.write("e", value);
  }

  String getCurrency() {
    return storage.read("e") ?? "INR";
  }

  clearGetStorage() {
    storage.clear();
  }
}