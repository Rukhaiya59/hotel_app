// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hotel/widgets/secondary_button.dart';
// import '../../service/service_theme.dart';
// import '../../util/app_color.dart';
// import '../../util/app_theme.dart';
// import 'controller_login.dart';
//
// class ActivityLogin extends GetView<ControllerLogin> {
//   const ActivityLogin({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ControllerLogin());
//     final themeService = Get.find<ServiceTheme>();
//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           bool isWide = constraints.maxWidth > 700;
//
//           return Row(
//             children: [
//               if (isWide)
//                 Expanded(
//                   flex: 1,
//                   child: Container(
//
//                     // 🔥 EXACT SAME AS SPLASH SCREEN
//                     decoration: const BoxDecoration(
//                       color: Colors.black87,
//                     ),
//
//                     child: Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: const [
//                           Icon(
//                             Icons.bed_outlined,
//                             color: Colors.white,
//                             size: 120,
//                           ),
//                           SizedBox(height: 25),
//                           Text(
//                             'RH Hotel',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 36,
//                               fontWeight: FontWeight.bold,
//                               letterSpacing: 1.2,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             'Relax • Comfort • Luxury',
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 18,
//                               letterSpacing: 1.1,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   // decoration: const BoxDecoration(
//                   //   gradient: LinearGradient(
//                   //     colors: [LightColor.background, LightColor.lightGrey],
//                   //     begin: Alignment.topCenter,
//                   //     end: Alignment.bottomCenter,
//                   //   ),
//                   // ),
//                   decoration: const BoxDecoration(
//                     color: Colors.black87,
//                   ),
//
//                   child: Center(
//                     child: SingleChildScrollView(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 40,
//                         vertical: 30,
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(
//                             Icons.lock_outline,
//                             color: Colors.white,
//                             size: 70,
//                           ),
//                           const SizedBox(height: 20),
//                           Text(
//                             'Login To Continue',
//                             style: TextStyle(
//                               fontSize: 26,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white.withValues(alpha: 0.9),
//                             ),
//                           ),
//                           const SizedBox(height: 35),
//
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white.withValues(alpha: 0.9),
//                               borderRadius: BorderRadius.circular(14),
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Colors.black12,
//                                   blurRadius: 6,
//                                   offset: Offset(1, 3),
//                                 ),
//                               ],
//                             ),
//                             child: TextField(
//                               controller: controller.emailController,
//                               style: const TextStyle(color: LightColor.black),
//                               decoration: InputDecoration(
//                                 hintText: 'Email',
//                                 hintStyle: TextStyle(
//                                   color: LightColor.grey.withValues(alpha: 0.8),
//                                 ),
//                                 prefixIcon: const Icon(
//                                   Icons.email_outlined,
//                                   color: Colors.black87,
//                                 ),
//                                 border: InputBorder.none,
//                                 contentPadding: const EdgeInsets.symmetric(
//                                   horizontal: 16,
//                                   vertical: 18,
//                                 ),
//                               ),
//                             ),
//                           ),
//
//                           const SizedBox(height: 18),
//
//                           Obx(
//                             () => Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withValues(alpha: 0.9),
//                                 borderRadius: BorderRadius.circular(14),
//                                 boxShadow: const [
//                                   BoxShadow(
//                                     color: Colors.black12,
//                                     blurRadius: 6,
//                                     offset: Offset(1, 3),
//                                   ),
//                                 ],
//                               ),
//                               child: TextField(
//                                 controller: controller.passwordController,
//                                 obscureText: controller.isPasswordHidden.value,
//                                 style: const TextStyle(color: LightColor.black),
//                                 decoration: InputDecoration(
//                                   hintText: 'Password',
//                                   hintStyle: TextStyle(
//                                     color: LightColor.grey.withValues(alpha:0.8),
//                                   ),
//                                   prefixIcon: const Icon(
//                                     Icons.lock_outline,
//                                     color: Colors.black87,
//                                   ),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       controller.isPasswordHidden.value
//                                           ? Icons.visibility_off_outlined
//                                           : Icons.visibility_outlined,
//                                       color: LightColor.darkgrey,
//                                     ),
//                                     onPressed:
//                                         controller.togglePasswordVisibility,
//                                   ),
//                                   border: InputBorder.none,
//                                   contentPadding: const EdgeInsets.symmetric(
//                                     horizontal: 16,
//                                     vertical: 18,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//
//                           const SizedBox(height: 30),
//
//                           // Container(
//                           //   width: double.infinity,
//                           //   height: 50,
//                           //   decoration: BoxDecoration(
//                           //     gradient: const LinearGradient(
//                           //       colors: [
//                           //         LightColor.primaryStart,
//                           //         LightColor.primaryEnd,
//                           //       ],
//                           //       begin: Alignment.topLeft,
//                           //       end: Alignment.bottomRight,
//                           //     ),
//                           //     borderRadius: BorderRadius.circular(14),
//                           //     boxShadow: [
//                           //       BoxShadow(
//                           //         color: LightColor.primaryStart.withValues(alpha:
//                           //           0.3,
//                           //         ),
//                           //         blurRadius: 8,
//                           //         offset: const Offset(2, 5),
//                           //       ),
//                           //     ],
//                           //   ),
//                             child: ElevatedButton(
//
//                               onPressed: controller.login, child: const Text(
//                                 'Login',style: TextStyle(color: Colors.black87),
//                             ),
//                           ),
//                       ),
//                     ]),
//                   ),
//                 ),
//               ),
//               )],
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../service/service_theme.dart';
import 'controller_login.dart';

class ActivityLogin extends GetView<ControllerLogin> {
  const ActivityLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ControllerLogin());
    final themeService = Get.find<ServiceTheme>();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 700;

          return Row(
            children: [
              if (isWide)
                Expanded(
                  flex: 1,
                  child: Container(
                    // 🔥 SAME AS SPLASH SCREEN
                    decoration: const BoxDecoration(
                      color: Colors.black87,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.bed_outlined,
                              color: Colors.white, size: 120),
                          SizedBox(height: 25),
                          Text(
                            'RH Hotel',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Relax • Comfort • Luxury',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                                letterSpacing: 1.1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // RIGHT SIDE
              Expanded(
                flex: 1,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.lock_outline,
                            color: Colors.white,
                            size: 70,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Login To Continue',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 35),

                          // EMAIL BOX
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(1, 3),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: controller.emailController,
                              style: const TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                    color: Colors.black87),
                                prefixIcon: const Icon(Icons.email_outlined,
                                    color: Colors.black87),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 18),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // PASSWORD BOX
                          Obx(
                                () => Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(1, 3),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: controller.passwordController,
                                obscureText: controller.isPasswordHidden.value,
                                style: const TextStyle(color: Colors.black87),
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                      color: Colors.black87),
                                  prefixIcon: const Icon(Icons.lock_outline,
                                      color: Colors.black87),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.isPasswordHidden.value
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.black54,
                                    ),
                                    onPressed:
                                    controller.togglePasswordVisibility,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // LOGIN BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: controller.login,
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 18),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
