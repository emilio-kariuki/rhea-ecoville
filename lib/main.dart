import 'package:ecoville/blocs/app/authentication/authentication_cubit.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/views/home/home.dart';
import 'package:flutter/services.dart';

const supabaseKey = String.fromEnvironment('ANON_KEY');
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://pkgfznuiqaixphqiynme.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBrZ2Z6bnVpcWFpeHBocWl5bm1lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTExOTQ3OTUsImV4cCI6MjAyNjc3MDc5NX0._XZG38PWJLZvyd7fU4mHqy-M1QnPFWS-d71FZB7iBbA",
      debug: false);
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          SizeConfig().init(constraints);
          return MaterialApp.router(
            routerConfig: AppRouter.appRouter,
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light,
            title: "Ecoville",
          );
        }
      ),
    );
  }
}

class Checker extends StatelessWidget {
  const Checker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        // TODO remember to update the location of the pages for authenticated and unauthenticated users
        if (state is Authenticated) {
          return const HomePage();
        } else if (state is Unauthenticated) {
          return const WelcomePage();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
