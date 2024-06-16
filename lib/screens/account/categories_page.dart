import 'package:ecoville/blocs/app/product_cubit.dart';
import 'package:ecoville/shared/network_image_container.dart';
import 'package:ecoville/utilities/packages.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            "Categories",
            style: GoogleFonts.inter(
                fontSize: 2.2 * SizeConfig.heightMultiplier,
                fontWeight: FontWeight.w600,
                color: black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: BlocProvider(
            create: (context) => ProductCubit()..getCategories(),
            child: Builder(builder: (context) {
              return BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  return state.status == ProductStatus.loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : GridView.builder(
                          itemCount: state.categories.length,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.8),
                          itemBuilder: (context, index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                NetworkImageContainer(
                                    imageUrl: state.categories[index].image,
                                    height: size.width * 0.5,
                                    width: size.width,
                                    borderRadius: BorderRadius.circular(15),
                                    ),
                                Gap(1 * SizeConfig.heightMultiplier),
                                Text(
                                  state.categories[index].name,
                                  style: GoogleFonts.inter(
                                      color: black,
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            );
                          });
                },
              );
            }),
          ),
        ));
  }
}
