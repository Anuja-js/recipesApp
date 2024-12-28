import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';

class AddRecipe extends StatefulWidget {
  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();

  Future<void> postRecipe() async {
    const String apiUrl =
        'https://api.spoonacular.com/recipes/visualizeRecipe?apiKey=5f49213d91e34457a121d6ad3892e0c8';

    // Create the request body
    Map<String, dynamic> body = {
      "title": titleController.text,
      "ingredients": ingredientsController.text,
      "instructions": instructionsController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successful response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recipe Posted Successfully!')),
        );
      } else {
        // Error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post recipe: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post a Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Recipe Title'),
            ),
            TextField(
              controller: ingredientsController,
              decoration: InputDecoration(labelText: 'Ingredients'),
            ),
            TextField(
              controller: instructionsController,
              decoration: InputDecoration(labelText: 'Instructions'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: postRecipe,
              child: Text('Post Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}