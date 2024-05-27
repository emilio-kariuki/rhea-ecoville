import 'package:ecoville/blocs/app/product_cubit.dart';
import 'package:ecoville/blocs/minimal/navigation_cubit.dart';
import 'package:ecoville/blocs/minimal/page_cubit.dart';
import 'package:ecoville/shared/border_button.dart';
import 'package:ecoville/shared/complete_button.dart';
import 'package:ecoville/shared/icon_container.dart';
import 'package:ecoville/shared/network_image_container.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/views/home/widgets/product_container.dart';
import 'package:ecoville/views/home/widgets/product_shimmer.dart';

class ProductDetailsPage extends StatelessWidget {
  ProductDetailsPage({super.key, required this.id, required this.title});
  final String id;
  final String title;

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<ProductCubit, ProductState>(
      buildWhen: (previous, current) => previous.product != current.product,
      bloc: context.read<ProductCubit>()..getProduct(id: id),
      builder: (context, state) {
        return Scaffold(
            backgroundColor: white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(8 * SizeConfig.heightMultiplier),
              child: const ProductAppBar(),
            ),
            body: SingleChildScrollView(
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
                              height: height,
                              pageController: _pageController,
                              width: width),
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
                                      fontSize: 2.5 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                      height: 1.2),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Emilio Kariuki",
                                          style: GoogleFonts.inter(
                                              color: black,
                                              fontSize:
                                                  2 * SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.w600,
                                              height: 1.2),
                                        ),
                                        Text(
                                          "Seller",
                                          style: GoogleFonts.inter(
                                              color: black,
                                              fontSize:
                                                  2 * SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.w500,
                                              height: 1.2),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    IconContainer(
                                      icon: AppImages.messages,
                                      function: () {},
                                    ),
                                  ],
                                ),
                                Gap(3 * SizeConfig.heightMultiplier),
                                Text(
                                  "Ksh 4,500",
                                  style: GoogleFonts.inter(
                                      color: black,
                                      fontSize: 2.8 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                      height: 1.2),
                                ),
                                Text(
                                  "Nairobi, Kenya",
                                  style: GoogleFonts.inter(
                                      color: black,
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                      height: 1.2),
                                ),
                                Gap(1 * SizeConfig.heightMultiplier),
                                Row(
                                  children: [
                                    Text(
                                      "Condition ",
                                      style: GoogleFonts.inter(
                                          color: Colors.grey,
                                          fontSize:
                                              2 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w600,
                                          height: 1.2),
                                    ),
                                    Gap(10 * SizeConfig.widthMultiplier),
                                    Row(
                                      children: [
                                        Text(
                                          "Used",
                                          style: GoogleFonts.inter(
                                              color: black,
                                              fontSize: 2.5 *
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
                                CompleteButton(
                                    height: 6.5 * SizeConfig.heightMultiplier,
                                    borderRadius: 30,
                                    text: Text(
                                      "Buy it Now",
                                      style: GoogleFonts.inter(
                                          color: white,
                                          fontSize:
                                              2.2 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.1),
                                    ),
                                    function: () {}),
                                Gap(1 * SizeConfig.heightMultiplier),
                                BorderButton(
                                    height: 6.5 * SizeConfig.heightMultiplier,
                                    borderRadius: 30,
                                    text: Text(
                                      "Add to Cart",
                                      style: GoogleFonts.inter(
                                          color: green,
                                          fontSize:
                                              2.2 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.1),
                                    ),
                                    function: () {}),
                                Gap(1 * SizeConfig.heightMultiplier),
                                BorderButton(
                                    height: 6.5 * SizeConfig.heightMultiplier,
                                    borderRadius: 30,
                                    text: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          AppImages.favourite,
                                          height:
                                              3 * SizeConfig.heightMultiplier,
                                          width:
                                              3 * SizeConfig.heightMultiplier,
                                          color: green,
                                        ),
                                        Gap(1 * SizeConfig.widthMultiplier),
                                        Text(
                                          "Add to Wishlist",
                                          style: GoogleFonts.inter(
                                              color: green,
                                              fontSize: 2.2 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.1),
                                        ),
                                      ],
                                    ),
                                    function: () {}),
                                Gap(3 * SizeConfig.heightMultiplier),
                                Text(
                                  "Item Description from the seller ",
                                  style: GoogleFonts.inter(
                                      color: black,
                                      fontSize: 2.5 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w600,
                                      height: 1.2),
                                ),
                                Gap(1 * SizeConfig.heightMultiplier),
                                Row(
                                  children: [
                                    Text(
                                      "See full description",
                                      style: GoogleFonts.inter(
                                          color: black,
                                          fontSize:
                                              1.8 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                          height: 1.2),
                                    ),
                                    const Spacer(),
                                    IconContainer(
                                      icon: AppImages.right,
                                      function: () {},
                                    ),
                                  ],
                                ),
                                Gap(3 * SizeConfig.heightMultiplier),
                                MoreLikeThisItems(
                                  title: "More Like This",
                                ),
                                MoreLikeThisItems(
                                  title: "Similar Customers Also Bought",
                                ),
                                SellerSection(),
                                Gap(4 * SizeConfig.heightMultiplier),
                                MoreLikeThisItems(
                                  title: "Buyers also viewed",
                                ),
                                MoreLikeThisItems(
                                  title: "Sponsored items from this seller",
                                ),
                              ],
                            ),
                          ),
                        ],
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  "Emilio Kariuki",
                  style: GoogleFonts.inter(
                      color: black,
                      fontSize: 2.2 *
                          SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w600,
                      height: 1.2),
                ),
                Gap(0.4 * SizeConfig.heightMultiplier),
                Text(
                  "90% Positive Rating",
                  style: GoogleFonts.inter(
                      color: black,
                      fontSize: 1.8 *
                          SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w500,
                      height: 1.2),
                ),
              ],
            ),
            const Spacer(),
            IconContainer(
              icon: AppImages.favourite,
              function: () {},
            ),
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
            Text(
              "Joined 2 years ago",
              style: GoogleFonts.inter(
                  color: black,
                  fontSize:
                      2 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w500,
                  height: 1.2),
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
                  fontSize:
                      2 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w500,
                  height: 1.2),
            ),
          ],
        ),
        Gap(3 * SizeConfig.heightMultiplier),
        CompleteButton(
            height: 7.5 * SizeConfig.heightMultiplier,
            borderRadius: 30,
            text: Text(
              "Seller's Other Items",
              style: GoogleFonts.inter(
                  color: white,
                  fontSize:
                      2.2 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1),
            ),
            function: () {}),
        Gap(1.5 * SizeConfig.heightMultiplier),
        BorderButton(
            height: 7.5 * SizeConfig.heightMultiplier,
            borderRadius: 30,
            text: Text(
              "Contact Seller",
              style: GoogleFonts.inter(
                  color: green,
                  fontSize:
                      2.2 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1),
            ),
            function: () {}),
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
        const Ratingbar(
          title: "Accurate Description",
          rating: 4.5,
        ),
        const Ratingbar(
          title: "Shipping Speed",
          rating: 4.5,
        ),
        const Ratingbar(
          title: "Communication",
          rating: 4.5,
        ),
        Gap(3 * SizeConfig.heightMultiplier),
        Row(
          children: [
            Text(
              "Seller Ratings ",
              style: GoogleFonts.inter(
                  color: black,
                  fontSize:
                      2.5 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  letterSpacing: 0.1),
            ),
            Text(
              "(120,000)",
              style: GoogleFonts.inter(
                  color: Colors.grey[600],
                  fontSize:
                      2.2 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                  letterSpacing: 0.1),
            ),
          ],
        ),
        Gap(3 * SizeConfig.heightMultiplier),
        BorderButton(
            height: 6.5 * SizeConfig.heightMultiplier,
            borderRadius: 30,
            text: Text(
              "See all ratings",
              style: GoogleFonts.inter(
                  color: green,
                  fontSize:
                      2.2 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1),
            ),
            function: () {}),
      ],
    );
  }
}

class ProductImagesSection extends StatelessWidget {
  const ProductImagesSection({
    super.key,
    required this.height,
    required PageController pageController,
    required this.width,
  }) : _pageController = pageController;

  final double height;
  final PageController _pageController;
  final double width;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
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
                      allowImplicitScrolling: false,
                      // pageSnapping: false,
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
                          ],
                        );
                      }),
                );
              },
            ),
            Gap(1 * SizeConfig.widthMultiplier),
            BlocBuilder<PageCubit, PageState>(
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
  });

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
        IconContainer(
            icon: AppImages.cart,
            function: () => context.pushNamed(Routes.cart)),
        Gap(1 * SizeConfig.widthMultiplier),
        IconContainer(
            icon: AppImages.save,
            function: () => context.pushNamed(Routes.cart)),
        Gap(1 * SizeConfig.widthMultiplier),
        IconContainer(
            icon: AppImages.more,
            function: () => context.pushNamed(Routes.cart)),
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
                fontSize: 2 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w600,
                height: 1.2),
          ),
          const Spacer(),
          Container(
            height: 6.5 * SizeConfig.heightMultiplier,
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
                fontSize: 2.2 * SizeConfig.textMultiplier,
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
