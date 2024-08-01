import 'package:ecoville/blocs/app/local_cubit.dart';
import 'package:ecoville/blocs/app/product_cubit.dart';
import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/shared/icon_container.dart';
import 'package:ecoville/shared/network_image_container.dart';
import 'package:ecoville/utilities/packages.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({super.key, required this.controller});

  // final String search;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
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
        title: SizedBox(
          height: 35,
          child: OutlinedButton(
            onPressed: () {
              context.pop();
            },
            style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: white,
                foregroundColor: Colors.grey,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  controller.text,
                  overflow: TextOverflow.ellipsis ,
                  maxLines: 1,
                  style: GoogleFonts.inter(
                      fontSize: 2.2 * SizeConfig.heightMultiplier,
                      fontWeight: FontWeight.w600,
                      color: black),
                ),
              ],
            ),
          ),
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
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<ProductCubit, ProductState>(
          bloc: context.read<ProductCubit>()
            ..getSearchResults(query: controller.text),
          buildWhen: (previous, current) =>
              previous.searchResults != current.searchResults,
          builder: (context, state) {
            if (state.status == ProductStatus.loading) {
              return SizedBox(
                height: 80 * SizeConfig.heightMultiplier,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return state.searchResults.isEmpty? SizedBox(
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
                          "Your Results are empty",
                          style: GoogleFonts.inter(
                            fontSize: 2.2 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w600,
                            color: black,
                          ),
                        ),
                        Text(
                          "Search for another product instead",
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
                ) : ListView.separated(
                  itemBuilder: (context, index) {
                    return OutlinedButton(
                      onPressed: () => context
                        ..push('/home/details/${state.searchResults[index].id}',
                            extra: {
                              'title': state.searchResults[index].name,
                            })
                        ..read<LocalCubit>().watchProduct(
                            product: LocalProductModel(
                                id: state.searchResults[index].id,
                                name: state.searchResults[index].name,
                                image: state.searchResults[index].image[0],
                                userId: state.searchResults[index].userId!,
                                startingPrice:
                                    state.searchResults[index].price!)),
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: white,
                          foregroundColor: Colors.grey,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NetworkImageContainer(
                            imageUrl: state.searchResults[index].image[0],
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
                                  state.searchResults[index].name,
                                  style: GoogleFonts.inter(
                                      fontSize: 1.6 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w600,
                                      height: 1.1,
                                      color: black),
                                ),
                              ),
                              Gap(0.5 * SizeConfig.heightMultiplier),
                              Text(
                                "condition: ${state.searchResults[index].condition}",
                                style: GoogleFonts.inter(
                                    fontSize: 1.4 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[500]),
                              ),
                              Text(
                                "\$${(state.searchResults[index].price!).toStringAsFixed(2)}",
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
                  },
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.grey[300],
                        thickness: 0.4,
                        height: 30,
                      ),
                  itemCount: state.searchResults.length);
            }
          },
        ),
      ),
    );
  }
}
