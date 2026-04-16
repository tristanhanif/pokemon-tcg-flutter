import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/pokemon_provider.dart';
import 'providers/topup_provider.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFF7573C),
      brightness: Brightness.dark,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, PokemonProvider>(
          create: (context) => PokemonProvider(context.read<AuthProvider>()),
          update: (context, auth, previous) => PokemonProvider(auth),
        ),
        ChangeNotifierProvider(create: (_) => TopupProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Pokémon TCG App',
            routerConfig: createAppRouter(authProvider),
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: colorScheme,
              scaffoldBackgroundColor: const Color(0xFF1a1a2e),
              appBarTheme: AppBarTheme(
                centerTitle: false,
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              cardTheme: const CardThemeData(
                color: Color(0xFF16213e),
                elevation: 8,
              ),
            ),
          );
        },
      ),
    );
  }
}
