import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config/color/colors.dart';
import '../../config/componets/text_custom.dart';
class DetailedPage extends StatefulWidget {
  final int recipeId;
  const DetailedPage({Key? key, required this.recipeId}) : super(key: key);

  @override
  _IngredientsPageState createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<DetailedPage> {
  late Future<Map<String, dynamic>> recipeDetails;

  Future<Map<String, dynamic>> fetchRecipeDetails() async {
    final String apiKey = '5f49213d91e34457a121d6ad3892e0c8';
    final String apiUrl =
        'https://api.spoonacular.com/recipes/${widget.recipeId}/information?apiKey=$apiKey&includeNutrition=false';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load recipe details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    recipeDetails = fetchRecipeDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.darkBgColor,
        elevation: 1,leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back_ios_outlined,color: AppColor.darkFontColor,)),
        title: TextCustom(text: "Recipe",textSize: 18,fontWeight: FontWeight.bold,),
      ),

      body: FutureBuilder<Map<String, dynamic>>(
        future: recipeDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            final data = snapshot.data!;
            final ingredients = data['extendedIngredients'] as List;
            return ListView.builder(
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = ingredients[index];
                return ListTile(
                  title: Text(ingredient['name']),
                  subtitle:
                      Text('${ingredient['amount']} ${ingredient['unit']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
