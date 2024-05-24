import 'package:ecoville/blocs/minimal/navigation_cubit.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/views/account/account_page.dart';
import 'package:ecoville/views/home/home_page.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  Widget getBody() {
    final pages = <Widget>[
      HomePage(),
      const Center(
        child: Text('Search'),
      ),
      AccountPage(),
      const Center(
        child: Text('notifications'),
      ),
    ];
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return IndexedStack(
          index: state.page,
          children: pages,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      bottomNavigationBar: getFooter(context),
    );
  }

  Widget getFooter(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final items = <Map<String, dynamic>>[
      {'icon': AppImages.home, 'name': "Home"},
      {'icon': AppImages.search, 'name': "Search"},
      {'icon': AppImages.profile, 'name': "Account"},
      {'icon': AppImages.notifications, 'name': "Inbox"},
    ];
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return SizedBox(
          height: height * 0.09,
          child: AnimatedBottomNavigationBar.builder(
            elevation: 0,
            backgroundColor: white,
            notchSmoothness: NotchSmoothness.softEdge,
            itemCount: items.length,
            safeAreaValues: const SafeAreaValues(
              bottom: false,
            ),
            activeIndex: state.page,
            gapWidth: 10,
            splashRadius: 0,
            scaleFactor: 0,
            onTap: (index) {
              BlocProvider.of<NavigationCubit>(context).changePage(page: index);
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            },
            tabBuilder: (int index, bool isActive) {
              final itemz = items[index];

              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    decoration: BoxDecoration(
                        color: isActive
                            ? secondary.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20)),
                    child: SvgPicture.asset(
                      itemz['icon'] as String,
                      color: isActive ? secondary : darkGrey,
                    ),
                  ),
                  const Gap(3),
                  Text(
                    itemz['name'] as String,
                    style: GoogleFonts.inter(
                      color: isActive ? secondary : darkGrey,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
