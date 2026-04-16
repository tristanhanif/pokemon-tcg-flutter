import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/pokemon_provider.dart';
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
      brightness: Brightness.light,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, PokemonProvider>(
          create: (context) => PokemonProvider(context.read<AuthProvider>()),
          update: (context, auth, previous) => PokemonProvider(auth),
        ),
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
              appBarTheme: AppBarTheme(
                centerTitle: false,
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
            ),
          );
        },
      ),
    );
  }
}
