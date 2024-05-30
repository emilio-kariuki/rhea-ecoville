import 'package:ecoville/blocs/app/local_cubit.dart';
import 'package:ecoville/blocs/minimal/navigation_cubit.dart';
import 'package:ecoville/shared/icon_container.dart';
import 'package:ecoville/utilities/packages.dart';

import 'widgets/local_product_container.dart';

class SavedProductsPage extends StatelessWidget {
  const SavedProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocalCubit()..getSavedProduct(),
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
            "Saved",
            style: GoogleFonts.inter(
                fontSize: 2.2 * SizeConfig.heightMultiplier,
                fontWeight: FontWeight.w600,
                color: black),
          ),
          actions: [
            IconContainer(icon: AppImages.search, function: () {}),
            Gap(1 * SizeConfig.widthMultiplier),
            IconContainer(
                icon: AppImages.cart,
                function: () =>
                    context.read<NavigationCubit>().changePage(page: 1)),
            Gap(1 * SizeConfig.widthMultiplier),
            IconContainer(
                icon: AppImages.more,
                function: () => context.push(Routes.cart)),
            Gap(1 * SizeConfig.widthMultiplier),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: BlocBuilder<LocalCubit, LocalState>(
              builder: (context, state) {
                return StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: state.savedProducts
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
