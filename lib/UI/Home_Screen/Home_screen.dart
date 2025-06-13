import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/image.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(),
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
  final List<String> bannerImages = [Images.banner_1, Images.banner_2, Images.banner_3, Images.banner_4];

  @override
  void initState() {
    super.initState();
    _startCarouselTimer();
    context.read<HomeBloc>().add(FetchHomeData());
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

  Widget mainContainer() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildCarousel(),
          const SizedBox(height: 30),
          _buildServiceCards(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final greeting = getGreeting();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                    style: MyTextStyle.f24(Colors.black, weight: FontWeight.w600),
                  ),
                  Text(
                    userName,
                    style: MyTextStyle.f24(Colors.black, weight: FontWeight.bold),
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
            style: MyTextStyle.f17(Colors.black54),
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
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    bannerImages[index],
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ServiceCard(
            title: 'Parcel\nPickup & Drop',
            icon: Icons.local_shipping,
            image: Images.parcel,
            iconColor: appSecondaryColor,
            imageBackground: appPrimaryColor,
          ),
          const SizedBox(height: 16),
          ServiceCard(
            title: 'Person\nPickup & Drop',
            icon: Icons.person,
            image: Images.person,
            iconColor: appPrimaryColor,
            imageBackground: appSecondaryColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: whiteColor,
        body: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) {
            if (current is HomeLoaded || current is HomeError) {
              return true;
            }
            return false;
          },
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeError) {
              return Center(child: Text(state.message));
            }
            return mainContainer();
          },
        ),
      ),
    );
  }
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<FetchHomeData>(_onFetchHomeData);
  }

  Future<void> _onFetchHomeData(
      FetchHomeData event,
      Emitter<HomeState> emit,
      ) async {
    emit(HomeLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(HomeLoaded());
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}

abstract class HomeEvent {}
class FetchHomeData extends HomeEvent {}

abstract class HomeState {}
class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {}
class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

class ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String image;
  final Color iconColor;
  final Color imageBackground;

  const ServiceCard({
    super.key,
    required this.title,
    required this.icon,
    required this.image,
    required this.iconColor,
    required this.imageBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: whiteColor,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: whiteColor, size: 30),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: MyTextStyle.f14(whiteColor, weight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Container(
                color: imageBackground,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}