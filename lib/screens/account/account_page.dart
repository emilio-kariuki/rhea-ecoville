import 'package:ecoville/blocs/app/local_cubit.dart';
import 'package:ecoville/blocs/app/user_cubit.dart';
import 'package:ecoville/blocs/minimal/navigation_cubit.dart';
import 'package:ecoville/shared/icon_container.dart';
import 'package:ecoville/shared/input_field.dart';
import 'package:ecoville/utilities/packages.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<Map<String, dynamic>> shoppingList = [
    // {
    //   "name": "Watchlist",
    //   'description': "Keep tabs in watched items",
    //   'icon': AppImages.watch,
    //   'page': Routes.watchlist
    // },
    {
      "name": "Wishlist",
      'description': "Your wishlist items",
      'icon': AppImages.wishlist,
      'page': Routes.wishlist
    },
    {
      "name": "Orders",
      'description': "Your orders and tracking",
      'icon': AppImages.offer,
      'page': Routes.orders
    },
    // {
    //   "name": "Bids & offers",
    //   'description': "Active auctions and seller offers",
    //   'icon': AppImages.bids,
    //   'page': Routes.cart
    // },
    {
      "name": "Recently viewed",
      'description': "Listing your recently viewed",
      'icon': AppImages.recent,
      'page': Routes.watchlist
    },
    // {
    //   "name": "Categories",
    //   'description': "Shop by category",
    //   'icon': AppImages.category,
    //   'page': Routes.categories
    // },
    // {
    //   "name": "Listings",
    //   'description': "Your all time listings",
    //   'icon': AppImages.listings,
    //   'page': Routes.cart
    // }
  ];
  List<Map<String, dynamic>> shortcutList = [
    // {
    //   "name": "Notifications",
    //   'description': "Notifications in one place",
    //   'icon': AppImages.notifications,
    //   'page': Routes.cart
    // },
    {
      "name": "Saved",
      'description': "Searches, sellers, feed",
      'icon': AppImages.save,
      'page': Routes.saved
    },
    {
      "name": "Liked",
      'description': "Your liked items",
      'icon': AppImages.favourite,
      'page': Routes.liked
    },
  ];
  List<Map<String, dynamic>> accountList = [
    // {
    //   "name": "Payment",
    //   'description': "Your payments in one place",
    //   'icon': AppImages.payment,
    //   'page': Routes.cart
    // },

    {
      "name": "Settings",
      'description': "Modify anything in the app",
      'icon': AppImages.settings,
      'page': Routes.settings
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: white,
          surfaceTintColor: white,
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Text(
            "My ecoville",
            style: GoogleFonts.inter(
                fontSize: 2.2 * SizeConfig.heightMultiplier,
                fontWeight: FontWeight.w600,
                color: black),
          ),
          actions: [
            Gap(1 * SizeConfig.widthMultiplier),
            IconContainer(
                icon: AppImages.search,
                function: () =>
                    context.read<NavigationCubit>().changePage(page: 1)),
            Gap(1 * SizeConfig.widthMultiplier),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<UserCubit, UserState>(
                  buildWhen: (previous, current) =>
                      previous.user != current.user,
                  builder: (context, state) {
                    return state.status == UserStatus.success &&
                            state.user != null
                        ? Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  color: green,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    state.user?.name.split("")[0].toString() ??
                                        "",
                                    style: GoogleFonts.inter(
                                        fontSize: 3 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.bold,
                                        color: black),
                                  ),
                                ),
                              ),
                              Gap(2 * SizeConfig.widthMultiplier),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.user?.name ?? "",
                                    style: GoogleFonts.inter(
                                        color: black,
                                        fontSize: 2 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.w500,
                                        height: 1.2),
                                  ),
                                  Text(
                                    "Member since ${state.user?.createdAt!.year ?? DateTime.now().year}",
                                    style: GoogleFonts.inter(
                                        color: Colors.grey,
                                        fontSize:
                                            1.6 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.w500,
                                        height: 1.2),
                                  ),
                                ],
                              ),
                              const Spacer()
                            ],
                          )
                        : const SizedBox.shrink();
                  },
                ),
                Gap(2 * SizeConfig.heightMultiplier),
                Text(
                  "Shopping",
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
                    return AccountContainer(
                      icon: shoppingList[index]['icon'],
                      name: shoppingList[index]['name'],
                      description: shoppingList[index]['description'],
                      function: () => context.pushNamed(
                        shoppingList[index]['page'],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      Gap(0.2 * SizeConfig.heightMultiplier),
                  itemCount: shoppingList.length,
                ),
                Gap(2 * SizeConfig.heightMultiplier),
                Text(
                  "Shortcut",
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
                    return AccountContainer(
                      icon: shortcutList[index]['icon'],
                      name: shortcutList[index]['name'],
                      description: shortcutList[index]['description'],
                      function: () => context.pushNamed(
                        shortcutList[index]['page'],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      Gap(0.2 * SizeConfig.heightMultiplier),
                  itemCount: shortcutList.length,
                ),
                Gap(2 * SizeConfig.heightMultiplier),
                Text(
                  "Account",
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
                    return AccountContainer(
                      icon: accountList[index]['icon'],
                      name: accountList[index]['name'],
                      description: accountList[index]['description'],
                      function: () => context.pushNamed(
                        accountList[index]['page'],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      Gap(0.2 * SizeConfig.heightMultiplier),
                  itemCount: accountList.length,
                ),
                //* Admin
                BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    return state.user!.role == "admin" ?Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Admin",
                          style: GoogleFonts.inter(
                              color: black,
                              fontSize: 2.2 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                              letterSpacing: 0.1),
                        ),
                        Gap(2 * SizeConfig.heightMultiplier),
                        AccountContainer(
                          icon: AppImages.admin,
                          name: "Manage Orders",
                          description: "Manage all orders",
                          function: () => context.pushNamed(Routes.admin),
                        ),
                      ],
                    ):const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class AccountContainer extends StatelessWidget {
  const AccountContainer({
    super.key,
    required this.icon,
    required this.name,
    required this.description,
    required this.function,
  });

  final String icon;
  final String name;
  final String description;
  final Function() function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          children: [
            IconContainer(icon: icon, function: function),
            Gap(3 * SizeConfig.widthMultiplier),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 1.8 * SizeConfig.textMultiplier,
                    color: black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 1.5 * SizeConfig.textMultiplier,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
