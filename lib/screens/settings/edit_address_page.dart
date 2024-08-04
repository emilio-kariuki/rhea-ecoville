import 'package:ecoville/blocs/app/address_cubit.dart';
import 'package:ecoville/blocs/minimal/bool_cubit.dart';
import 'package:ecoville/models/address_model.dart';
import 'package:ecoville/shared/input_field.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/utilities/utilities.dart';
import 'package:flutter/material.dart';

class EditAddressPage extends StatelessWidget {
  EditAddressPage({super.key, required this.id});

  String id;

  TextEditingController _nameController = TextEditingController();

  TextEditingController _phoneController = TextEditingController();

  TextEditingController _altPhoneController = TextEditingController();

  TextEditingController _regionController = TextEditingController();

  TextEditingController _cityController = TextEditingController();

  TextEditingController _countryController = TextEditingController();

  TextEditingController _informationController = TextEditingController();

  TextEditingController _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isDefault = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressCubit, AddressState>(
      bloc: context.read<AddressCubit>()..getAddressById(id: id),
      listener: (context, state) {
        if (state.status == AddressStatus.success) {
          debugPrint("Selected address: ${state.selectedAddress!.toJson()}");
          _nameController.text = state.selectedAddress!.name;
          _phoneController.text = state.selectedAddress!.phone;
          _regionController.text = state.selectedAddress!.region;
          _altPhoneController.text = state.selectedAddress!.altPhone;
          _cityController.text = state.selectedAddress!.city;
          _countryController.text = state.selectedAddress!.country;
          _informationController.text = state.selectedAddress!.additionalInformation;
          _addressController.text = state.selectedAddress!.address;
         
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: white,
            surfaceTintColor: white,
            leading: Padding(
              padding: const EdgeInsets.all(13),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: SvgPicture.asset(
                  AppImages.back,
                  height: 3 * SizeConfig.heightMultiplier,
                  width: 3 * SizeConfig.heightMultiplier,
                  color: black,
                ),
              ),
            ),
            title: Text(
              "Add Address",
              style: GoogleFonts.inter(
                fontSize: 2.2 * SizeConfig.textMultiplier,
                color: black,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    context.read<AddressCubit>().updateAddress(
                          address: AddressRequestModel(
                            name: _nameController.text,
                            email: supabase.auth.currentUser!.email!,
                            region: _regionController.text,
                            altPhone: _altPhoneController.text,
                            city: _cityController.text,
                            country: _countryController.text,
                            phone: _phoneController.text,
                            additionalInformation: _informationController.text,
                            address: _addressController.text,
                          ),
                          id: id,
                        );
                    context.pop();
                  }
                },
                child: Text(
                  "Save",
                  style: GoogleFonts.inter(
                    fontSize: 1.7 * SizeConfig.textMultiplier,
                    color: green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Gap(3 * SizeConfig.widthMultiplier),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputField(
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                        return null;
                      },
                      controller: _nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                      hintText: "Name"),
                  Gap(1.5 * SizeConfig.heightMultiplier),
                  InputField(
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                        return null;
                      },
                      controller: _regionController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Region required";
                        }
                        return null;
                      },
                      hintText: "Region"),
                  Gap(1.5 * SizeConfig.heightMultiplier),
                  InputField(
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                        return null;
                      },
                      controller: _cityController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "City is required";
                        }
                        return null;
                      },
                      hintText: "City"),
                  Gap(1.5 * SizeConfig.heightMultiplier),
                  
                  InputField(
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                        return null;
                      },
                      controller: _phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Phone is required";
                        }
                        return null;
                      },
                      hintText: "Phone"),
                  Gap(1.5 * SizeConfig.heightMultiplier),
                  InputField(
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                        return null;
                      },
                      controller: _altPhoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Alt Phone required";
                        }
                        return null;
                      },
                      hintText: "Alt Phone"),
                  Gap(1.5 * SizeConfig.heightMultiplier),
                  InputField(
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                        return null;
                      },
                      controller: _countryController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Country is required";
                        }
                        return null;
                      },
                      hintText: "Country"),
                  Gap(1.5 * SizeConfig.heightMultiplier),
                  InputField(
                    maxLines: 5,
                    minLines: 3,
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                        return null;
                      },
                      controller: _informationController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Additional Information required";
                        }
                        return null;
                      },
                      hintText: "Additional Information"),
                  Gap(1.5 * SizeConfig.heightMultiplier),
                  InputField(
                    maxLines: 5,
                    minLines: 3,
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                        return null;
                      },
                      controller: _addressController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Address is required";
                        }
                        return null;
                      },
                      hintText: "Your Address"),
                  Gap(1.5 * SizeConfig.heightMultiplier),
                  
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
