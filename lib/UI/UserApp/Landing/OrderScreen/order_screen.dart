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
      serviceId: 'LP13946',
      date: 'Jun 14, 2025',
      time: '1:14 PM',
      status: 'pending',
      dropAddress:
          '224, 6, Thiruvalluvar Salai,\nKuyavarpalayam, Puducherry India 605013',
      phoneNumber: '+91 9655334412',
    ),
    CurrentOrder(
      serviceId: 'LP13946',
      date: 'Jun 15, 2025',
      time: '2:14 PM',
      status: 'cancelled',
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pickup And Drop',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Status : ${order.status}',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('ServiceId : ${order.serviceId}'),
                const SizedBox(height: 6),
                Text('Date : ${order.date}'),
                const SizedBox(height: 6),
                Text('Requested On : ${order.time}'),
                const SizedBox(height: 12),
                const Text(
                  'Drop Address :',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_city,
                        color: Colors.orange, size: 20),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        order.dropAddress,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                RichText(
                  text: TextSpan(
                    text: 'Help line: ',
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: order.phoneNumber,
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      )
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
