import 'package:ecoville/main.dart';
import 'package:ecoville/screens/account/categories_page.dart';
import 'package:ecoville/screens/cart/checkout_page.dart';
import 'package:ecoville/screens/messages/chat_page.dart';
import 'package:ecoville/screens/messages/messages_page.dart';
import 'package:ecoville/screens/settings/add_address_page.dart';
import 'package:ecoville/screens/settings/address_page.dart';
import 'package:ecoville/screens/settings/edit_address_page.dart';
import 'package:ecoville/screens/settings/settings_page.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/screens/account/account_page.dart';
import 'package:ecoville/screens/account/favourite_product_page.dart';
import 'package:ecoville/screens/account/saved_products_page.dart';
import 'package:ecoville/screens/account/watchlist_product_page.dart';
import 'package:ecoville/screens/account/wishlist_products_page.dart';
import 'package:ecoville/screens/authentication/welcome_page.dart';
import 'package:ecoville/screens/cart/cart_page.dart';
import 'package:ecoville/screens/home.dart';
import 'package:ecoville/screens/home/home_page.dart';
import 'package:ecoville/screens/home/product_page.dart';
import 'package:ecoville/screens/inbox/inbox_page.dart';
import 'package:ecoville/screens/search/search_page.dart';
import 'package:ecoville/screens/seller/rating_items.dart';
import 'package:ecoville/screens/seller/sellers_items.dart';
import 'package:ecoville/screens/seller/selling_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
    observers: [
      PosthogObserver(),
    ],
    initialLocation: '/home',
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
        builder: (context, state) => CartPage(),
        redirect: (context, state) {
          final user = supabase.auth.currentUser;
          if (user == null) {
            return '/welcome';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/checkout',
        name: Routes.checkout,
        builder: (context, state) => CheckoutPage(),
        redirect: (context, state) {
          final user = supabase.auth.currentUser;
          if (user == null) {
            return '/welcome';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/settings',
        name: Routes.settings,
        builder: (context, state) => SettingsPage(),
        redirect: (context, state) {
          final user = supabase.auth.currentUser;
          if (user == null) {
            return '/welcome';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/address',
        name: Routes.address,
        builder: (context, state) => AddressPage(),
        redirect: (context, state) {
          final user = supabase.auth.currentUser;
          if (user == null) {
            return '/welcome';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/addAddress',
        name: Routes.addAddress,
        builder: (context, state) => AddAddressPage(),
        redirect: (context, state) {
          final user = supabase.auth.currentUser;
          if (user == null) {
            return '/welcome';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/editAddress',
        name: Routes.editAddress,
        builder: (context, state) {
          final data = state.extra;
          return EditAddressPage(
            id: (data as Map)['id'],
          );
        },
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
          path: '/messages',
          name: Routes.messages,
          builder: (context, state) => const MessagesPage(),
          redirect: (context, state) {
            final user = supabase.auth.currentUser;
            if (user == null) {
              return '/welcome';
            }
            return null;
          },
          routes: [
            GoRoute(
              path: 'chat/:seller/:conversationId',
              pageBuilder: (context, state) {
                final id = state.pathParameters['seller'];
                final conversationId = state.pathParameters['conversationId'];
                return CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: ChatPage(
                    sellerId: id!,
                    conversationId: conversationId!,
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                );
              },
              redirect: (context, state) {
                final user = supabase.auth.currentUser;
                if (user == null) {
                  return '/welcome';
                }
                return null;
              },
            ),
          ]),
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
                GoRoute(
                    path: 'categories',
                    name: Routes.categories,
                    builder: (context, state) {
                      return const CategoriesPage();
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
            pageBuilder: (context, state) => MaterialPage(child: InboxPage()),
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
  static const String categories = '/account/categories';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String selling = '/selling';
  static const String ratings = '/ratings';
  static const String saved = '/account/saved';
  static const String wishlist = '/account/wishlist';
  static const String watchlist = '/account/watchlist';
  static const String liked = '/account/liked';
  static const String settings = '/settings';
  static const String address = '/address';
  static const String addAddress = '/addAddress';
  static const String editAddress = '/editAddress';
  static const String messages = '/messages';
}
