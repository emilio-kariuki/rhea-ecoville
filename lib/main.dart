import 'package:ecoville/blocs/app/authentication_cubit.dart';
import 'package:ecoville/blocs/app/local_cubit.dart';
import 'package:ecoville/blocs/app/product_cubit.dart';
import 'package:ecoville/blocs/app/user_cubit.dart';
import 'package:ecoville/blocs/minimal/navigation_cubit.dart';
import 'package:ecoville/data/repository/notification_repository.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/firebase_options.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/views/authentication/welcome_page.dart';
import 'package:ecoville/views/home/home_page.dart';
import 'package:flutter/services.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final notification = message.notification;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationRepository().initializeNotifications();
  await NotificationRepository().sendImageNotification(
      title: notification!.title!,
      body: notification.body!,
      imageUrl: notification.android!.imageUrl!);

  debugPrint("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  initLocator();
  await Supabase.initialize(
      url: "https://fuvjfsjfehyistbfkmkg.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1dmpmc2pmZWh5aXN0YmZrbWtnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU5NDU0ODMsImV4cCI6MjAzMTUyMTQ4M30.EaKs4B9BheWafF7u2Cz0uQhw-m9C8LTVYuT_YVlXGR4",
      debug: false);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await NotificationRepository().initializeNotifications();
  await NotificationRepository().getNotificationToken();

  runApp(const MainApp());
  FlutterNativeSplash.remove();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationCubit()..appStarted(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => ProductCubit()..getProducts()..getNearbyProducts()..getSimilarProducts(productId: "adfasdf-asdfasd-asdfasdf"),
        ),
         BlocProvider(
          lazy: false,
          create: (context) => UserCubit()..getUser(),
        ),
         BlocProvider(
          lazy: false,
          create: (context) => LocalCubit(),
        ),
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        SizeConfig().init(constraints);
        return MaterialApp.router(
          routerDelegate: appRouter.routerDelegate,
          routeInformationParser: appRouter.routeInformationParser,
          routeInformationProvider: appRouter.routeInformationProvider,
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          title: "Ecoville",
        );
      }),
    );
  }
}

class Checker extends StatelessWidget {
  const Checker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        return state.status == AuthenticationStatus.authenticated
            ? const HomePage()
            : const WelcomePage();
      },
    );
  }
}
