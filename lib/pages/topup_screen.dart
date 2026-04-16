import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../providers/pokemon_provider.dart';
import '../providers/auth_provider.dart';

class TopupScreen extends StatefulWidget {
  const TopupScreen({super.key});

  @override
  State<TopupScreen> createState() => _TopupScreenState();
}

class _TopupScreenState extends State<TopupScreen> {
  final TextEditingController _amountController = TextEditingController();
  final formatRupiah = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
  
  final bgColor = const Color(0xFF0F0F0F); 
  final cardBgColor = const Color(0xFF1E1E1E);
  final accentOrange = const Color(0xFFE5734A); 

  void _submitTopup() async {
    final amountText = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid amount')));
      return;
    }

    final amount = int.parse(amountText);
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Amount must be greater than 0')));
      return;
    }

    final provider = context.read<PokemonProvider>();
    final success = await provider.topup(amount);

    if (!mounted) return;

    if (success) {
      _showSuccessDialog(amount);
      _amountController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? 'Topup Failed'), backgroundColor: Colors.redAccent),
      );
    }
  }

  void _showSuccessDialog(int amount) {
    final authProvider = context.read<AuthProvider>();
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: accentOrange.withOpacity(0.5), width: 2),
                boxShadow: [
                  BoxShadow(color: accentOrange.withOpacity(0.2), blurRadius: 40, spreadRadius: 10),
                ]
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
                  const SizedBox(height: 16),
                  const Text('Topup Successful!', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text('Added ${formatRupiah.format(amount)} to your wallet.', style: const TextStyle(color: Colors.white70, fontSize: 14), textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text('New Balance', style: TextStyle(color: Colors.white54, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(formatRupiah.format(authProvider.balance), style: TextStyle(color: accentOrange, fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentOrange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Awesome!', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: child,
          ),
        );
      },
    );
  }

  void _setQuickNominal(int value) {
    _amountController.text = value.toString();
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
        title: SizedBox(
           height: 40,
           child: Image.network('https://upload.wikimedia.org/wikipedia/commons/9/98/International_Pok%C3%A9mon_logo.svg', color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Digital Wallet', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Fund your adventures and collect more cards.', style: TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(height: 32),
            
            // Professional "Poke-Card" Wallet
            _buildWalletCard(),
            
            const SizedBox(height: 40),
            
            const Text('Amount to Topup', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            
            // Premium Input Field
            _buildAmountInput(),
            
            const SizedBox(height: 32),
            
            const Text('Select Package', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            
            // Interactive 2x2 Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 2.2,
              children: [
                _buildQuickNominalButton(50000, 'Poké Ball', Icons.catching_pokemon),
                _buildQuickNominalButton(100000, 'Great Ball', Icons.catching_pokemon, isPopular: true),
                _buildQuickNominalButton(250000, 'Ultra Ball', Icons.catching_pokemon),
                _buildQuickNominalButton(500000, 'Master Ball', Icons.catching_pokemon),
              ],
            ),
            
            const SizedBox(height: 48),
            
            // Submit Button
            Consumer<PokemonProvider>(
              builder: (context, provider, child) {
                return ElevatedButton(
                  onPressed: provider.isLoading ? null : _submitTopup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentOrange,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 10,
                    shadowColor: accentOrange.withOpacity(0.5),
                  ),
                  child: provider.isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                      )
                    : const Text('Proceed to Payment', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                );
              }
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2A2A3A),
            Color(0xFF1E1E2A),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(Icons.account_balance_wallet, size: 150, color: Colors.white.withOpacity(0.02)),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.contactless, color: Colors.white.withOpacity(0.5)),
                    const Text('TRAINER CARD', style: TextStyle(color: Colors.white54, letterSpacing: 2, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Current Balance', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    Consumer<AuthProvider>(
                      builder: (context, auth, child) {
                        return Text(
                          formatRupiah.format(auth.balance),
                          style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: 1),
                        );
                      }
                    ),
                  ],
                ),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) => Text(
                    auth.currentUser?.name.toUpperCase() ?? 'GUEST TRAINER',
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1.5),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        style: TextStyle(color: accentOrange, fontSize: 24, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          prefixText: 'Rp ',
          prefixStyle: TextStyle(color: accentOrange.withOpacity(0.5), fontSize: 24, fontWeight: FontWeight.bold),
          border: InputBorder.none,
          hintText: '0',
          hintStyle: TextStyle(color: Colors.white24, fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildQuickNominalButton(int amount, String label, IconData icon, {bool isPopular = false}) {
    return InkWell(
      onTap: () => _setQuickNominal(amount),
      borderRadius: BorderRadius.circular(16),
      splashColor: accentOrange.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isPopular ? accentOrange : Colors.white10, width: isPopular ? 2 : 1),
          boxShadow: isPopular ? [BoxShadow(color: accentOrange.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))] : [],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
             Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: isPopular ? accentOrange : Colors.white54, size: 20),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(label, style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(formatRupiah.format(amount), style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ],
             ),
             if (isPopular)
                Positioned(
                  top: -20,
                  right: -10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: accentOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('POPULAR', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                  ),
                )
          ],
        ),
      ),
    );
  }
}

