// ignore_for_file: unused_local_variable

import 'package:dots_indicator/dots_indicator.dart';
import 'package:ecoville/blocs/minimal/page_cubit.dart';
import 'package:ecoville/utilities/packages.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});

  final List<Map<String, String>> items = [
    {
      "title": "Conviniently Sell your item",
      "description":
          "Post your item and get the best price for it. You can also post your item for free.",
      "image": AppImages.shop,
    },
    {
      "title": "See Products nearby",
      "description":
          "See the products nearby via the map functionality and purchase the product you like.",
      "image": AppImages.products,
    },
    {
      "title": "Manage your orders",
      "description":
          "Manage your orders and get the product delivered to your doorstep.",
      "image": AppImages.messages_1,
    },
    {
      "title": "Get the product delivered to your doorstep",
      "description":
          "Add a shipping address and get the product delivered to your doorstep.",
      "image": AppImages.delivery,
    }
  ];

  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    int index = 0;
    return Scaffold(
      backgroundColor: white,
      body: BlocProvider(
        create: (context) => PageCubit(),
        child: BlocConsumer<PageCubit, PageState>(
          listener: (context, state) {
            if (state.status == PageStatus.changed) {
              index = state.page;
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                items[index]['image']!,
                                height: height * 0.65,
                                width: width,
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                              ),
                            ],
                          ),
                          Positioned.fill(
                            top: height * 0.63,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                                child: Scaffold(
                                  backgroundColor: white,
                                  bottomNavigationBar: SizedBox(
                                    height: height * 0.1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        DotsIndicator(
                                          dotsCount: items.length,
                                          position: index,
                                          onTap: (position) {
                                            pageController.jumpToPage(position);
                                          },
                                          decorator: DotsDecorator(
                                            activeColor: green,
                                            color: lightGreen,
                                            spacing: const EdgeInsets.all(3),
                                            size: const Size(8.0, 6.0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            activeSize: const Size(35.0, 6.0),
                                            activeShape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Center(
                                          child: SizedBox(
                                            height: height * 0.06,
                                            width: height * 0.06,
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                  backgroundColor: green,
                                                  minimumSize: Size(width, 50),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                  side: BorderSide.none),
                                              onPressed: index != 3
                                                  ? () {
                                                      pageController.jumpToPage(
                                                          index += 1);

                                                      context
                                                          .read<PageCubit>()
                                                          .changePage(
                                                              page: index++);
                                                    }
                                                  : () async {
                                                      context
                                                          .go(Routes.welcome);
                                                      await SharedPreferences
                                                          .getInstance()
                                                          .then((value) {
                                                        value.setBool(
                                                            'onboarded', true);
                                                      });
                                                    },
                                              child: SvgPicture.asset(
                                                AppImages.right,
                                                color: white,
                                                height: height * 0.02,
                                                width: height * 0.02,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  body: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          pageController.jumpToPage(3);
                                          context
                                              .read<PageCubit>()
                                              .changePage(page: 2);
                                        },
                                        child: Text(
                                          "Skip",
                                          style: GoogleFonts.inter(
                                            fontSize:
                                                2 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w600,
                                            color: black,
                                          ),
                                        ),
                                      ),
                                      Gap(
                                        height * 0.02,
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          
                                          Gap(
                                            height * 0.01,
                                          ),
                                          Text(
                                            items[index]['title']!,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              fontSize:
                                                  3 * SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.w700,
                                              color: black,
                                            ),
                                          ),
                                          Gap(
                                            height * 0.01,
                                          ),
                                          Text(
                                            items[index]['description']!,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              fontSize: 1.9 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black.withOpacity(0.6),
                                              height: 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
