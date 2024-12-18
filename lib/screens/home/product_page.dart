import 'package:ecoville/blocs/app/local_cubit.dart';
import 'package:ecoville/blocs/app/product_cubit.dart';
import 'package:ecoville/blocs/app/rating_cubit.dart';
import 'package:ecoville/blocs/minimal/navigation_cubit.dart';
import 'package:ecoville/blocs/minimal/page_cubit.dart';
import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/models/rating_model.dart';
import 'package:ecoville/screens/home/bidding_page.dart';
import 'package:ecoville/screens/home/widgets/product_list_shimmer.dart';
import 'package:ecoville/shared/border_button.dart';
import 'package:ecoville/shared/complete_button.dart';
import 'package:ecoville/shared/icon_container.dart';
import 'package:ecoville/shared/network_image_container.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/screens/home/widgets/product_container.dart';
import 'package:ecoville/screens/home/widgets/product_shimmer.dart';

class ProductDetailsPage extends StatelessWidget {
  ProductDetailsPage({super.key, required this.id, required this.title});
  final String id;
  final String title;

  final _pageController = PageController();

  String formatMinutes(int totalMinutes) {
    if (totalMinutes < 0) {
      throw ArgumentError('Minutes cannot be negative');
    }

    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<ProductCubit, ProductState>(
      buildWhen: (previous, current) => previous.product != current.product,
      bloc: context.read<ProductCubit>()
        ..getProduct(id: id)
        ..getProductRecommendations(query: title),
      builder: (context, state) {
        return Scaffold(
            backgroundColor: white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(8 * SizeConfig.heightMultiplier),
              child: (state.status == ProductStatus.success)
                  ? ProductAppBar(
                      id: id,
                      userId: state.product!.userId!,
                    )
                  : AppBar(
                      backgroundColor: white,
                      elevation: 0,
                      title: Text(
                        title,
                        style: GoogleFonts.inter(
                            color: black,
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.bold,
                            height: 1.2),
                      ),
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back, color: black),
                        onPressed: () => context.pop(),
                      ),
                    ),
            ),
            body: RefreshIndicator(
              onRefresh: () {
                context.read<ProductCubit>()
                  ..getProduct(id: id)
                  ..getProductRecommendations(query: title);
                return Future.value();
              },
              child: SingleChildScrollView(
                child: BlocProvider(
                  create: (context) => PageCubit(),
                  child: state.status == ProductStatus.loading
                      ? ProductPageShimmer(
                          title: title,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProductImagesSection(
                              id: id,
                              pageController: _pageController,
                            ),
                            Gap(2 * SizeConfig.widthMultiplier),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.product!.name,
                                    style: GoogleFonts.inter(
                                        color: black,
                                        fontSize:
                                            2.5 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2),
                                  ),
                                  Gap(1 * SizeConfig.heightMultiplier),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: state.product!.sold!
                                          ? Colors.red.withOpacity(0.2)
                                          : Colors.blue.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      state.product!.sold!
                                          ? "Sold Out"
                                          : "Available",
                                      style: GoogleFonts.inter(
                                          fontSize:
                                              1.5 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w600,
                                          color: state.product!.sold!
                                              ? Colors.red
                                              : Colors.blue),
                                    ),
                                  ),
                                  Gap(1 * SizeConfig.heightMultiplier),
                                  // Row(
                                  //   children: [
                                  //     NetworkImageContainer(
                                  //       imageUrl: AppImages.defaultImage,
                                  //       height: height * 0.05,
                                  //       width: height * 0.05,
                                  //       isCirlce: true,
                                  //     ),
                                  //     Gap(2 * SizeConfig.widthMultiplier),
                                  //     Column(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.start,
                                  //       children: [
                                  //         BlocBuilder<ProductCubit, ProductState>(
                                  //           buildWhen: (previous, current) =>
                                  //               previous.product !=
                                  //               current.product,
                                  //           builder: (context, state) {
                                  //             return Text(
                                  //               state.product!.user!.name!,
                                  //               style: GoogleFonts.inter(
                                  //                   color: black,
                                  //                   fontSize: 2.2 *
                                  //                       SizeConfig.textMultiplier,
                                  //                   fontWeight: FontWeight.w600,
                                  //                   height: 1.2),
                                  //             );
                                  //           },
                                  //         ),
                                  //         Text(
                                  //           "90% Positive Rating",
                                  //           style: GoogleFonts.inter(
                                  //               color: black,
                                  //               fontSize: 1.6 *
                                  //                   SizeConfig.textMultiplier,
                                  //               fontWeight: FontWeight.w500,
                                  //               height: 1.2),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     const Spacer(),
                                  //     state.product!.userId !=
                                  //             supabase.auth.currentUser!.id
                                  //         ? BlocProvider(
                                  //             create: (context) => MessageCubit(),
                                  //             child: Builder(builder: (context) {
                                  //               return BlocListener<MessageCubit,
                                  //                   MessageState>(
                                  //                 listener: (context, state) {
                                  //                   debugPrint(
                                  //                       "Message State: ${state.status}");
                                  //                   if (state.status ==
                                  //                       MessageStatus.success) {
                                  //                     context
                                  //                         .push(Routes.messages);
                                  //                   }
                                  //                 },
                                  //                 child: IconContainer(
                                  //                   icon: AppImages.messages,
                                  //                   function: () => state.product!
                                  //                               .userId !=
                                  //                           supabase.auth
                                  //                               .currentUser!.id
                                  //                       ? context
                                  //                           .read<MessageCubit>()
                                  //                           .createConversation(
                                  //                               sellerId: state
                                  //                                   .product!
                                  //                                   .userId!)
                                  //                       : null,
                                  //                 ),
                                  //               );
                                  //             }),
                                  //           )
                                  //         : const SizedBox.shrink(),
                                  //   ],
                                  // ),
                                  // Gap(3 * SizeConfig.heightMultiplier),
                                  Text(
                                    state.product!.allowBidding!
                                        ? "Ksh ${state.product!.biddingPrice}"
                                        : "Ksh ${state.product!.price}",
                                    style: GoogleFonts.inter(
                                        color: black,
                                        fontSize:
                                            2.8 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2),
                                  ),
                                  Gap(1 * SizeConfig.heightMultiplier),
                                  if (state.product!.allowBidding!)
                                    Row(
                                      children: [
                                        Text(
                                          state.product!.bids!.isEmpty
                                              ? "No Bids"
                                              : "${state.product!.bids!.length} Bids",
                                          style: GoogleFonts.inter(
                                              color: black,
                                              fontSize: 1.6 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.w400,
                                              height: 1.2),
                                        ),
                                        const Spacer(),
                                        // time left endBidding - startBidding
                                        if (state.product!.allowBidding!)
                                          Text(
                                            "Ends in ${formatMinutes((state.product!.endBidding!.subtract(const Duration(hours: 3))).difference(DateTime.timestamp()).inMinutes)}",
                                            style: GoogleFonts.inter(
                                                color: black,
                                                fontSize: 1.6 *
                                                    SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.w400,
                                                height: 1.2),
                                          ),
                                      ],
                                    ),
                                  Gap(1 * SizeConfig.heightMultiplier),
                                  Text(
                                    "${state.product!.address!.city!}, ${state.product!.address!.country!}",
                                    style: GoogleFonts.inter(
                                        color: black,
                                        fontSize: 2 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.w500,
                                        height: 1.2),
                                  ),
                                  Gap(1.5 * SizeConfig.heightMultiplier),
                                  Row(
                                    children: [
                                      Text(
                                        "Condition ",
                                        style: GoogleFonts.inter(
                                            color: Colors.grey,
                                            fontSize:
                                                1.6 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w600,
                                            height: 1.2),
                                      ),
                                      Gap(10 * SizeConfig.widthMultiplier),
                                      Row(
                                        children: [
                                          Text(
                                            state.product!.condition!,
                                            style: GoogleFonts.inter(
                                                color: black,
                                                fontSize: 1.6 *
                                                    SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.w700,
                                                height: 1.2),
                                          ),
                                          Gap(0.5 * SizeConfig.widthMultiplier),
                                          SvgPicture.asset(AppImages.info,
                                              height: 2.5 *
                                                  SizeConfig.heightMultiplier,
                                              width: 2.5 *
                                                  SizeConfig.heightMultiplier,
                                              color: green),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Gap(3 * SizeConfig.heightMultiplier),
                                  if (state.product!.biddingStatus == "open")
                                    BlocBuilder<ProductCubit, ProductState>(
                                      builder: (context, state) {
                                        if (state.product!.allowBidding! &&
                                            state.product!.user!.id !=
                                                supabase.auth.currentUser!.id) {
                                          return CompleteButton(
                                            height: 6.5 *
                                                SizeConfig.heightMultiplier,
                                            borderRadius: 30,
                                            text: Text(
                                              "Place Bid",
                                              style: GoogleFonts.inter(
                                                  color: white,
                                                  fontSize: 1.8 *
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.1),
                                            ),
                                            function: () =>
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BiddingPage(
                                                              productId: state
                                                                  .product!.id,
                                                            ))),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  Gap(1 * SizeConfig.heightMultiplier),
                                  if ((state.product!.userId! !=
                                              supabase.auth.currentUser!.id) &&
                                          (!state.product!.sold!) ||
                                      (state.product!.biddingStatus! ==
                                              "closed" &&
                                          state.product!.highestBidder ==
                                              supabase.auth.currentUser!.id))
                                    BlocConsumer<LocalCubit, LocalState>(
                                      listenWhen: (previous, current) =>
                                          previous.status != current.status,
                                      buildWhen: (previous, current) =>
                                          previous.status != current.status,
                                      listener: (context, state) {
                                        if (state.status ==
                                            LocalStatus.updated) {
                                          context
                                            ..read<ProductCubit>()
                                                .getProduct(id: id)
                                            ..read<LocalCubit>()
                                                .getCartProducts();
                                        }
                                      },
                                      builder: (context, localState) {
                                        return BlocBuilder<ProductCubit,
                                            ProductState>(
                                          builder: (context, pstate) {
                                            return BorderButton(
                                                height: 6 *
                                                    SizeConfig.heightMultiplier,
                                                borderRadius: 30,
                                                text: BlocBuilder<LocalCubit,
                                                    LocalState>(
                                                  builder: (context, state) {
                                                    return Text(
                                                      state.cartItems.any(
                                                              (element) =>
                                                                  element.id ==
                                                                  pstate
                                                                      .product!
                                                                      .id)
                                                          ? "Added to Cart"
                                                          : "Add to Cart",
                                                      style: GoogleFonts.inter(
                                                          color: green,
                                                          fontSize: 1.8 *
                                                              SizeConfig
                                                                  .textMultiplier,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.1),
                                                    );
                                                  },
                                                ),
                                                function: () {
                                                  context
                                                      .read<LocalCubit>()
                                                      .addProductToCart(
                                                          product:
                                                              LocalProductModel(
                                                        id: state.product!.id,
                                                        name:
                                                            state.product!.name,
                                                        image: state
                                                            .product!.image[0],
                                                        userId: state
                                                            .product!.userId!,
                                                        available: state
                                                            .product!.quantity
                                                            .toString(),
                                                        startingPrice: state
                                                            .product!.price,
                                                      ));
                                                });
                                          },
                                        );
                                      },
                                    ),
                                  Gap(1 * SizeConfig.heightMultiplier),
                                  BlocBuilder<ProductCubit, ProductState>(
                                    buildWhen: (previous, current) =>
                                        previous.product != current.product,
                                    builder: (context, state) {
                                      return BlocProvider(
                                        create: (context) => LocalCubit(),
                                        child: Builder(builder: (context) {
                                          return BlocListener<LocalCubit,
                                              LocalState>(
                                            listenWhen: (previous, current) =>
                                                previous.status !=
                                                current.status,
                                            listener: (context, state) {
                                              if (state.status ==
                                                  LocalStatus.updated) {
                                                context
                                                    .read<ProductCubit>()
                                                    .getProduct(id: id);
                                              }
                                            },
                                            child: BorderButton(
                                                height: 6 *
                                                    SizeConfig.heightMultiplier,
                                                borderRadius: 30,
                                                text: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      state.product!
                                                              .isWishlisted
                                                          ? AppImages
                                                              .favouriteSolid
                                                          : AppImages.favourite,
                                                      height: 3 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      width: 3 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      color: green,
                                                    ),
                                                    Gap(1 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                                    Text(
                                                      state.product!
                                                              .isWishlisted
                                                          ? "Added to Wishlist"
                                                          : "Add to Wishlist",
                                                      style: GoogleFonts.inter(
                                                          color: green,
                                                          fontSize: 1.8 *
                                                              SizeConfig
                                                                  .textMultiplier,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.1),
                                                    ),
                                                  ],
                                                ),
                                                function: () => state
                                                        .product!.isWishlisted
                                                    ? context
                                                        .read<LocalCubit>()
                                                        .removeProductFromWishlist(
                                                            id: state
                                                                .product!.id)
                                                    : context
                                                        .read<LocalCubit>()
                                                        .addProductToWishlist(
                                                            id: state
                                                                .product!.id)),
                                          );
                                        }),
                                      );
                                    },
                                  ),
                                  Gap(3 * SizeConfig.heightMultiplier),
                                  Text(
                                    "Item Description from the seller ",
                                    style: GoogleFonts.inter(
                                        color: black,
                                        fontSize:
                                            2.5 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.w600,
                                        height: 1.2),
                                  ),
                                  Gap(1 * SizeConfig.heightMultiplier),
                                  Text(
                                    "Available items: ${state.product!.quantity}",
                                    style: GoogleFonts.inter(
                                        color: black,
                                        fontSize:
                                            1.6 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.w600,
                                        height: 1.2),
                                  ),
                                  Gap(1 * SizeConfig.heightMultiplier),
                                  Text(
                                    state.product!.description!,
                                    style: GoogleFonts.inter(
                                        color: black,
                                        fontSize:
                                            1.6 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.w500,
                                        height: 1.2),
                                  ),
                                  Gap(3 * SizeConfig.heightMultiplier),
                                  SellerSection(),
                                  Gap(4 * SizeConfig.heightMultiplier),
                                  RecommendedItems()
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ));
      },
    );
  }
}

class SellerSection extends StatelessWidget {
  const SellerSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About this seller",
          style: GoogleFonts.inter(
              color: black,
              fontSize: 2.5 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: 0.1),
        ),
        Gap(2 * SizeConfig.heightMultiplier),
        Row(
          children: [
            NetworkImageContainer(
              imageUrl: AppImages.defaultImage,
              height: height * 0.07,
              width: height * 0.07,
              isCirlce: true,
            ),
            Gap(2 * SizeConfig.widthMultiplier),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<ProductCubit, ProductState>(
                  buildWhen: (previous, current) =>
                      previous.product != current.product,
                  builder: (context, state) {
                    return Text(
                      state.product!.user!.name!,
                      style: GoogleFonts.inter(
                          color: black,
                          fontSize: 2.2 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w600,
                          height: 1.2),
                    );
                  },
                ),
                Gap(0.4 * SizeConfig.heightMultiplier),
                Text(
                  "90% Positive Rating",
                  style: GoogleFonts.inter(
                      color: black,
                      fontSize: 1.6 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w500,
                      height: 1.2),
                ),
              ],
            ),
            const Spacer(),
            // IconContainer(
            //   icon: AppImages.favourite,
            //   function: () {},
            // ),
          ],
        ),
        Gap(4 * SizeConfig.heightMultiplier),
        Row(
          children: [
            SvgPicture.asset(
              AppImages.calendar,
              height: 2.5 * SizeConfig.heightMultiplier,
              width: 2.5 * SizeConfig.heightMultiplier,
              color: black,
            ),
            Gap(1 * SizeConfig.widthMultiplier),
            BlocBuilder<ProductCubit, ProductState>(
              buildWhen: (previous, current) =>
                  previous.product != current.product,
              builder: (context, state) {
                return Text(
                  // "Member since ${state.product!.user.createdAt!.year}",
                  "Joined ${state.product!.user!.createdAt.toString().timeAgo()}",
                  style: GoogleFonts.inter(
                      color: black,
                      fontSize: 1.8 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w500,
                      height: 1.2),
                );
              },
            ),
          ],
        ),
        Gap(1 * SizeConfig.heightMultiplier),
        Row(
          children: [
            SvgPicture.asset(
              AppImages.clock,
              height: 2.5 * SizeConfig.heightMultiplier,
              width: 2.5 * SizeConfig.heightMultiplier,
              color: black,
            ),
            Gap(1 * SizeConfig.widthMultiplier),
            Text(
              "Usually responds within 24 hours",
              style: GoogleFonts.inter(
                  color: black,
                  fontSize: 1.8 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w500,
                  height: 1.2),
            ),
          ],
        ),
        Gap(3 * SizeConfig.heightMultiplier),
        BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            return CompleteButton(
                height: 6 * SizeConfig.heightMultiplier,
                borderRadius: 30,
                text: Text(
                  "Seller's Other Items",
                  style: GoogleFonts.inter(
                      color: white,
                      fontSize: 1.8 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1),
                ),
                function: () =>
                    context.push("/home/selleritems/${state.product!.userId}"));
          },
        ),
        Gap(1.5 * SizeConfig.heightMultiplier),
        // BorderButton(
        //     height: 6 * SizeConfig.heightMultiplier,
        //     borderRadius: 30,
        //     text: Text(
        //       "Contact Seller",
        //       style: GoogleFonts.inter(
        //           color: green,
        //           fontSize: 1.8 * SizeConfig.textMultiplier,
        //           fontWeight: FontWeight.w600,
        //           letterSpacing: 0.1),
        //     ),
        //     function: () {}),
        Gap(3 * SizeConfig.heightMultiplier),
        Text(
          "Detailed Seller Ratings",
          style: GoogleFonts.inter(
              color: black,
              fontSize: 2.5 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: 0.1),
        ),
        Gap(2 * SizeConfig.heightMultiplier),
        Text(
          "Average for the last 12 months",
          style: GoogleFonts.inter(
              color: Colors.grey,
              fontSize: 1.8 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.w600,
              height: 1.2,
              letterSpacing: 0.1),
        ),
        Gap(2 * SizeConfig.heightMultiplier),
        BlocBuilder<ProductCubit, ProductState>(
          buildWhen: (previous, current) => previous.product != current.product,
          builder: (context, state) {
            return Column(
              children: [
                Ratingbar(
                  title: "Accurate Description",
                  rating: state.product!.user!.rating?.description ?? 0,
                ),
                Ratingbar(
                  title: "Communication",
                  rating: state.product!.user!.rating?.communication ?? 0,
                ),
                Ratingbar(
                  title: "Shipping Speed",
                  rating: state.product!.user!.rating?.shipping ?? 0,
                ),
              ],
            );
          },
        ),
        Gap(3 * SizeConfig.heightMultiplier),
        BlocBuilder<ProductCubit, ProductState>(
          buildWhen: (previous, current) => previous.product != current.product,
          builder: (context, state) {
            return BlocProvider(
              create: (context) => RatingCubit()
                ..getProductRatings(productId: state.product!.id),
              child: Builder(builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Product Ratings ",
                          style: GoogleFonts.inter(
                              color: black,
                              fontSize: 2.5 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                              letterSpacing: 0.1),
                        ),
                        BlocBuilder<RatingCubit, RatingState>(
                          builder: (context, state) {
                            return Text(
                              "(${state.productRatings.length})",
                              style: GoogleFonts.inter(
                                  color: Colors.grey[600],
                                  fontSize: 2.2 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                  letterSpacing: 0.1),
                            );
                          },
                        ),
                      ],
                    ),
                    Gap(2 * SizeConfig.heightMultiplier),
                    BlocBuilder<RatingCubit, RatingState>(
                      builder: (context, state) {
                        return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return RatingContainer(
                                rating: state.productRatings[index],
                              );
                            },
                            separatorBuilder: (context, index) => const Divider(
                                  color: Colors.grey,
                                  height: 30,
                                ),
                            itemCount: state.productRatings.length > 3
                                ? 3
                                : state.productRatings.length);
                      },
                    )
                  ],
                );
              }),
            );
          },
        ),
        Gap(3 * SizeConfig.heightMultiplier),
        BlocBuilder<ProductCubit, ProductState>(
          buildWhen: (previous, current) => previous.product != current.product,
          builder: (context, state) {
            return BorderButton(
                height: 6 * SizeConfig.heightMultiplier,
                borderRadius: 30,
                text: Text(
                  "See all ratings",
                  style: GoogleFonts.inter(
                      color: green,
                      fontSize: 1.8 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1),
                ),
                function: () => context.pushNamed(Routes.ratings, extra: {
                      "id": state.product?.id,
                      "sellerId": state.product!.user!.id,
                      "name": state.product!.user!.name,
                    }));
          },
        ),
      ],
    );
  }
}

