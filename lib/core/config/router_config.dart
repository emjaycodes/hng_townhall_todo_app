import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';

import '../../common/constants/route_constant.dart';
import '../../screens/add_todo.dart';
import '../../screens/home_screen.dart';
import '../../screens/splash_screen.dart';
import '../../screens/success_screen.dart';


final GoRouter routerConfig = GoRouter(
    initialLocation: RoutesPath.splash,
    errorBuilder: (context, state) => const Placeholder(),
    routes: [
      GoRoute(
        path: RoutesPath.splash,
        pageBuilder: (context, state) => CupertinoPage<void>(
          child: const SplashScreen(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
          path: RoutesPath.homeScreen,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
                transitionDuration: const Duration(milliseconds: 500),
                barrierDismissible: false,
                key: state.pageKey,
                child: const HomeScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }),
      GoRoute(
          path: RoutesPath.addTodoScreen,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
                transitionDuration: const Duration(milliseconds: 500),
                barrierDismissible: false,
                key: state.pageKey,
                child: const AddTodoScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }),
      GoRoute(
          path: RoutesPath.successScreen,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
                transitionDuration: const Duration(milliseconds: 500),
                barrierDismissible: false,
                key: state.pageKey,
                child: const SuccessScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }),
    ]);
