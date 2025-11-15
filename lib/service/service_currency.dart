import 'package:get/get.dart';

class ServiceCurrency extends GetxService {
  // Selected currency code
  final RxString currency = "INR".obs;

  // Currency symbol map stored centrally
  final Map<String, String> symbols = {
    "INR": "₹",
    "USD": "\$",
    "EUR": "€",
    "GBP": "£",
    "AED": "د.إ",
    "SAR": "﷼",
    "QAR": "ر.ق",
    "KWD": "د.ك",
    "BHD": ".د.ب",
    "OMR": "ر.ع",
  };

  Future<ServiceCurrency> init() async {
    return this;
  }

  /// Get symbol for selected currency
  String get symbol => symbols[currency.value] ?? currency.value;

  /// Change currency
  void updateCurrency(String newCurrency) {
    currency.value = newCurrency;
  }
}