import 'package:flutter/material.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';

class AddressSelectionStep extends StatelessWidget {
  const AddressSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    // final bloc = context.read<AddressFlowBloc>();
    // final state = context.watch<AddressFlowBloc>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child:
              //state.addresses.isEmpty
              //     ? Center(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             const Icon(Icons.location_off,
              //                 size: 64, color: greyColor),
              //             const SizedBox(height: 16),
              //             Text(
              //               "No Address added yet",
              //               style: MyTextStyle.f16(greyColor),
              //             ),

              //     ],
              //   ),
              // )
              //          :
              ListView.builder(
            itemCount: 2,
            itemBuilder: (context, index) {
              //final address = state.addresses[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading:
                      const Icon(Icons.location_on, color: appPrimaryColor),
                  title: Text(
                    "addressTitle",
                    style:
                        MyTextStyle.f16(textColorDark, weight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // if (address.buildingName?.isNotEmpty ?? false)
                      Text(
                        "",
                        // address.buildingName!,
                        style: MyTextStyle.f14(textColorDark),
                      ),
                      Text(
                        "",
                        // 'House No: ${address.houseNo}, Floor No: ${address.floorNo}',
                        style: MyTextStyle.f14(textColorDark),
                      ),
                      //  if (address.street?.isNotEmpty ?? false)
                      Text(
                        "",
                        // address.street!,
                        style: MyTextStyle.f14(textColorDark),
                      ),
                      // if (address.area?.isNotEmpty ?? false)
                      Text(
                        "",
                        //address.area!,
                        style: MyTextStyle.f14(textColorDark),
                      ),
                      Text(
                        "",
                        //  '${address.city}, ${address.state} ${address.pincode}',
                        style: MyTextStyle.f14(greyColor),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: redColor),
                    onPressed: () {},
                    // bloc.add(RemoveAddressEvent(address.id, context)),
                  ),
                  onTap: () {
                    //   Navigator.pop(context, address);
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              // state.hasReachedLimit
              //     ? null
              //     : () => bloc.add(ChangeStepEvent(1)),
              style: ElevatedButton.styleFrom(
                backgroundColor: appPrimaryColor,
                //state.hasReachedLimit ? greyColor : appPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                "+ Add new Address",
                // state.hasReachedLimit
                //     ? "Maximum addresses reached (10)"
                //     : "+ Add new Address",
                style: MyTextStyle.f18(whiteColor, weight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
