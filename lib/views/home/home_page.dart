import 'package:ecoville/blocs/app/product_cubit.dart';
import 'package:ecoville/blocs/minimal/navigation_cubit.dart';
import 'package:ecoville/shared/icon_container.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/views/home/widgets/categories_section.dart';
import 'package:ecoville/views/home/widgets/product_container.dart';
import 'package:ecoville/views/home/widgets/product_list_shimmer.dart';

import 'widgets/page_search.dart';
import 'widgets/section_title.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
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
                icon: AppImages.notifications,
                function: () =>
                    context.read<NavigationCubit>().changePage(page: 3),
              ),
              Gap(1 * SizeConfig.widthMultiplier),
              IconContainer(
                  icon: AppImages.cart,
                  function: () => context.pushNamed(Routes.cart)),
            ],
          ),
          bottom: const PreferredSize(
              preferredSize: Size.fromHeight(90), child: MainPageSearch())),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              CategoriesSection(),
              Gap(3.5 * SizeConfig.heightMultiplier),
              const RecentItems(),
              const NearbyItems()
              // const WatchedItems(),
              // const YourDeals(),
              // const WatchedItems(),
              // const RecommendedItems()
            ],
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SectionTitle(
            title: 'Your Products Nearby',
            onTap: () {},
          ),
        ),
        Gap(2.5 * SizeConfig.heightMultiplier),
        BlocBuilder<ProductCubit, ProductState>(
          buildWhen: (previous, current) =>
              previous.productsNearby != current.productsNearby,
          builder: (context, state) {
            return state.status == ProductStatus.loading
                ? const ProductListShimmer()
                : SizedBox(
                    height: height * 0.32,
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
                  );
          },
        ),
      ],
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SectionTitle(
            title: 'Your Recently Viewed Items',
            onTap: () {},
          ),
        ),
        Gap(2.5 * SizeConfig.heightMultiplier),
        BlocBuilder<ProductCubit, ProductState>(
          buildWhen: (previous, current) =>
              previous.products != current.products,
          builder: (context, state) {
            return state.status == ProductStatus.loading
                ? const ProductListShimmer()
                : SizedBox(
                    height: height * 0.32,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 10 : 0,
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SectionTitle(
            title: 'Your Watched Items',
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
