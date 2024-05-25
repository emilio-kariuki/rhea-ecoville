import 'package:ecoville/main.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/views/account/account_page.dart';
import 'package:ecoville/views/authentication/welcome_page.dart';
import 'package:ecoville/views/cart/cart_page.dart';
import 'package:ecoville/views/home.dart';
import 'package:ecoville/views/home/home_page.dart';
import 'package:ecoville/views/home/product_page.dart';
import 'package:ecoville/views/inbox/inbox_page.dart';
import 'package:ecoville/views/search/search_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(initialLocation: '/home', routes: [
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
    path: '/welcome',
    pageBuilder: (context, state) => CustomTransitionPage<void>(
      key: state.pageKey,
      child: const WelcomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  ),
  GoRoute(
    path: '/cart',
    name: Routes.cart,
    pageBuilder: (context, state) => CustomTransitionPage<void>(
      key: state.pageKey,
      child: const CartPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
    redirect: (context, state) {
      final user = supabase.auth.currentUser;
      if (user == null) {
        return '/welcome';
      }
      return null;
    },
  ),
  GoRoute(
    path: '/welcome',
    name: Routes.welcome,
    pageBuilder: (context, state) => CustomTransitionPage<void>(
      key: state.pageKey,
      child: const WelcomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  ),
  ShellRoute(
    navigatorKey: _rootNavigatorKey,
    builder: (context, state, child) => Home(child: child),
    routes: [
      GoRoute(
        path: '/home',
        name: Routes.home,
        pageBuilder: (context, state) => MaterialPage(child: HomePage()),
        routes: [
          GoRoute(
            path: 'details',
            name: Routes.details,
            builder: (context, state) =>  ProductDetailsPage(),
          ),
        ],
        redirect: (context, state) {
          final user = supabase.auth.currentUser;
          if (user == null) {
            return '/welcome';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/search',
        name: Routes.search,
        redirect: (context, state) {
          final user = supabase.auth.currentUser;
          if (user == null) {
            return '/welcome';
          }
          return null;
        },
        pageBuilder: (context, state) =>
            const MaterialPage(child: SearchPage()),
      ),
      GoRoute(
        path: '/account',
        name: Routes.account,
        redirect: (context, state) {
          final user = supabase.auth.currentUser;
          if (user == null) {
            return '/welcome';
          }
          return null;
        },
        pageBuilder: (context, state) =>
            const MaterialPage(child: AccountPage()),
      ),
      GoRoute(
        path: '/inbox',
        name: Routes.inbox,
        redirect: (context, state) {
          final user = supabase.auth.currentUser;
          if (user == null) {
            return '/welcome';
          }
          return null;
        },
        pageBuilder: (context, state) => const MaterialPage(child: InboxPage()),
      ),
    ],
  ),
]);

class Routes {
  static const String welcome = '/welcome';
  static const String checker = '/checker';
  static const String home = '/home';
  static const String details = '/home/details';
  static const String search = '/home/search';
  static const String account = '/home/account';
  static const String inbox = '/home/inbox';
  static const String cart = '/cart';
}
