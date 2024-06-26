import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shoe_admin/features/personalization/controllers/address_controller.dart';
import 'package:shoe_admin/features/personalization/screens/address/add_new_address.dart';
import 'package:shoe_admin/features/personalization/screens/address/widgets/single_address.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/cloud_helper_function.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());
    return Scaffold(
      appBar: const TAppbar(
        showBackArrow: true,
        title: Text('Addresses'),
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Obx(() => FutureBuilder(
              key: Key(controller.refreshData.value.toString()),
              future: controller.getAllUserAddresses(),
              builder: (context, snapshot){

                final response = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot);
                if(response != null) return response;

                final addresses = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: addresses.length,
                  itemBuilder: (_, index){
                    return TSingleAddress(address: addresses[index], onTap: () => controller.selectAddress(addresses[index]));
                  },
                );


              }
          )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddNewAddressScreen()),
        backgroundColor: TColors.primaryColor,
        child: const Icon(
          Iconsax.add,
          color: TColors.white,
        ),
      ),

    );
  }
}
