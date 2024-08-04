import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ecoville/blocs/app/ai_cubit.dart';
import 'package:ecoville/blocs/app/app_cubit.dart';
import 'package:ecoville/blocs/app/location_cubit.dart';
import 'package:ecoville/blocs/app/product_cubit.dart';
import 'package:ecoville/blocs/app/user_cubit.dart';
import 'package:ecoville/blocs/minimal/bool_cubit.dart';
import 'package:ecoville/blocs/minimal/value_cubit.dart';
import 'package:ecoville/models/product_model.dart';
import 'package:ecoville/models/product_request_model.dart';
import 'package:ecoville/shared/complete_button.dart';
import 'package:ecoville/shared/icon_container.dart';
import 'package:ecoville/shared/input_field.dart';
import 'package:ecoville/shared/network_image_container.dart';
import 'package:ecoville/utilities/packages.dart';

final _priceController = TextEditingController();

final _endDateController = TextEditingController(text: DateTime.now().toString());

bool allowBidding = false;

class PostingPage extends StatefulWidget {
  PostingPage({super.key});

  @override
  State<PostingPage> createState() => _PostingPageState();
}

class _PostingPageState extends State<PostingPage> {
  final _titleController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _quantityController = TextEditingController();

  final _categoryController = TextEditingController();

  final _conditionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<String> images = [];

  String option = 'new';

