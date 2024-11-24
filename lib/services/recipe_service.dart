import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:resepmakanan/models/recipe_model.dart';
import 'package:resepmakanan/services/session_service.dart';

const String baseUrl = 'https://recipe.incube.id/api';

class RecipeService {
  final SessionService _sessionService = SessionService();

  Future<List<RecipeModel>> getAllRecipe() async {
    // Mendapatkan token
    final token = await _sessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan atau kosong");
    }

    // Mengirim permintaan GET ke API
    final response = await http.get(
      Uri.parse('$baseUrl/recipes'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // Memeriksa status respons
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      // Validasi data yang diterima
      if (jsonData['data'] != null && jsonData['data']['data'] != null) {
        final List<dynamic> recipeList = jsonData['data']['data'];
        return recipeList.map((json) => RecipeModel.fromJson(json)).toList();
      } else {
        throw Exception("Data API tidak valid");
      }
    } else {
      throw Exception("Gagal memuat data. Status: ${response.statusCode}");
    }
  }
}
