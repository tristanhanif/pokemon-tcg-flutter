import 'package:flutter/material.dart';
import '../models/pokemon_card_model.dart';
import 'package:intl/intl.dart';

class CardComponent extends StatelessWidget {
  final PokemonCard card;
  const CardComponent({super.key, required this.card});

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'grass': return const Color(0xFF4DAD5B);
      case 'fire': return const Color(0xFFE5734A);
      case 'water': return const Color(0xFF5090D6);
      case 'lightning': return const Color(0xFFF2D94E);
      case 'psychic': return const Color(0xFFA664BF);
      case 'fighting': return const Color(0xFFD67831);
      case 'darkness': return const Color(0xFF5A5366);
      case 'metal': return const Color(0xFF9EA3AC);
      case 'fairy': return const Color(0xFFEC8FE6);
      case 'dragon': return const Color(0xFF0F6AC0);
      case 'colorless': return const Color(0xFFA0A29F);
      default: return const Color(0xFFA0A29F);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryTypeColor = _getTypeColor(card.types.first);
    final mockHeight = ((card.name.length * 0.1) + 0.5).toStringAsFixed(1) + ' M';
    final mockWeight = ((card.name.length * 5) + 5.0).toStringAsFixed(1) + ' KG';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle glow behind the card based on type
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryTypeColor.withOpacity(0.2),
                    blurRadius: 40,
                    spreadRadius: 20,
                  )
                ]
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top section: Image
                Expanded(
                  flex: 3,
                  child: Hero(
                    tag: 'card_${card.id}',
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Image.network(
                          card.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24, size: 40),
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Bottom section: Details
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Text(
                        '• ${card.name} •',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      // Type Badges
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        alignment: WrapAlignment.center,
                        children: card.types.map((t) => _buildTypeBadge(t)).toList(),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Mock Stats (Height/Weight per design)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn(mockHeight, 'Height', Icons.height),
                          _buildStatColumn(mockWeight, 'Weight', Icons.fitness_center),
                        ],
                      ),
                      
                      const Spacer(),
                      
                      // Action Button
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.flash_on, color: primaryTypeColor, size: 14),
                            const SizedBox(width: 4),
                            const Text(
                              'More Details',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(String type) {
    Color color = _getTypeColor(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        type.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, IconData icon) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white54, size: 10),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
