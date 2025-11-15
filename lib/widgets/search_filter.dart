// import 'package:flutter/material.dart';
// import '../util/app_color.dart';
// import '../widgets/secondary_button.dart';
//
// typedef OnSearchChanged = void Function(String query);
// typedef OnFilterPressed = void Function();
//
// class SearchFilterWidget extends StatelessWidget {
//   final String hintText;
//   final OnSearchChanged? onSearchChanged;
//   final OnFilterPressed? onFilterPressed;
//   final TextEditingController? controller;
//
//   const SearchFilterWidget({
//     super.key,
//     this.hintText = "Search",
//     this.onSearchChanged,
//     this.onFilterPressed,
//     this.controller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController _controller = controller ?? TextEditingController();
//
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             controller: _controller,
//             onChanged: onSearchChanged,
//             decoration: InputDecoration(
//               hintText: hintText,
//               prefixIcon: Icon(Icons.search, color: LightColor.primaryStart),
//               suffixIcon: _controller.text.isEmpty
//                   ? null
//                   : IconButton(
//                 icon: const Icon(Icons.clear),
//                 onPressed: () {
//                   _controller.clear();
//                   if (onSearchChanged != null) onSearchChanged!("");
//                 },
//               ),
//               filled: true,
//               fillColor: Colors.white.withOpacity(0.9),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         if (onFilterPressed != null)
//           SecondaryButton(
//             text: "Filter",
//             onPressed: onFilterPressed!,
//             height: 50,
//             borderRadius: 14,
//           ),
//       ],
//     );
//   }
// }
