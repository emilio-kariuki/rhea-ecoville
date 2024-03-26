import 'package:ecoville/blocs/app/supabase_auth/auth_cubit.dart';
import 'package:ecoville/shared/complete_button.dart';
import 'package:ecoville/shared/input_field.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/utilities/utilities.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: white,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: SvgPicture.asset(
                    AppImages.close,
                    height: 3 * SizeConfig.heightMultiplier,
                    width: 3 * SizeConfig.heightMultiplier,
                  ),
                ),
                Gap(1 * SizeConfig.heightMultiplier),
                Center(
                  child: Container(
                    margin: EdgeInsets.all(1 * SizeConfig.heightMultiplier),
                    padding: EdgeInsets.all(3 * SizeConfig.heightMultiplier),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6DFFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SvgPicture.asset(
                      AppImages.smile,
                      height: 5 * SizeConfig.heightMultiplier,
                      width: 5 * SizeConfig.heightMultiplier,
                    ),
                  ),
                ),
                Gap(2 * SizeConfig.heightMultiplier),
                Center(
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.inter(
                      fontSize: 3 * SizeConfig.textMultiplier,
                      color: tertiary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Gap(1 * SizeConfig.heightMultiplier),
                Center(
                  child: Text(
                    'It was popularised in the 1960s with the release of Letraset sheets containing Lorem',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 2 * SizeConfig.textMultiplier,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Gap(2 * SizeConfig.heightMultiplier),
                Center(
                  child: SupaSocialsAuth(
                    socialProviders: const [
                      OAuthProvider.github,
                      OAuthProvider.google,
                      OAuthProvider.discord,
                      OAuthProvider.figma
                    ],
                    colored: true,
                    socialButtonVariant: SocialButtonVariant.icon,
                    redirectUrl: kIsWeb
                        ? null
                        : 'https://pkgfznuiqaixphqiynme.supabase.co/auth/v1/callback',
                    onSuccess: (Session response) {
                      // context.push('/home');
                    },
                    showSuccessSnackBar: false,
                    onError: (error) {
                      debugPrint(error.toString());
                    },
                  ),
                ),
                Gap(2 * SizeConfig.heightMultiplier),
                // Row(
                //   children: [
                //     Expanded(
                //       child: SocialButton(
                //         title: "Github",
                //         icon: AppImages.github,
                //         function: () {},
                //       ),
                //     ),
                //     Gap(2 * SizeConfig.widthMultiplier),
                //     Expanded(
                //       child: SocialButton(
                //         title: "Google",
                //         icon: AppImages.google,
                //         function: () {},
                //       ),
                //     ),
                //   ],
                // ),
                // Gap(2 * SizeConfig.heightMultiplier),
                const Separator(),
                Gap(2 * SizeConfig.heightMultiplier),
                InputField(
                  borderRadius: 15,
                  controller: nameController,
                  fillColor: const Color(0xFFF6F8FE),
                  hintText: "Full Name",
                  onChanged: (_) {
                    _formKey.currentState!.validate();
                    return null;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Full Name cannot be empty ";
                    }
                    return null;
                  },
                ),
                Gap(2 * SizeConfig.heightMultiplier),
                InputField(
                  borderRadius: 15,
                  controller: emailController,
                  fillColor: const Color(0xFFF6F8FE),
                  hintText: "Email Address",
                  onChanged: (_) {
                    _formKey.currentState!.validate();
                    return null;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email cannot be empty";
                    }
                    return null;
                  },
                ),
                Gap(2 * SizeConfig.heightMultiplier),
                InputField(
                  borderRadius: 15,
                  controller: passwordController,
                  fillColor: const Color(0xFFF6F8FE),
                  hintText: "Password",
                  onChanged: (_) {
                    _formKey.currentState!.validate();
                    return null;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password cannot be empty";
                    }
                    return null;
                  },
                ),
                Gap(3 * SizeConfig.heightMultiplier),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      fillColor: MaterialStateProperty.all(
                        const Color(0xFFF6F8FE),
                      ),
                      value: false,
                      onChanged: (value) {},
                    ),
                    Gap(1 * SizeConfig.widthMultiplier),
                    Expanded(
                      child: RichText(
                        // maxLines: 2,
                        text: TextSpan(
                          text: 'I agree to the ',
                          style: GoogleFonts.inter(
                            fontSize: 2 * SizeConfig.textMultiplier,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Terms of Service',
                              style: GoogleFonts.inter(
                                fontSize: 2 * SizeConfig.textMultiplier,
                                color: green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: ' and ',
                              style: GoogleFonts.inter(
                                fontSize: 2 * SizeConfig.textMultiplier,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: 'Privacy policy',
                              style: GoogleFonts.inter(
                                fontSize: 2 * SizeConfig.textMultiplier,
                                color: green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Gap(3 * SizeConfig.heightMultiplier),
                BlocProvider(
                  create: (context) => AuthCubit(),
                  child: BlocConsumer<AuthCubit, SupabaseAuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        context.go(AppRoute.home);
                      }
                      if (state is AuthError) {
                        context.showErrorToast(
                            title: "Error",
                            message: state.message,
                            context: context);
                      }
                    },
                    builder: (context, state) {
                      return CompleteButton(
                        isLoading: state is AuthLoading,
                        borderRadius: 30,
                        text: 'Create Account',
                        width: 80 * SizeConfig.widthMultiplier,
                        height: 7 * SizeConfig.heightMultiplier,
                        function: () {
                          if (_formKey.currentState!.validate()) {
                            context
                                .read<AuthCubit>()
                                .signUpWithEmailAndPassword(
                                    emailController.text,
                                    nameController.text,
                                    passwordController.text);
                          }
                        },
                        backgroundColor: green,
                      );
                    },
                  ),
                ),
                Gap(3 * SizeConfig.heightMultiplier),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: GoogleFonts.inter(
                        fontSize: 2 * SizeConfig.textMultiplier,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Gap(1 * SizeConfig.widthMultiplier),
                    GestureDetector(
                      onTap: () => context.push(AppRoute.login),
                      child: Text(
                        "Sign in",
                        style: GoogleFonts.inter(
                          fontSize: 2 * SizeConfig.textMultiplier,
                          color: green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}

class Separator extends StatelessWidget {
  const Separator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: lightGrey,
            height: 0.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "OR",
            style: GoogleFonts.inter(
              fontSize: 1.8 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: lightGrey,
            height: 0.5,
          ),
        ),
      ],
    );
  }
}

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.title,
    required this.icon,
    required this.function,
  });

  final String title;
  final String icon;
  final Function() function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: 2.2 * SizeConfig.heightMultiplier),
        decoration: BoxDecoration(
            color: const Color(0xFFF6F8FE),
            borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                icon,
                height: 3 * SizeConfig.heightMultiplier,
                width: 3 * SizeConfig.heightMultiplier,
              ),
              Gap(1 * SizeConfig.widthMultiplier),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 2.2 * SizeConfig.textMultiplier,
                  color: darkGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
