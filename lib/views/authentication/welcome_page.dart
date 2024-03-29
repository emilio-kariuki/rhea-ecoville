import 'package:ecoville/shared/complete_button.dart';
import 'package:ecoville/shared/outline_button.dart';
import 'package:ecoville/utilities/packages.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE7EDDD),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                SvgPicture.asset(
                  AppImages.welcome,
                  height: 55 * SizeConfig.heightMultiplier,
                  width: MediaQuery.sizeOf(context).width,
                  color: green,
                ),
                const Spacer(),
                Text(
                  'Welcome to Ecoville!',
                  style: GoogleFonts.inter(
                    fontSize: 3 * SizeConfig.textMultiplier,
                    color: tertiary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gap(1 * SizeConfig.heightMultiplier),
                Text(
                  'Ecoville is a platform that connects you to\npeople who share the same passion for\nsustainability and the environment.',
                  style: GoogleFonts.inter(
                      fontSize: 2 * SizeConfig.textMultiplier,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      height: 1.3),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      CompleteButton(
                        text: 'Get Started',
                        width: 80 * SizeConfig.widthMultiplier,
                        height: 7 * SizeConfig.heightMultiplier,
                        function: () => context.push(AppRoute.login),
                        backgroundColor: green,
                      ),
                      Gap(1.5 * SizeConfig.heightMultiplier),
                      OutlineButton(
                        text: 'Sign Up',
                        width: 80 * SizeConfig.widthMultiplier,
                        height: 7 * SizeConfig.heightMultiplier,
                        function: () => context.push(AppRoute.register),
                      ),
                    ],
                  ),
                ),
                Gap(4 * SizeConfig.heightMultiplier),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
