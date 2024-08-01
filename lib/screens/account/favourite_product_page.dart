import 'package:ecoville/blocs/app/local_cubit.dart';
import 'package:ecoville/shared/icon_container.dart';
import 'package:ecoville/utilities/packages.dart';

import 'widgets/local_product_container.dart';

class LikedProductsPage extends StatelessWidget {
  const LikedProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocalCubit()..getLikedProducts()..getCartProducts(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: white,
              surfaceTintColor: white,
              automaticallyImplyLeading: false,
              centerTitle: false,
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
              title: Text(
                "Likes",
                style: GoogleFonts.inter(
                    fontSize: 2.2 * SizeConfig.heightMultiplier,
                    fontWeight: FontWeight.w600,
                    color: black),
              ),
              actions: [
                IconContainer(icon: AppImages.search, function: () {}),
                Gap(1 * SizeConfig.widthMultiplier),
                  BlocBuilder<LocalCubit, LocalState>(
            
                    builder: (context, state) {
                      return Stack(
                        children: [
                          IconContainer(
                              icon: AppImages.cart,
                              function: () => context.pushNamed(Routes.cart)),
                          if (state.cartItems.isNotEmpty)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  color: Color(0xffF4521E),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  state.cartItems.length.toString(),
                                  style: GoogleFonts.inter(
                                    color: darkGrey,
                                    fontSize: 1.3 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
               
                Gap(1 * SizeConfig.widthMultiplier),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: BlocBuilder<LocalCubit, LocalState>(
                  builder: (context, state) {
                    return state.likedProducts.isEmpty? SizedBox(
                      height: 80 * SizeConfig.heightMultiplier,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppImages.favourite,
                              height: 20 * SizeConfig.heightMultiplier,
                            ),
                            Gap(1 * SizeConfig.heightMultiplier),
                            Text(
                              "No liked products",
                              style: GoogleFonts.inter(
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                                fontWeight: FontWeight.w600,
                                color: black,
                              ),
                            ),
                            Text(
                                    "You have not liked any products yet. \n",
                                    style: GoogleFonts.inter(
                                      fontSize: 1.8 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w400,
                                      color: darkGrey,
                                    ),
                                  ),
                          ],
                        ),
                      
                      ),
                    ) :StaggeredGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: state.likedProducts
                          .map((product) => LocalProductContainer(
                                productId: product.id,
                                image: product.product.image[0],
                                name: product.product.name,
                                price: product.product.price.toInt(),
                          ))
                          .toList(),
                    );
                  },
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
