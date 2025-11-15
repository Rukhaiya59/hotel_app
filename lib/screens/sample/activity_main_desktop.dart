import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller_sample.dart';

class ActivitySampleDesktop extends StatelessWidget {
  final ControllerSample controller;

  const ActivitySampleDesktop({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home_title'.tr),
        actions: [
          IconButton(
            tooltip: 'toggle_theme'.tr,
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              controller.serviceTheme.toggle();
            },
          ),
          PopupMenuButton<Locale>(
            tooltip: 'change_language'.tr,
            onSelected: (local) {
              controller.serviceLocale.update(local);
            },
            itemBuilder: (_) => const [
              PopupMenuItem<Locale>(
                value: Locale('en', 'US'),
                child: Text('English'),
              ),
              PopupMenuItem<Locale>(
                value: Locale('hi', 'IN'),
                child: Text('हिंदी'),
              ),
              PopupMenuItem<Locale>(
                value: Locale('mr', 'IN'),
                child: Text('मराठी'),
              ),
              PopupMenuItem<Locale>(
                value: Locale('ur', 'PK'),
                // or Locale('ur', 'IN') if you added ur_IN
                child: Text('اردو'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
