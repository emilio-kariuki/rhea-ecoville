import 'package:ecoville/blocs/app/authentication_cubit.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/firebase_options.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/views/home/home.dart';
import 'package:flutter/services.dart';

const supabaseKey = String.fromEnvironment('ANON_KEY');
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initLocator();
  await Supabase.initialize(
      url: "https://fuvjfsjfehyistbfkmkg.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1dmpmc2pmZWh5aXN0YmZrbWtnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU5NDU0ODMsImV4cCI6MjAzMTUyMTQ4M30.EaKs4B9BheWafF7u2Cz0uQhw-m9C8LTVYuT_YVlXGR4",
      debug: false);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationCubit()..appStarted(),
      lazy: false,
      child: LayoutBuilder(builder: (context, constraints) {
        SizeConfig().init(constraints);
        return MaterialApp.router(
          routerConfig: AppRouter.appRouter,
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
