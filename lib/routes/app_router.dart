import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/login_pages.dart';
import '../pages/register_pages.dart';
import '../pages/splash_page.dart';
import '../pages/home_screen.dart';
import '../pages/topup_screen.dart';
import '../pages/set_detail_screen.dart';
import 'app_routes.dart';
import '../providers/auth_provider.dart';

GoRouter createAppRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: AppRoutes.splashPath,
    refreshListenable: authProvider,
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Page not found'))),
    redirect: (context, state) {
      final isLoggedIn = authProvider.isLoggedIn;

      final currentPath = state.uri.path;
      final isGoingToSplash = currentPath == AppRoutes.splashPath;
      final isGoingToLogin = currentPath == AppRoutes.loginPath;
      final isGoingToRegister = currentPath == AppRoutes.registerPath;

      if (isGoingToSplash) {
        return null;
      }

      // if (!isLoggedIn && !isGoingToLogin && !isGoingToRegister) {
      //   return AppRoutes.loginPath;
      // }

      if (isLoggedIn && (isGoingToLogin || isGoingToRegister)) {
        return AppRoutes.homePath;
      }

      return null;
    },
    routes: [
      GoRoute(
        name: AppRoutes.splashName,
        path: AppRoutes.splashPath,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        name: AppRoutes.homeName,
        path: AppRoutes.homePath,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: AppRoutes.topupName,
        path: AppRoutes.topupPath,
        builder: (context, state) => const TopupScreen(),
      ),
      GoRoute(
        name: AppRoutes.setDetailName,
        path: AppRoutes.setDetailPath,
        builder: (context, state) {
          final set = state.extra as dynamic;
          if (set == null) {
            return const Scaffold(
              body: Center(child: Text('Set details tidak tersedia')),
            );
          }
          return SetDetailScreen(pokemonSet: set);
        },
      ),
      GoRoute(
        name: AppRoutes.loginName,
        path: AppRoutes.loginPath,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: AppRoutes.registerName,
        path: AppRoutes.registerPath,
        builder: (context, state) => const RegisterPage(),
      ),
    ],
  );
}
