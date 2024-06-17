import 'package:ecoville/blocs/app/address_cubit.dart';
import 'package:ecoville/blocs/minimal/bool_cubit.dart';
import 'package:ecoville/models/address_model.dart';
import 'package:ecoville/shared/input_field.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/utilities/utilities.dart';

class AddAddressPage extends StatelessWidget {
  AddAddressPage({super.key});

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _postalCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isDefault = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        surfaceTintColor: white,
        leading: Padding(
          padding: const EdgeInsets.all(13),
          child: GestureDetector(
            onTap: () =>context..pop()..read<AddressCubit>().getAddresses(),
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
              var uuid = Uuid();
              if (_formKey.currentState?.validate() ?? false) {
                context.read<AddressCubit>().addAddress(
                      address: AddressModel(
                        id: uuid.v4(),
                        name: _nameController.text,
                        addressLine1: _addressLine1Controller.text,
                        addressLine2: _addressLine2Controller.text,
                        city: _cityController.text,
                        country: _countryController.text,
                        postalCode: _postalCodeController.text,
                        phone: _phoneController.text,
                        primary: _isDefault.toString().toLowerCase(),
                      ),
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
          child: SingleChildScrollView(
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
                    controller: _addressLine1Controller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Address line 1 is required";
                      }
                      return null;
                    },
                    hintText: "Address Line 1"),
                Gap(1.5 * SizeConfig.heightMultiplier),
                InputField(
                    onChanged: (value) {
                      _formKey.currentState?.validate();
                      return null;
                    },
                    controller: _addressLine2Controller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Address line 2 is required";
                      }
                      return null;
                    },
                    hintText: "Address Line 2"),
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
                    controller: _postalCodeController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Zip code is required";
                      }
                      return null;
                    },
                    hintText: "Zip Code"),
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
                BlocProvider(
                  create: (context) => BoolCubit(),
                  child: BlocConsumer<BoolCubit, BoolState>(
                    listener: (context, state) {
                      if (state.status == BoolStatus.changed) {
                        _isDefault = state.value;
                      }
                    },
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Checkbox(
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -4),
                              side: BorderSide(width: 1, color: darkGrey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              value: state.status == BoolStatus.changed
                                  ? state.value
                                  : false,
                              activeColor: green,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onChanged: (value) {
                                context
                                    .read<BoolCubit>()
                                    .changeValue(value: value!);
                              }),
                          Gap(
                            0.3 * SizeConfig.heightMultiplier,
                          ),
                          GestureDetector(
                            onTap: () => context.read<BoolCubit>().changeValue(
                                value: !context.read<BoolCubit>().state.value),
                            child: Text(
                              "Set as default address",
                              style: TextStyle(
                                fontSize: 1.6 * SizeConfig.textMultiplier,
                                fontWeight: FontWeight.w500,
                                color: darkGrey,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
