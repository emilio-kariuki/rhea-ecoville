import 'package:ecoville/blocs/app/local_cubit.dart';
import 'package:ecoville/shared/complete_button.dart';
import 'package:ecoville/shared/network_image_container.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/utilities/utilities.dart';
import 'package:flutter_easy_faq/flutter_easy_faq.dart';

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

  final List<Map<String, dynamic>> greatListings = [
    {
      'title': "Write a standout title",
      'description_1':
          "Avoid titles with capslock and focus on specific details like brand, model, size and color.",
      'description_2': "Example: 'Apple iPhone 12 Pro Max 256GB Pacific Blue",
      'cardColor': Color.fromARGB(255, 251, 122, 79),
    },
    {
      'title': "Take clear photos",
      'description_1':
          "Use natural light and take photos from different angles.",
      'description_2': "Make sure to show any flaws or imperfections.",
      'cardColor': Color.fromARGB(255, 192, 228, 224)
    },
    {
      'title': "Set a fair price",
      'description_1':
          "Research similar items to see what they are selling for and set a competitive price.",
      'description_2': "The price should reflect the item's condition and age.",
      'cardColor': const Color.fromARGB(255, 163, 192, 244)
    },
    {
      'title': "Be honest",
      'description_1': "Describe any flaws or imperfections in your item.",
      'description_2': "Being honest will help you build trust with buyers.",
      'cardColor': Color.fromARGB(255, 251, 220, 230)
    },
    {
      'title': "Ship with ease",
      'description_1':
          "Use ecoville's shipping label to print and ship your item.",
      'description_2': "You can also schedule a pickup with the carrier.",
      'cardColor': const Color(0xffF4521E),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: CompleteButton(
              height: 6 * SizeConfig.heightMultiplier,
              borderRadius: 30,
              text: Text(
                "List an item",
                style: GoogleFonts.inter(
                    color: white,
                    fontSize: 1.8 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1),
              ),
              function: () => context.pushNamed(Routes.checkout)),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  NetworkImageContainer(
                      imageUrl:
                          "https://fuvjfsjfehyistbfkmkg.supabase.co/storage/v1/object/public/ecoville/kelly-sikkema-6vudIBHwLe8-unsplash.jpg",
                      height: size.height * 0.2,
                      width: size.width),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Sell your items on Ecoville",
                              style: GoogleFonts.inter(
                                  color: white,
                                  fontSize: 2.2 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                  letterSpacing: 0.1),
                            ),
                            Gap(0.5 * SizeConfig.heightMultiplier),
                            Text(
                              "Make money and help the planet by selling your\nitems on Ecoville",
                              style: GoogleFonts.inter(
                                  color: white,
                                  fontSize: 1.5 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.w500,
                                  height: 1.2,
                                  letterSpacing: 0.1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Gap(3 * SizeConfig.heightMultiplier),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "How it Works",
                      style: GoogleFonts.inter(
                          color: black,
                          fontSize: 2.2 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          letterSpacing: 0.1),
                    ),
                  ),
                  Gap(2 * SizeConfig.heightMultiplier),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              IconContainer(
                                  icon: howItWorks[index]['icon'],
                                  function: () {}),
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
                                    width: size.width * 0.7,
                                    child: Text(
                                      howItWorks[index]['description'],
                                      style: GoogleFonts.inter(
                                        fontSize:
                                            1.5 * SizeConfig.textMultiplier,
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
                  ),
                  Gap(3 * SizeConfig.heightMultiplier),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Create a greate listing",
                      style: GoogleFonts.inter(
                          color: black,
                          fontSize: 2 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          letterSpacing: 0.1),
                    ),
                  ),
                  Gap(0.3 * SizeConfig.heightMultiplier),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Here are ways to make your listing great.",
                      style: GoogleFonts.inter(
                          color: Colors.grey[600],
                          fontSize: 1.5 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          letterSpacing: 0.1),
                    ),
                  ),
                  Gap(2 * SizeConfig.heightMultiplier),
                  SizedBox(
                    height: size.height * 0.4,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? 15 : 0,
                            right: index == greatListings.length - 1 ? 15 : 0,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: greatListings[index]['cardColor'],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  greatListings[index]['title'],
                                  style: GoogleFonts.inter(
                                      color: black.withOpacity(0.7),
                                      fontSize: 2.5 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                      letterSpacing: 0.1),
                                ),
                                Gap(2 * SizeConfig.heightMultiplier),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Gap(1.5 * SizeConfig.widthMultiplier),
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          color: black.withOpacity(0.6),
                                          shape: BoxShape.circle),
                                    ),
                                    Gap(1.5 * SizeConfig.widthMultiplier),
                                    SizedBox(
                                      width: size.width * 0.6,
                                      child: Text(
                                        greatListings[index]['description_1'],
                                        style: GoogleFonts.inter(
                                            color: black.withOpacity(0.7),
                                            fontSize:
                                                1.7 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5,
                                            letterSpacing: 0.1),
                                      ),
                                    ),
                                  ],
                                ),
                                Gap(1 * SizeConfig.heightMultiplier),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Gap(1.5 * SizeConfig.widthMultiplier),
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          color: black.withOpacity(0.6),
                                          shape: BoxShape.circle),
                                    ),
                                    Gap(1.5 * SizeConfig.widthMultiplier),
                                    SizedBox(
                                      width: size.width * 0.6,
                                      child: Text(
                                        greatListings[index]['description_2'],
                                        style: GoogleFonts.inter(
                                            color: black.withOpacity(0.7),
                                            fontSize:
                                                1.7 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5,
                                            letterSpacing: 0.1),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          Gap(2 * SizeConfig.widthMultiplier),
                      itemCount: greatListings.length,
                    ),
                  ),
                  Gap(2 * SizeConfig.heightMultiplier),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 15),
                  //   child: Text(
                  //     "FAQs",
                  //     style: GoogleFonts.inter(
                  //         color: black,
                  //         fontSize: 2.2 * SizeConfig.textMultiplier,
                  //         fontWeight: FontWeight.w700,
                  //         height: 1.2,
                  //         letterSpacing: 0.1),
                  //   ),
                  // ),
                  // Gap(2 * SizeConfig.heightMultiplier),
                  // Padding(
                  //    padding: const EdgeInsets.symmetric(horizontal: 15),
                  //   child: EasyFaq(
                  //     backgroundColor: lightGrey,
                  //     questionTextStyle: GoogleFonts.inter(
                  //         color: black,
                  //         fontSize: 1.6 * SizeConfig.textMultiplier,
                  //         fontWeight: FontWeight.w600,
                  //         height: 1.2,
                  //         letterSpacing: 0.1),
                  //     anserTextStyle: GoogleFonts.inter(
                  //         color: black,
                  //         fontSize: 1.5 * SizeConfig.textMultiplier,
                  //         fontWeight: FontWeight.w500,
                  //         height: 1.3,
                  //         letterSpacing: 0.1),
                  //     question: "What is Lorem Ipsum?",
                  //     answer: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into ",
                  //   ),
                  // ),
                  // Gap(1 * SizeConfig.heightMultiplier),
                  // Padding(
                  //    padding: const EdgeInsets.symmetric(horizontal: 15),
                  //   child: EasyFaq(
                  //     backgroundColor: lightGrey,
                  //     questionTextStyle: GoogleFonts.inter(
                  //         color: black,
                  //         fontSize: 1.6 * SizeConfig.textMultiplier,
                  //         fontWeight: FontWeight.w600,
                  //         height: 1.2,
                  //         letterSpacing: 0.1),
                  //     anserTextStyle: GoogleFonts.inter(
                  //         color: black,
                  //         fontSize: 1.5 * SizeConfig.textMultiplier,
                  //         fontWeight: FontWeight.w500,
                  //         height: 1.3,
                  //         letterSpacing: 0.1),
                  //     question: "What is Lorem Ipsum?",
                  //     answer: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into ",
                  //   ),
                  // ),
                ],
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
