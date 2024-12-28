import 'package:http/http.dart' as http;
import '../models/recipes_model.dart';
class RecipieRepository {
  final String baseUrl = 'https://api.spoonacular.com/recipes/complexSearch';
  final String apiKey = '5f49213d91e34457a121d6ad3892e0c8';
  Future<Recipes> fetchRecipes({
    String query = '',
    int number = 10,
    int offset = 0,
  }) async {
    final uri = Uri.parse('$baseUrl?apiKey=$apiKey&query=$query&number=$number&offset=$offset');
    try {
      final response = await http.get(uri);
      switch (response.statusCode) {
        case 200:print("object");
          return recipesFromJson(response.body);
        case 201:
          throw Exception('Resource created unexpectedly.');
        case 400:
          throw Exception('Bad Request: The server could not understand the request.');
        case 401:
          throw Exception('Unauthorized: Invalid API key or permissions.');
        case 404:
          throw Exception('Resource Not Found: The requested resource could not be found.');
        case 500:
          throw Exception('Internal Server Error: Something went wrong on the server.');
        default:
          throw Exception('Unexpected Error: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (error) {
      throw Exception('An error occurred while fetching recipes: $error');
    }
  }
}
