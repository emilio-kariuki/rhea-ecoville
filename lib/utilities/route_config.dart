import 'package:ecoville/main.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/views/home/home_page.dart';
import 'package:ecoville/views/home/product_page.dart';

final GlobalKey<NavigatorState> parentNavigatorKey =
    GlobalKey<NavigatorState>();

final GlobalKey<NavigatorState> homeTabNavigatorKey =
    GlobalKey<NavigatorState>();

class AppRouter {
  static final appRouter = GoRouter(
    navigatorKey: parentNavigatorKey,
    
    initialLocation: '/checker', 
    routes: [
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
              child: HomePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
            ),
        redirect: (context, state) {
          final user = supabase.auth.currentUser;
          if (user == null) {
            return '/welcome';
          }
          return null;
        },
        routes: []),
         GoRoute(
        path: '/details',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: ProductDetailsPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
            ),
        redirect: (context, state) {
          final user = supabase.auth.currentUser;
          if (user == null) {
            return '/welcome';
          }
          return null;
        },
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
