import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipes_model.dart';

class RecipieRepository {
  final String baseUrl = 'https://api.spoonacular.com/recipes/complexSearch';
  final String apiKey = '5f49213d91e34457a121d6ad3892e0c8';

  /// Fetch recipes from the API with optional query and pagination.
  Future<Recipes> fetchRecipes({
    String query = '',
    int number = 10, // Default number of recipes per fetch
    int offset = 0,  // For pagination
  }) async {
    final uri = Uri.parse('$baseUrl?apiKey=$apiKey&query=$query&number=$number&offset=$offset');
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Parse and return the recipes
        return recipesFromJson(response.body);
      } else {
        // Handle non-200 responses
        throw Exception('Failed to load recipes: ${response.reasonPhrase}');
      }
    } catch (error) {
      // Handle network or parsing errors
      throw Exception('An error occurred while fetching recipes: $error');
    }
  }
}