  String? selectedCondition;

  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
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
            "Post a product",
            style: GoogleFonts.inter(
                fontSize: 2.2 * SizeConfig.heightMultiplier,
                fontWeight: FontWeight.w600,
                color: black),
          ),
          actions: [
            IconContainer(
                icon: AppImages.more,
                function: () => context.pushNamed(Routes.addAddress)),
            Gap(1 * SizeConfig.widthMultiplier),
          ],
        ),
        bottomNavigationBar: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, localState) {
            return BlocProvider(
              create: (context) => ProductCubit(),
              child: BlocConsumer<ProductCubit, ProductState>(
                listener: (context, state) {
                  if (state.status == ProductStatus.success) {
                    context
                      ..showSuccessToast(
                          title: "Success",
                          message: "Product added successfully",
                          context: context)
                      ..pop();
                  }
                },
                builder: (context, productState) {
                  return Builder(builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: BlocBuilder<UserCubit, UserState>(
                        builder: (context, state) {
                          return CompleteButton(
                              height: 6 * SizeConfig.heightMultiplier,
                              isLoading:
                                  productState.status == ProductStatus.loading,
                              borderRadius: 30,
                              text: Text(
                                "List an item",
                                style: GoogleFonts.inter(
                                    color: white,
                                    fontSize: 1.8 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.1),
                              ),
                              function: () {
                                final product = ProductRequestModel(
                                    name: _titleController.text.trim(),
                                    description:
                                        _descriptionController.text.trim(),
                                    image: images.isEmpty ? [
                                      "https:picsa.pro/profile.jpg"
                                    ] : images,
                                    userId: supabase.auth.currentUser!.id,
                                    categoryid: _categoryController.text.trim(),
                                    price: double.parse(_priceController.text),
                                    allowBidding: allowBidding,
                                    endBidding: _endDateController.text.isEmpty
                                        ? DateTime.now()
                                        : DateTime.parse(_endDateController.text),
                                    currentPrice:
                                        double.parse(_priceController.text),
                                    condition: _conditionController.text.trim(),
                                    address: Address(
                                        lat: localState.position!.latitude
                                            .toString(),
                                        lon: localState.position!.longitude
                                            .toString(),
                                        city: "city",
                                        country: "Kenya")
                                    );
                                context.read<ProductCubit>().createProduct(
                                    product: product, allowBidding: false);
                              });
                        },
                      ),
                    );
                  });
                },
              ),
            );
          },
        ),
        body: BlocProvider(
          create: (context) => AiCubit(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocProvider(
                        create: (context) => AppCubit(),
                        child: Builder(builder: (context) {
                          return BlocConsumer<AppCubit, AppState>(
                            listener: (context, state) {
                              debugPrint("state: ${state.status}");
                              if (state.status == AppStatus.uploaded) {
                                images.add(state.imageUrl);
                              }
                            },
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _outlinePickButton(),
                                  Gap(1 * SizeConfig.heightMultiplier),
                                  _outlineUploadButton(),
                                  Gap(1 * SizeConfig.heightMultiplier),
                                  if (state.status == AppStatus.loading)
                                    LinearProgressIndicator(
                                      color: green,
                                    ),
                                  images.isEmpty
                                      ? const SizedBox.shrink()
                                      : Gap(1 * SizeConfig.heightMultiplier),
                                  images.isEmpty
                                      ? const SizedBox.shrink()
                                      : SizedBox(
                                          height: size.height * 0.1,
                                          child: ListView.separated(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Stack(
                                                  children: [
                                                    NetworkImageContainer(
                                                      imageUrl: images[index],
                                                      height: size.height * 0.1,
                                                      width: size.height * 0.08,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    Positioned.fill(
                                                      child: GestureDetector(
                                                        onTap: () => images
                                                            .removeAt(index),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          decoration: BoxDecoration(
                                                              color: lightGrey
                                                                  .withOpacity(
                                                                      0.1),
                                                              shape: BoxShape
                                                                  .circle),
                                                          child: Center(
                                                              child: Icon(
                                                            Icons.close,
                                                            color: lightGrey,
                                                          )),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) => Gap(1 *
                                                      SizeConfig
                                                          .widthMultiplier),
                                              itemCount: images.length),
                                        ),
                                ],
                              );
                            },
                          );
                        }),
                      ),
                      Gap(2 * SizeConfig.heightMultiplier),
                      Text(
                        'Query',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gap(1 * SizeConfig.heightMultiplier),
                      BlocConsumer<AiCubit, AiState>(
                        listener: (context, state) {
                          if (state.status == AiStatus.success) {
                            _titleController.text = state.model!.title;
                            _descriptionController.text =
                                state.model!.description;
                          }
                        },
                        builder: (context, state) {
                          return InputField(
                            controller: _titleController,
                            maxLines: 6,
                            minLines: 2,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Title is required";
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            hintText:
                                "Describe your product completely (e.g. 'A beautiful red dress')",
                          );
                        },
                      ),
                      Gap(1 * SizeConfig.heightMultiplier),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: BlocBuilder<AiCubit, AiState>(
                          builder: (context, state) {
                            return CompleteButton(
                                height: 6 * SizeConfig.heightMultiplier,
                                isLoading: state.status == AiStatus.loading,
                                borderRadius: 30,
                                text: Text(
                                  "Generate",
                                  style: GoogleFonts.inter(
                                      color: white,
                                      fontSize: 1.8 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.1),
                                ),
                                function: () => context
                                    .read<AiCubit>()
                                    .generateTitleAndDescription(
                                        query: _titleController.text));
                          },
                        ),
                      ),
                      Gap(2 * SizeConfig.heightMultiplier),
                      Text(
                        'Price',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
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
                        textInputAction: TextInputAction.next,
                        hintText: "Product price",
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
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.only(
                                          left: 14, right: 14),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            width: 1,
                                            color: const Color(0xff808B9A)),
                                        color: Colors.transparent,
                                      ),
                                      elevation: 0,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight: 300,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
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
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                      padding:
                                          EdgeInsets.only(left: 14, right: 14),
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
                                return BlocBuilder<ProductCubit, ProductState>(
                                  bloc: context.read<ProductCubit>()
                                    ..getCategories(),
                                  builder: (context, state) {
                                    return DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        isExpanded: true,
                                        hint: Text(
                                          'category',
                                          style: GoogleFonts.inter(
                                            fontSize:
                                                1.6 * SizeConfig.textMultiplier,
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
                                                    fontWeight: FontWeight.w500,
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
                            );
                          },
                        ),
                      ),
                      Gap(2 * SizeConfig.heightMultiplier),
                      _biddingSection()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class _biddingSection extends StatelessWidget {
  _biddingSection({
    super.key,
  });

  final _priceController = TextEditingController();

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
                        context.read<BoolCubit>().changeValue(value: value);
                      },
                    ),
                  ],
                ),
                if (state.value)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        textInputAction: TextInputAction.next,
                        hintText: "Minimum price for bidding",
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
                        textInputAction: TextInputAction.next,
                        hintText: "End date for bidding",
                        onTap: () async {
                          final DateTime? date = await showDateTimePicker(
                            context: context,
                          );
                          if (date != null) {
                            _endDateController.text = date.toString();
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
    );
  }
}

class _outlinePickButton extends StatelessWidget {
  const _outlinePickButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          // backgroundColor: lightGrey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: BorderSide(color: Colors.black.withOpacity(0.4), width: 0.6)),
      onPressed: () =>
          context.read<AppCubit>().pickImage(source: ImageSource.camera),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Text(
              'Take Photo',
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            const Spacer(),
            IconContainer(
                icon: AppImages.camera,
                function: () => context
                    .read<AppCubit>()
                    .pickImage(source: ImageSource.camera))
          ],
        ),
      ),
    );
  }
}

class _outlineUploadButton extends StatelessWidget {
  const _outlineUploadButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          // backgroundColor: lightGrey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: BorderSide(color: Colors.black.withOpacity(0.4), width: 0.6)),
      onPressed: () =>
          context.read<AppCubit>().pickImage(source: ImageSource.gallery),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Text(
              'Upload Photo',
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            const Spacer(),
            IconContainer(
                icon: AppImages.upload,
                function: () => context
                    .read<AppCubit>()
                    .pickImage(source: ImageSource.gallery))
          ],
        ),
      ),
    );
  }
}
