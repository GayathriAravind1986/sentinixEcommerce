import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentinix_ecommerce/Bloc/demo/demo_bloc.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/image.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Authentication/login.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Profile/MyOrders/my_order_screen.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Profile/profile/profile_info_page.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Profile/profile/widget/profile_tile_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: const ProfileScreenView(),
    );
  }
}

class ProfileScreenView extends StatefulWidget {
  const ProfileScreenView({super.key});

  @override
  ProfileScreenViewState createState() => ProfileScreenViewState();
}

class ProfileScreenViewState extends State<ProfileScreenView> {
  String userName = 'Sriram D';
  ImageProvider? profileImage;
  String? errorMessage;
  bool loginLoad = false;

  @override
  void initState() {
    super.initState();
    profileImage = const AssetImage('assets/image/profile.png');
  }

  @override
  void dispose() {
    super.dispose();
  }

  void navigateToProfileInfo() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileInfoPage(
          userName: userName,
          profileImage: profileImage,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        userName = result['name'];
        if (result['image'] != null) {
          profileImage = result['image'];
        }
      });
    }
  }

  void _deleteAccount() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account deleted successfully')),
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _logout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully')),
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account',
              style: MyTextStyle.f16(appPrimaryColor, weight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your account can\'t be restored after deletion',
                  style: MyTextStyle.f13(redColor, weight: FontWeight.w400),
                ),
                const SizedBox(height: 10),
                Text(
                  'Are you sure you want to delete your account?',
                  style: MyTextStyle.f13(appSecondaryColor,
                      weight: FontWeight.w400),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(color: appPrimaryColor, width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(
                          "Cancel",
                          style: MyTextStyle.f13(appSecondaryColor,
                              weight: FontWeight.w400),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        color: appPrimaryColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: appPrimaryColor, width: 1.5),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                          //SystemNavigator.pop(); // Closes the app
                        },
                        child: Text(
                          "Delete",
                          style: MyTextStyle.f13(whiteColor,
                              weight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout', style: TextStyle(color: Colors.black)),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(color: appPrimaryColor, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      "Cancel",
                      style: MyTextStyle.f13(appSecondaryColor,
                          weight: FontWeight.w400),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: appPrimaryColor,
                    border: Border.all(color: appPrimaryColor, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      SharedPreferences sharedPreference =
                          await SharedPreferences.getInstance();
                      await sharedPreference.remove('userId');
                      await sharedPreference.remove('roleId');
                      await sharedPreference.remove('token');
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginCustomer()),
                          (route) => false);
                    },
                    child: Text(
                      "Logout",
                      style:
                          MyTextStyle.f13(whiteColor, weight: FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContainer() {
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: appPrimaryColor,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                        Images.profile,
                      )),
                ),
                const SizedBox(height: 12),
                Text(userName,
                    style:
                        MyTextStyle.f20(whiteColor, weight: FontWeight.w500)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: appPrimaryColor, width: 1)),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  CustomTile(
                    icon: Icons.person,
                    title: 'Personal Info',
                    onTap: () {
                      navigateToProfileInfo();
                    },
                  ),
                  CustomTile(
                    icon: Icons.shopping_bag_outlined,
                    title: 'My Orders',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyOrderScreen(),
                        ),
                      );
                    },
                  ),
                  CustomTile(
                      icon: Icons.delete_outline,
                      title: 'Delete My Account',
                      onTap: () {
                        showDeleteAccountDialog();
                      }),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: appPrimaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                          leading: const Icon(Icons.logout, color: whiteColor),
                          title: Text(
                            'Logout',
                            style: MyTextStyle.f16(whiteColor,
                                weight: FontWeight.w500),
                          ),
                          onTap: () {
                            showLogoutConfirmationDialog();
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: appPrimaryColor,
          title: Text("Profile",
              style: MyTextStyle.f20(whiteColor, weight: FontWeight.w600)),
          centerTitle: true,
        ),
      ),
      body: BlocBuilder<DemoBloc, dynamic>(
        buildWhen: (previous, current) {
          return true;
        },
        builder: (context, dynamic) {
          return mainContainer();
        },
      ),
    );
  }
}
