import 'package:ecoville/main.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/views/account/account_page.dart';
import 'package:ecoville/views/account/favourite_product_page.dart';
import 'package:ecoville/views/account/saved_products_page.dart';
import 'package:ecoville/views/account/watchlist_product_page.dart';
import 'package:ecoville/views/account/wishlist_products_page.dart';
import 'package:ecoville/views/authentication/welcome_page.dart';
import 'package:ecoville/views/cart/cart_page.dart';
import 'package:ecoville/views/home.dart';
import 'package:ecoville/views/home/home_page.dart';
import 'package:ecoville/views/home/product_page.dart';
import 'package:ecoville/views/inbox/inbox_page.dart';
import 'package:ecoville/views/search/search_page.dart';
import 'package:ecoville/views/seller/rating_items.dart';
import 'package:ecoville/views/seller/sellers_items.dart';
import 'package:ecoville/views/seller/selling_page.dart';

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
    path: '/seller_items',
    pageBuilder: (context, state) => CustomTransitionPage<void>(
      key: state.pageKey,
      child: const SellersItems(),
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
              path: 'details/:id',
              name: Routes.details,
              builder: (context, state) {
                final id = state.pathParameters['id'];
                final data = state.extra;
                return ProductDetailsPage(
                  id: id!,
                  title: (data as Map)['title'],
                );
              }),
          GoRoute(
              path: 'ratings',
              name: Routes.ratings,
              builder: (context, state) {
                final data = state.extra;
                return RatingsItem(
                  id: (data as Map)['id'],
                  sellerId: (data)['sellerId'],
                  name: (data)['name'],
                );
              }),
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
          routes: [
            GoRoute(
                path: 'saved',
                name: Routes.saved,
                builder: (context, state) {
                  return const SavedProductsPage();
                }),
            GoRoute(
                path: 'wishlist',
                name: Routes.wishlist,
                builder: (context, state) {
                  return const WishlistProductsPage();
                }),
            GoRoute(
                path: 'watchlist',
                name: Routes.watchlist,
                builder: (context, state) {
                  return const WatchlistProductsPage();
                }),
                GoRoute(
                path: 'liked',
                name: Routes.liked,
                builder: (context, state) {
                  return const LikedProductsPage();
                }),
          ]),
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
      GoRoute(
        path: '/selling',
        name: Routes.selling,
        redirect: (context, state) {
          final user = supabase.auth.currentUser;
          if (user == null) {
            return '/welcome';
          }
          return null;
        },
        pageBuilder: (context, state) => MaterialPage(child: SellingPage()),
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
  static const String selling = '/selling';
  static const String ratings = '/ratings';
  static const String saved = '/saved';
  static const String wishlist = '/wishlist';
  static const String watchlist = '/watchlist';
    static const String liked = '/liked';

}
