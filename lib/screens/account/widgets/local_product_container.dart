import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/shared/network_image_container.dart';
import 'package:ecoville/utilities/packages.dart';

class LocalProductContainer extends StatelessWidget {
  const LocalProductContainer({
    super.key,
    required this.product,
  });

  final LocalProductModel product;

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
                  context.push('/home/details/${product.id}', extra: {
                    'title': product.name,
                  }),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NetworkImageContainer(
                    imageUrl: product.image[0],
                    height: width * 0.37,
                    borderRadius: BorderRadius.circular(15),
                    width: width,
                  ),
                  Gap(1.3 * SizeConfig.heightMultiplier),
                  Text(
                    product.name,
                    maxLines: 2,
                    style: GoogleFonts.inter(
                        color: black,
                        fontSize: 1.9 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w500,
                        height: 1),
                  ),
                  Gap(0.8 * SizeConfig.heightMultiplier),
                  Text(
                    "\$${product.startingPrice}",
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
