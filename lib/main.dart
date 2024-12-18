import 'package:ecoville/blocs/app/address_cubit.dart';
import 'package:ecoville/blocs/app/app_cubit.dart';
import 'package:ecoville/blocs/app/authentication_cubit.dart';
import 'package:ecoville/blocs/app/local_cubit.dart';
import 'package:ecoville/blocs/app/location_cubit.dart';
import 'package:ecoville/blocs/app/message_cubit.dart';
import 'package:ecoville/blocs/app/notification_cubit.dart';
import 'package:ecoville/blocs/app/product_cubit.dart';
import 'package:ecoville/blocs/app/user_cubit.dart';
import 'package:ecoville/blocs/minimal/navigation_cubit.dart';
import 'package:ecoville/data/provider/socket_provider.dart';
import 'package:ecoville/data/repository/location_repository.dart';
import 'package:ecoville/data/repository/notification_repository.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/firebase_options.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

var logger = Logger();

final analytics = FirebaseAnalytics.instance;

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

final _socketService = service<SocketProvider>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  initLocator();
  await Supabase.initialize(
      url: "https://fuvjfsjfehyistbfkmkg.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1dmpmc2pmZWh5aXN0YmZrbWtnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU5NDU0ODMsImV4cCI6MjAzMTUyMTQ4M30.EaKs4B9BheWafF7u2Cz0uQhw-m9C8LTVYuT_YVlXGR4",
      debug: false,
      storageOptions: const StorageClientOptions(
        retryAttempts: 3,
      ),
      postgrestOptions: const PostgrestClientOptions(
        schema: 'public',
      ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  analytics.logAppOpen();x
  _socketService.connect();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await NotificationRepository().initializeNotifications();
  await NotificationRepository().getNotificationToken();
  await LocationRepository().requestPermission();
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://999a1c41bde283cc73c316a7c9ab26ca@o4507333268275200.ingest.de.sentry.io/4507333270175824';
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MainApp()),
  );
  
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
            create: (context) => ProductCubit()
              ..getProducts()
              ..getBiddingProducts()
              ..getNearbyProducts()),
        BlocProvider(
            lazy: false,
            create: (context) => NotificationCubit()..getAllNotifications()),
        BlocProvider(lazy: false, create: (context) => MessageCubit()),
        BlocProvider(
          lazy: false,
          create: (context) => UserCubit()..getUser(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => LocalCubit()
            ..getCartProducts()
            ..getWatchedProduct()
            ..getLaterCartProducts(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => AddressCubit()..getAddresses(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => LocationCubit()..getCurrentLocation(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => AppCubit()..getSearchList(),
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
