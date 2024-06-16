import 'package:ecoville/blocs/app/auth_cubit.dart';
import 'package:ecoville/blocs/app/product_cubit.dart';
import 'package:ecoville/shared/complete_button.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/screens/authentication/widgets/terms_of_service.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(AppImages.welcome),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppImages.ecoville,
                    height: 8 * SizeConfig.heightMultiplier,
                    width: 8 * SizeConfig.heightMultiplier,
                  ),
                  Gap(2 * SizeConfig.widthMultiplier),
                  Text(
                    APP_NAME,
                    style: GoogleFonts.rubikBubbles(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Gap(3 * SizeConfig.heightMultiplier),
              Text(
                "\"$APP_DESCRIPTION\"",
                textAlign: TextAlign.center,
                style: GoogleFonts.rubikBubbles(
                    color: Colors.white,
                    fontSize: 3 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w600,
                    height: 1.1),
              ),
              Gap(2 * SizeConfig.heightMultiplier),
              BlocProvider(
                create: (context) => AuthCubit(),
                child: Builder(builder: (context) {
                  return BlocConsumer<AuthCubit, AuthenticationState>(
                    listener: (context, state) {
                      if (state.status == AuthStatus.success) {
                        context
                          ..read<ProductCubit>().getProducts()
                          ..read<ProductCubit>().getNearbyProducts()
                          ..read<ProductCubit>().getSimilarProducts(
                              productId: "adfasdf-asdfasd-asdfasdf")
                          ..pushNamed(Routes.home);
                      }
                    },
                    builder: (context, state) {
                      return CompleteButton(
                        isLoading: state.status == AuthStatus.loading,
                        text: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppImages.google,
                              height: 3 * SizeConfig.heightMultiplier,
                              width: 3 * SizeConfig.heightMultiplier,
                            ),
                            Gap(1 * SizeConfig.widthMultiplier),
                            Text(
                              "Sign in with Google",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 2 * SizeConfig.textMultiplier,
                                color: black,
                              ),
                            ),
                          ],
                        ),
                        function: () =>
                            context.read<AuthCubit>().signInWithGoogle(),
                        width: 80 * SizeConfig.widthMultiplier,
                        height: 7 * SizeConfig.heightMultiplier,
                        borderRadius: 10,
                        backgroundColor: white,
                      );
                    },
                  );
                }),
              ),
              Gap(1 * SizeConfig.heightMultiplier),
              const TermsOfService()
            ],
          ),
        ),
      ),
    );
  }
}
