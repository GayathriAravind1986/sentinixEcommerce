import 'package:flutter/material.dart';

class NavigatorItem {
  final Widget icon;
  final int index;
  final Widget screen;

  NavigatorItem(this.icon, this.index, this.screen);
}

List<NavigatorItem> navigatorItems = [
//   NavigatorItem(
//       const SizedBox(
//           width: 30,
//           height: 30,
//           child: ImageIcon(AssetImage("assets/png/home.png"))),
//       0,
//       const HomePage()),
//   NavigatorItem(
//     const SizedBox(
//       width: 30,
//       height: 30,
//       child: ImageIcon(
//         AssetImage(
//           "assets/png/mycourse.png",
//         ),
//       ),
//     ),
//     1,
//     const MyCourse(),
//   ),
//   NavigatorItem(
//     const SizedBox(
//         width: 30,
//         height: 30,
//         child: ImageIcon(AssetImage("assets/png/chat.png"))),
//     2,
//     const ChatShow(),
//   ),
//   NavigatorItem(
//       const SizedBox(
//           width: 30,
//           height: 30,
//           child: ImageIcon(AssetImage("assets/png/person.png"))),
//       3,
//       const Profile()),
];
List<NavigatorItem> tabNavigatorItems = [
//   NavigatorItem(
//       const SizedBox(
//           width: 50,
//           height: 50,
//           child: ImageIcon(
//             AssetImage(
//               "assets/png/home.png",
//             ),
//           )),
//       0,
//       const HomePage()),
//   NavigatorItem(
//     const SizedBox(
//       width: 50,
//       height: 50,
//       child: ImageIcon(
//         AssetImage(
//           "assets/png/mycourse.png",
//         ),
//       ),
//     ),
//     1,
//     const MyCourse(),
//   ),
//   NavigatorItem(
//     const SizedBox(
//         width: 50,
//         height: 50,
//         child: ImageIcon(AssetImage("assets/png/chat.png"))),
//     2,
//     const ChatShow(),
//   ),
//   NavigatorItem(
//       const SizedBox(
//           width: 50,
//           height: 50,
//           child: ImageIcon(AssetImage("assets/png/person.png"))),
//       3,
//       const Profile()),
];
