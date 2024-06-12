import 'package:ecoville/blocs/app/local_cubit.dart';
import 'package:ecoville/blocs/app/payment_cubit.dart';
import 'package:ecoville/blocs/app/user_cubit.dart';
import 'package:ecoville/shared/complete_button.dart';
import 'package:ecoville/shared/icon_container.dart';
import 'package:ecoville/shared/network_image_container.dart';
import 'package:ecoville/utilities/packages.dart';

class CheckoutPage extends StatelessWidget {
  CheckoutPage({super.key});

  double totalAmount = 0.0;
  List<String> products = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        surfaceTintColor: white,
        automaticallyImplyLeading: false,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: IconContainer(
              icon: AppImages.close,
              function: () => context.pushNamed(Routes.cart)),
        ),
        title: Text(
          "Checkout",
          style: GoogleFonts.inter(
              fontSize: 2.2 * SizeConfig.heightMultiplier,
              fontWeight: FontWeight.w600,
              color: black),
        ),
        actions: [
          IconContainer(
              icon: AppImages.more,
              function: () => context.pushNamed(Routes.cart)),
          Gap(1 * SizeConfig.widthMultiplier),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<LocalCubit, LocalState>(
              builder: (context, state) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final product = state.cartItems[index];
                    totalAmount += product.startingPrice;
                    products.add(product.id);
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Column(
                        children: [
                          Gap(2 * SizeConfig.heightMultiplier),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NetworkImageContainer(
                                imageUrl: product.image,
                                height: 13 * SizeConfig.heightMultiplier,
                                width: 13 * SizeConfig.widthMultiplier,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              Gap(2 * SizeConfig.widthMultiplier),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.6,
                                    child: Text(
                                      product.name,
                                      softWrap: true,
                                      maxLines: 2,
                                      style: GoogleFonts.inter(
                                          fontSize:
                                              1.8 * SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.w500,
                                          color: black),
                                    ),
                                  ),
                                  Gap(1 * SizeConfig.heightMultiplier),
                                  Text(
                                    "\$${(product.startingPrice).toStringAsFixed(2)}",
                                    style: GoogleFonts.inter(
                                        fontSize:
                                            1.7 * SizeConfig.heightMultiplier,
                                        fontWeight: FontWeight.w700,
                                        color: black),
                                  ),
                                  Gap(1 * SizeConfig.heightMultiplier),
                                  Text(
                                    "Free returns",
                                    style: GoogleFonts.inter(
                                        fontSize:
                                            1.5 * SizeConfig.heightMultiplier,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[500]),
                                  ),
                                  Gap(2 * SizeConfig.heightMultiplier),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          context
                                              .read<LocalCubit>()
                                              .removeProductFromCart(
                                                  id: product.id);
                                        },
                                        child: Text(
                                          "Remove",
                                          style: GoogleFonts.inter(
                                              fontSize: 1.5 *
                                                  SizeConfig.heightMultiplier,
                                              fontWeight: FontWeight.w500,
                                              color: green),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey[400],
                    thickness: 0.5,
                  ),
                  itemCount: state.cartItems.length,
                );
              },
            ),
            Divider(
              color: Colors.grey[400],
              thickness: 0.5,
            ),
            Gap(2 * SizeConfig.heightMultiplier),
            BlocBuilder<UserCubit, UserState>(
              builder: (context, userState) {
                return BlocProvider(
                  create: (context) => PaymentCubit(),
                  child: Builder(
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: CompleteButton(
                            height: 6 * SizeConfig.heightMultiplier,
                            borderRadius: 30,
                            text: Text(
                              "Pay \$${totalAmount.toStringAsFixed(2)}",
                              style: GoogleFonts.inter(
                                  color: white,
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.1),
                            ),
                            function: () => context
                                .read<PaymentCubit>()
                                .initializePayment(
                                    phone: int.parse(userState.user!.phone!),
                                    amount: totalAmount,
                                    products: products)),
                      );
                    }
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
