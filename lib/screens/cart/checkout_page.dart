import 'package:ecoville/blocs/app/address_cubit.dart';
import 'package:ecoville/blocs/app/Cart_cubit.dart';
import 'package:ecoville/blocs/app/local_cubit.dart';
import 'package:ecoville/blocs/app/payment_cubit.dart';
import 'package:ecoville/blocs/app/user_cubit.dart';
import 'package:ecoville/blocs/minimal/page_cubit.dart';
import 'package:ecoville/shared/complete_button.dart';
import 'package:ecoville/shared/icon_container.dart';
import 'package:ecoville/shared/network_image_container.dart';
import 'package:ecoville/utilities/packages.dart';

class CheckoutPage extends StatelessWidget {
  CheckoutPage({super.key});

  double totalAmount = 0.0;
  List<String> products = [];

  List<Map<String, dynamic>> paymentMethods = [
    {
      'name': 'M-Pesa',
      'icon': AppImages.mpesa,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => LocalCubit()..getCartProducts(),
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: white,
          surfaceTintColor: white,
          automaticallyImplyLeading: false,
          centerTitle: false,
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: IconContainer(
                icon: AppImages.close, function: () => context.pop()),
          ),
          title: Text(
            "Checkout",
            style: GoogleFonts.inter(
                fontSize: 2.2 * SizeConfig.heightMultiplier,
                fontWeight: FontWeight.w600,
                color: black),
          ),
          actions: [
            IconContainer(
                icon: AppImages.more,
                function: () => context.pushNamed(Routes.cart)),
            Gap(1 * SizeConfig.widthMultiplier),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
              bottom: 20,
              left: 20,
              right: 20,
              top: 1 * SizeConfig.heightMultiplier),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<UserCubit, UserState>(
                builder: (context, userState) {
                  return BlocProvider(
                    create: (context) => PaymentCubit(),
                    child: Builder(builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: BlocConsumer<PaymentCubit, PaymentState>(
                          listener: (context, state) {
                            debugPrint("Payment status: ${state.status}");
                            if (state.status == PaymentStatus.success) {
                              context.pop();
                              context.read<LocalCubit>().clearCart();
                              context.showSuccessToast(
                                  title: "Success",
                                  message: state.message ?? "Payment successful",
                                  context: context);
                            }
                            if (state.status == PaymentStatus.initialized) {
                              context.read<PaymentCubit>().completePayment();
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      width: size.width,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      color: white,
                                      child: IntrinsicHeight(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Confirming payment...",
                                              style: GoogleFonts.inter(
                                                  fontSize: 2.2 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  fontWeight: FontWeight.w600,
                                                  color: black),
                                            ),
                                            Gap(2 *
                                                SizeConfig.heightMultiplier),
                                            const CircularProgressIndicator(),
                                            Gap(2 *
                                                SizeConfig.heightMultiplier),
                                            CompleteButton(
                                                height: 6 *
                                                    SizeConfig.heightMultiplier,
                                                loaderColor: white,
                                                borderRadius: 30,
                                                text: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Cancel",
                                                      style: GoogleFonts.inter(
                                                          color: white,
                                                          fontSize: 1.8 *
                                                              SizeConfig
                                                                  .textMultiplier,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.1),
                                                    ),
                                                  ],
                                                ),
                                                function: () {})
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }
                            if (state.status == PaymentStatus.confirming) {
                              Future.delayed(const Duration(seconds: 15), () {
                                context.read<PaymentCubit>().confirmPayment();
                              });
                            }
                          },
                          builder: (context, state) {
                            return CompleteButton(
                                height: 6 * SizeConfig.heightMultiplier,
                                loaderColor: white,
                                isLoading: state.status ==
                                        PaymentStatus.loading ||
                                    state.status == PaymentStatus.confirming,
                                borderRadius: 30,
                                text: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(AppImages.lock,
                                        height: 2 * SizeConfig.heightMultiplier,
                                        width: 2 * SizeConfig.heightMultiplier,
                                        color: white),
                                    Gap(1 * SizeConfig.widthMultiplier),
                                    Text(
                                      "Confirm and pay",
                                      style: GoogleFonts.inter(
                                          color: white,
                                          fontSize:
                                              1.8 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.1),
                                    ),
                                  ],
                                ),
                                function: () => context
                                    .read<PaymentCubit>()
                                    .initializePayment(
                                        phone:
                                            int.parse(userState.user!.phone!),
                                        amount: totalAmount,
                                        products: products));
                          },
                        ),
                      );
                    }),
                  );
                },
              ),
              Gap(2 * SizeConfig.heightMultiplier),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppImages.shield,
                    height: 2.5 * SizeConfig.heightMultiplier,
                    width: 2.5 * SizeConfig.heightMultiplier,
                    color: Colors.blue[700],
                  ),
                  Gap(1 * SizeConfig.widthMultiplier),
                  Text(
                    "Purchase protected by Ecoville money back guarantee",
                    style: GoogleFonts.inter(
                        fontSize: 1.5 * SizeConfig.heightMultiplier,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: BlocProvider(
          create: (context) => PageCubit(),
          child: BlocListener<PageCubit, PageState>(
            listener: (context, state) {
              if (state.status == PageStatus.changed) {
                totalAmount += state.page.toDouble();
              }
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<LocalCubit, LocalState>(
                    buildWhen: (previous, current) =>
                        current.cartItems != previous.cartItems,
                    builder: (context, state) {
                      totalAmount = 0.0;
                      return ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final product = state.cartItems[index];
                          context
                              .read<PageCubit>()
                              .changePage(page: product.startingPrice.toInt());
                          products.add(product.id);
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Column(
                              children: [
                                Gap(2 * SizeConfig.heightMultiplier),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    NetworkImageContainer(
                                      imageUrl: product.image,
                                      height: 13 * SizeConfig.heightMultiplier,
                                      width: 13 * SizeConfig.widthMultiplier,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    Gap(2 * SizeConfig.widthMultiplier),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.6,
                                          child: Text(
                                            product.name,
                                            softWrap: true,
                                            maxLines: 2,
                                            style: GoogleFonts.inter(
                                                fontSize: 1.8 *
                                                    SizeConfig.heightMultiplier,
                                                fontWeight: FontWeight.w500,
                                                color: black),
                                          ),
                                        ),
                                        Gap(1 * SizeConfig.heightMultiplier),
                                        Text(
                                          "\$${(product.startingPrice).toStringAsFixed(2)}",
                                          style: GoogleFonts.inter(
                                              fontSize: 1.7 *
                                                  SizeConfig.heightMultiplier,
                                              fontWeight: FontWeight.w700,
                                              color: black),
                                        ),
                                        Gap(1 * SizeConfig.heightMultiplier),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Quantity: 1",
                                              style: GoogleFonts.inter(
                                                  fontSize: 1.3 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey[500]),
                                            ),
                                            Gap(0.35 *
                                                MediaQuery.of(context)
                                                    .size
                                                    .width),
                                            // GestureDetector(
                                            //   onTap: () {
                                            //     context
                                            //         .read<LocalCubit>()
                                            //         .removeProductFromCart(
                                            //             id: product.id);
                                            //   },
                                            //   child: Text(
                                            //     "Remove",
                                            //     style: GoogleFonts.inter(
                                            //         fontSize: 1.5 *
                                            //             SizeConfig
                                            //                 .heightMultiplier,
                                            //         fontWeight: FontWeight.w600,
                                            //         color: green),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        Gap(1 * SizeConfig.heightMultiplier),
                                        Text(
                                          "Free returns",
                                          style: GoogleFonts.inter(
                                              fontSize: 1.5 *
                                                  SizeConfig.heightMultiplier,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[500]),
                                        ),
                                        Gap(1 * SizeConfig.heightMultiplier),
                                        Text(
                                          "Delivery: 3-5 days",
                                          style: GoogleFonts.inter(
                                              fontSize: 1.5 *
                                                  SizeConfig.heightMultiplier,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[700]),
                                        ),
                                        Gap(0.3 * SizeConfig.heightMultiplier),
                                        SizedBox(
                                          width: size.width * 0.6,
                                          child: Text(
                                            "Message the seller to communicate about the delivery",
                                            style: GoogleFonts.inter(
                                                fontSize: 1.5 *
                                                    SizeConfig.heightMultiplier,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey[700]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey[400],
                          thickness: 0.5,
                        ),
                        itemCount: state.cartItems.length,
                      );
                    },
                  ),
                  Divider(
                    color: Colors.grey[400],
                    thickness: 0.4,
                  ),
                  Gap(2 * SizeConfig.heightMultiplier),
                  const AddressSection(),
                  Gap(1 * SizeConfig.heightMultiplier),
                  Divider(
                    color: Colors.grey[400],
                    thickness: 0.4,
                  ),
                  Gap(1 * SizeConfig.heightMultiplier),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "Pay with",
                              style: GoogleFonts.inter(
                                  fontSize: 1.8 * SizeConfig.heightMultiplier,
                                  fontWeight: FontWeight.w600,
                                  color: black),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Gap(1 * SizeConfig.heightMultiplier),
                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final paymentMethod = paymentMethods[index];
                          return ListTile(
                            onTap: () {},
                            leading: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey[300]!, width: 0.5),
                              ),
                              child: Image.asset(
                                paymentMethod['icon'],
                                height: 3 * SizeConfig.heightMultiplier,
                                width: 6 * SizeConfig.heightMultiplier,
                              ),
                            ),
                            title: Text(
                              paymentMethod['name'],
                              style: GoogleFonts.inter(
                                  fontSize: 1.8 * SizeConfig.heightMultiplier,
                                  fontWeight: FontWeight.w500,
                                  color: black),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey[400],
                          thickness: 0.4,
                        ),
                        itemCount: paymentMethods.length,
                      ),
                    ],
                  ),
                  Gap(1 * SizeConfig.heightMultiplier),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<LocalCubit, LocalState>(
                              buildWhen: (previous, current) =>
                                  current.cartItems != previous.cartItems,
                              builder: (context, state) {
                                return Text(
                                  "Items (${state.cartItems.length})",
                                  style: GoogleFonts.inter(
                                      fontSize:
                                          1.5 * SizeConfig.heightMultiplier,
                                      fontWeight: FontWeight.w600,
                                      color: darkGrey),
                                );
                              },
                            ),
                            const Spacer(),
                            BlocBuilder<PageCubit, PageState>(
                              builder: (context, state) {
                                return Text(
                                  "\$${totalAmount.toStringAsFixed(2)}",
                                  style: GoogleFonts.inter(
                                      fontSize:
                                          1.6 * SizeConfig.heightMultiplier,
                                      fontWeight: FontWeight.w700,
                                      color: black),
                                );
                              },
                            ),
                            Gap(2 * SizeConfig.heightMultiplier),
                          ],
                        ),
                        Divider(
                          color: Colors.grey[300],
                          thickness: 0.4,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<LocalCubit, LocalState>(
                              buildWhen: (previous, current) =>
                                  current.cartItems != previous.cartItems,
                              builder: (context, state) {
                                return Text(
                                  "Service fee",
                                  style: GoogleFonts.inter(
                                      fontSize:
                                          1.5 * SizeConfig.heightMultiplier,
                                      fontWeight: FontWeight.w600,
                                      color: darkGrey),
                                );
                              },
                            ),
                            const Spacer(),
                            BlocBuilder<PageCubit, PageState>(
                              builder: (context, state) {
                                return Text(
                                  "\$2.00",
                                  style: GoogleFonts.inter(
                                      fontSize:
                                          1.6 * SizeConfig.heightMultiplier,
                                      fontWeight: FontWeight.w700,
                                      color: black),
                                );
                              },
                            ),
                            Gap(2 * SizeConfig.heightMultiplier),
                          ],
                        ),
                        Divider(
                          color: Colors.grey[300],
                          thickness: 0.4,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<LocalCubit, LocalState>(
                              buildWhen: (previous, current) =>
                                  current.cartItems != previous.cartItems,
                              builder: (context, state) {
                                return Text(
                                  "Order total",
                                  style: GoogleFonts.inter(
                                      fontSize:
                                          2.2 * SizeConfig.heightMultiplier,
                                      fontWeight: FontWeight.w700,
                                      color: darkGrey),
                                );
                              },
                            ),
                            const Spacer(),
                            BlocBuilder<PageCubit, PageState>(
                              buildWhen: (previous, current) => current.page !=
                                  previous.page,
                              builder: (context, state) {
                                return Text(
                                  "\$${(totalAmount + 2.00).toStringAsFixed(2)}",
                                  style: GoogleFonts.inter(
                                      fontSize:
                                          1.8 * SizeConfig.heightMultiplier,
                                      fontWeight: FontWeight.w700,
                                      color: black),
                                );
                              },
                            ),
                            Gap(2 * SizeConfig.heightMultiplier),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddressSection extends StatelessWidget {
  const AddressSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Ship to",
                style: GoogleFonts.inter(
                    fontSize: 1.8 * SizeConfig.heightMultiplier,
                    fontWeight: FontWeight.w600,
                    color: black),
              ),
            ),
            const Spacer(),
            BlocBuilder<AddressCubit, AddressState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    onTap: () => context.pushNamed(Routes.addAddress),
                    child: Text(
                      state.addresses.isEmpty ? "Add" : "",
                      style: GoogleFonts.inter(
                          fontSize: 1.5 * SizeConfig.heightMultiplier,
                          fontWeight: FontWeight.w500,
                          color: green),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        Gap(2 * SizeConfig.heightMultiplier),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            "Shipping address",
            style: GoogleFonts.inter(
                fontSize: 1.5 * SizeConfig.heightMultiplier,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500]),
          ),
        ),
        Gap(2 * SizeConfig.heightMultiplier),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: BlocBuilder<AddressCubit, AddressState>(
            builder: (context, state) {
              if (state.status == AddressStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return state.addresses.isEmpty
                    ? const SizedBox.shrink()
                    : ListView.separated(
                        itemCount: 1,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final address = state.addresses[index];
                          return OutlinedButton(
                            onPressed: () =>
                                context.pushNamed(Routes.editAddress, extra: {
                              "id": address.id,
                            }),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              foregroundColor: white,
                              side: BorderSide.none,
                            ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      address.name,
                                      style: GoogleFonts.inter(
                                          fontSize:
                                              1.5 * SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.w600,
                                          color: black),
                                    ),
                                    Text(
                                      address.addressLine1,
                                      style: GoogleFonts.inter(
                                          fontSize:
                                              1.6 * SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.w400,
                                          color: black),
                                    ),
                                    Text(
                                      address.addressLine2,
                                      style: GoogleFonts.inter(
                                          fontSize:
                                              1.6 * SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.w400,
                                          color: black),
                                    ),
                                    Text(
                                      address.city,
                                      style: GoogleFonts.inter(
                                          fontSize:
                                              1.6 * SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.w400,
                                          color: black),
                                    ),
                                    // Text(
                                    //   address.country,
                                    //   style: GoogleFonts.inter(
                                    //       fontSize: 1.6 * SizeConfig.heightMultiplier,
                                    //       fontWeight: FontWeight.w400,
                                    //       color: black),
                                    // ),
                                    Text(
                                      address.phone,
                                      style: GoogleFonts.inter(
                                          fontSize:
                                              1.6 * SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.w400,
                                          color: black),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                IconContainer(
                                    icon: AppImages.right, function: () {})
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.grey[300],
                            thickness: 0.5,
                            height: 20,
                          );
                        },
                      );
              }
            },
          ),
        ),
      ],
    );
  }
}
