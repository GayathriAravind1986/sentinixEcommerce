import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:simple/Bloc/demo/demo_bloc.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/elevated_button.dart';

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
    nameController.dispose();
    phoneController.dispose();
    altPhoneController.dispose();
    dobController.dispose();
    super.dispose();
  }

  bool _validatePhoneNumber(String phone) {
    final digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');
    return digitsOnly.length == 10 && RegExp(r'^[6-9]\d{9}$').hasMatch(digitsOnly);
  }

  void _showValidationError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalid Phone Number'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text('Gallery'),
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
    if (!_validatePhoneNumber(phoneController.text)) {
      _showValidationError('Please enter a valid 10-digit Indian phone number starting with 6-9');
      return;
    }

    if (altPhoneController.text.isNotEmpty && !_validatePhoneNumber(altPhoneController.text)) {
      _showValidationError('Please enter a valid alternate phone number or leave it empty');
      return;
    }

    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'name': nameController.text,
        'image': customAvatar,
      });
    }
  }

  Widget _buildPhoneField(String label, TextEditingController controller, IconData icon) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (label == 'Phone Number' && (value == null || value.isEmpty)) {
          return 'Please enter phone number';
        }
        if (value != null && value.isNotEmpty && !_validatePhoneNumber(value)) {
          return 'Invalid phone number';
        }
        return null;
      },
    );
  }

  Widget _buildField(
      String label,
      TextEditingController controller, {
        IconData? icon,
        bool readOnly = false,
        VoidCallback? onTap,
      }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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
            _buildField(
              "Name",
              nameController,
              icon: Icons.person,
              validator: (val) => val?.isEmpty ?? true ? "Name cannot be empty" : null,
            ),
            const SizedBox(height: 16),
            _buildField(
              "Date of Birth",
              dobController,
              icon: Icons.calendar_today,
              readOnly: true,
              onTap: _pickDOB,
            ),
            const SizedBox(height: 16),
            _buildPhoneField("Phone Number", phoneController, Icons.phone),
            const SizedBox(height: 16),
            _buildPhoneField("Alt Phone (Optional)", altPhoneController, Icons.phone_android),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('SAVE'),
          ),
        ],
      ),
      body: BlocBuilder<DemoBloc, dynamic>(
        builder: (context, dynamic) => mainContainer(),
      ),
    );
  }
}