import 'dart:io';

abstract class AddRecipeEvent {}

class PickImageEvent extends AddRecipeEvent {}

class SubmitRecipeEvent extends AddRecipeEvent {
  final String title;
  final String ingredients;
  final String instructions;
  final String readyInMinutes;
  final String servings;
  final File? image;

  SubmitRecipeEvent({
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.readyInMinutes,
    required this.servings,
    this.image,
  });
}