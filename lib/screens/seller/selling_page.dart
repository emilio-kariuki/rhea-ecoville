import 'package:ecoville/blocs/app/local_cubit.dart';
import 'package:ecoville/blocs/minimal/navigation_cubit.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/utilities/utilities.dart';

import '../../shared/icon_container.dart';

class SellingPage extends StatelessWidget {
  SellingPage({super.key});

  final List<Map<String, dynamic>> howItWorks = [
    {
      'name': 'Getting started',
      'description':
          'By just adding payment destails to your ecoville account you are good to go.',
      'icon': AppImages.payment
    },
    {
      'name': 'List you item',
      'description': 'Snap some photos and write a great description.',
      'icon': AppImages.camera
    },
    {
      'name': 'Get paid quickly and safely',
      'description':
          'When your item sells, we make the payment process easy for you and the buyer',
      'icon': AppImages.sale
    },
    {
      'name': 'Ship to its new home',
      'description':
          'Box it up, print a label directly on ecoville and say farewell. It\'s that simple.',
      'icon': AppImages.ship
    }
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: white,
          surfaceTintColor: white,
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Text(
            "Selling",
            style: GoogleFonts.inter(
                fontSize: 2.2 * SizeConfig.heightMultiplier,
                fontWeight: FontWeight.w600,
                color: black),
          ),
          actions: [
            
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
            Gap(1 * SizeConfig.widthMultiplier),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CreateListingButton(),
              Gap(3 * SizeConfig.heightMultiplier),
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        "Active",
                        style: GoogleFonts.inter(
                            color: black,
                            fontSize: 1.5 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            letterSpacing: 0.1),
                      ),
                      Text(
                        "10",
                        style: GoogleFonts.inter(
                            color: black,
                            fontSize: 2.2 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            letterSpacing: 0.1),
                      ),
                    ],
                  ),
                  Gap(3 * SizeConfig.widthMultiplier),
                  Column(
                    children: [
                      Text(
                        "Sold",
                        style: GoogleFonts.inter(
                            color: black,
                            fontSize: 1.5 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            letterSpacing: 0.1),
                      ),
                      Text(
                        "30",
                        style: GoogleFonts.inter(
                            color: black,
                            fontSize: 2.2 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            letterSpacing: 0.1),
                      ),
                    ],
                  ),
                ],
              ),
              Gap(3 * SizeConfig.heightMultiplier),
              Text(
                "How it Works",
                style: GoogleFonts.inter(
                    color: black,
                    fontSize: 2.2 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    letterSpacing: 0.1),
              ),
              Gap(2 * SizeConfig.heightMultiplier),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        IconContainer(
                            icon: howItWorks[index]['icon'], function: () {}),
                        Gap(3 * SizeConfig.widthMultiplier),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              howItWorks[index]['name'],
                              style: GoogleFonts.inter(
                                fontSize: 1.8 * SizeConfig.textMultiplier,
                                color: black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: width * 0.7,
                              child: Text(
                                howItWorks[index]['description'],
                                style: GoogleFonts.inter(
                                  fontSize: 1.5 * SizeConfig.textMultiplier,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                        const Spacer()
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    Gap(0.2 * SizeConfig.heightMultiplier),
                itemCount: howItWorks.length,
              ),
            ],
          ),
        ));
  }
}

class CreateListingButton extends StatelessWidget {
  const CreateListingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          IconContainer(icon: AppImages.edit, function: () {}),
          Gap(3 * SizeConfig.widthMultiplier),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add listing",
                style: GoogleFonts.inter(
                  fontSize: 1.8 * SizeConfig.textMultiplier,
                  color: black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "create yout listing from here",
                style: GoogleFonts.inter(
                  fontSize: 1.5 * SizeConfig.textMultiplier,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          const Spacer(),
          SvgPicture.asset(AppImages.right),
        ],
      ),
    );
  }
}
