import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../pages/home_screen.dart';
import '../pages/topup_screen.dart';
import '../pages/login_pages.dart';
import '../pages/register_pages.dart'; 
import '../providers/auth_provider.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  // Redirect untuk proteksi route
  redirect: (BuildContext context, GoRouterState state) {
    // Ambil auth state tanpa listen agar tidak build berulang di router
    final auth = context.read<AuthProvider>();
    
    final isGoingToLogin = state.matchedLocation == '/login' || state.matchedLocation == '/register';

    // Jika user belum login dan mencoba ke halaman selain login/register
    if (!auth.isLoggedIn && !isGoingToLogin) {
      return '/login';
    }

    // Jika user sudah login tapi mencoba mengakses login/register lagi
    if (auth.isLoggedIn && isGoingToLogin) {
      return '/';
    }

    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    // Route Dashboard / Home (Infinite Scroll Sets)
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    // Route Topup
    GoRoute(
      path: '/topup',
      builder: (context, state) => const TopupScreen(),
    ),
  ],
);
