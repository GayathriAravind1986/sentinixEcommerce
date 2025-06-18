import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentinix_ecommerce/Bloc/demo/demo_bloc.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/image.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Notifications/widget/notification_item_widget.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Navigation_Bar/Navigation_bar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: NotificationScreenView(),
    );
  }
}

class NotificationScreenView extends StatefulWidget {
  const NotificationScreenView({
    super.key,
  });

  @override
  State<NotificationScreenView> createState() => _NotificationScreenViewState();
}

class _NotificationScreenViewState extends State<NotificationScreenView> {
  //GetEventModel getEventModel = GetEventModel();

  String? errorMessage;
  bool orderLoad = true;
  List<NotificationItem> notifications = [
    NotificationItem(
      title: 'PRO DELIVERZ',
      message: 'Your Service has been Completed.\nThank you for choosing us',
      serviceId: 'PDI3946',
      dateTime: 'Jun 14, 2025  2:07 PM',
    ),
    NotificationItem(
      title: 'PRO DELIVERZ',
      message: 'Your Service has been Completed.\nThank you for choosing us',
      serviceId: 'PDI3946',
      dateTime: 'Jun 14, 2025  2:07 PM',
    ),
    NotificationItem(
      title: 'PRO DELIVERZ',
      message: 'Your Service has been Completed.\nThank you for choosing us',
      serviceId: 'PDI3946',
      dateTime: 'Jun 14, 2025  2:07 PM',
    ),
    NotificationItem(
      title: 'PRO DELIVERZ',
      message: 'Your Service has been Completed.\nThank you for choosing us',
      serviceId: 'LPI3946',
      dateTime: 'Jun 14, 2025  2:07 PM',
    ),
    NotificationItem(
      title: 'PRO DELIVERZ',
      message: 'Your Service has been Completed.\nThank you for choosing us',
      serviceId: 'PDI3946',
      dateTime: 'Jun 14, 2025  2:07 PM',
    ),
    NotificationItem(
      title: 'PRO DELIVERZ',
      message: 'Your Service has been Completed.\nThank you for choosing us',
      serviceId: 'PDI3946',
      dateTime: 'Jun 14, 2025  2:07 PM',
    ),
  ];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget mainContainer() {
      return Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(

          //     Images.splashLogo,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // Positioned.fill(
          //   child: BackdropFilter(
          //     filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          //     child: Container(color: appPrimaryColor.withOpacity(0.3)),
          //   ),
          // ),
          SizedBox(
            height: size.height * 0.8,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: appSecondaryColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title,
                          style: MyTextStyle.f16(orangeColor,
                              weight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(item.message,
                          style: MyTextStyle.f14(blackColor,
                              weight: FontWeight.w400)),
                      const SizedBox(height: 6),
                      Text("#Service Id : ${item.serviceId}",
                          style: MyTextStyle.f13(blackColor,
                              weight: FontWeight.w400)),
                      const SizedBox(height: 6),
                      Text(item.dateTime,
                          style: MyTextStyle.f12(appSecondaryColor,
                              weight: FontWeight.w400)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const DashBoardScreen()),
            (route) => false, // Clear all routes
          );
        }
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: appPrimaryColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Notifications',
            style: MyTextStyle.f20(whiteColor, weight: FontWeight.w600),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  "Clear All",
                  style: MyTextStyle.f14(Colors.white,
                      weight: FontWeight.w500,
                      textDecoration: TextDecoration.underline,
                      decorationColor: whiteColor),
                ),
              ),
            )
          ],
        ),
        body: BlocBuilder<DemoBloc, dynamic>(
          buildWhen: (previous, current) {
            return false;
          },
          builder: (context, dynamic) {
            return mainContainer();
          },
        ),
      ),
    );
  }
}
