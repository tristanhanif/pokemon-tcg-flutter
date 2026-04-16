import 'package:flutter/material.dart';
import '../models/pokemon_set_model.dart';
import '../services/analytics_service.dart';

class SetDetailScreen extends StatefulWidget {
  final PokemonSet pokemonSet;

  const SetDetailScreen({super.key, required this.pokemonSet});

  @override
  State<SetDetailScreen> createState() => _SetDetailScreenState();
}

class _SetDetailScreenState extends State<SetDetailScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.logScreenView('set_detail');
  }

  @override
  Widget build(BuildContext context) {
    final set = widget.pokemonSet;

    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: AppBar(
        title: Text(set.name),
        backgroundColor: const Color(0xFF16213e),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'set-image-${set.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  set.logo,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 220,
                    color: const Color(0xFF0f3460),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.white30,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              set.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Price: ${set.price}',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'ID: ${set.id}',
                  style: const TextStyle(color: Colors.white54),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              set.description,
              style: const TextStyle(color: Colors.white70, height: 1.6),
            ),
            const SizedBox(height: 28),
            const Text(
              'About this set',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF16213e),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Detail page menampilkan informasi package set, harga, dan deskripsi. Jika API set detail tersedia nanti, fitur ini dapat dikembangkan lebih lanjut untuk memuat kartu individu.',
                style: TextStyle(color: Colors.white60, height: 1.5),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  AnalyticsService.logEvent(
                    'view_cards_clicked',
                    parameters: {'set_id': set.id},
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Detail cards belum tersedia.'),
                    ),
                  );
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text('View cards from set'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
