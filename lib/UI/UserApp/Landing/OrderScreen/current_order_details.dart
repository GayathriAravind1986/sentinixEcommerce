import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentinix_ecommerce/Bloc/demo/demo_bloc.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/image.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Navigation_Bar/Navigation_bar.dart';

class CurrentOrderStatus extends StatelessWidget {
  const CurrentOrderStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: CurrentOrderStatusView(),
    );
  }
}

class CurrentOrderStatusView extends StatefulWidget {
  const CurrentOrderStatusView({
    super.key,
  });

  @override
  State<CurrentOrderStatusView> createState() => _CurrentOrderStatusViewState();
}

class _CurrentOrderStatusViewState extends State<CurrentOrderStatusView> {
  //GetEventModel getEventModel = GetEventModel();

  String? errorMessage;
  bool orderLoad = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget mainContainer() {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Status : ',
                  style: MyTextStyle.f15(blackColor, weight: FontWeight.bold),
                ),
                Text(
                  'Ongoing',
                  style: MyTextStyle.f15(greenColor, weight: FontWeight.w400),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(Images.profile),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vijay R',
                        style: MyTextStyle.f15(blackColor,
                            weight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'For any queries please contact Mr.Vijay R',
                        style:
                            MyTextStyle.f13(greyColor, weight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.call, color: Colors.cyan, size: 30),
                  onPressed: () {
                    // Add call functionality here
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Pick up Address',
              style: MyTextStyle.f14(blackColor, weight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_city, color: orangeColor),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '03, 5, East Coast Rd, Devaki Nagar,\nKrishna Nagar, Puducherry India 605003',
                    style:
                        MyTextStyle.f14(blackColor54, weight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Drop Address',
              style: MyTextStyle.f14(blackColor, weight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_city, color: orangeColor),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '224, 6, Thiruvalluvar Salai,\nKuyavarpalayam, Puducherry India 605013',
                    style:
                        MyTextStyle.f14(blackColor54, weight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => const DashBoardScreen(
                      selectTab: 1,
                    )),
          );
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
            title: Text("Current Order Status",
                style: MyTextStyle.f20(whiteColor, weight: FontWeight.w600)),
            centerTitle: true,
            leading: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const DashBoardScreen(
                            selectTab: 1,
                          )),
                );
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
