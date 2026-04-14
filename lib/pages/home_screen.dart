import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/pokemon_provider.dart';
import '../components/card_component.dart';
import '../components/hero_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final List<String> _types = [
    'Grass', 'Fire', 'Water', 'Lightning', 'Psychic', 'Fighting', 'Darkness', 'Metal', 'Fairy', 'Dragon', 'Colorless'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PokemonProvider>().fetchCards(isRefresh: true);
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<PokemonProvider>();
      if (!provider.isLoading && provider.hasMore) {
        provider.fetchCards();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF0F0F0F); // Very dark background like the reference

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Hero Section
          SliverToBoxAdapter(
            child: const HeroSection(heroType: 'Grass'), // Will make dynamic later
          ),

          // Filters and Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Row(
                children: [
                  // Type Filter
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Filter by type:', style: TextStyle(color: Colors.white54, fontSize: 12)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _types.map((t) => _buildTypeMiniBadge(t)).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Search Bar
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Find your pokemon:', style: TextStyle(color: Colors.white54, fontSize: 12)),
                        const SizedBox(height: 8),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (val) => context.read<PokemonProvider>().searchCards(val),
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText: 'I choose you!',
                                    hintStyle: TextStyle(color: Colors.white30, fontSize: 14),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                ),
                              ),
                              Container(
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(child: Icon(Icons.search, color: Colors.white, size: 20)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Cards Grid
          Consumer<PokemonProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.cards.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: Colors.green)),
                );
              }

              if (provider.cards.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text('No pokemon found.', style: TextStyle(color: Colors.white54)),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.6, // Adjusted for taller cards with stats
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 24,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == provider.cards.length) {
                        return const Center(child: CircularProgressIndicator(color: Colors.green));
                      }
                      return CardComponent(card: provider.cards[index]);
                    },
                    childCount: provider.cards.length + (provider.hasMore ? 1 : 0),
                  ),
                ),
              );
            },
          ),
          
          // Forest Footer
          SliverToBoxAdapter(
             child: Container(
               height: 100,
               margin: const EdgeInsets.only(top: 40),
               decoration: const BoxDecoration(
                 image: DecorationImage(
                   image: AssetImage('assets/forest_footer.png'), // Placeholder
                   fit: BoxFit.cover,
                   alignment: Alignment.topCenter,
                 )
               ),
               // Fallback if asset isn't ready
               child: Stack(
                 children: [
                   Positioned(
                     bottom: 0, left: 0, right: 0,
                     child: Container(height: 50, color: const Color(0xFF1B3D23)),
                   )
                 ],
               ),
             ),
          )
        ],
      ),
    );
  }

  Widget _buildTypeMiniBadge(String type) {
    Color color;
    switch (type.toLowerCase()) {
      case 'grass': color = const Color(0xFF4DAD5B); break;
      case 'fire': color = const Color(0xFFE5734A); break;
      case 'water': color = const Color(0xFF5090D6); break;
      case 'lightning': color = const Color(0xFFF2D94E); break;
      case 'psychic': color = const Color(0xFFA664BF); break;
      case 'fighting': color = const Color(0xFFD67831); break;
      case 'darkness': color = const Color(0xFF5A5366); break;
      case 'metal': color = const Color(0xFF9EA3AC); break;
      case 'fairy': color = const Color(0xFFEC8FE6); break;
      case 'dragon': color = const Color(0xFF0F6AC0); break;
      case 'colorless': color = const Color(0xFFA0A29F); break;
      default: color = const Color(0xFFA0A29F); break;
    }

    return Container(
      margin: const EdgeInsets.only(right: 6),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

