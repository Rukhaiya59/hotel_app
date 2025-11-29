// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'controller_splash.dart';
//
// class ActivitySplash extends GetView<ControllerSplash> {
//   const ActivitySplash({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // final controller = Get.put(ControllerSplash());
//     final controller = Get.find<ControllerSplash>();
//
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//
//         decoration: const BoxDecoration(
//           color: Colors.black87,
//         ),
//
//         child: SafeArea(
//           child: Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Logo circle
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withValues(alpha: 0.08),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.bed,
//                     size: 60,
//                     color: Colors.white,
//                   ),
//                 ),
//
//                 const SizedBox(height: 30),
//
//                 const Text(
//                   'RH Hotel',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 36,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1.5,
//                   ),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 Text(
//                   'Relax • Comfort • Luxury',
//                   style: TextStyle(
//                     color: Colors.white60,
//                     fontSize: 18,
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//
//                 const SizedBox(height: 50),
//
//                 const CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 3,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller_splash.dart';

class ActivitySplash extends GetView<ControllerSplash> {
  const ActivitySplash({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ControllerSplash>();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // 🌙 THEME BASED BACKGROUND
        decoration: BoxDecoration(
          color: isDark ? Colors.black87 : Colors.white,
        ),

        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔵 LOGO (theme-based transparency box)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: (isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.black.withOpacity(0.08))
                        .withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.bed,
                    size: 60,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),

                const SizedBox(height: 30),

                // 🌟 HOTEL NAME
                Text(
                  'RH Hotel',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Relax • Comfort • Luxury',
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontSize: 18,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 50),

                CircularProgressIndicator(
                  color: isDark ? Colors.white : Colors.black87,
                  strokeWidth: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
