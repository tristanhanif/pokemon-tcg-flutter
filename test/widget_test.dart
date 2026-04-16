// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pokemon_tcg_flutter/main.dart';
import 'package:pokemon_tcg_flutter/providers/auth_provider.dart';
import 'package:pokemon_tcg_flutter/providers/pokemon_provider.dart';
import 'package:pokemon_tcg_flutter/providers/topup_provider.dart';

void main() {
  testWidgets('App loads home screen', (WidgetTester tester) async {
    // Create providers
    final authProvider = AuthProvider();
    final pokemonProvider = PokemonProvider(authProvider);
    final topupProvider = TopupProvider();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authProvider),
          ChangeNotifierProvider.value(value: pokemonProvider),
          ChangeNotifierProvider.value(value: topupProvider),
        ],
        child: const MyApp(),
      ),
    );

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Verify that the home screen title is present
    expect(find.text('Pokémon TCG Sets'), findsOneWidget);
  });
}
