import 'package:ecoville/utilities/packages.dart';

class ProductListShimmer extends StatelessWidget {
  const ProductListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * 0.32,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 10 : 0,
              right: index == 4 ? 10 : 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: width * 0.41,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: width * 0.4,
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                Gap(1.3 * SizeConfig.heightMultiplier),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[200]!,
                  child: AnimatedContainer(
                    height: height * 0.015,
                    width: width * 0.4,
                    duration: const Duration(milliseconds: 300),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                  ),
                ),
                Gap(0.3 * SizeConfig.heightMultiplier),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[200]!,
                  child: AnimatedContainer(
                    height: height * 0.015,
                    width: width * 0.4,
                    duration: const Duration(milliseconds: 300),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                  ),
                ),
                Gap(0.8 * SizeConfig.heightMultiplier),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[200]!,
                  child: AnimatedContainer(
                    height: height * 0.025,
                    width: width * 0.2,
                    duration: const Duration(milliseconds: 300),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: 10,
        separatorBuilder: (context, index) =>
            Gap(1.3 * SizeConfig.widthMultiplier),
      ),
    );
  }
}
