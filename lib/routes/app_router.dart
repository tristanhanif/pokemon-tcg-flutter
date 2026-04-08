import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/login_pages.dart';
import '../pages/register_pages.dart';
import 'app_routes.dart';
import '../providers/auth_provider.dart';

GoRouter createAppRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: AppRoutes.homePath,
    refreshListenable: authProvider,
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Page not found'))),
    redirect: (context, state) {
      final isLoggedIn = authProvider.isLoggedIn;

      final currentPath = state.uri.path;
      final isGoingToLogin = currentPath == AppRoutes.loginPath;
      final isGoingToRegister = currentPath == AppRoutes.registerPath;

      if (!isLoggedIn && !isGoingToLogin && !isGoingToRegister) {
        return AppRoutes.loginPath;
      }

      if (isLoggedIn && (isGoingToLogin || isGoingToRegister)) {
        return AppRoutes.homePath;
      }

      return null;
    },
    routes: [
      GoRoute(
        name: AppRoutes.homeName,
        path: AppRoutes.homePath,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Home Page'))),
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