class RatingContainer extends StatelessWidget {
  const RatingContainer({
    super.key,
    required this.rating,
  });

  final RatingModel rating;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(color: green, shape: BoxShape.circle),
                child: Icon(
                  Icons.add,
                  size: 18,
                  color: white,
                )),
            Gap(1 * SizeConfig.widthMultiplier),
            Text(
              "${rating.user.name.encrypt().toTitleCase()} • ",
              style: GoogleFonts.inter(
                  color: black,
                  fontSize: 1.6 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w600,
                  height: 1.2),
            ),
            Text(
              rating.createdAt.toString().timeAgo(),
              style: GoogleFonts.inter(
                  color: black,
                  fontSize: 1.5 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w600,
                  height: 1.2),
            ),
            const Spacer(),
            Text(
              "Verified Purchase",
              style: GoogleFonts.inter(
                  color: black,
                  fontSize: 1.6 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w600,
                  height: 1.2),
            ),
          ]),
      Gap(2 * SizeConfig.heightMultiplier),
      Text(
        rating.review,
        style: GoogleFonts.inter(
            color: black,
            fontSize: 1.8 * SizeConfig.textMultiplier,
            fontWeight: FontWeight.w500,
            height: 1.2),
      ),
      Gap(1 * SizeConfig.heightMultiplier),
      // generate 5 stars
      Row(
        children: List.generate(5, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              index < rating.rating
                  ? Icons.star
                  : Icons.star_border_purple500_outlined,
              color: green,
              size: 16,
            ),
          );
        }),
      ),
    ]);
  }
}

