import 'package:ecoville/blocs/app/supabase_auth/auth_cubit.dart';
import 'package:ecoville/shared/complete_button.dart';
import 'package:ecoville/shared/input_field.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/utilities/utilities.dart';
class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
                      AppImages.happy,
                      height: 5 * SizeConfig.heightMultiplier,
                      width: 5 * SizeConfig.heightMultiplier,
                    ),
                  ),
                ),
                Gap(1 * SizeConfig.heightMultiplier),
                Center(
                  child: Text(
                    'Sign In',
                    style: GoogleFonts.inter(
                      fontSize: 3 * SizeConfig.textMultiplier,
                      color: tertiary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Gap(2 * SizeConfig.heightMultiplier),
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
                Row(
                  children: [
                    Expanded(
                      child: SocialButton(
                        title: "Github",
                        icon: AppImages.github,
                        function: () {},
                      ),
                    ),
                    Gap(2 * SizeConfig.widthMultiplier),
                    Expanded(
                      child: SocialButton(
                        title: "Google",
                        icon: AppImages.google,
                        function: () {},
                      ),
                    ),
                  ],
                ),
                Gap(2 * SizeConfig.heightMultiplier),
                const Separator(),
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => showModalBottomSheet(
                        clipBehavior: Clip.antiAlias,
                        backgroundColor: white,
                        isScrollControlled: true,
                        barrierColor: Colors.black.withOpacity(0.6),
                        elevation: 5,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(27.25),
                                topRight: Radius.circular(27.25))),
                        context: context,
                        builder: (context) => ForgotPasswordPage(),
                      ),
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.inter(
                          fontSize: 1.8 * SizeConfig.textMultiplier,
                          color: grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
                        text: 'Sign In',
                        width: 80 * SizeConfig.widthMultiplier,
                        height: 7.5 * SizeConfig.heightMultiplier,
                        function: () {
                          if (_formKey.currentState!.validate()) {
                            context
                                .read<AuthCubit>()
                                .signInWithEmailAndPassword(
                                    emailController.text,
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
                      "Don't have an account?",
                      style: GoogleFonts.inter(
                        fontSize: 2 * SizeConfig.textMultiplier,
                        color: grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Gap(1 * SizeConfig.widthMultiplier),
                    GestureDetector(
                      onTap: () => context.push(AppRoute.register),
                      child: Text(
                        "Sign up",
                        style: GoogleFonts.inter(
                          fontSize: 2 * SizeConfig.textMultiplier,
                          color: green,
                          fontWeight: FontWeight.w600,
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
