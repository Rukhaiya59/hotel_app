import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repository/repo_get_storage.dart';

class ServiceTheme extends GetxService {
  final RepoGetStorage repoGetStorage = Get.find();
  static const _key = 'themeMode';

  ThemeMode get theme => _loadTheme();
  bool get isDarkMode {
    if (theme == ThemeMode.system) {
      return Get.isPlatformDarkMode;
    } else {
      return theme == ThemeMode.dark;
    }
  }

  ThemeMode _loadTheme() {
    final value = repoGetStorage.getThemeMode();
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> update(ThemeMode mode) async {
    repoGetStorage.setThemeMode(mode.name);
    Get.changeThemeMode(mode);
  }

  void toggle() {
    final next = theme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    update(next);
  }
}
