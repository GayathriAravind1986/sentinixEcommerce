import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentinix_ecommerce/Bloc/demo/demo_bloc.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Profile/MyOrders/my_order_details.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: OrderScreenView(),
    );
  }
}

class CurrentOrder {
  final String serviceId;
  final String date;
  final String time;
  final String status;
  final String dropAddress;
  final String phoneNumber;

  CurrentOrder({
    required this.serviceId,
    required this.date,
    required this.time,
    required this.status,
    required this.dropAddress,
    required this.phoneNumber,
  });
}

class OrderScreenView extends StatefulWidget {
  const OrderScreenView({
    super.key,
  });

  @override
  State<OrderScreenView> createState() => _OrderScreenViewState();
}

class _OrderScreenViewState extends State<OrderScreenView> {
  //GetEventModel getEventModel = GetEventModel();

  String? errorMessage;
  bool orderLoad = true;
  final List<CurrentOrder> orders = [
    CurrentOrder(
      serviceId: 'PD13946',
      date: 'Jun 14, 2025',
      time: '1:14 PM',
      status: 'Pending',
      dropAddress:
          '224, 6, Thiruvalluvar Salai,\nKuyavarpalayam, Puducherry India 605013',
      phoneNumber: '+91 9655334412',
    ),
    CurrentOrder(
      serviceId: 'PD13947',
      date: 'Jun 15, 2025',
      time: '2:14 PM',
      status: 'Cancelled',
      dropAddress:
          '224, 6, Thiruvalluvar Salai,\nKuyavarpalayam, Puducherry India 605013',
      phoneNumber: '+91 9655334412',
    ),
    CurrentOrder(
      serviceId: 'PD13948',
      date: 'Jun 16, 2025',
      time: '10:14 AM',
      status: 'onGoing',
      dropAddress:
          '224, 6, Thiruvalluvar Salai,\nKuyavarpalayam, Puducherry India 605013',
      phoneNumber: '+91 9655334412',
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
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: appSecondaryColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pickup And Drop',
                        style: MyTextStyle.f15(orangeColor,
                            weight: FontWeight.bold)),
                    Row(
                      children: [
                        Text('Status : ',
                            style: MyTextStyle.f15(blackColor,
                                weight: FontWeight.bold)),
                        Text(order.status,
                            style: MyTextStyle.f13(
                                order.status == "Pending"
                                    ? orangeColor
                                    : order.status == "Cancelled"
                                        ? redColor
                                        : greenColor,
                                weight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('ServiceId : ',
                        style: MyTextStyle.f15(blackColor,
                            weight: FontWeight.bold)),
                    Text(order.serviceId,
                        style: MyTextStyle.f13(blackColor,
                            weight: FontWeight.w400)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('Date : ',
                        style: MyTextStyle.f15(blackColor,
                            weight: FontWeight.bold)),
                    Text(order.date,
                        style: MyTextStyle.f13(blackColor,
                            weight: FontWeight.w400)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('Requested On : ',
                        style: MyTextStyle.f15(blackColor,
                            weight: FontWeight.bold)),
                    Text(order.time,
                        style: MyTextStyle.f13(blackColor,
                            weight: FontWeight.w400)),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Drop Address :',
                    style: MyTextStyle.f15(appSecondaryColor,
                        weight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_city,
                        color: orangeColor, size: 20),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        order.dropAddress,
                        style: MyTextStyle.f14(appSecondaryColor,
                            weight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                RichText(
                  text: TextSpan(
                    text: 'Help line: ',
                    style: MyTextStyle.f15(blackColor, weight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: order.phoneNumber,
                          style: MyTextStyle.f13(appSecondaryColor,
                              weight: FontWeight.w400,
                              textDecoration: TextDecoration.underline,
                              decorationColor: appSecondaryColor))
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          // Navigator.of(context).pushAndRemoveUntil(
          //   MaterialPageRoute(builder: (context) => const LoginDeliveryMan()),
          //   (route) => false,
          // );
        }
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: appPrimaryColor,
            title: Text("Current Order Details",
                style: MyTextStyle.f20(whiteColor, weight: FontWeight.w600)),
            centerTitle: true,
          ),
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
