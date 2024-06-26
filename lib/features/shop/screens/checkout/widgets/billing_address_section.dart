import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/common/widgets/text/section_heading.dart';
import 'package:shoe_admin/features/personalization/controllers/address_controller.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';

class TBillingAddressSection extends StatelessWidget {
  const TBillingAddressSection({super.key});


  @override
  Widget build(BuildContext context) {
    final addressController = AddressController.instance;

    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TSectionHeading(title: 'Shipping Address',buttonTitle: 'Change',onPressed: () => addressController.selectNewAddressPopup(context),),
        addressController.selectedAddress.value.id.isNotEmpty ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(addressController.selectedAddress.value.name,style: Theme.of(context).textTheme.bodyLarge,),
            const SizedBox(height: TSizes.spaceBtwItems / 2,),
            Row(
              children: [
                const Icon(Icons.phone,color: Colors.grey,size: 16,),
                const SizedBox(width: TSizes.spaceBtwItems,),
                Text(addressController.selectedAddress.value.phoneNumber,style: Theme.of(context).textTheme.bodyMedium,)
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2,),
            Row(
              children: [
                const Icon(Icons.location_history,color: Colors.grey,size: 16,),
                const SizedBox(width: TSizes.spaceBtwItems,),
                Expanded(child: Text(addressController.selectedAddress.value.toString().toString(),style: Theme.of(context).textTheme.bodyMedium,softWrap: true,))
              ],
            ),
            // const SizedBox(height: TSizes.spaceBtwItems / 2,),
          ],
        ) : Text('Select Address', style: Theme.of(context).textTheme.bodyMedium,),

      ],
    ));
  }
}