class ProductImagesSection extends StatelessWidget {
  const ProductImagesSection({
    super.key,
    required PageController pageController,
    required this.id,
  }) : _pageController = pageController;

  final PageController _pageController;
  final String id;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return BlocBuilder<ProductCubit, ProductState>(
      buildWhen: (previous, current) => previous.product != current.product,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<PageCubit, PageState>(
              builder: (context, pstate) {
                return SizedBox(
                  height: height * 0.45,
                  child: PageView.builder(
                      controller: _pageController,
                      allowImplicitScrolling: true,
                      pageSnapping: true,
                      physics: const BouncingScrollPhysics(),
                      // physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (value) {
                        _pageController.jumpToPage(value);
                        context.read<PageCubit>().changePage(page: value);
                      },
                      itemCount: state.product!.image.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            NetworkImageContainer(
                              imageUrl: state.product!.image[index],
                              borderRadius: BorderRadius.zero,
                              height: height,
                              width: width,
                              fit: BoxFit.cover,
                            ),
                            Positioned.fill(
                                bottom: 1.5 * SizeConfig.heightMultiplier,
                                right: 1.5 * SizeConfig.heightMultiplier,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: BlocProvider(
                                    create: (context) => LocalCubit(),
                                    child: Builder(builder: (context) {
                                      return BlocListener<LocalCubit,
                                          LocalState>(
                                        listenWhen: (previous, current) =>
                                            previous.status != current.status,
                                        listener: (context, state) {
                                          if (state.status ==
                                              LocalStatus.success) {
                                            context
                                                .read<ProductCubit>()
                                                .getProduct(id: id);
                                          }
                                        },
                                        child: BlocBuilder<ProductCubit,
                                            ProductState>(
                                          builder: (context, state) {
                                            return GestureDetector(
                                              onTap: () {
                                                var isLiked =
                                                    state.product!.isLiked;
                                                state.products
                                                    .firstWhere((element) =>
                                                        element.id ==
                                                        state.product!.id)
                                                    .copyWith(
                                                        isLiked: !isLiked);
                                                isLiked
                                                    ? context
                                                        .read<LocalCubit>()
                                                        .unLikeProduct(
                                                            id: state
                                                                .product!.id)
                                                    : context
                                                        .read<LocalCubit>()
                                                        .likeProduct(
                                                            id: state
                                                                .product!.id);
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: white,
                                                    shape: BoxShape.circle),
                                                child: Center(
                                                  widthFactor: 1,
                                                  heightFactor: 1,
                                                  child: SvgPicture.asset(
                                                    state.product?.isLiked ??
                                                            false
                                                        ? AppImages
                                                            .favouriteSolid
                                                        : AppImages.favourite,
                                                    height: 3 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    width: 3 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    color: black,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }),
                                  ),
                                ))
                          ],
                        );
                      }),
                );
              },
            ),
            Gap(1 * SizeConfig.widthMultiplier),
            state.product!.image.length == 1
                ? const SizedBox.shrink()
                : BlocBuilder<PageCubit, PageState>(
                    builder: (context, pstate) {
                      return SizedBox(
                        height: height * 0.11,
                        child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.only(
                                    left: index == 0
                                        ? 1.3 * SizeConfig.widthMultiplier
                                        : 0,
                                    right: index == 9
                                        ? 1.3 * SizeConfig.widthMultiplier
                                        : 0,
                                  ),
                                  child: GestureDetector(
                                      onTap: () {
                                        _pageController.jumpToPage(index);
                                        context
                                            .read<PageCubit>()
                                            .changePage(page: index);
                                      },
                                      child: NetworkImageContainer(
                                        imageUrl: state.product!.image[index],
                                        height: height * 0.1,
                                        width: height * 0.11,
                                        fit: BoxFit.cover,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: black,
                                            width: _pageController.page == index
                                                ? 3
                                                : 0),
                                      )),
                                ),
                            separatorBuilder: (context, index) =>
                                Gap(1 * SizeConfig.widthMultiplier),
                            itemCount: state.product!.image.length),
                      );
                    },
                  ),
          ],
        );
      },
    );
  }
}

