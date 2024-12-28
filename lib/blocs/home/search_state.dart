// recipe_state.dart
import '../../models/recipes_model.dart';

abstract class RecipeState {
  final bool isLoading;

  RecipeState(this.isLoading);
}
class RecipeInitial extends RecipeState {

  RecipeInitial() : super(false);

}

class RecipeLoading extends RecipeState {
  RecipeLoading() : super(true);

}

class RecipeLoaded extends RecipeState {

  final List<Result> recipes;
  RecipeLoaded(this.recipes) : super(false);
}

class RecipeError extends RecipeState {
  final String message;

  RecipeError(this.message) : super(false);
}
