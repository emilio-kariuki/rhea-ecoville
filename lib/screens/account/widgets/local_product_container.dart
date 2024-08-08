import 'package:ecoville/shared/network_image_container.dart';
import 'package:ecoville/utilities/packages.dart';

class LocalProductContainer extends StatelessWidget {
  const LocalProductContainer({
    super.key,
    required this.productId, required this.image, required this.name,
    required this.price,
  });

  final String productId;
  final String image;
  final String name;
  final dynamic price;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.4,
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
              onPressed: () =>
                  context.push('/home/details/${productId}', extra: {
                    'title': name,
                  }),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NetworkImageContainer(
                    imageUrl: image[0],
                    height: width * 0.37,
                    borderRadius: BorderRadius.circular(15),
                    width: width,
                  ),
                  Gap(1.3 * SizeConfig.heightMultiplier),
                  Text(
                    name,
                    maxLines: 2,
                    style: GoogleFonts.inter(
                        color: black,
                        fontSize: 1.9 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w500,
                        height: 1.2),
                  ),
                  Gap(0.8 * SizeConfig.heightMultiplier),
                  Text(
                    "\$${price}",
                    style: GoogleFonts.inter(
                        color: black,
                        fontSize: 2.2 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
