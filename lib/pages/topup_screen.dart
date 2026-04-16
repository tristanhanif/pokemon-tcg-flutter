import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/pokemon_provider.dart';
import '../providers/topup_provider.dart';
import '../providers/auth_provider.dart';

class TopupScreen extends StatefulWidget {
  const TopupScreen({super.key});

  @override
  State<TopupScreen> createState() => _TopupScreenState();
}

class _TopupScreenState extends State<TopupScreen> {
  final TextEditingController _amountController = TextEditingController();
  final formatRupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  final bgColor = const Color(0xFF1a1a2e);
  final cardBgColor = const Color(0xFF16213e);
  final accentOrange = const Color(0xFFf7b731);

  Future<void> _processTopup(int amount) async {
    final pokemonProvider = context.read<PokemonProvider>();
    final topupProvider = context.read<TopupProvider>();

    topupProvider.clearMessages();
    topupProvider.setProcessing(true);

    final success = await pokemonProvider.topup(amount);

    if (!mounted) return;

    topupProvider.setProcessing(false);

    if (success) {
      topupProvider.setSuccessMessage('Top up berhasil!');
      topupProvider.clearSelection();
      _showSuccessDialog(amount);
    } else {
      topupProvider.setErrorMessage(
        pokemonProvider.errorMessage ?? 'Top up gagal',
      );
    }
  }

  void _showSuccessDialog(int amount) {
    final authProvider = context.read<AuthProvider>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: cardBgColor,
          title: const Text(
            'Top Up Berhasil!',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              Text(
                'Saldo telah ditambahkan sebesar ${formatRupiah.format(amount)}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              Text(
                'Saldo baru: ${formatRupiah.format(authProvider.balance)}',
                style: const TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Top Up'),
        backgroundColor: cardBgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Saldo Kamu',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        formatRupiah.format(authProvider.balance),
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Masukkan jumlah topup',
                  labelStyle: const TextStyle(color: Colors.white54),
                  prefixText: 'Rp ',
                  prefixStyle: const TextStyle(color: Colors.amber),
                  border: InputBorder.none,
                  hintText: '50000',
                  hintStyle: const TextStyle(color: Colors.white24),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Pilih Paket',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Consumer<TopupProvider>(
              builder: (context, topupProvider, _) {
                return GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                  children: topupProvider.topupItems.map((item) {
                    final isSelected =
                        topupProvider.selectedItem?.id == item.id;
                    return _buildTopupCard(
                      item.name,
                      item.amount,
                      item.icon,
                      () {
                        topupProvider.selectItem(item);
                        _amountController.text = item.amount.toString();
                      },
                      isSelected,
                      topupProvider.isProcessing,
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            Consumer2<PokemonProvider, TopupProvider>(
              builder: (context, pokemonProvider, topupProvider, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (topupProvider.errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          topupProvider.errorMessage!,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentOrange,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: topupProvider.isProcessing
                          ? null
                          : () {
                              final amountText = _amountController.text
                                  .replaceAll(RegExp(r'[^0-9]'), '');
                              if (amountText.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Masukkan jumlah topup yang valid',
                                    ),
                                  ),
                                );
                                return;
                              }
                              final amount = int.tryParse(amountText) ?? 0;
                              if (amount <= 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Jumlah harus lebih besar dari 0',
                                    ),
                                  ),
                                );
                                return;
                              }
                              _processTopup(amount);
                            },
                      child: pokemonProvider.isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Top Up Sekarang',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopupCard(
    String title,
    int amount,
    String icon,
    VoidCallback onTap,
    bool isSelected,
    bool isLoading,
  ) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber.withValues(alpha: 0.2) : cardBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Colors.amber : Colors.white12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon.contains('assets/')
                ? Image.asset(icon, height: 40)
                : Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Text(
              formatRupiah.format(amount),
              style: const TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
