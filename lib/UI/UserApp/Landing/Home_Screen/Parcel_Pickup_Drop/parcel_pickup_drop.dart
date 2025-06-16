import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentinix_ecommerce/Bloc/demo/demo_bloc.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/Reusable/image.dart';
import 'package:sentinix_ecommerce/Reusable/elevated_button.dart';

class PickupDropScreen extends StatelessWidget {
  const PickupDropScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: const PickupDropView(),
    );
  }
}

class PickupDropView extends StatefulWidget {
  const PickupDropView({super.key});

  @override
  State<PickupDropView> createState() => _PickupDropViewState();
}

class _PickupDropViewState extends State<PickupDropView> {
  final _formKey = GlobalKey<FormState>();

  int _pickupType = 0;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<String> _banners = [
    Images.banner_1,
    Images.banner_2,
    Images.banner_3,
  ];

  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();
  final TextEditingController _packageController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();

  bool _useDifferentPhone = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget mainContainer() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildBannerSlider(),
            const SizedBox(height: 20),
            _buildPickupTypeSelector(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerSlider() {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  _banners[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (index) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? appPrimaryColor : Colors.grey.shade300,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPickupTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Type", style: MyTextStyle.f18(blackColor, weight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 15,
          children: [
            ChoiceChip(
              label: const Text("Single Pickup and Drop"),
              selected: _pickupType == 0,
              onSelected: (_) => setState(() => _pickupType = 0),
            ),
            ChoiceChip(
              label: const Text("Multiple Pickups"),
              selected: _pickupType == 1,
              onSelected: (_) => setState(() => _pickupType = 1),
            ),
            ChoiceChip(
              label: const Text("Multiple Drops"),
              selected: _pickupType == 2,
              onSelected: (_) => setState(() => _pickupType = 2),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        title: Text(
          "Parcel Pickup & Drop",
          style: MyTextStyle.f22(whiteColor, weight: FontWeight.bold),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: BlocBuilder<DemoBloc, dynamic>(
        buildWhen: (previous, current) => false,
        builder: (context, state) {
          return mainContainer();
        },
      ),
    );
  }
}
