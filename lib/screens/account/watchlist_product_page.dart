import 'package:ecoville/blocs/app/local_cubit.dart';
import 'package:ecoville/shared/icon_container.dart';
import 'package:ecoville/utilities/packages.dart';

import 'widgets/local_product_container.dart';

class WatchlistProductsPage extends StatelessWidget {
  const WatchlistProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocalCubit()..getWatchedProduct()..getCartProducts(),
      child: Scaffold(
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
            "Recently Viewed",
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
                return state.watchedProducts.isEmpty ? SizedBox(
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
                          "Your watchlist is empty",
                          style: GoogleFonts.inter(
                            fontSize: 2.2 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w600,
                            color: black,
                          ),
                        ),
                        Text(
                          "Add products to your watchlist to keep track of them",
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
                ) : StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: state.watchedProducts
                      .map((product) => LocalProductContainer(product: product))
                      .toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
