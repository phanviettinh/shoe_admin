import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/common/widgets/loaders/loader.dart';
import 'package:shoe_admin/common/widgets/text/section_heading.dart';
import 'package:shoe_admin/data/repositories/adddresses/address_repository.dart';
import 'package:shoe_admin/features/authentication/controllers/signup/network_manager.dart';
import 'package:shoe_admin/features/personalization/models/address_model.dart';
import 'package:shoe_admin/features/personalization/screens/address/add_new_address.dart';
import 'package:shoe_admin/features/personalization/screens/address/widgets/single_address.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/image_strings.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/cloud_helper_function.dart';
import 'package:shoe_admin/utils/popups/full_screen_loader.dart';

class AddressController extends GetxController{
  static AddressController get instance => Get.find();

  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final street = TextEditingController();
  final postalCode = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final country = TextEditingController();
  GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

  RxBool refreshData = true.obs;
  final Rx<AddressModel> selectedAddress = AddressModel.empty().obs;
  final addressRepository = Get.put(AddressRepository());

  ///fetch all user specific addresses
  Future<List<AddressModel>> getAllUserAddresses() async{
    try{
      final addresses = await addressRepository.fetchUserAddresses();
      selectedAddress.value = addresses.firstWhere((element) => element.selectedAddress, orElse: () => AddressModel.empty());
      return addresses;
    }catch(e){
      TLoaders.errorSnackBar(title: 'Address not found!',message: e.toString());
      return [];
    }
  }

  ///
  Future selectAddress(AddressModel newSelectedAddress) async{
    try{
      Get.defaultDialog(
        title: '',
        onWillPop: () async {return false;},
        barrierDismissible: false,
        backgroundColor: Colors.transparent,
        content: const CircularProgressIndicator(color: TColors.primaryColor,),
      );

      //clear the "selected" field
      if(selectedAddress.value.id.isNotEmpty){
        await addressRepository.updateSelectedField(selectedAddress.value.id, false);
      }

      //assign selected address
      newSelectedAddress.selectedAddress = true;
      selectedAddress.value = newSelectedAddress;

      //set the "selected" field to true for the newly selected address
      await addressRepository.updateSelectedField(selectedAddress.value.id, true);
      Get.back();
    }catch(e){
      TLoaders.errorSnackBar(title: 'Error in Selection!',message: e.toString());
    }
  }

  ///
  Future addNewAddresses() async{
    try{
    //start loading
      TFullScreenLoader.openLoadingDialog('Storing Address...', TImages.loading);

      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }

      //form validation
      if(!addressFormKey.currentState!.validate()){
        TFullScreenLoader.stopLoading();
        return;
      }

      //save address data
      final address = AddressModel(
          id: '',
          name: name.text.trim(),
          phoneNumber: phoneNumber.text.trim(),
          street: street.text.trim(),
          city: city.text.trim(),
          state: state.text.trim(),
          postalCode: postalCode.text.trim(),
          country: country.text.trim(),
          selectedAddress: true
      );
      final id = await addressRepository.addAddress(address);

      //update selected address status
      address.id = id;
      await selectAddress(address);

      //remove loader
      TFullScreenLoader.stopLoading();

      //show success
      TLoaders.successSnackBar(title: 'Congratulations', message: 'Your address has been saved successfully');

      //refresh addresses
      refreshData.toggle();

      //reset field
      resetFormFields();

      //redirect
      Navigator.of(Get.context!).pop();
    }catch(e){
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Address not found!',message: e.toString());
    }
  }

  ///
  Future<dynamic> selectNewAddressPopup(BuildContext context)  {
    return showModalBottomSheet(
        context: context,
        builder: (_) =>  SingleChildScrollView(child: Container(
          padding: const EdgeInsets.all(TSizes.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TSectionHeading(title: 'Select Address',showActionButton: false,),
              const SizedBox(height: TSizes.spaceBtwItems,),

              FutureBuilder(
                  future: getAllUserAddresses(),
                  builder: (_, snapshot){
                    final response = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot);
                    if(response != null) return response;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => TSingleAddress(
                        address: snapshot.data![index],
                        onTap: () async {
                          await selectAddress(snapshot.data![index]);
                          Get.back();
                        },
                      ),
                    );
                  }
              ),
              const SizedBox(height: TSizes.spaceBtwItems,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => Get.to(() => const AddNewAddressScreen()),child: const Text('Add new address'),),
              )
            ],
          ),
        ),)
    );
  }

  void resetFormFields() {
    name.clear();
    phoneNumber.clear();
    street.clear();
    postalCode.clear();
    city.clear();
    state.clear();
    country.clear();
    addressFormKey.currentState?.reset();
  }
}