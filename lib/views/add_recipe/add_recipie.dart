import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:newsapp/config/componets/text_custom.dart';
import 'package:newsapp/config/constants/constants.dart';
import 'package:newsapp/views/add_recipe/display_added_recipie/display_added_recipe.dart';

import '../../config/color/colors.dart';

class AddRecipe extends StatefulWidget {
  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController readyInMinutesController = TextEditingController();
  final TextEditingController servingsController = TextEditingController();
  File? selectedImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }
  Future<void> postRecipe() async {
    const String apiUrl =
        'https://api.spoonacular.com/recipes/visualizeRecipe?apiKey=5f49213d91e34457a121d6ad3892e0c8';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      request.fields['title'] = titleController.text;
      request.fields['ingredients'] = ingredientsController.text;
      request.fields['instructions'] = instructionsController.text;
      request.fields['readyInMinutes'] = readyInMinutesController.text;
      request.fields['servings'] = servingsController.text;
      request.fields['mask'] = 'ellipseMask';
      request.fields['backgroundColor'] = '#ffffff';
      request.fields['fontColor'] = '#333333';

      if (selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          selectedImage!.path,
        ));
      }

      final response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final responseData = await jsonDecode(responseBody);
        print(responseData.toString());
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayAddedRecipe(responseData: responseData),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post recipe: ${response.reasonPhrase}')),
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
        backgroundColor: AppColor.darkBgColor,
        elevation: 1,leading: IconButton(onPressed: (){
          Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back_ios_outlined,color: AppColor.darkFontColor,)),
        title: TextCustom(text: "Post a Recipe",textSize: 18,fontWeight: FontWeight.bold,),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
          sh10,
              selectedImage != null
                  ? Image.file(
                selectedImage!,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              )
                  : Text('No image selected'),
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Pick an Image'),
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Recipe Title'),
              ),
              TextField(
                controller: ingredientsController,
                decoration: InputDecoration(labelText: 'Ingredients'),
                maxLines: 3,
              ),
              TextField(
                controller: instructionsController,
                decoration: InputDecoration(labelText: 'Instructions'),
                maxLines: 3,
              ),
              TextField(
                controller: readyInMinutesController,
                decoration: InputDecoration(labelText: 'Ready in Minutes'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: servingsController,
                decoration: InputDecoration(labelText: 'Servings'),
                keyboardType: TextInputType.number,
              ),

              sh20,
              ElevatedButton(
                onPressed: postRecipe,
                child: Text('Post Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
