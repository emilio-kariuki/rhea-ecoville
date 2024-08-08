
import 'package:ecoville/blocs/app/local_cubit.dart';
import 'package:ecoville/blocs/app/product_cubit.dart';
import 'package:ecoville/blocs/minimal/navigation_cubit.dart';
import 'package:ecoville/data/repository/socket_repository.dart';
import 'package:ecoville/screens/account/widgets/local_product_container.dart';
import 'package:ecoville/shared/icon_container.dart';
import 'package:ecoville/shared/network_image_container.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/screens/home/widgets/categories_section.dart';
import 'package:ecoville/screens/home/widgets/product_container.dart';
import 'package:ecoville/screens/home/widgets/product_list_shimmer.dart';

import 'widgets/page_search.dart';
import 'widgets/section_title.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // socket.onConnect((data) {
    //   socket.on('update', (data) {
    //     debugPrint('message received ' + data);
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    // socket.on('product', (data) {
    //   debugPrint('message received ' + data);
    //   context.read<ProductCubit>().getProducts();
    // });
    return Scaffold(
      backgroundColor: white,
      floatingActionButton: FloatingActionButton(
        tooltip: "View Map",
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        onPressed: () => context.pushNamed(Routes.map),
        backgroundColor: green,
        child: SvgPicture.asset(
          AppImages.map,
          color: white,
          height: 2.5 * SizeConfig.heightMultiplier,
          width: 2.5 * SizeConfig.heightMultiplier,
        ),
      ),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: primary,
          surfaceTintColor: white,
          title: Row(
            children: [
              SvgPicture.asset(
                AppImages.ecovilleName,
                height: 4 * SizeConfig.heightMultiplier,
                width: 4 * SizeConfig.heightMultiplier,
              ),
              const Spacer(),
              // IconContainer(
              //   icon: AppImages.messages,
              //   function: () => context.pushNamed(Routes.messages),
              // ),
              Gap(1 * SizeConfig.widthMultiplier),
              IconContainer(
                icon: AppImages.notifications,
                function: () =>
                    context.read<NavigationCubit>().changePage(page: 3),
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
            ],
          ),
          bottom: const PreferredSize(
              preferredSize: Size.fromHeight(90), child: MainPageSearch())),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        backgroundColor: white,
        color: green,
        onRefresh: () async {
          context
            ..read<ProductCubit>().getProducts()
            ..read<ProductCubit>().getNearbyProducts()
            ..read<LocalCubit>().getWatchedProduct()
            ..read<LocalCubit>().getCartProducts();
          return Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                CategoriesSection(),
                Gap(3 * SizeConfig.heightMultiplier),
                const RecentItems(),
                const BiddingItems(),
                const WatchedItems(),
                const NearbyItems(),
                const EcovilleCategories(),
                // const WatchedItems(),
                // const YourDeals(),
                // const RecommendedItems()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NearbyItems extends StatelessWidget {
  const NearbyItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocBuilder<ProductCubit, ProductState>(
      buildWhen: (previous, current) =>
          previous.productsNearby != current.productsNearby,
      builder: (context, state) {
        return state.status == ProductStatus.loading
            ? const ProductListShimmer()
            : state.productsNearby.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SectionTitle(
                          title: 'Your Products Nearby',
                          onTap: () {},
                        ),
                      ),
                      Gap(2.5 * SizeConfig.heightMultiplier),
                      SizedBox(
                        height: height * 0.25,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.only(
                              left: index == 0 ? 10 : 0,
                              right: index == (state.productsNearby.length - 1)
                                  ? 10
                                  : 0,
                            ),
                            child: ProductContainer(
                              product: state.productsNearby[index],
                            ),
                          ),
                          separatorBuilder: (context, index) =>
                              Gap(1.3 * SizeConfig.widthMultiplier),
                          itemCount: state.productsNearby.length,
                        ),
                      ),
                    ],
                  );
      },
    );
  }
}

class RecentItems extends StatelessWidget {
  const RecentItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocBuilder<ProductCubit, ProductState>(
      buildWhen: (previous, current) => previous.products != current.products,
      builder: (context, state) {
        return state.status == ProductStatus.loading
            ? const ProductListShimmer()
            : state.products.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SectionTitle(
                          title: 'Recently Added Items',
                          onTap: () {},
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
                                  index == (state.products.length - 1) ? 10 : 0,
                            ),
                            child: ProductContainer(
                              key: UniqueKey(),
                              product: state.products[index],
                            ),
                          ),
                          separatorBuilder: (context, index) =>
                              Gap(1.3 * SizeConfig.widthMultiplier),
                          itemCount: state.products.length,
                        ),
                      ),
                    ],
                  );
      },
    );
  }
}


