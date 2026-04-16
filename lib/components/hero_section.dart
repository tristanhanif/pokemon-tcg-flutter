import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  final dynamic featuredCard; // Using dynamic or PokemonCard
  final String heroType;

  const HeroSection({super.key, this.featuredCard, required this.heroType});

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'grass': return const Color(0xFF4DAD5B); // Match design green
      case 'fire': return const Color(0xFFE5734A);
      case 'water': return const Color(0xFF5090D6);
      default: return const Color(0xFF4DAD5B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getTypeColor(heroType);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Center(
            child: SizedBox(
               height: 60,
               child: Image.network('https://upload.wikimedia.org/wikipedia/commons/9/98/International_Pok%C3%A9mon_logo.svg', color: Colors.white),
            ),
          ),
          const SizedBox(height: 30),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Info Area
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      featuredCard?.name ?? 'Ivysaur',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildBadge(Icons.eco, 'GRASS'),
                        const SizedBox(width: 8),
                        _buildBadge(Icons.science, 'POISON'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      featuredCard?.flavorText ?? 
                      "Ivysaur is the evolution of Bulbasaur... A reliable partner, ideal for trainers seeking a versatile Pokémon capable of facing various challenges.",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        height: 1.5,
                      ),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.flash_on, color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Text('More details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              
              // Image Area
              Expanded(
                flex: 1,
                child: Hero(
                  tag: 'featured_pokemon',
                  child: Image.network(
                    featuredCard?.images?.large ?? 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/002.png',
                    fit: BoxFit.contain,
                    height: 250,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }
}
