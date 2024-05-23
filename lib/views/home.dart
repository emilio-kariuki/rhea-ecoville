import 'package:ecoville/blocs/minimal/navigation_cubit.dart';
import 'package:ecoville/utilities/packages.dart';
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

    supabase
        .channel('public:ecoville_user')
        .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'ecoville_user',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'id',
              value: supabase.auth.currentUser!.id,
            ),
            callback: (payload) {
              debugPrint('Change received: ${payload.toString()}');
            })
        .subscribe();
  }

  Widget getBody() {
    final pages = <Widget>[
      const Center(
        child: Text('Home'),
      ),
      const Center(
        child: Text('Search'),
      ),
      const Center(
        child: Text('account'),
      ),
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
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: Scaffold(
        body: getBody(),
        bottomNavigationBar: getFooter(context),
      ),
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
            backgroundColor: Colors.transparent,
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