class BiddingItems extends StatelessWidget {
  const BiddingItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocBuilder<ProductCubit, ProductState>(
      buildWhen: (previous, current) => previous.biddingProducts != current.biddingProducts,
      builder: (context, state) {
        return state.status == ProductStatus.loading
            ? const ProductListShimmer()
            : state.biddingProducts.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SectionTitle(
                          title: 'Bidding Items',
                          onTap: () {},
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
                                  index == (state.biddingProducts.length - 1) ? 10 : 0,
                            ),
                            child: ProductContainer(
                              key: UniqueKey(),
                              product: state.biddingProducts[index],
                            ),
                          ),
                          separatorBuilder: (context, index) =>
                              Gap(1.3 * SizeConfig.widthMultiplier),
                          itemCount: state.biddingProducts.length,
                        ),
                      ),
                    ],
                  );
      },
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

    return BlocBuilder<ProductCubit, ProductState>(
      buildWhen: (previous, current) =>
          previous.similarProducts != current.similarProducts,
      builder: (context, state) {
        return state.status == ProductStatus.loading
            ? const ProductListShimmer()
            : state.similarProducts.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SectionTitle(
                          title: 'Recommended Items',
                          onTap: () {},
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
                              right: index == (state.similarProducts.length - 1)
                                  ? 10
                                  : 0,
                            ),
                            child: ProductContainer(
                              key: UniqueKey(),
                              product: state.similarProducts[index],
                            ),
                          ),
                          separatorBuilder: (context, index) =>
                              Gap(1.3 * SizeConfig.widthMultiplier),
                          itemCount: state.similarProducts.length,
                        ),
                      ),
                    ],
                  );
      },
    );
  }
}

class WatchedItems extends StatelessWidget {
  const WatchedItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<LocalCubit, LocalState>(
      buildWhen: (previous, current) =>
          previous.watchedProducts != current.watchedProducts,
      builder: (context, state) {
        return state.status == ProductStatus.loading
            ? const ProductListShimmer()
            : state.watchedProducts.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SectionTitle(
                          title: 'Your Watched Products',
                          onTap: () {},
                        ),
                      ),
                      Gap(2.5 * SizeConfig.heightMultiplier),
                      SizedBox(
                        height: height * 0.27,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.only(
                              left: index == 0 ? 10 : 0,
                              right: index == (state.watchedProducts.length - 1)
                                  ? 10
                                  : 0,
                            ),
                            child: LocalProductContainer(
                              productId: state.watchedProducts[index].id,
                                image: state.watchedProducts[index].image[0],
                                name: state.watchedProducts[index].name,
                                price: state.watchedProducts[index].startingPrice,
                            ),
                          ),
                          separatorBuilder: (context, index) =>
                              Gap(1.3 * SizeConfig.widthMultiplier),
                          itemCount: state.watchedProducts.length,
                        ),
                      ),
                    ],
                  );
      },
    );
  }
}

class EcovilleCategories extends StatelessWidget {
  const EcovilleCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Text(
                'Ecoville Categories',
                style: GoogleFonts.inter(
                    color: black,
                    fontSize: 2 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1),
              ),
              const Spacer(),
            ],
          ),
        ),
        Gap(0.5 * SizeConfig.heightMultiplier),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: BlocProvider(
            create: (context) => ProductCubit()..getCategories(),
            child: Builder(builder: (context) {
              return BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  return state.status == ProductStatus.loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : GridView.builder(
                          itemCount: state.categories.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.9),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: ()=>context.push(Routes.searchResults,
                          extra: {'controller': TextEditingController(text: "&&category=${state.categories[index].id}")}),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  NetworkImageContainer(
                                    imageUrl: state.categories[index].image,
                                    isCirlce: true,
                                    height: size.width * 0.23,
                                    width: size.width,
                                  ),
                                  Gap(0.3 * SizeConfig.heightMultiplier),
                                  Text(
                                    state.categories[index].name,
                                    style: GoogleFonts.inter(
                                        color: black,
                                        fontSize: 1.5 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            );
                          });
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}
