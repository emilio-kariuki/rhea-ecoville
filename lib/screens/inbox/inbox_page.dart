import 'package:ecoville/blocs/app/local_cubit.dart';
import 'package:ecoville/blocs/app/notification_cubit.dart';
import 'package:ecoville/shared/icon_container.dart';
import 'package:ecoville/utilities/packages.dart';

class InboxPage extends StatefulWidget {
  InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  final _pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
            "Notifications",
            style: GoogleFonts.inter(
                fontSize: 2.2 * SizeConfig.heightMultiplier,
                fontWeight: FontWeight.w600,
                color: black),
          ),
          actions: [
            IconContainer(icon: AppImages.search, function: () {}),
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
            // IconContainer(
            //     icon: AppImages.more,
            //     function: () => context.push(Routes.cart)),
            Gap(1 * SizeConfig.widthMultiplier),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<NotificationCubit>().getAllNotifications();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () =>{
                        context.read<NotificationCubit>().getAllNotifications(),
                         _pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn),
                          },
                      child: Text(
                        "All",
                        style: GoogleFonts.inter(
                            fontSize: 1.8 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            color: black),
                      ),
                    ),
                    Gap(2 * SizeConfig.widthMultiplier),
                    GestureDetector(
                      onTap: () =>{
                        context.read<NotificationCubit>().getAllNotifications(),
                         _pageController.animateToPage(1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn),},
                      child: Text(
                        "Unread",
                        style: GoogleFonts.inter(
                            fontSize: 1.8 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            color: black),
                      ),
                    ),
                    Gap(2 * SizeConfig.widthMultiplier),
                    GestureDetector(
                      onTap: () => _pageController.animateToPage(2,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn),
                      child: Text(
                        "Archive",
                        style: GoogleFonts.inter(
                            fontSize: 1.8 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            color: black),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => context
                          .read<NotificationCubit>()
                          .getAllNotifications(),
                      child: Text(
                        "refresh",
                        style: GoogleFonts.inter(
                            fontSize: 1.6 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            color: darkGrey),
                      ),
                    ),
                  ],
                ),
                Gap(2 * SizeConfig.heightMultiplier),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: [
                      BlocBuilder<NotificationCubit, NotificationState>(
                        buildWhen: (current, previous) =>
                            current.notifications != previous.notifications,
                        builder: (context, state) {
                          if (state.status == NotificationStatus.loading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state.status == NotificationStatus.error) {
                            return const Center(child: EmptyNotifications());
                          } else {
                            return state.notifications.isEmpty
                                ? const Center(child: EmptyNotifications())
                                : ListView.separated(
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                      onTap: () => context
                                          .read<NotificationCubit>()
                                          .readNotification(
                                              id: state
                                                  .notifications[index].id),
                                      child: Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration:
                                            BoxDecoration(color: lightGrey),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                      color: green
                                                          .withOpacity(0.2),
                                                      shape: BoxShape.circle),
                                                ),
                                                Gap(2 *
                                                    SizeConfig.widthMultiplier),
                                                Text(
                                                  state.notifications[index]
                                                      .title,
                                                  style: GoogleFonts.inter(
                                                      fontSize: 1.4 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: darkGrey),
                                                ),
                                              ],
                                            ),
                                            Gap(1 *
                                                SizeConfig.heightMultiplier),
                                            Text(
                                              state.notifications[index]
                                                  .description,
                                              style: GoogleFonts.inter(
                                                  fontSize: 1.4 *
                                                      SizeConfig.textMultiplier,
                                                  color: darkGrey),
                                            ),
                                            Gap(1 *
                                                SizeConfig.heightMultiplier),
                                            Text(
                                              state.notifications[index]
                                                  .createdAt
                                                  .toString()
                                                  .timeAgo(),
                                              style: GoogleFonts.inter(
                                                  fontSize: 1.2 *
                                                      SizeConfig.textMultiplier,
                                                  color: darkGrey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    separatorBuilder: (context, index) =>
                                        Gap(1 * SizeConfig.heightMultiplier),
                                    itemCount: state.notifications.length,
                                  );
                          }
                        },
                      ),
                      BlocBuilder<NotificationCubit, NotificationState>(
                        buildWhen: (current, previous) =>
                            current.unreadNotifications !=
                            previous.unreadNotifications,
                        builder: (context, state) {
                          if (state.status == NotificationStatus.loading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state.status == NotificationStatus.error) {
                            return const Center(child: EmptyNotifications());
                          } else {
                            return state.unreadNotifications.isEmpty
                                ? const Center(child: EmptyNotifications())
                                : ListView.separated(
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                      onTap: () => context
                                          .read<NotificationCubit>()
                                          .readNotification(
                                              id: state
                                                  .notifications[index].id),
                                      child: Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration:
                                            BoxDecoration(color: lightGrey),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                      color: Colors.orange
                                                          .withOpacity(0.2),
                                                      shape: BoxShape.circle),
                                                ),
                                                Gap(2 *
                                                    SizeConfig.widthMultiplier),
                                                Text(
                                                  state
                                                      .unreadNotifications[
                                                          index]
                                                      .title,
                                                  style: GoogleFonts.inter(
                                                      fontSize: 1.4 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: darkGrey),
                                                ),
                                              ],
                                            ),
                                            Gap(1 *
                                                SizeConfig.heightMultiplier),
                                            Text(
                                              state.unreadNotifications[index]
                                                  .description,
                                              style: GoogleFonts.inter(
                                                  fontSize: 1.4 *
                                                      SizeConfig.textMultiplier,
                                                  color: darkGrey),
                                            ),
                                            Gap(1 *
                                                SizeConfig.heightMultiplier),
                                            Text(
                                              state.unreadNotifications[index]
                                                  .createdAt
                                                  .toString()
                                                  .timeAgo(),
                                              style: GoogleFonts.inter(
                                                  fontSize: 1.2 *
                                                      SizeConfig.textMultiplier,
                                                  color: darkGrey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    separatorBuilder: (context, index) =>
                                        Gap(1 * SizeConfig.heightMultiplier),
                                    itemCount: state.unreadNotifications.length,
                                  );
                          }
                        },
                      ),
                      BlocBuilder<NotificationCubit, NotificationState>(
                        buildWhen: (current, previous) =>
                            current.readNotifications !=
                            previous.readNotifications,
                        builder: (context, state) {
                          if (state.status == NotificationStatus.loading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state.status == NotificationStatus.error) {
                            return const Center(child: EmptyNotifications());
                          } else {
                            return state.readNotifications.isEmpty
                                ? const Center(child: EmptyNotifications())
                                : ListView.separated(
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) => Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration:
                                          BoxDecoration(color: lightGrey),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                    color: red.withOpacity(0.2),
                                                    shape: BoxShape.circle),
                                              ),
                                              Gap(2 *
                                                  SizeConfig.widthMultiplier),
                                              Text(
                                                state.readNotifications[index]
                                                    .title,
                                                style: GoogleFonts.inter(
                                                    fontSize: 1.4 *
                                                        SizeConfig
                                                            .textMultiplier,
                                                    fontWeight: FontWeight.w600,
                                                    color: darkGrey),
                                              ),
                                            ],
                                          ),
                                          Gap(1 * SizeConfig.heightMultiplier),
                                          Text(
                                            state.readNotifications[index]
                                                .description,
                                            style: GoogleFonts.inter(
                                                fontSize: 1.4 *
                                                    SizeConfig.textMultiplier,
                                                color: darkGrey),
                                          ),
                                          Gap(1 * SizeConfig.heightMultiplier),
                                          Text(
                                            state.readNotifications[index]
                                                .createdAt
                                                .toString()
                                                .timeAgo(),
                                            style: GoogleFonts.inter(
                                                fontSize: 1.2 *
                                                    SizeConfig.textMultiplier,
                                                color: darkGrey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    separatorBuilder: (context, index) =>
                                        Gap(1 * SizeConfig.heightMultiplier),
                                    itemCount: state.readNotifications.length,
                                  );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppImages.notificationSolid,
          height: 15 * SizeConfig.heightMultiplier,
          width: 15 * SizeConfig.heightMultiplier,
        ),
        Text(
          "You're all caught up!",
          style: GoogleFonts.inter(
              fontSize: 2.2 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.w600,
              color: black),
        )
      ],
    );
  }
}
