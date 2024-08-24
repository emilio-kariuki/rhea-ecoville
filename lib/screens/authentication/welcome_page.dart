import 'package:ecoville/blocs/app/address_cubit.dart';
import 'package:ecoville/blocs/app/auth_cubit.dart';
import 'package:ecoville/blocs/app/local_cubit.dart';
import 'package:ecoville/blocs/app/message_cubit.dart';
import 'package:ecoville/blocs/app/notification_cubit.dart';
import 'package:ecoville/blocs/app/product_cubit.dart';
import 'package:ecoville/blocs/app/user_cubit.dart';
import 'package:ecoville/blocs/minimal/bool_cubit.dart';
import 'package:ecoville/shared/complete_button.dart';
import 'package:ecoville/shared/input_field.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/screens/authentication/widgets/terms_of_service.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Colors.white
            // image: DecorationImage(
            //   fit: BoxFit.cover,
            //   image: AssetImage(AppImages.welcome),
            // ),
            ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        AppImages.ecoville,
                        height: 25 * SizeConfig.heightMultiplier,
                        width: 25 * SizeConfig.heightMultiplier,
                      ),
                    ),
                    Gap(4 * SizeConfig.heightMultiplier),
                    Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 2.6 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w700,
                          height: 1.1),
                    ),
                    Gap(1 * SizeConfig.heightMultiplier),
                    Text(
                      "Login to continue",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 1.8 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w400,
                          height: 1.1),
                    ),
                    Gap(4 * SizeConfig.heightMultiplier),
                    InputField(
                      controller: _emailController,
                      onChanged: (value) {
                        _formKey.currentState!.validate();
                        return null;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email cannot be empty";
                        }
                        return null;
                      },
                      hintText: "Email Address",
                    ),
                    Gap(1 * SizeConfig.heightMultiplier),
                    BlocProvider(
                      create: (context) => BoolCubit()..changeValue(value: isObscure),
                      child: BlocConsumer<BoolCubit, BoolState>(
                        listener: (context, state) {
                          if (state.status == BoolStatus.changed) {
                            isObscure = state.value;
                          }
                        },
                        builder: (context, state) {
                          return InputField(
                            controller: _passwordController,
                            obScureText: isObscure,
                            maxLines: 1,
                            onChanged: (value) {
                              _formKey.currentState!.validate();
                              return null;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password cannot be empty";
                              }
                              return null;
                            },
                            hintText: "Password",
                            suffixIcon: IconButton(
                              splashColor: Colors.transparent,
                              onPressed: () {
                                context
                                    .read<BoolCubit>()
                                    .changeValue(value: !isObscure);
                              },
                              icon: Icon(
                                isObscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.black.withOpacity(0.6),
                                size: 20,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Gap(2 * SizeConfig.heightMultiplier),
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {}
                          },
                          child: Text(
                            "Forgot Password?",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 1.6 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
                                ..read<ProductCubit>().getBiddingProducts()
                                ..read<MessageCubit>().getConversations()
                                ..read<UserCubit>().getUser()
                                ..read<ProductCubit>().getNearbyProducts()
                                ..read<AddressCubit>().getAddresses()
                                ..read<LocalCubit>().getCartProducts()
                                ..read<LocalCubit>().getWatchedProduct()
                                ..read<LocalCubit>().getLaterCartProducts()
                                ..read<NotificationCubit>().getAllNotifications()
                                ..read<ProductCubit>().getSimilarProducts(
                                    productId: "adfasdf-asdfasd-asdfasdf")
                                ..pushNamed(Routes.home);
                            }
                          },
                          builder: (context, state) {
                            return CompleteButton(
                              isLoading: state.status == AuthStatus.loading,
                              text: Text(
                                "Login to continue",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 2 * SizeConfig.textMultiplier,
                                  color: white,
                                ),
                              ),
                              function: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().signInWithEmailPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text);
                                }
                              },
                              width: 80 * SizeConfig.widthMultiplier,
                              height: 7 * SizeConfig.heightMultiplier,
                              borderRadius: 10,
                              backgroundColor: green,
                            );
                          },
                        );
                      }),
                    ),
                    Gap(2 * SizeConfig.heightMultiplier),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            foregroundColor: white
                          ),
                          onPressed: () {
                            context.pushNamed(Routes.register);
                          },
                          child: Text(
                            
                            "Don't have an account? Register",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 1.6 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(3 * SizeConfig.heightMultiplier),
                    BlocProvider(
                      create: (context) => AuthCubit(),
                      child: Builder(builder: (context) {
                        return BlocConsumer<AuthCubit, AuthenticationState>(
                          listener: (context, state) {
                            if (state.status == AuthStatus.success) {
                              context
                                ..read<ProductCubit>().getProducts()
                                ..read<MessageCubit>().getConversations()
                                ..read<UserCubit>().getUser()
                                ..read<ProductCubit>().getNearbyProducts()
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
                              backgroundColor: lightGrey,
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
          ),
        ),
      ),
    );
  }
}
