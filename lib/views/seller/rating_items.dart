import 'package:ecoville/blocs/app/rating_cubit.dart';
import 'package:ecoville/shared/icon_container.dart';
import 'package:ecoville/shared/network_image_container.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/views/home/product_page.dart';

class RatingsItem extends StatelessWidget {
  const RatingsItem(
      {super.key,
      required this.id,
      required this.sellerId,
      required this.name});
  final String id;
  final String sellerId;
  final String name;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          surfaceTintColor: white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(13),
            child: GestureDetector(
              onTap: () => context.pop(),
              child: SvgPicture.asset(
                AppImages.back,
                height: 3 * SizeConfig.heightMultiplier,
                width: 3 * SizeConfig.heightMultiplier,
                color: black,
              ),
            ),
          ),
          title: Text("Ratings",
              style: GoogleFonts.inter(
                fontSize: 2.2 * SizeConfig.textMultiplier,
                color: black,
                fontWeight: FontWeight.w600,
              )),
          actions: [
            IconContainer(
                icon: AppImages.save,
                function: () => context.pushNamed(Routes.cart)),
            Gap(1 * SizeConfig.widthMultiplier),
            IconContainer(
                icon: AppImages.more,
                function: () => context.pushNamed(Routes.cart)),
            Gap(1 * SizeConfig.widthMultiplier),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  NetworkImageContainer(
                    imageUrl: AppImages.defaultImage,
                    height: height * 0.05,
                    width: height * 0.05,
                    isCirlce: true,
                  ),
                  Gap(2 * SizeConfig.widthMultiplier),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.inter(
                            color: black,
                            fontSize: 2.2 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w600,
                            height: 1.2),
                      ),
                      Gap(0.4 * SizeConfig.heightMultiplier),
                      Text(
                        "90% Positive Rating",
                        style: GoogleFonts.inter(
                            color: black,
                            fontSize: 1.8 * SizeConfig.textMultiplier,
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
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: BlocProvider(
            create: (context) =>
                RatingCubit()..getSellerRatings(userId: sellerId),
            child: BlocBuilder<RatingCubit, RatingState>(
              builder: (context, state) {
                return state.status == RatingStatus.loading
                    ? Center(
                        child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(
                              color: black,
                              strokeWidth: 4,
                            )),
                      )
                    : SizedBox(
                        height: height,
                        child: ListView.separated(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return RatingContainer(
                                rating: state.sellerRatings[index],
                              );
                            },
                            separatorBuilder: (context, index) => const Divider(
                                  color: Colors.grey,
                                  height: 30,
                                ),
                            itemCount: state.sellerRatings.length),
                      );
              },
            ),
          ),
        ));
  }
}