class ProductAppBar extends StatelessWidget {
  const ProductAppBar({
    super.key,
    required this.id,
    required this.userId,
  });
  final String id;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      surfaceTintColor: white,
      backgroundColor: white,
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
      centerTitle: false,
      title: Text(
        "Item",
        style: GoogleFonts.inter(
            color: black,
            fontSize: 2.3 * SizeConfig.textMultiplier,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1),
      ),
      actions: [
        IconContainer(
          icon: AppImages.search,
          function: () => context.read<NavigationCubit>().changePage(page: 1),
        ),
        Gap(1 * SizeConfig.widthMultiplier),
        BlocBuilder<LocalCubit, LocalState>(
          builder: (context, state) {
            return Stack(
              children: [
                IconContainer(
                    icon: AppImages.cart,
                    function: () => context.pushNamed(Routes.cart)),
                if (state.cartItems.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Color(0xffF4521E),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        state.cartItems.length.toString(),
                        style: GoogleFonts.inter(
                          color: darkGrey,
                          fontSize: 1.3 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        Gap(1 * SizeConfig.widthMultiplier),
        BlocProvider(
          create: (context) => LocalCubit(),
          child: Builder(builder: (context) {
            return BlocListener<LocalCubit, LocalState>(
              listener: (context, state) {
                if (state.status == LocalStatus.updated) {
                  context.read<ProductCubit>().getProduct(id: id);
                }
              },
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  return IconContainer(
                      icon: state.product?.isSaved ?? false
                          ? AppImages.saveSolid
                          : AppImages.save,
                      function: () => state.product!.isSaved
                          ? context
                              .read<LocalCubit>()
                              .unSaveProduct(id: state.product!.id)
                          : context
                              .read<LocalCubit>()
                              .saveProduct(productId: state.product!.id));
                },
              ),
            );
          }),
        ),
        Gap(1 * SizeConfig.widthMultiplier),
        if (userId == supabase.auth.currentUser!.id)
          IconContainer(
              icon: AppImages.edit,
              function: () => context.push('/selling/edit/$id')),
        Gap(1 * SizeConfig.widthMultiplier),
      ],
    );
  }
}

class Ratingbar extends StatelessWidget {
  const Ratingbar({
    super.key,
    required this.title,
    required this.rating,
  });
  final String title;
  final double rating;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
                color: black,
                fontSize: 1.8 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w600,
                height: 1.2),
          ),
          const Spacer(),
          Container(
            height: 0.5 * SizeConfig.heightMultiplier,
            width: width * 0.35,
            decoration: BoxDecoration(
              color: green,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Gap(2 * SizeConfig.widthMultiplier),
          Text(
            rating.toString(),
            style: GoogleFonts.inter(
                color: black,
                fontSize: 1.8 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w600,
                height: 1.2),
          ),
        ],
      ),
    );
  }
}

