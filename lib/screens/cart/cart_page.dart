import 'package:ecoville/blocs/app/local_cubit.dart';
import 'package:ecoville/blocs/app/user_cubit.dart';
import 'package:ecoville/blocs/minimal/page_cubit.dart';
import 'package:ecoville/shared/complete_button.dart';
import 'package:ecoville/shared/icon_container.dart';
import 'package:ecoville/shared/input_field.dart';
import 'package:ecoville/shared/network_image_container.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/utilities/utilities.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  double totalAmount = 0.0;

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
            "ecoville shopping cart",
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
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(5 * SizeConfig.heightMultiplier),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: BlocBuilder<LocalCubit, LocalState>(
                    builder: (context, state) {
                      return Text(
                        "Your Cart" " (${state.cartItems.length})",
                        style: GoogleFonts.inter(
                            fontSize: 1.5 * SizeConfig.heightMultiplier,
                            fontWeight: FontWeight.w600,
                            color: black),
                      );
                    },
                  ),
                ),
                Divider(
                  color: Colors.grey[300],
                  thickness: 0.5,
                ),
              ],
            ),
          ),
        ),
        body: BlocProvider(
          create: (context) => PageCubit(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<LocalCubit, LocalState>(
                  builder: (context, state) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final product = state.cartItems[index];
                        // individual product quantity
                        int quantity = 1;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Column(
                            children: [
                              BlocProvider(
                                create: (context) => UserCubit()
                                  ..getUserById(id: product.userId),
                                child: Builder(builder: (context) {
                                  return BlocBuilder<UserCubit, UserState>(
                                    builder: (context, userState) {
                                      if (state.status == UserStatus.loading) {
                                        return const SizedBox.shrink();
                                      } else {
                                        return Row(
                                          children: [
                                            NetworkImageContainer(
                                              imageUrl: userState.user?.image ??
                                                  AppImages.defaultImage,
                                              height: size.height * 0.04,
                                              width: size.height * 0.04,
                                              isCirlce: true,
                                            ),
                                            Gap(2 * SizeConfig.widthMultiplier),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  userState.user?.name ?? "",
                                                  style: GoogleFonts.inter(
                                                      color: black,
                                                      fontSize: 1.8 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.2),
                                                ),
                                                Gap(0.4 *
                                                    SizeConfig
                                                        .heightMultiplier),
                                                Text(
                                                  "90% Positive Rating",
                                                  style: GoogleFonts.inter(
                                                      color: black,
                                                      fontSize: 1.3 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1.2),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            IconContainer(
                                              icon: AppImages.more,
                                              function: () {},
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  );
                                }),
                              ),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                      BlocConsumer<PageCubit, PageState>(
                                        listener: (context, state) {
                                          if (state.status ==
                                              PageStatus.changed) {
                                            if (state.page > quantity) {
                                              quantity = state.page;
                                              totalAmount +=
                                                  product.startingPrice *
                                                      quantity;
                                            } else {
                                              totalAmount +=
                                                  product.startingPrice *
                                                      state.page;
                                              quantity = state.page;
                                            }
                                          }
                                        },
                                        builder: (context, state) {
                                          return Text(
                                            "\$${(product.startingPrice * quantity).toStringAsFixed(2)}",
                                            style: GoogleFonts.inter(
                                                fontSize: 1.7 *
                                                    SizeConfig.heightMultiplier,
                                                fontWeight: FontWeight.w700,
                                                color: black),
                                          );
                                        },
                                      ),
                                      Gap(1 * SizeConfig.heightMultiplier),
                                      Row(
                                        children: [
                                           Text(
                                            "Quantity   ",
                                            style: GoogleFonts.inter(
                                                fontSize: 1.4 *
                                                    SizeConfig.heightMultiplier,
                                                fontWeight: FontWeight.w500,
                                                color: black),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.2,
                                            height: 4 * SizeConfig.heightMultiplier,
                                            child: TextFormField(
                                              controller: TextEditingController()
                                                ..text = quantity.toString(),
                                                onChanged: (value) {
                                                  context
                                                      .read<PageCubit>()
                                                      .changePage(
                                                          page: int.parse(value));
                                                },
                                              keyboardType: TextInputType.number,
                                              cursorHeight: 2 *
                                                  SizeConfig.heightMultiplier,
                                              decoration: InputDecoration(
                                                hintText: "",
                                                hintStyle: GoogleFonts.inter(
                                                    fontSize: 1.5 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    fontWeight: FontWeight.w500,
                                                    color: darkGrey),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide:  BorderSide(
                                                    width: 0.5,
                                                      color: darkGrey),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide:  BorderSide(
                                                    width: 0.5,
                                                      color: darkGrey),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide:  BorderSide(
                                                    width: 0.5,
                                                      color: darkGrey),
                                                ),
                                              ),
                                            ),
                                            
                                          )
                                        ],
                                      ),
                                      // BlocConsumer<PageCubit, PageState>(
                                      //   listener: (context, state) {
                                      //     if (state.status ==
                                      //         PageStatus.changed) {
                                      //       if (state.page > quantity) {
                                      //         quantity = state.page;
                                      //         totalAmount +=
                                      //             product.startingPrice *
                                      //                 quantity;
                                      //       } else {
                                      //         totalAmount +=
                                      //             product.startingPrice *
                                      //                 state.page;
                                      //         quantity = state.page;
                                      //       }
                                      //     }
                                      //   },
                                      //   builder: (context, state) {
                                      //     return Row(
                                      //       children: [
                                      //         GestureDetector(
                                      //           onTap: () {
                                      //             context
                                      //                 .read<PageCubit>()
                                      //                 .changePage(
                                      //                     page: quantity - 1);
                                      //           },
                                      //           child: Container(
                                      //             padding:
                                      //                 const EdgeInsets.all(5),
                                      //             decoration: BoxDecoration(
                                      //                 color: green,
                                      //                 shape: BoxShape.circle),
                                      //             child: Icon(
                                      //               Icons.remove,
                                      //               color: lightGrey,
                                      //               size: 2.2 *
                                      //                   SizeConfig
                                      //                       .heightMultiplier,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //         Gap(1.5 *
                                      //             SizeConfig.widthMultiplier),
                                      //         BlocBuilder<PageCubit, PageState>(
                                      //           builder: (context, state) {
                                      //             return Text(
                                      //               quantity.toString(),
                                      //               style: GoogleFonts.inter(
                                      //                   fontSize: 1.7 *
                                      //                       SizeConfig
                                      //                           .heightMultiplier,
                                      //                   fontWeight:
                                      //                       FontWeight.w700,
                                      //                   color: black),
                                      //             );
                                      //           },
                                      //         ),
                                      //         Gap(1.5 *
                                      //             SizeConfig.widthMultiplier),
                                      //         GestureDetector(
                                      //           onTap: () {
                                      //             context
                                      //                 .read<PageCubit>()
                                      //                 .changePage(
                                      //                     page: quantity + 1);
                                      //           },
                                      //           child: Container(
                                      //             padding:
                                      //                 const EdgeInsets.all(5),
                                      //             decoration: BoxDecoration(
                                      //                 color: green,
                                      //                 shape: BoxShape.circle),
                                      //             child: Icon(
                                      //               Icons.add,
                                      //               color: lightGrey,
                                      //               size: 2.2 *
                                      //                   SizeConfig
                                      //                       .heightMultiplier,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     );
                                      //   },
                                      // ),
                                      Gap(2 * SizeConfig.heightMultiplier),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Save for later",
                                            style: GoogleFonts.inter(
                                                fontSize: 1.5 *
                                                    SizeConfig.heightMultiplier,
                                                fontWeight: FontWeight.w500,
                                                color: green),
                                          ),
                                          Gap(1.5 * SizeConfig.widthMultiplier),
                                          GestureDetector(
                                            onTap: () {
                                              context
                                                  .read<LocalCubit>()
                                                  .removeProductFromCart(
                                                      id: product.id);
                                            },
                                            child: Text(
                                              "Remove",
                                              style: GoogleFonts.inter(
                                                  fontSize: 1.5 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  fontWeight: FontWeight.w500,
                                                  color: green),
                                            ),
                                          ),
                                        ],
                                      )
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
                  thickness: 0.5,
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<LocalCubit, LocalState>(
                            builder: (context, state) {
                              return Text(
                                "Items (${state.cartItems.length})",
                                style: GoogleFonts.inter(
                                    fontSize: 1.5 * SizeConfig.heightMultiplier,
                                    fontWeight: FontWeight.w600,
                                    color: darkGrey),
                              );
                            },
                          ),
                          const Spacer(),
                          BlocBuilder<PageCubit, PageState>(
                            builder: (context, state) {
                              return BlocBuilder<LocalCubit, LocalState>(
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
                              );
                            },
                          ),
                          Gap(2 * SizeConfig.heightMultiplier),
                        ],
                      ),
                      Divider(
                        color: Colors.grey[300],
                        thickness: 0.5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<LocalCubit, LocalState>(
                            builder: (context, state) {
                              return Text(
                                "Subtotal",
                                style: GoogleFonts.inter(
                                    fontSize: 1.5 * SizeConfig.heightMultiplier,
                                    fontWeight: FontWeight.w600,
                                    color: darkGrey),
                              );
                            },
                          ),
                          const Spacer(),
                          BlocBuilder<PageCubit, PageState>(
                            builder: (context, state) {
                              return BlocBuilder<LocalCubit, LocalState>(
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
                              );
                            },
                          ),
                          Gap(2 * SizeConfig.heightMultiplier),
                        ],
                      ),
                      Gap(2 * SizeConfig.heightMultiplier),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: CompleteButton(
                            height: 6 * SizeConfig.heightMultiplier,
                            borderRadius: 30,
                            text: Text(
                              "Go to checkout",
                              style: GoogleFonts.inter(
                                  color: white,
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.1),
                            ),
                            function: () => showModalBottomSheet(context: context, builder: (context,){
                              return Container(
                                height: size.height * 0.6,
                                width: size.width,
                                padding: const EdgeInsets.all(20),
                                decoration:  BoxDecoration(
                                  color: white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Delivery Address",
                                      style: GoogleFonts.inter(
                                          fontSize: 1.8 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w600,
                                          color: black),
                                    ),
                                                        
                                    
                                  ]
                                ),
                              );
                            })),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
