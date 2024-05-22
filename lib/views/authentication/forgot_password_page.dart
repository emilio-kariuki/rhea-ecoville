// import 'package:ecoville/blocs/app/supabase_auth/auth_cubit.dart';
import 'package:ecoville/shared/complete_button.dart';
import 'package:ecoville/shared/input_field.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/utilities/utilities.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  final emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(27.25),
                topRight: Radius.circular(27.25))),
        width: MediaQuery.sizeOf(context).width,
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: SvgPicture.asset(
                    AppImages.close,
                    height: 3 * SizeConfig.heightMultiplier,
                    width: 3 * SizeConfig.heightMultiplier,
                  ),
                ),
              ),
              Gap(2 * SizeConfig.heightMultiplier),
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
                  'Reset Password',
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
                  'Enter your email address below to receive\na link to reset your password.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 2 * SizeConfig.textMultiplier,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Gap(2 * SizeConfig.heightMultiplier),
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
              Gap(5 * SizeConfig.heightMultiplier),
              // BlocProvider(
              //   create: (context) => AuthCubit(),
              //   child: BlocConsumer<AuthCubit, SupabaseAuthState>(
              //     listener: (context, state) {
              //       if (state is PasswordResetEmailSent) {
              //         context
              //           ..showSuccessToast(
              //               title: "Success",
              //               message: "Password reset link sent to your email",
              //               context: context)
              //           ..pop();
              //       }
              //       if (state is AuthError) {
              //         context.showErrorToast(
              //             title: "Error",
              //             message: state.message,
              //             context: context);
              //       }
              //     },
              //     builder: (context, state) {
              //       return CompleteButton(
              //         isLoading: state is AuthLoading,
              //         borderRadius: 30,
              //         text: 'Submit',
              //         width: 80 * SizeConfig.widthMultiplier,
              //         height: 7.5 * SizeConfig.heightMultiplier,
              //         function: () {
              //           context
              //               .read<AuthCubit>()
              //               .sendPasswordResetEmail(emailController.text);
              //         },
              //         backgroundColor: green,
              //       );
              //     },
              //   ),
              // ),
              Gap(2 * SizeConfig.heightMultiplier),
            ],
          ),
        ),
      ),
    );
  }
}
