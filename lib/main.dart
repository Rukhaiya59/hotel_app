import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotel/server/server_controller.dart';
import 'package:hotel/service/service_currency.dart';
import 'repository/repo_get_storage.dart';
import 'service/service_locale.dart';
import 'service/service_object_box.dart';
import 'service/service_storage.dart';
import 'service/service_theme.dart';
import 'util/app_route.dart';
import 'util/app_theme.dart';
import 'util/app_translation.dart';


void main() async {
  await initServices();
  runApp(MyApp());
  ServerController();
}

Future<void> initServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  /// GetStorage ///
  await GetStorage.init();

  // // ✅ STEP 1: Initialize ServiceStorage properly
  // final serviceStorage = await ServiceStorage().init(); // <-- this ensures _box is ready
  // Get.put(serviceStorage); // register instance
  //
  // // ✅ STEP 2: Initialize RepoGetStorage
  // final repoGetStorage = RepoGetStorage(storage: serviceStorage);
  // Get.put(repoGetStorage);
  var storage = await ServiceStorage().init();
  await Get.putAsync<RepoGetStorage>(() async => RepoGetStorage(storage: storage));
  // ObjectBox
  await Get.putAsync<ServiceObjectBox>(() async => ServiceObjectBox().init());
  // Sync services
  Get.put(ServiceTheme());
  Get.put(ServiceLocale());
  Get.put(AppTranslation());
  Get.put(ServiceCurrency());

  // final dir = await getApplicationDocumentsDirectory();
  // String fileName = 'GetStorage';
  // final _file = File('${dir.path}/$fileName.bak');
  // debugPrint(_file.path);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final themeService = Get.find<ServiceTheme>();
  final localeService = Get.find<ServiceLocale>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      smartManagement: SmartManagement.full,
      debugShowCheckedModeBanner: false,
      title: 'app_title'.tr,
      translations: AppTranslation(),
      locale: localeService.locale,
      fallbackLocale: const Locale('en', 'US'),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeService.theme,
      initialRoute: AppRoute.splash,
      getPages: AppRoute.pages,
    );
  }
}
