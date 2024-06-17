import 'package:ecoville/blocs/app/app_cubit.dart';
import 'package:ecoville/blocs/app/auth_cubit.dart';
import 'package:ecoville/utilities/packages.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
            "Settings",
            style: GoogleFonts.inter(
                fontSize: 2.2 * SizeConfig.heightMultiplier,
                fontWeight: FontWeight.w600,
                color: black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: BlocProvider(
            create: (context) => AppCubit(),
            child: Builder(
              builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account",
                      style: GoogleFonts.inter(
                          fontSize: 1.5 * SizeConfig.heightMultiplier,
                          fontWeight: FontWeight.w600,
                          color: green),
                    ),
                    Gap(1 * SizeConfig.heightMultiplier),
                    SettingsTile(
                      title: "Shipping Address",
                      function: () => context.pushNamed(Routes.address),
                    ),
                    // SettingsTile(
                    //   title: "Change Password",
                    //   function: () {},
                    // ),
                    BlocProvider(
                      create: (context) => AuthCubit(),
                      child: Builder(builder: (context) {
                        return BlocListener<AuthCubit, AuthenticationState>(
                          listener: (context, state) {
                            if (state.status == AuthStatus.success) {
                              context.goNamed(Routes.welcome);
                            }
                          },
                          child: SettingsTile(
                            title: "Sign Out",
                            function: () => context.read<AuthCubit>().signOut(),
                          ),
                        );
                      }),
                    ),
                    Divider(
                      height: 40,
                      color: Colors.grey[300],
                      thickness: 0.5,
                    ),
                    // Text(
                    //   "About",
                    //   style: GoogleFonts.inter(
                    //       fontSize: 1.5 * SizeConfig.heightMultiplier,
                    //       fontWeight: FontWeight.w600,
                    //       color: green),
                    // ),
                    // Gap(1 * SizeConfig.heightMultiplier),
                    // SettingsTile(
                    //   title: "Customer Service",
                    //   function: () {},
                    // ),
                    // Divider(
                    //   height: 40,
                    //   color: Colors.grey[300],
                    //   thickness: 0.5,
                    // ),
                    Text(
                      "About",
                      style: GoogleFonts.inter(
                          fontSize: 1.5 * SizeConfig.heightMultiplier,
                          fontWeight: FontWeight.w600,
                          color: green),
                    ),
                    Gap(1 * SizeConfig.heightMultiplier),
                    SettingsTile(
                      title: "Money Back Guarantee",
                      function: () => context
                          .read<AppCubit>()
                          .launchBrowser("https://ecoville.site/moneyback"),
                    ),
                    SettingsTile(
                      title: "Privacy",
                      function: () => context
                          .read<AppCubit>()
                          .launchBrowser("https://ecoville.site/privacy"),
                    ),
                    SettingsTile(
                      title: "Rate Us",
                      function: () => context.read<AppCubit>().launchBrowser(
                          "https://play.google.com/store/apps/details?id=com.ecoville.eville"),
                    ),
                    SettingsTile(
                      title: "Legal",
                      function: () => context
                          .read<AppCubit>()
                          .launchBrowser("https://ecoville.site/legal"),
                    ),
                  ],
                );
              }
            ),
          ),
        ));
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.function,
    required this.title,
  });

  final Function() function;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          title,
          style: GoogleFonts.inter(
              fontSize: 1.8 * SizeConfig.heightMultiplier,
              fontWeight: FontWeight.w600,
              color: black),
        ),
      ),
    );
  }
}
