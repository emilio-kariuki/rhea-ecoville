import 'package:ecoville/main.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/views/home/home.dart';

class AppRouter {
  static final appRouter = GoRouter(initialLocation: '/checker', routes: [
    GoRoute(
      path: '/checker',
     pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child:  const Checker(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity:animation, child: child),
            ),
    ),
    GoRoute(
        path: '/auth',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child:  const WelcomePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity:animation, child: child),
            ),
        routes: [
          GoRoute(
            path: 'welcome',
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child:  const WelcomePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity:animation, child: child),
            ),
          ),
          GoRoute(
            path: 'login',
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child:   LoginPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity:animation, child: child),
            ),
          ),
          GoRoute(
            path: 'register',
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child:   RegisterPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity:animation, child: child),
            ),
          ),
          GoRoute(
            path: 'forgot',
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child:   ForgotPasswordPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity:animation, child: child),
            ),
          ),
        ]),
         GoRoute(
        path: '/home',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child:   HomePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity:animation, child: child),
            ),
        routes: [
          
        ]),
  ]);
}

class AppRoute {
  //* Authentication

  static const String checker = '/checker';
  static const String auth = '/auth';
  static const String welcome = '/auth/welcome';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgot = '/auth/forgot';

  //* Home
    static const String home = '/home';

}
