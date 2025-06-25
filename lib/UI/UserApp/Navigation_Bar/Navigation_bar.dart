import 'package:flutter/material.dart';
import 'package:sentinix_ecommerce/Alertbox/alertdialogBottomNav.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Home_screen.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Notifications/notification.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/OrderScreen/order_screen.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Profile/profile/profile_screen.dart';

class DashBoardScreen extends StatefulWidget {
  final int? selectTab;
  const DashBoardScreen({super.key, this.selectTab});

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

  void _initSelectedTab() {
    if (widget.selectTab != null && widget.selectTab! >= 0 && widget.selectTab! < _pages.length) {
      _selectedIndex = widget.selectTab!;
    }
  }

  @override
  void initState() {
    super.initState();
    _initSelectedTab();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const DashBoardScreen()),
                  (route) => false,
            );
          });
          return false;
        } else {
          if (Navigator.of(context).canPop()) return true;
          final shouldExit = await showExitConfirmationDialog(
            context,
            MediaQuery.of(context).size,
          );
          return shouldExit;
        }
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: _pages[_selectedIndex],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            bottom: 12.0,
          ),
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
                final isSelected = index == _selectedIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedIndex = index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isSelected ? accentColor : Colors.transparent,
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
      ),
    );
  }
}
