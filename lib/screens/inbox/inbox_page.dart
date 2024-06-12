import 'package:ecoville/blocs/app/local_cubit.dart';
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
