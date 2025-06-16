import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple/Bloc/demo/demo_bloc.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/elevated_button.dart';
import 'profile_info_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: const ProfilePageView(),
    );
  }
}

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  @override
  ProfilePageViewState createState() => ProfilePageViewState();
}

class ProfilePageViewState extends State<ProfilePageView> {
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

  void _navigateToProfileInfo() async {
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

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account', style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your account can\'t be restored after deletion',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Are you sure you want to delete your account?',
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: CustomButton(
                        text: 'CANCEL',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: CustomButton(
                        text: 'DELETE',
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteAccount();
                        },
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

  void _showLogoutConfirmationDialog() {
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: CustomButton(
                    text: 'NO',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: CustomButton(
                    text: 'YES',
                    onPressed: () {
                      Navigator.pop(context);
                      _logout();
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: appPrimaryColor),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }

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
              GestureDetector(
                onTap: _navigateToProfileInfo,
                child: Container(
                  decoration: BoxDecoration(
                    color: appSecondaryColor,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    backgroundImage: profileImage,
                    child: profileImage == null
                        ? const Icon(Icons.person, size: 60, color: appSecondaryColor)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                _buildTile(
                  icon: Icons.person,
                  title: 'Personal Info',
                  onTap: _navigateToProfileInfo,
                ),
                _buildTile(
                  icon: Icons.shopping_bag_outlined,
                  title: 'My Orders',
                  onTap: () {},
                ),
                _buildTile(
                  icon: Icons.delete_outline,
                  title: 'Delete My Account',
                  onTap: _showDeleteAccountDialog,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7E67),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: Colors.white),
                      title: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: _showLogoutConfirmationDialog,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7F5),
      body: BlocBuilder<DemoBloc, dynamic>(
        buildWhen: (previous, current) => false,
        builder: (context, dynamic) => mainContainer(),
      ),
    );
  }
}