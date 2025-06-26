import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sentinix_ecommerce/Bloc/demo/demo_bloc.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Parcel_Pickup_Drop/parcel_pickup_drop.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Person_Pickup_Drop/person_pickup_drop.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/widget/home_card_widget.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/image.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: const HomeScreenView(),
    );
  }
}

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  final PageController _carouselPageController = PageController(initialPage: 0);
  Timer? _carouselTimer;
  final String userName = 'Sri Ram';
  final List<String> bannerImages = [
    Images.banner_1,
    Images.banner_2,
    Images.banner_3,
    Images.banner_4
  ];

  @override
  void initState() {
    super.initState();
    _startCarouselTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheImages();
    });
  }

  void _precacheImages() {
    for (final imagePath in bannerImages) {
      precacheImage(AssetImage(imagePath), context);
    }
  }

  void _startCarouselTimer() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_carouselPageController.hasClients) {
        int nextPage = _carouselPageController.page!.toInt() + 1;
        if (nextPage >= bannerImages.length) {
          nextPage = 0;
        }
        _carouselPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _carouselPageController.dispose();
    _carouselTimer?.cancel();
    super.dispose();
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _buildHeader(BuildContext context) {
    final greeting = getGreeting();
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: screenHeight * 0.04,
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting,',
                    style: MyTextStyle.f20(Colors.black, weight: FontWeight.w600),
                  ),
                  Text(
                    userName,
                    style: MyTextStyle.f18(Colors.black, weight: FontWeight.bold),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 24,
                backgroundColor: appPrimaryColor,
                child: const Icon(Icons.person, color: whiteColor, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Ready to send something today?',
            style: MyTextStyle.f14(Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _carouselPageController,
            itemCount: bannerImages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: RepaintBoundary(
                    child: Image.asset(
                      bannerImages[index],
                      width: double.infinity,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: greyShade300,
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _carouselPageController,
          count: bannerImages.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: appPrimaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCards() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PickupDropScreen()),
              );
            },
            child: ServiceCard(
              title: 'Parcel Pickup & Drop',
              image: Images.parcel,
              iconColor: appPrimaryColor,
              imageBackground: appSecondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PersonPickupDropScreen()),
              );
            },
            child: ServiceCard(
              title: 'Person Pickup & Drop',
              image: Images.person,
              iconColor: appPrimaryColor,
              imageBackground: appSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContainer() {
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 10),
              _buildCarousel(),
              const SizedBox(height: 30),
              _buildServiceCards(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      body: BlocBuilder<DemoBloc, dynamic>(
        buildWhen: (previous, current) => false,
        builder: (context, dynamic) {
          return mainContainer();
        },
      ),
    );
  }
}
