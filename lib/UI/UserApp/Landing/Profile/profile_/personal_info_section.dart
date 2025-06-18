import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:sentinix_ecommerce/Bloc/demo/demo_bloc.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/elevated_button.dart';

class ProfileInfoPage extends StatelessWidget {
  final String userName;
  final ImageProvider? profileImage;

  const ProfileInfoPage({
    required this.userName,
    required this.profileImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: ProfileInfoPageView(
        userName: userName,
        profileImage: profileImage,
      ),
    );
  }
}

class ProfileInfoPageView extends StatefulWidget {
  final String userName;
  final ImageProvider? profileImage;

  const ProfileInfoPageView({
    required this.userName,
    required this.profileImage,
    super.key,
  });

  @override
  ProfileInfoPageViewState createState() => ProfileInfoPageViewState();
}

class ProfileInfoPageViewState extends State<ProfileInfoPageView> {
  ImageProvider? customAvatar;
  final picker = ImagePicker();
  String? errorMessage;
  bool loginLoad = false;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  final phoneController = TextEditingController(text: "+91 9876543210");
  final altPhoneController = TextEditingController();
  final dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userName);
    customAvatar = widget.profileImage;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickImage() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source', style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: Text('Camera', style: TextStyle(color: appPrimaryColor)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: Text('Gallery', style: TextStyle(color: appPrimaryColor)),
          ),
        ],
      ),
    );

    if (source != null) {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() => customAvatar = FileImage(File(pickedFile.path)));
      }
    }
  }

  void _removeImage() => setState(() => customAvatar = null);

  void _pickDOB() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: appPrimaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: appPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      String formatted = DateFormat('dd MMM yyyy').format(picked);
      setState(() => dobController.text = formatted);
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'name': nameController.text,
        'image': customAvatar,
      });
    }
  }

  Widget _buildField(
      String label,
      TextEditingController controller, {
        IconData? icon,
        TextInputType keyboardType = TextInputType.text,
        String? Function(String?)? validator,
        bool readOnly = false,
        VoidCallback? onTap,
      }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      validator: validator,
      onTap: onTap,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
        prefixIcon: icon != null ? Icon(icon, color: Colors.black.withOpacity(0.6)) : null,
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appPrimaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }

  Widget mainContainer() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 65,
                  backgroundImage: customAvatar,
                  backgroundColor: Colors.white,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: appPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(Icons.edit, size: 20, color: Colors.white),
                    ),
                  ),
                ),
                if (customAvatar != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _removeImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: appSecondaryColor,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 30),
            _buildField("Name", nameController, icon: Icons.person, validator: (val) {
              if (val == null || val.isEmpty) return "Name cannot be empty";
              return null;
            }),
            const SizedBox(height: 16),
            _buildField("Date of Birth", dobController, icon: Icons.calendar_today,
                readOnly: true, onTap: _pickDOB),
            const SizedBox(height: 16),
            _buildField("Phone Number", phoneController, icon: Icons.phone,
                keyboardType: TextInputType.phone, readOnly: true),
            const SizedBox(height: 16),
            _buildField("Alt Phone (Optional)", altPhoneController, icon: Icons.phone_android),
            const SizedBox(height: 30),
            CustomButton(
              text: "SAVE CHANGES",
              onPressed: _saveProfile,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile_', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              'SAVE',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<DemoBloc, dynamic>(
        buildWhen: (previous, current) {
          return false;
        },
        builder: (context, dynamic) {
          return mainContainer();
        },
      ),
    );
  }
}
