import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newsapp/%20repositories/add_recipe_repo.dart';
import 'package:newsapp/config/color/colors.dart';
import 'package:newsapp/config/componets/text_custom.dart';
import 'package:newsapp/views/add_recipe/display_added_recipie/display_added_recipe.dart';
import 'package:newsapp/views/details/detailed_page.dart';
import '../../blocs/add_recipe/add_bloc.dart';
import '../../blocs/add_recipe/add_event.dart';
import '../../blocs/add_recipe/add_state.dart';
class AddRecipe extends StatelessWidget {
  final AddRecipeBloc bloc = AddRecipeBloc(RecipeRepository());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController readyInMinutesController = TextEditingController();
  final TextEditingController servingsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.darkBgColor,
          elevation: 1,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_outlined, color: AppColor.darkFontColor),
          ),
          title: TextCustom(
            text: "Post a Recipe",
            textSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: BlocConsumer<AddRecipeBloc, AddRecipeState>(
          listener: (context, state) {
            if (state is RecipeSubmittedState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayAddedRecipe(responseData: state.responseData),
                ),
              );
            } else if (state is RecipeSubmissionErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (state is ImagePickedState)
                      Image.file(
                        state.selectedImage,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      )
                    else
                      Text('No image selected'),
                    ElevatedButton(
                      onPressed: () => bloc.add(PickImageEvent()),
                      child: Text('Pick an Image'),
                    ),
                    _buildTextField(titleController, 'Recipe Title'),
                    _buildTextField(ingredientsController, 'Ingredients', maxLines: 3),
                    _buildTextField(instructionsController, 'Instructions', maxLines: 3),
                    _buildTextField(readyInMinutesController, 'Ready in Minutes', keyboardType: TextInputType.number),
                    _buildTextField(servingsController, 'Servings', keyboardType: TextInputType.number),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        if(state is ImagePickedState){
                          bloc.add(
                            SubmitRecipeEvent(
                              title: titleController.text,
                              ingredients: ingredientsController.text,
                              instructions: instructionsController.text,
                              readyInMinutes: readyInMinutesController.text,
                              servings: servingsController.text,
                              image: (state is ImagePickedState) ? state.selectedImage : null,
                            ),
                          );
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: TextCustom( text:"Please Select image",color: AppColor.darkFontColor, )),
                          );
                        }

                      },
                      child: Text('Post Recipe'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {int maxLines = 1, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }
}
