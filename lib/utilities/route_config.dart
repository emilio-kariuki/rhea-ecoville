import 'package:ecoville/main.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/views/home.dart';

class AppRouter {
  static final appRouter = GoRouter(initialLocation: '/checker', routes: [
    GoRoute(
      path: '/checker',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const Checker(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
        path: '/home',
        name: Routes.home,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child:  Home(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
            ),
        routes: []),
  ]);
}

class Routes {
  //* Authentication

  static const String checker = '/checker';
  static const String auth = '/auth';
  static const String welcome = '/auth/welcome';

  //* Home
  static const String home = '/home';
}
