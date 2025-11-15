import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repository/repo_get_storage.dart';

class ServiceLocale extends GetxService {
  final RepoGetStorage _repoGetStorage = Get.find();

  Locale get locale => _loadLocale();

  Locale _loadLocale() {
    final code = _repoGetStorage.getLocale();
    if (code == null) return Get.deviceLocale ?? const Locale('en', 'US');
    final parts = code.split('_');
    return Locale(parts[0], parts.length > 1 ? parts[1] : null);
  }

  Future<void> update(Locale locale) async {
    final code = locale.countryCode == null
        ? locale.languageCode
        : '${locale.languageCode}_${locale.countryCode}';
    _repoGetStorage.setLocale(code);
    Get.updateLocale(locale);
  }
}
