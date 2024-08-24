import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ecoville/blocs/app/product_cubit.dart';
import 'package:ecoville/blocs/minimal/bool_cubit.dart';
import 'package:ecoville/blocs/minimal/value_cubit.dart';
import 'package:ecoville/shared/complete_button.dart';
import 'package:ecoville/shared/input_field.dart';
import 'package:ecoville/utilities/packages.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({super.key, required this.id});
  final String id;

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  String get productId => widget.id;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _categoryController = TextEditingController();
  final _conditionController = TextEditingController();
  final _endDateController = TextEditingController(text: DateTime.now().toString());
  final _bidPriceController = TextEditingController();

  String? selectedCondition;
  bool? allowBidding = false;

  String? selectedCategory;

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    _endDateController.text = selectedDate.toString();

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit()..getProduct(id: productId),
      child: Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: white,
            surfaceTintColor: white,
            automaticallyImplyLeading: false,
            centerTitle: false,
            leading: Padding(
              padding: const EdgeInsets.all(13),
              child: GestureDetector(
                  onTap: () => context.pop(),
                  child: SvgPicture.asset(
                    AppImages.back,
                    color: black,
                    height: 2.5 * SizeConfig.heightMultiplier,
                  )),
            ),
            title: Text(
              "Edit Product",
              style: GoogleFonts.inter(
                  fontSize: 2.2 * SizeConfig.heightMultiplier,
                  fontWeight: FontWeight.w600,
                  color: black),
            ),
            actions: [
              // IconContainer(
              //     icon: AppImages.more,
              //     function: () => context.pushNamed(Routes.cart)),
              Gap(1 * SizeConfig.widthMultiplier),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: BlocConsumer<ProductCubit, ProductState>(
              listener: (context, state) {
                if (state.status == ProductStatus.updated) {
                  context.pop();
                  context.showSuccessToast(
                      title: "Success",
                      message: "Product updated successfully",
                      context: context);
                }
              },
              builder: (context, state) {
                return CompleteButton(
                    height: 6 * SizeConfig.heightMultiplier,
                    borderRadius: 30,
                    isLoading: state.status == ProductStatus.loading,
                    text: Text(
                      "Update Product",
                      style: GoogleFonts.inter(
                          color: white,
                          fontSize: 1.8 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.1),
                    ),
                    function: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ProductCubit>().updateProduct(
                          product: {
                            'id': productId,
                            'name': _titleController.text,
                            'description': _descriptionController.text,
                            'price': double.parse(_priceController.text),
                            'quantity': int.parse(_quantityController.text),
                            'categoryId': selectedCategory,
                            'condition': selectedCondition,
                            'sold': int.parse(_quantityController.text) > 0
                                ? false
                                : true,
                            'allowBidding': allowBidding,
                            'highestBidder': supabase.auth.currentUser!.id,
                            'endBidding': _endDateController.text.isEmpty
                                        ? DateTime.now()
                                        : DateTime.parse(_endDateController.text),
                          },
                        );
                      }
                    });
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: BlocConsumer<ProductCubit, ProductState>(
                buildWhen: (previous, current) =>
                    current.product != previous.product,
                listener: (context, state) {
                  if (state.status == ProductStatus.success) {
                    final product = state.product!;
                    _titleController.text = product.name;
                    _descriptionController.text = product.description!;
                    _priceController.text = product.price.toString();
                    _quantityController.text = product.quantity.toString();
                    _categoryController.text = product.category!.name!;
                    _conditionController.text = product.condition!;
                    selectedCategory = product.category!.id;
                    selectedCondition = product.condition;
                    allowBidding = product.allowBidding;
                    if (product.allowBidding!) {
                      _bidPriceController.text =
                          product.biddingPrice.toString();
                      _endDateController.text = product.endBidding.toString();
                    }
                  }
                },
                builder: (context, state) {
                  if (state.status == ProductStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // name
                        Text(
                          'Product Name',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Gap(1 * SizeConfig.heightMultiplier),
                        InputField(
                          controller: _titleController,
                          hintText: "Product Name",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter the product name";
                            }
                            return null;
                          },
                        ),
                        Gap(2 * SizeConfig.heightMultiplier),
                        // description
                        Text(
                          'Product Description',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Gap(1 * SizeConfig.heightMultiplier),
                        InputField(
                          controller: _descriptionController,
                          hintText: "Product Description",
                          maxLines: 8,
                          minLines: 3,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter the product description";
                            }
                            return null;
                          },
                        ),
                        Gap(2 * SizeConfig.heightMultiplier),
                        // price
                        Text(
                          'Product Price',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Gap(1 * SizeConfig.heightMultiplier),
                        InputField(
                          controller: _priceController,
                          hintText: "Product Price",
                          textInputType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter the product price";
                            }
                            return null;
                          },
                        ),
                        Gap(2 * SizeConfig.heightMultiplier),
                        // quantity
                        Text(
                          'Product Quantity',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Gap(1 * SizeConfig.heightMultiplier),
                        InputField(
                          controller: _quantityController,
                          hintText: "Product Quantity",
                          textInputType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter the product quantity";
                            }
                            return null;
                          },
                        ),
                        Gap(2 * SizeConfig.heightMultiplier),
                        Text(
                          "Condition",
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Gap(1 * SizeConfig.heightMultiplier),
                        BlocProvider(
                          create: (context) => ValueCubit(),
                          child: Builder(
                            builder: (context) {
                              return BlocConsumer<ValueCubit, ValueState>(
                                listener: (context, state) {
                                  if (state.status == ValueStatus.changed) {
                                    _conditionController.text = state.value;
                                    selectedCondition = state.value;
                                  }
                                },
                                builder: (context, state) {
                                  return DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      isExpanded: true,
                                      hint: Text(
                                        'Condition',
                                        style: GoogleFonts.inter(
                                          fontSize:
                                              1.6 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w500,
                                          color: black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      items: ['New', 'Used']
                                          .map(
                                            (item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: GoogleFonts.inter(
                                                  fontSize: 1.6 *
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.w500,
                                                  color: black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      value: selectedCondition,
                                      onChanged: (value) {
                                        context.read<ValueCubit>().changeValue(
                                              value: value.toString(),
                                            );
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.065,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.only(
                                            left: 14, right: 14),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 1,
                                              color: const Color(0xff808B9A)),
                                          color: Colors.transparent,
                                        ),
                                        elevation: 0,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 300,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: Colors.white,
                                        ),
                                        elevation: 0,
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness:
                                              MaterialStateProperty.all<double>(
                                                  6),
                                          thumbVisibility:
                                              MaterialStateProperty.all<bool>(
                                                  true),
                                        ),
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 40,
                                        padding: EdgeInsets.only(
                                            left: 14, right: 14),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Gap(2 * SizeConfig.heightMultiplier),
                        Text(
                          "Category",
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Gap(1 * SizeConfig.heightMultiplier),
                        BlocProvider(
                          create: (context) => ValueCubit(),
                          child: Builder(
                            builder: (context) {
                              return BlocConsumer<ValueCubit, ValueState>(
                                listener: (context, state) {
                                  if (state.status == ValueStatus.changed) {
                                    _categoryController.text = state.value;
                                    selectedCategory = state.value;
                                  }
                                },
                                builder: (context, state) {
                                  return BlocBuilder<ProductCubit,
                                      ProductState>(
                                    bloc: context.read<ProductCubit>()
                                      ..getCategories(),
                                    builder: (context, state) {
                                      return DropdownButtonHideUnderline(
                                        child: DropdownButton2(
                                          isExpanded: true,
                                          hint: Text(
                                            'category',
                                            style: GoogleFonts.inter(
                                              fontSize: 1.6 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.w500,
                                              color: black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          items: state.categories
                                              .map(
                                                (item) =>
                                                    DropdownMenuItem<String>(
                                                  value: item.id,
                                                  child: Text(
                                                    item.name,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 1.6 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: black,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          value: selectedCategory,
                                          onChanged: (value) {
                                            context
                                                .read<ValueCubit>()
                                                .changeValue(
                                                  value: value.toString(),
                                                );
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.065,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.only(
                                                left: 14, right: 14),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  width: 1,
                                                  color:
                                                      const Color(0xff808B9A)),
                                              color: Colors.transparent,
                                            ),
                                            elevation: 0,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 300,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: Colors.white,
                                            ),
                                            elevation: 0,
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(40),
                                              thickness: MaterialStateProperty
                                                  .all<double>(6),
                                              thumbVisibility:
                                                  MaterialStateProperty.all<
                                                      bool>(true),
                                            ),
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                            padding: EdgeInsets.only(
                                                left: 14, right: 14),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        //* bidding
                        BlocProvider(
                          create: (context) => BoolCubit(),
                          child: Builder(builder: (context) {
                            return BlocBuilder<BoolCubit, BoolState>(
                              builder: (context, state) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Allow Bidding",
                                          style: GoogleFonts.notoSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const Spacer(),
                                        Switch(
                                          value: state.value,
                                          activeColor: green,
                                          inactiveTrackColor: lightGrey,
                                          onChanged: (value) {
                                            allowBidding = value;
                                            context
                                                .read<BoolCubit>()
                                                .changeValue(value: value);
                                          },
                                        ),
                                      ],
                                    ),
                                    if (state.value)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Gap(2 * SizeConfig.heightMultiplier),
                                          Text(
                                            "Minimum Price",
                                            style: GoogleFonts.notoSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Gap(1 * SizeConfig.heightMultiplier),
                                          InputField(
                                            controller: _priceController,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Price is required";
                                              }
                                              return null;
                                            },
                                            textInputAction:
                                                TextInputAction.next,
                                            hintText:
                                                "Minimum price for bidding",
                                          ),
                                          Gap(2 * SizeConfig.heightMultiplier),
                                          Text(
                                            "End Date",
                                            style: GoogleFonts.notoSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Gap(1 * SizeConfig.heightMultiplier),
                                          InputField(
                                            controller: _endDateController,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "End date is required";
                                              }
                                              return null;
                                            },
                                            textInputAction:
                                                TextInputAction.next,
                                            hintText: "End date for bidding",
                                            onTap: () async {
                                              final DateTime? date =
                                                  await showDateTimePicker(
                                                context: context,
                                              );
                                              if (date != null) {
                                                _endDateController.text =
                                                    date.toString();
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                  ],
                                );
                              },
                            );
                          }),
                        )
                        // category
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