class MoreLikeThisItems extends StatelessWidget {
  const MoreLikeThisItems({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 0.6 * width,
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                        color: black,
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        letterSpacing: 0.1),
                  ),
                ),
                Text(
                  "Sponsored",
                  style: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 1.8 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: lightGrey,
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(color: black, width: 0.8),
                ),
                child: Row(
                  children: [
                    Text('See all',
                        style: GoogleFonts.quicksand(
                          color: black,
                          fontSize: 1.9 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w600,
                        )),
                    Gap(0.2 * SizeConfig.widthMultiplier),
                    SvgPicture.asset(
                      AppImages.forward,
                      height: 2.5 * SizeConfig.heightMultiplier,
                      width: 2.5 * SizeConfig.heightMultiplier,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Gap(2.5 * SizeConfig.heightMultiplier),
        BlocBuilder<ProductCubit, ProductState>(
          buildWhen: (previous, current) => previous.product != current.product,
          builder: (context, state) {
            return SizedBox(
              height: height * 0.32,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 1 : 0,
                    right: index == (state.products.length - 1) ? 10 : 0,
                  ),
                  child: ProductContainer(
                    product: state.products[index],
                  ),
                ),
                separatorBuilder: (context, index) =>
                    Gap(1.3 * SizeConfig.widthMultiplier),
                itemCount: state.products.length,
              ),
            );
          },
        ),
      ],
    );
  }
}

