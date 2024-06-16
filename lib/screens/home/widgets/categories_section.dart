import 'package:ecoville/utilities/packages.dart';

class CategoriesSection extends StatelessWidget {
  CategoriesSection({
    super.key,
  });

  final List<Map<String, dynamic>> categories = [
    {'name': "Categories", "icon": AppImages.category, "page": Routes.categories},
    {'name': "Deals", "icon": AppImages.flash, "page": ""},
    {'name': "Saved", "icon": AppImages.favourite, "page": Routes.saved},
    {'name': "Wishlist", "icon": AppImages.wishlist, "page":Routes.wishlist},
    {'name': "Bids", "icon": AppImages.bids, "page": ""},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4 * SizeConfig.heightMultiplier,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? 15 : 0,
            right: index == 4 ? 15 : 0,
          ),
          child: GestureDetector(
            onTap: () => context.push(categories[index]['page']),
            child: Container(
              decoration: BoxDecoration(
                color: lightGrey,
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: black, width: 0.8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        categories[index]['icon'],
                        height: 2 * SizeConfig.heightMultiplier,
                        width: 2 * SizeConfig.heightMultiplier,
                      ),
                      Gap(1 * SizeConfig.widthMultiplier),
                      Text(
                        categories[index]['name'],
                        style: GoogleFonts.quicksand(
                          color: black,
                          fontSize: 1.6 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        separatorBuilder: (context, index) =>
            Gap(1 * SizeConfig.widthMultiplier),
        itemCount: categories.length,
      ),
    );
  }
}
