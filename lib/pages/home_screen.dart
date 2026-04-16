import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/pokemon_provider.dart';
import '../providers/auth_provider.dart';
import '../services/analytics_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Load Pokemon Sets on first init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      AnalyticsService.logScreenView('home_sets');
      context.read<PokemonProvider>().fetchPokemonSets();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      final provider = context.read<PokemonProvider>();
      if (!provider.isLoadingSets && provider.hasMoreSets) {
        provider.fetchPokemonSets();
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
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: AppBar(
        title: const Text('Pokémon TCG Sets'),
        elevation: 0,
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '💰 ${authProvider.balance}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellowAccent,
                    ),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () => context.push('/topup'),
                icon: const Icon(Icons.add),
                label: const Text('Top Up'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                context.read<PokemonProvider>().searchSets(value);
                AnalyticsService.logEvent(
                  'set_search',
                  parameters: {'query': value},
                );
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search sets...',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF16213e),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Consumer<PokemonProvider>(
              builder: (context, pokemonProvider, _) {
                final items = pokemonProvider.filteredPokemonSets;

                if (items.isEmpty && pokemonProvider.isLoadingSets) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                    ),
                  );
                }

                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      pokemonProvider.errorMessageSets ?? 'No sets found.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () =>
                      pokemonProvider.fetchPokemonSets(isRefresh: true),
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: items.length + 1,
                    itemBuilder: (context, index) {
                      if (index == items.length) {
                        // This part handles the last item (pagination + footer)
                        Widget paginationWidget;
                        if (pokemonProvider.isLoadingSets) {
                          paginationWidget = const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.amber,
                                ),
                              ),
                            ),
                          );
                        } else if (pokemonProvider.hasMoreSets) {
                          paginationWidget = Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ElevatedButton(
                              onPressed: () {
                                AnalyticsService.logEvent('load_more_sets');
                                pokemonProvider.fetchPokemonSets();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: const Text('Load More'),
                            ),
                          );
                        } else {
                          paginationWidget = const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Text(
                                'All sets loaded',
                                style: TextStyle(color: Colors.white54),
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            paginationWidget,
                            // Decorative Footer
                            Padding(
                              padding: const EdgeInsets.only(top: 24, bottom: 0),
                              child: Column(
                                children: [
                                  const Text(
                                    'Discover more sets in technical updates soon!',
                                    style: TextStyle(
                                      color: Colors.white24,
                                      fontSize: 10,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Image.asset(
                                    'assets/forest_footer.png',
                                    fit: BoxFit.fitWidth,
                                    width: double.infinity,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      final set = items[index];
                      return _buildSetCard(context, set);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetCard(BuildContext context, dynamic set) {
    return Card(
      margin: const EdgeInsets.only(bottom: 0),
      color: const Color(0xFF16213e),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          AnalyticsService.logEvent(
            'set_clicked',
            parameters: {'set_id': set.id},
          );
          context.push('/set/${set.id}', extra: set);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Hero(
                tag: 'set-image-${set.id}',
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF0f3460),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      set.logo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF0f3460),
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.white30,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      set.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      set.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.amber),
                          ),
                          child: Text(
                            '💰 ${set.price}',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward, color: Colors.white54),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
