import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
class RecipeRepository {
  Future<Map<String, dynamic>> postRecipe({
    required String title,
    required String ingredients,
    required String instructions,
    required String readyInMinutes,
    required String servings,
    File? image,
  }) async {
    const String apiUrl =
        'https://api.spoonacular.com/recipes/visualizeRecipe?apiKey=5f49213d91e34457a121d6ad3892e0c8';

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['title'] = title;
    request.fields['ingredients'] = ingredients;
    request.fields['instructions'] = instructions;
    request.fields['readyInMinutes'] = readyInMinutes;
    request.fields['servings'] = servings;
    request.fields['mask'] = 'ellipseMask';
    request.fields['backgroundColor'] = '#ffffff';
    request.fields['fontColor'] = '#333333';

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      return jsonDecode(responseBody);
    } else {
      throw Exception('Failed to post recipe: ${response.reasonPhrase}');
    }
  }
}