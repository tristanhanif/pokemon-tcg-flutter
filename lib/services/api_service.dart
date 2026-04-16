import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'https://api-tcg-backend.vercel.app/api';

  /// Get Bearer Token (untuk header Authorization)
  static String _getBearerToken(String token) => 'Bearer $token';

  /// 📦 Fetch Pokemon Sets dengan pagination
  static Future<Map<String, dynamic>> fetchPokemonSets({
    required String bearerToken,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/pokemon/sets?page=$page&limit=$limit');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': _getBearerToken(bearerToken),
        },
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      }

      return {
        'success': false,
        'message': 'Failed to fetch sets: ${response.statusCode}',
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  /// 💳 Topup Balance
  static Future<Map<String, dynamic>> topupBalance({
    required String bearerToken,
    required int amount,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/users/topup');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': _getBearerToken(bearerToken),
        },
        body: jsonEncode({'amount': amount}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'balance': data['data']?['saldo_baru'] ?? data['saldo_baru'] ?? 0,
        };
      }

      return {
        'success': false,
        'message': 'Topup failed: ${response.statusCode}',
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
