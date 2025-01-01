import 'dart:io';

abstract class AddRecipeState {}

class AddRecipeInitial extends AddRecipeState {}

class ImagePickedState extends AddRecipeState {
  final File selectedImage;

  ImagePickedState(this.selectedImage);
}

class RecipeSubmittingState extends AddRecipeState {}

class RecipeSubmittedState extends AddRecipeState {
  final Map<String, dynamic> responseData;

  RecipeSubmittedState(this.responseData);
}

class RecipeSubmissionErrorState extends AddRecipeState {
  final String error;

  RecipeSubmissionErrorState(this.error);
}