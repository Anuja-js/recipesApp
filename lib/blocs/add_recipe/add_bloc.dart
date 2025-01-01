// Bloc Implementation
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newsapp/blocs/add_recipe/add_event.dart';
import 'package:newsapp/blocs/add_recipe/add_state.dart';

import '../../ repositories/add_recipe_repo.dart';

class AddRecipeBloc extends Bloc<AddRecipeEvent, AddRecipeState> {
  final RecipeRepository repository;

  AddRecipeBloc(this.repository) : super(AddRecipeInitial()) {
    on<PickImageEvent>((event, emit) async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        emit(ImagePickedState(File(pickedFile.path)));
      }
    });

    on<SubmitRecipeEvent>((event, emit) async {
      emit(RecipeSubmittingState());

      try {
        final response = await repository.postRecipe(
          title: event.title,
          ingredients: event.ingredients,
          instructions: event.instructions,
          readyInMinutes: event.readyInMinutes,
          servings: event.servings,
          image: event.image,
        );

        emit(RecipeSubmittedState(response));
      } catch (e) {
        emit(RecipeSubmissionErrorState(e.toString()));
      }
    });
  }
}