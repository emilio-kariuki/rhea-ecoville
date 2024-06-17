import 'package:ecoville/blocs/app/notification_cubit.dart';
import 'package:ecoville/blocs/minimal/navigation_cubit.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  final Widget child;
  const Home({super.key, required this.child});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    supabase
        ..channel('public:$TABLE_NOTIFICATION')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: TABLE_NOTIFICATION,
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'userId',
              value: supabase.auth.currentUser!.id,
            ),
            callback: (payload) {
              debugPrint('Change received: ${payload.toString()}');
              context.read<NotificationCubit>().getAllNotifications();
            })
        .subscribe()
        ..channel('public:$TABLE_MESSAGE')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: TABLE_MESSAGE,
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'userId',
              value: supabase.auth.currentUser!.id,
            ),
            callback: (payload) {
              debugPrint('Change received: ${payload.toString()}');
              
            })
        .subscribe();
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: getFooter(context),
    );
  }

  Widget getFooter(BuildContext context) {
    final items = <Map<String, dynamic>>[
      {'icon': AppImages.home, 'name': "Home"},
      {'icon': AppImages.search, 'name': "Search"},
      {'icon': AppImages.profile, 'name': "Account"},
      {'icon': AppImages.notifications, 'name': "Inbox"},
      {'icon': AppImages.sale, 'name': "Selling"},
    ];
    final List<String> routes = [
      '/home',
      '/search',
      '/account',
      '/inbox',
      '/selling'
    ];

    return BlocConsumer<NavigationCubit, NavigationState>(
      listener: (context, state) {
        appRouter.push(routes[state.page]);
      },
      builder: (context, state) {
        return AnimatedBottomNavigationBar.builder(
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
                  child: SvgPicture.asset(itemz['icon'] as String,
                      color: isActive ? secondary : darkGrey,
                      height: 2.5 * SizeConfig.heightMultiplier,
                      width: 2.5 * SizeConfig.widthMultiplier),
                ),
                const Gap(3),
                Text(
                  itemz['name'] as String,
                  style: GoogleFonts.inter(
                    color: isActive ? secondary : darkGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: 1.6 * SizeConfig.textMultiplier,
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}
