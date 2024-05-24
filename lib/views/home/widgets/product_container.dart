
import 'package:ecoville/shared/network_image_container.dart';
import 'package:ecoville/utilities/packages.dart';

class ProductContainer extends StatelessWidget {
  const ProductContainer({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 0.435,
      child: Stack(
        children: [
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: Colors.grey,
                backgroundColor: Colors.transparent,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              onPressed: () => context.push('/details'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NetworkImageContainer(
                    imageUrl: AppImages.defaultImage,
                    height:  width * 0.435,
                    borderRadius: BorderRadius.circular(20),
                    width: width,
                  ),
                  Gap(1.3 * SizeConfig.heightMultiplier),
                  Text(
                    'Plastic Bottle, 1L - 12 pieces pack',
                    maxLines: 2,
                    style: GoogleFonts.inter(
                        color: black,
                        fontSize: 2 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w500,
                        height: 1),
                  ),
                  Gap(0.8 * SizeConfig.heightMultiplier),
                  Text(
                    '\$1000',
                    style: GoogleFonts.inter(
                        color: black,
                        fontSize: 2.2 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2),
                  ),
                ],
              )),
               Positioned.fill(
                      top: 1.5 * SizeConfig.heightMultiplier,
                      right: 1.5 * SizeConfig.heightMultiplier,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: white, shape: BoxShape.circle),
                          child: Center(
                            widthFactor: 1,
                            heightFactor: 1,
                            child: SvgPicture.asset(
                              AppImages.favourite,
                              height: 3 * SizeConfig.heightMultiplier,
                              width: 3 * SizeConfig.heightMultiplier,
                              color: black,
                            ),
                          ),
                        ),
                      ))
        ],
      ),
    );
  }
}