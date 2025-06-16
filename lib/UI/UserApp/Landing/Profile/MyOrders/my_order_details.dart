import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentinix_ecommerce/Bloc/demo/demo_bloc.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Profile/MyOrders/my_order_screen.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Profile/MyOrders/widget/order_details_widget.dart';

class MyOrderDetails extends StatelessWidget {
  const MyOrderDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: MyOrderDetailsView(),
    );
  }
}

class MyOrderDetailsView extends StatefulWidget {
  const MyOrderDetailsView({
    super.key,
  });

  @override
  State<MyOrderDetailsView> createState() => _MyOrderDetailsViewState();
}

class _MyOrderDetailsViewState extends State<MyOrderDetailsView> {
  //GetEventModel getEventModel = GetEventModel();

  String? errorMessage;
  bool orderLoad = true;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContainer() {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddressSectionWidget(
              title: "Pick-up Address:",
              address:
                  "03, 5,  East Coast Rd,  Devaki Nagar,\nKrishna Nagar, Puducherry India 605003",
            ),
            SizedBox(height: 16),
            AddressSectionWidget(
              title: "Delivery Address:",
              address:
                  "224, 6,  Thiruvalluvar Salai,\nKuyavarpalayam, Puducherry India 605013",
            ),
            SizedBox(height: 20),
            Text(
              "Date :",
              style: MyTextStyle.f15(weight: FontWeight.bold, blackColor),
            ),
            SizedBox(height: 4),
            Text(
              "Jun 14, 2025, 1:14 PM",
              style: MyTextStyle.f14(weight: FontWeight.w400, blackColor),
            ),
            SizedBox(height: 16),
            Text(
              "Amount:",
              style: MyTextStyle.f15(weight: FontWeight.bold, blackColor),
            ),
            SizedBox(height: 4),
            Text(
              "₹ 40.40",
              style: MyTextStyle.f14(weight: FontWeight.w400, blackColor),
            ),
            SizedBox(height: 16),
            Text(
              "Delivery Status:",
              style: MyTextStyle.f15(weight: FontWeight.bold, blackColor),
            ),
            SizedBox(height: 4),
            Text(
              "pending",
              style: MyTextStyle.f14(weight: FontWeight.w400, orangeColor),
            ),
          ],
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MyOrderScreen()));
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
            title: Text("Order Details",
                style: MyTextStyle.f20(whiteColor, weight: FontWeight.w600)),
            centerTitle: true,
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const MyOrderScreen()));
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
