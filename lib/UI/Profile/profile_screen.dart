import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/image.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/Reusable/space.dart';
import 'package:sentinix_ecommerce/UI/profile/profile_section_tile.dart';
import 'package:sentinix_ecommerce/UI/profile/personal_info_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final String username = "RegisteredUser";

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Widget _buildConfirmationCard({
    required String text,
    required String confirmText,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
    required IconData icon,
  }) {
    return Card(
      elevation: 10,
      color: appSecondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: appPrimaryColor, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              text,
              style: MyTextStyle.f16(appPrimaryColor, weight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            verticalSpace(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appPrimaryColor,
                    foregroundColor: appSecondaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 4,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  icon: Icon(icon),
                  label: Text(confirmText),
                ),
                ElevatedButton.icon(
                  onPressed: onCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appPrimaryColor,
                    foregroundColor: appSecondaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 4,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  icon: const Icon(Icons.cancel),
                  label: const Text("Cancel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline, color: appSecondaryColor),
                  horizontalSpace(width: 8),
                  Text(
                    'Profile',
                    style: MyTextStyle.f26(appSecondaryColor),
                  ),
                ],
              ),
              verticalSpace(height: 10),
              Text(
                'Welcome, $username',
                style: MyTextStyle.f16(appSecondaryColor),
              ),
              verticalSpace(height: 20),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : AssetImage(Images.profileIcon) as ImageProvider,
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: appPrimaryColor,
                    child: IconButton(
                      icon: const Icon(Icons.edit, size: 18, color: appSecondaryColor),
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
              verticalSpace(height: 24),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: ProfileSectionTile(
                  title: 'Personal Information',
                  icon: Icons.info_outline,
                  child: const PersonalInfoSection(),
                ),
              ),
              verticalSpace(height: 16),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: ProfileSectionTile(
                  title: 'Delete Account',
                  icon: Icons.delete_outline,
                  child: _buildConfirmationCard(
                    text: 'Are you sure you want to delete your account permanently?',
                    confirmText: 'Delete',
                    icon: Icons.delete_outline,
                    onConfirm: () {},
                    onCancel: () {},
                  ),
                ),
              ),
              verticalSpace(height: 16),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: ProfileSectionTile(
                  title: 'Logout',
                  icon: Icons.logout,
                  child: _buildConfirmationCard(
                    text: 'Do you want to logout from your account?',
                    confirmText: 'Logout',
                    icon: Icons.logout,
                    onConfirm: () {},
                    onCancel: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfileScreen(),
  ));
}
