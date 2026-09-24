import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/authenticated_home_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'route_names.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'rootNav');

  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: RouteNames.initial,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        // Let SplashPage display doodle animation before navigation
        if (state.matchedLocation == RouteNames.initial) {
          return null;
        }

        final authState = authBloc.state;
        final isAuthenticated = authState is AuthenticatedState;
        final isAuthRoute =
            state.matchedLocation == RouteNames.login ||
            state.matchedLocation == RouteNames.register ||
            state.matchedLocation == RouteNames.forgotPassword;

        if (authState is AuthInitialState || authState is AuthLoadingState) {
          return null;
        }

        if (!isAuthenticated) {
          return isAuthRoute ? null : RouteNames.login;
        }

        if (isAuthRoute) {
          return RouteNames.dashboard;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: RouteNames.initial,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SplashPage(),
            transitionDuration: const Duration(milliseconds: 650),
            reverseTransitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
                CurvedAnimation(
                  parent: secondaryAnimation,
                  curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
                ),
              );
              final scaleOut = Tween<double>(begin: 1.0, end: 0.94).animate(
                CurvedAnimation(
                  parent: secondaryAnimation,
                  curve: Curves.easeOutCubic,
                ),
              );
              return FadeTransition(
                opacity: fadeOut,
                child: ScaleTransition(
                  scale: scaleOut,
                  child: child,
                ),
              );
            },
          ),
        ),
        GoRoute(
          path: RouteNames.login,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const LoginPage(),
            transitionDuration: const Duration(milliseconds: 650),
            reverseTransitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final curve = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              );
              return FadeTransition(
                opacity: curve,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.05),
                    end: Offset.zero,
                  ).animate(curve),
                  child: child,
                ),
              );
            },
          ),
        ),
        GoRoute(
          path: RouteNames.register,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const RegisterPage(),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: RouteNames.forgotPassword,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ForgotPasswordPage(),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: RouteNames.dashboard,
          pageBuilder: (context, state) {
            final authState = authBloc.state;
            final page = authState is AuthenticatedState
                ? AuthenticatedHomePage(user: authState.user)
                : const LoginPage();
            return CustomTransitionPage(
              key: state.pageKey,
              child: page,
              transitionDuration: const Duration(milliseconds: 600),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutCubic,
                  ),
                  child: child,
                );
              },
            );
          },
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Route not found: ${state.uri.toString()}'),
        ),
      ),
    );
  }
}
