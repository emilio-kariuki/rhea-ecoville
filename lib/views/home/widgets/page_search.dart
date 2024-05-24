import 'package:ecoville/blocs/minimal/navigation_cubit.dart';
import 'package:ecoville/utilities/packages.dart';

class MainPageSearch extends StatelessWidget {
  const MainPageSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<NavigationCubit>().changePage(page: 1),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 19),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              AppImages.search,
              height: 2.7 * SizeConfig.heightMultiplier,
              width: 2.7 * SizeConfig.heightMultiplier,
            ),
            Gap(1 * SizeConfig.widthMultiplier),
            Text(
              'Search on ecoville',
              style: GoogleFonts.notoSans(
                color: black,
                fontSize: 1.9 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
