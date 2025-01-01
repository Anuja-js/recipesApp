abstract class RecipesState {}

class RecipesInitial extends RecipesState {}

class RecipesLoading extends RecipesState {}

class RecipesLoaded extends RecipesState {
  final Map<String, dynamic> recipeDetails;

  RecipesLoaded(this.recipeDetails);
}

class RecipesError extends RecipesState {
  final String message;

  RecipesError(this.message);
}