import 'package:ecoville/utilities/packages.dart';

class ProductPageShimmer extends StatelessWidget {
  const ProductPageShimmer({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[200]!,
          child: AnimatedContainer(
            height: height * 0.45,
            width: width,
            duration: const Duration(milliseconds: 300),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
        Gap(1 * SizeConfig.widthMultiplier),
        SizedBox(
          height: height * 0.11,
          child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 1.3 * SizeConfig.widthMultiplier : 0,
                      right: index == 9 ? 1.3 * SizeConfig.widthMultiplier : 0,
                    ),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[200]!,
                      child: AnimatedContainer(
                        height: height * 0.1,
                        width: height * 0.11,
                        duration: const Duration(milliseconds: 300),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                    ),
                  ),
              separatorBuilder: (context, index) =>
                  Gap(1 * SizeConfig.widthMultiplier),
              itemCount: 10),
        ),
        Gap(2 * SizeConfig.widthMultiplier),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(2 * SizeConfig.heightMultiplier),
              Text(
                title,
                style: GoogleFonts.inter(
                    color: black,
                    fontSize: 2.5 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.bold,
                    height: 1.2),
              ),
              Gap(2 * SizeConfig.heightMultiplier),
              Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[200]!,
                    child: AnimatedContainer(
                      height: height * 0.07,
                      width: height * 0.07,
                      duration: const Duration(milliseconds: 300),
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                    ),
                  ),
                  Gap(2 * SizeConfig.widthMultiplier),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[200]!,
                        child: AnimatedContainer(
                          height: height * 0.015,
                          width: width * 0.4,
                          duration: const Duration(milliseconds: 300),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                      Gap(1 * SizeConfig.widthMultiplier),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[200]!,
                        child: AnimatedContainer(
                          height: height * 0.015,
                          width: width * 0.3,
                          duration: const Duration(milliseconds: 300),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[200]!,
                    child: AnimatedContainer(
                      height: 4 * SizeConfig.heightMultiplier,
                      width: 4 * SizeConfig.heightMultiplier,
                      duration: const Duration(milliseconds: 300),
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
              Gap(3 * SizeConfig.heightMultiplier),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[200]!,
                child: AnimatedContainer(
                  height: height * 0.02,
                  width: width * 0.4,
                  duration: const Duration(milliseconds: 300),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
              ),
              Gap(1 * SizeConfig.heightMultiplier),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[200]!,
                child: AnimatedContainer(
                  height: height * 0.015,
                  width: width * 0.6,
                  duration: const Duration(milliseconds: 300),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
              ),
              Gap(1 * SizeConfig.heightMultiplier),
              Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[200]!,
                    child: AnimatedContainer(
                      height: height * 0.015,
                      width: width * 0.3,
                      duration: const Duration(milliseconds: 300),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  ),
                  Gap(10 * SizeConfig.widthMultiplier),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[200]!,
                    child: AnimatedContainer(
                      height: height * 0.02,
                      width: width * 0.3,
                      duration: const Duration(milliseconds: 300),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  ),
                ],
              ),
              Gap(3 * SizeConfig.heightMultiplier),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[200]!,
                child: AnimatedContainer(
                  height: 7 * SizeConfig.heightMultiplier,
                  width: width,
                  duration: const Duration(milliseconds: 300),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
              ),
              Gap(1 * SizeConfig.heightMultiplier),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[200]!,
                child: AnimatedContainer(
                  height: 7 * SizeConfig.heightMultiplier,
                  width: width,
                  duration: const Duration(milliseconds: 300),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
              ),
              Gap(1 * SizeConfig.heightMultiplier),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[200]!,
                child: AnimatedContainer(
                  height: 7 * SizeConfig.heightMultiplier,
                  width: width,
                  duration: const Duration(milliseconds: 300),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
