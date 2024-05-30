import 'package:ecoville/blocs/minimal/navigation_cubit.dart';
import 'package:ecoville/shared/icon_container.dart';
import 'package:ecoville/utilities/packages.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        surfaceTintColor: white,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          "Notifications",
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
              icon: AppImages.more, function: () => context.push(Routes.cart)),
          Gap(1 * SizeConfig.widthMultiplier),
        ],
      ),
      body: Center(
          child: EmptyNotifications()),
    );
  }
}

class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
    SvgPicture.asset(
      AppImages.notificationSolid,
      height: 15 * SizeConfig.heightMultiplier,
      width: 15 * SizeConfig.heightMultiplier,
    ),
    Text(
      "You're all caught up!",
      style: GoogleFonts.inter(
          fontSize: 2.2 * SizeConfig.textMultiplier,
          fontWeight: FontWeight.w600,
          color: black),
    )
            ],
          );
  }
}
