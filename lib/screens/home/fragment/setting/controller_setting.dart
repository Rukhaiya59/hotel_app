import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotel/enums/enum_drawer_menu.dart';
import '../../../../repository/repo_constants.dart';
import '../../../../service/service_currency.dart';
import '../../../../service/service_locale.dart';
import '../../../../service/service_theme.dart';
import '../../controller_home.dart';

class ControllerSetting extends GetxController {
  final ServiceTheme serviceTheme = Get.find();
  final ServiceCurrency serviceCurrency = Get.find();

  final ServiceLocale _serviceLocale = Get.find();
  late RxString currentCurrency;
  var resetBookingType = "Daily".obs;
  final List<String> resetBookingOptions = [
    "Daily",
    "Weekly",
    "Monthly",
    "Quarterly",
    "Yearly",
  ];
  // final RepoGetStorage repoGetStorage = RepoGetStorage(storage: Get.find());

  late Rx<ThemeMode> currentTheme;
  late Rx<Locale> currentLocale;
  //
  // late RxString currentCurrencyCode;
  // late RxString currentCurrencySymbol;

  @override
  void onInit() {
    super.onInit();
    currentTheme = serviceTheme.theme.obs;
    currentLocale = _serviceLocale.locale.obs;
    currentCurrency = serviceCurrency.currency;
    // currentCurrencyCode = repoGetStorage.getCurrency().obs;
    // currentCurrencySymbol = repoGetStorage.getCurrency().obs;
//booking id
    final box = GetStorage();
    resetBookingType.value = box.read("resetBookingType") ?? "Daily";
    }


    void toggleTheme() {
    final newTheme = currentTheme.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    serviceTheme.update(newTheme);
    currentTheme.value = newTheme;
  }

  Future<void> changeLanguage(String code) async {
    final parts = code.split('_');
    final newLocale = Locale(parts[0], parts.length > 1 ? parts[1] : null);
    await _serviceLocale.update(newLocale);
    currentLocale.value = newLocale;

    updateDrawerAfterLanguageChange(); // ✅ this function is now inside
  }
  void updateDrawerAfterLanguageChange() {
    final homeCtrl = Get.find<ControllerHome>();

    homeCtrl.rxListDrawer.value = RepoConstants.getSampleListForRole(
      homeCtrl.rxUser.value.role ?? "",
    );

    final selectedEnum = EnumDrawerMenu.values.firstWhere(
          (e) =>
      e.value ==
          EnumDrawerMenu.values
              .firstWhere(
                (item) =>
            item.value.tr ==
                homeCtrl.rxSelectedDrawer.value.title,
            orElse: () => EnumDrawerMenu.dashboard,
          )
              .value,
    );

    homeCtrl.rxSelectedDrawer.value = homeCtrl.rxListDrawer.firstWhere(
          (item) => item.title == selectedEnum.value.tr,
      orElse: () => homeCtrl.rxListDrawer.first,
    );
  // }
  // Future<void> changeCurrency(String code, String symbol) async {
  //   await repoGetStorage.setCurrency(code);
  //   await repoGetStorage.setCurrency(symbol);
  //   currentCurrencyCode.value = code;
  //   currentCurrencySymbol.value = symbol;
  }
  void changeCurrency(String currencyCode) {
    serviceCurrency.updateCurrency(currencyCode);
    currentCurrency.value = currencyCode;
    }
  Future<void> saveSettings() async {
    final box = GetStorage();

    // Save Theme
    await serviceTheme.update(currentTheme.value);

    // Save Language
    await _serviceLocale.update(currentLocale.value);

    // Save Currency
    serviceCurrency.updateCurrency(currentCurrency.value);

    // Save Reset Booking Type
    await box.write("resetBookingType", resetBookingType.value);

  }

}
