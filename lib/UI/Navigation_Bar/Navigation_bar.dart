import 'package:flutter/material.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Profile/profile_screen.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import '../../Reusable/color.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({super.key});

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  int _currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final List<BottomNavigationBarItem> navItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Order'),
    BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'Notification'),
    BottomNavigationBarItem(icon: Icon(Icons.contact_mail), label: 'profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      showUnselectedLabels: true,
      selectedFontSize: 14,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: appPrimaryColor,
      unselectedItemColor: blackColor.withOpacity(0.5),
      backgroundColor: appSecondaryColor ,
      onTap: onTap,
      items: navItems,
    );
  }
}
