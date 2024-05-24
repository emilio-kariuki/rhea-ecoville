import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/views/home/widgets/categories_section.dart';
import 'package:ecoville/views/home/widgets/product_container.dart';

import 'widgets/page_search.dart';
import 'widgets/section_title.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

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
              Container(
                padding: const EdgeInsets.all(12),
                decoration:
                    BoxDecoration(color: lightGrey, shape: BoxShape.circle),
                child: SvgPicture.asset(
                  AppImages.notifications,
                  height: 2.8 * SizeConfig.heightMultiplier,
                  width: 2.8 * SizeConfig.heightMultiplier,
                  color: black,
                ),
              ),
              Gap(1 * SizeConfig.widthMultiplier),
              Container(
                padding: const EdgeInsets.all(12),
                decoration:
                    BoxDecoration(color: lightGrey, shape: BoxShape.circle),
                child: SvgPicture.asset(
                  AppImages.cart,
                  height: 2.8 * SizeConfig.heightMultiplier,
                  width: 2.8 * SizeConfig.heightMultiplier,
                  color: black,
                ),
              )
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
              const WatchedItems(),
              const YourDeals(),
              const WatchedItems(),
            ],
          ),
        ),
      ),
    );
  }
}

class RecentItems extends StatelessWidget {
  const RecentItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SectionTitle(
            title: 'Your Recently Viewed Items',
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
                left: index == 0 ? 15 : 0,
                right: index == 4 ? 15 : 0,
              ),
              child: ProductContainer(width: width),
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                left: index == 0 ? 15 : 0,
                right: index == 4 ? 15 : 0,
              ),
              child: ProductContainer(width: width),
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                left: index == 0 ? 15 : 0,
                right: index == 4 ? 15 : 0,
              ),
              child: ProductContainer(width: width),
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
