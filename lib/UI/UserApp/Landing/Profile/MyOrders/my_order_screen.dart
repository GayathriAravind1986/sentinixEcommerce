import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentinix_ecommerce/Bloc/demo/demo_bloc.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Profile/MyOrders/my_order_details.dart';

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: MyOrderScreenView(),
    );
  }
}

class MyOrderScreenView extends StatefulWidget {
  const MyOrderScreenView({
    super.key,
  });

  @override
  State<MyOrderScreenView> createState() => _MyOrderScreenViewState();
}

class _MyOrderScreenViewState extends State<MyOrderScreenView> {
  //GetEventModel getEventModel = GetEventModel();

  String? errorMessage;
  bool orderLoad = true;
  final List<Map<String, String>> orders = const [
    {
      'type': 'Parcel PickupAndDrop',
      'orderNumber': 'PD13946',
      'date': 'Jun 14, 2025, 1:14PM',
      'amount': '40.40',
      'status': 'pending',
    },
    {
      'type': 'Parcel PickupAndDrop',
      'orderNumber': 'PD13947',
      'date': 'Jun 15, 2025, 2:30PM',
      'amount': '60.00',
      'status': 'onGoing',
    },
    {
      'type': 'Person PickupAndDrop',
      'orderNumber': 'PD13948',
      'date': 'Jun 16, 2025, 4:30PM',
      'amount': '80.00',
      'status': 'Cancelled',
    },
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
          return InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const MyOrderDetails()));
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: appPrimaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          order['type']!,
                          style: MyTextStyle.f16(
                              weight: FontWeight.bold, blackColor),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: appPrimaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Details>>',
                          style: MyTextStyle.f14(whiteColor),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Order number : ${order['orderNumber']}',
                    style: MyTextStyle.f14(blackColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ordered Placed date : ${order['date']}',
                    style: MyTextStyle.f14(blackColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total Amount : ${order['amount']}',
                    style: MyTextStyle.f14(blackColor),
                  ),
                  const SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      text: 'Order Status : ',
                      style: MyTextStyle.f14(blackColor),
                      children: [
                        TextSpan(
                          text: order['status'],
                          style: MyTextStyle.f14(
                              weight: FontWeight.bold,
                              order['status'] == "pending"
                                  ? orangeColor
                                  : order['status'] == "onGoing"
                                      ? greenColor
                                      : redColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
            title: Text("My Orders",
                style: MyTextStyle.f20(whiteColor, weight: FontWeight.w600)),
            centerTitle: true,
            leading: InkWell(
              onTap: () {
                // Navigator.of(context).pushAndRemoveUntil(...);
              },
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: whiteColor,
                  )),
            ),
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
