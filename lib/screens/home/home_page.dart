import 'package:ecoville/blocs/app/local_cubit.dart';
import 'package:ecoville/blocs/app/product_cubit.dart';
import 'package:ecoville/blocs/minimal/navigation_cubit.dart';
import 'package:ecoville/screens/account/widgets/local_product_container.dart';
import 'package:ecoville/shared/icon_container.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      floatingActionButton: FloatingActionButton(
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
              IconContainer(
                icon: AppImages.messages,
                function: () => context.pushNamed(Routes.messages),
              ),
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
            ..read<LocalCubit>().getWatchedProduct();
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
                const NearbyItems(),
                const WatchedItems(),
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
                          title: 'Your Recently Viewed Items',
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

class RecommendedItems extends StatelessWidget {
  const RecommendedItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Column(
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
          height: height * 0.32,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 10 : 0,
                right: index == 4 ? 10 : 0,
              ),
              child: Container(),
            ),
            separatorBuilder: (context, index) =>
                Gap(1.3 * SizeConfig.widthMultiplier),
            itemCount: 5,
          ),
        ),
      ],
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
                              product: state.watchedProducts[index],
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

class YourDeals extends StatelessWidget {
  const YourDeals({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SectionTitle(
            title: 'Your Deals',
            onTap: () {},
          ),
        ),
        Gap(2.5 * SizeConfig.heightMultiplier),
        SizedBox(
          height: height * 0.32,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 10 : 0,
                right: index == 4 ? 10 : 0,
              ),
              child: Container(),
            ),
            separatorBuilder: (context, index) =>
                Gap(1.3 * SizeConfig.widthMultiplier),
            itemCount: 5,
          ),
        ),
      ],
    );
  }
}
