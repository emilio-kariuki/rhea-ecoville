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
          child: Column(
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
              SettingsTile(
                title: "Change Password",
                function: () {},
              ),
              SettingsTile(
                title: "Sign Out",
                function: () {},
              ),
              Divider(
                height: 40,
                color: Colors.grey[300],
                thickness: 0.5,
              ),
              Text(
                "About",
                style: GoogleFonts.inter(
                    fontSize: 1.5 * SizeConfig.heightMultiplier,
                    fontWeight: FontWeight.w600,
                    color: green),
              ),
              Gap(1 * SizeConfig.heightMultiplier),
              SettingsTile(
                title: "Customer Service",
                function: () {},
              ),
              
              Divider(
                height: 40,
                color: Colors.grey[300],
                thickness: 0.5,
              ),
              Text(
                "About",
                style: GoogleFonts.inter(
                    fontSize: 1.5 * SizeConfig.heightMultiplier,
                    fontWeight: FontWeight.w600,
                    color: green),
              ),
              Gap(1 * SizeConfig.heightMultiplier),
              SettingsTile(
                title: "User Agreement",
                function: () {},
              ),
              SettingsTile(
                title: "Privacy",
                function: () {},
              ),
              SettingsTile(
                title: "Rate Us",
                function: () {},
              ),
              SettingsTile(
                title: "Legal",
                function: () {},
              ),
            ],
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
