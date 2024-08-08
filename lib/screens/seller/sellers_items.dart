import 'package:ecoville/blocs/app/local_cubit.dart';
import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/models/product_model.dart';
import 'package:ecoville/shared/network_image_container.dart';
import 'package:ecoville/utilities/packages.dart';

import '../../blocs/app/product_cubit.dart';

class SellersItems extends StatelessWidget {
  const SellersItems({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => ProductCubit()..getSellerProducts(sellerId: id),
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: white,
          surfaceTintColor: white,
          leading: Padding(
            padding: const EdgeInsets.all(13),
            child: GestureDetector(
                onTap: () => context.pop(),
                child: SvgPicture.asset(
                  AppImages.back,
                  color: black,
                  height: 2.5 * SizeConfig.heightMultiplier,
                )),
          ),
          centerTitle: false,
          title: Text(
            "Sellers Items ",
            style: GoogleFonts.inter(
                color: black,
                fontSize: 2.3 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: BlocBuilder<ProductCubit, ProductState>(
            buildWhen: (previous, current) =>
                previous.sellerProducts != current.sellerProducts,
            builder: (context, state) {
              if (state.status == ProductStatus.loading) {
                return SizedBox(
                  height: 80 * SizeConfig.heightMultiplier,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return state.sellerProducts.isEmpty
                    ? SizedBox(
                        height: 80 * SizeConfig.heightMultiplier,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppImages.watch,
                                height: 20 * SizeConfig.heightMultiplier,
                              ),
                              Gap(1 * SizeConfig.heightMultiplier),
                              Text(
                                "Sellers Results are empty",
                                style: GoogleFonts.inter(
                                  fontSize: 2.2 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.w600,
                                  color: black,
                                ),
                              ),
                              Text(
                                "Search for another seller instead",
                                style: GoogleFonts.inter(
                                  fontSize: 1.6 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.w400,
                                  color: darkGrey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          return SellerContainer(
                              size: size, product: state.sellerProducts[index]);
                        },
                        separatorBuilder: (context, index) => Divider(
                              color: Colors.grey[300],
                              thickness: 0.4,
                              height: 30,
                            ),
                        itemCount: state.sellerProducts.length);
              }
            },
          ),
        ),
      ),
    );
  }
}

class SellerContainer extends StatelessWidget {
  const SellerContainer({
    super.key,
    required this.size,
    required this.product,
  });

  final Size size;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      key: UniqueKey(),
      onPressed: () {
        debugPrint("Product id: ${product.id}");
        context
          ..push('/home/details/${product.id}', extra: {
            'title': product.name,
          })
          ..read<LocalCubit>().watchProduct(
              product: LocalProductModel(
                  id: product.id,
                  name: product.name,
                  image: product.image[0],
                  userId: product.userId!,
                  startingPrice: product.price!));
      },
      style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: white,
          foregroundColor: Colors.grey,
          side: BorderSide.none,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkImageContainer(
            imageUrl: product.image[0],
            height: size.width * 0.3,
            borderRadius: BorderRadius.circular(15),
            width: size.width * 0.3,
          ),
          Gap(2 * SizeConfig.heightMultiplier),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * 0.4,
                child: Text(
                  product.name,
                  style: GoogleFonts.inter(
                      fontSize: 1.6 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                      color: black),
                ),
              ),
              Gap(0.5 * SizeConfig.heightMultiplier),
              Text(
                "condition: ${product.condition}",
                style: GoogleFonts.inter(
                    fontSize: 1.4 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500]),
              ),
              Text(
                "\$${(product.price!).toStringAsFixed(2)}",
                style: GoogleFonts.inter(
                    fontSize: 1.8 * SizeConfig.heightMultiplier,
                    fontWeight: FontWeight.w700,
                    color: black),
              )
            ],
          ),
        ],
      ),
    );
  }
}
