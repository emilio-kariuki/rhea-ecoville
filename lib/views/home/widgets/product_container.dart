import 'package:ecoville/blocs/app/local_cubit.dart';
import 'package:ecoville/blocs/app/product_cubit.dart';
import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/models/product_model.dart';
import 'package:ecoville/shared/network_image_container.dart';
import 'package:ecoville/utilities/packages.dart';

class ProductContainer extends StatelessWidget {
  const ProductContainer({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.41,
      child: Stack(
        children: [
          BlocProvider(
            create: (context) => LocalCubit(),
            child: Builder(
              builder: (context) {
                return OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: Colors.grey,
                      backgroundColor: Colors.transparent,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () {
                      context
                        ..push('/home/details/${product.id}', extra: {
                          'title': product.name,
                        })
                        ..read<LocalCubit>().watchProduct(
                            product: LocalProductModel(
                                id: product.id,
                                name: product.name,
                                image: product.image[0],
                                userId: product.userId,
                                startingPrice: product.startingPrice));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NetworkImageContainer(
                          imageUrl: product.image[0],
                          height: width * 0.4,
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
                    ));
              }
            ),
          ),
          Positioned.fill(
              top: 1.5 * SizeConfig.heightMultiplier,
              right: 1.5 * SizeConfig.heightMultiplier,
              child: Align(
                alignment: Alignment.topRight,
                child: BlocProvider(
                  create: (context) => LocalCubit(),
                  child: Builder(builder: (context) {
                    return BlocListener<LocalCubit, LocalState>(
                      listener: (context, state) {
                        if (state.status == LocalStatus.success) {
                          context..read<ProductCubit>().getProducts()..read<ProductCubit>().getNearbyProducts();
                        }
                      },
                      child: GestureDetector(
                        onTap: () => product.favourite
                            ? context
                                .read<LocalCubit>()
                                .unLikeProduct(id: product.id)
                            : context.read<LocalCubit>().likeProduct(
                                product: LocalProductModel(
                                    id: product.id,
                                    name: product.name,
                                    image: product.image[0],
                                    userId: product.userId,
                                    startingPrice: product.startingPrice)),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: white, shape: BoxShape.circle),
                          child: Center(
                            widthFactor: 1,
                            heightFactor: 1,
                            child: SvgPicture.asset(
                              product.favourite
                                  ? AppImages.favouriteSolid
                                  : AppImages.favourite,
                              height: 3 * SizeConfig.heightMultiplier,
                              width: 3 * SizeConfig.heightMultiplier,
                              color: black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ))
        ],
      ),
    );
  }
}