class RecommendedItems extends StatelessWidget {
  const RecommendedItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<ProductCubit, ProductState>(
      // buildWhen: (previous, current) =>
      //     previous.recommendations != current.recommendations,
      builder: (context, state) {
        return state.status == ProductStatus.loading
            ? const ProductListShimmer()
            : state.products.isEmpty
                ? const ProductListShimmer()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Recommended for you",
                          style: GoogleFonts.inter(
                              color: black,
                              fontSize: 2.2 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.1),
                        ),
                      ),
                      Gap(2.5 * SizeConfig.heightMultiplier),
                      SizedBox(
                        height: height * 0.26,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.only(
                                left: index == 0 ? 10 : 0,
                                right:
                                    index == (state.recommendations.length - 1)
                                        ? 10
                                        : 0,
                              ),
                              child: SizedBox(
                                width: width * 0.41,
                                child: Stack(
                                  children: [
                                    BlocProvider(
                                      create: (context) => LocalCubit(),
                                      child: Builder(builder: (context) {
                                        return BlocListener<LocalCubit,
                                            LocalState>(
                                          listener: (context, state) {
                                            if (state.status ==
                                                LocalStatus.success) {
                                              context
                                                  .read<LocalCubit>()
                                                  .getWatchedProduct();
                                            }
                                          },
                                          child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                foregroundColor: Colors.grey,
                                                backgroundColor:
                                                    Colors.transparent,
                                                side: BorderSide.none,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),
                                              ),
                                              onPressed: () {
                                                context
                                                  ..push(
                                                      '/home/details/${state.recommendations[index].id}',
                                                      extra: {
                                                        'title': state
                                                            .recommendations[
                                                                index]
                                                            .name,
                                                      })
                                                  ..read<LocalCubit>()
                                                      .watchProduct(
                                                          product:
                                                              LocalProductModel(
                                                    id: state
                                                        .recommendations[index]
                                                        .id,
                                                    name: state
                                                        .recommendations[index]
                                                        .name,
                                                    image: state
                                                        .recommendations[index]
                                                        .image[0],
                                                    available: "1",
                                                    userId: supabase
                                                        .auth.currentUser!.id,
                                                    startingPrice: state
                                                        .recommendations[index]
                                                        .price,
                                                  ));
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  NetworkImageContainer(
                                                    imageUrl: state
                                                        .recommendations[index]
                                                        .image[0],
                                                    height: width * 0.37,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    width: width,
                                                  ),
                                                  Gap(1.3 *
                                                      SizeConfig
                                                          .heightMultiplier),
                                                  Text(
                                                    state.recommendations[index]
                                                        .name,
                                                    maxLines: 2,
                                                    style: GoogleFonts.inter(
                                                        color: black,
                                                        fontSize: 1.7 *
                                                            SizeConfig
                                                                .textMultiplier,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1),
                                                  ),
                                                  Gap(0.8 *
                                                      SizeConfig
                                                          .heightMultiplier),
                                                  Text(
                                                    "Ksh ${state.recommendations[index].price}",
                                                    style: GoogleFonts.inter(
                                                        color: black,
                                                        fontSize: 2.2 *
                                                            SizeConfig
                                                                .textMultiplier,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        letterSpacing: 0.2),
                                                  ),
                                                ],
                                              )),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              )),
                          separatorBuilder: (context, index) =>
                              Gap(1.3 * SizeConfig.widthMultiplier),
                          itemCount: state.recommendations.length,
                        ),
                      ),
                    ],
                  );
      },
    );
  }
}
