// import 'package:flutter/material.dart';
// import 'package:sentinix_ecommerce/Reusable/color.dart';
//
// class DashBoardScreen extends StatefulWidget {
//   const DashBoardScreen({super.key});
//   @override
//   State<DashBoardScreen> createState() => _DashBoardScreenState();
// }
//
// class _DashBoardScreenState extends State<DashBoardScreen> {
//   int _selectedIndex = 0;
//
//   final List<IconData> _icons = [
//     Icons.home,
//     Icons.shopping_bag_outlined,
//     Icons.chat_bubble_outline,
//     Icons.person_outline,
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueGrey[50],
//       body: Center(
//         child: Text(
//           'Page ${_selectedIndex + 1}',
//           style: const TextStyle(fontSize: 24, color: Colors.black87),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
//         child: Container(
//           height: 70,
//           decoration: BoxDecoration(
//             color: appPrimaryColor,
//             borderRadius: BorderRadius.circular(40),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.15),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: List.generate(_icons.length, (index) {
//               bool isSelected = index == _selectedIndex;
//               return GestureDetector(
//                 onTap: () => setState(() => _selectedIndex = index),
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: isSelected ? appSecondaryColor : Colors.transparent,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     _icons[index],
//                     color: isSelected ? Colors.white : Colors.white70,
//                     size: 26,
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Home_screen.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Notifications/notification.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/OrderScreen/order_screen.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Profile/Profile/profile_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    OrderScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.shopping_bag_outlined,
    Icons.notifications,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: appPrimaryColor,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_icons.length, (index) {
              bool isSelected = index == _selectedIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected ? appSecondaryColor : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _icons[index],
                    color: isSelected ? whiteColor : whiteColor70,
                    size: 26,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
