abstract class RecipesEvent {}

class FetchRecipesDetails extends RecipesEvent {
  final int recipeId;

  FetchRecipesDetails(this.recipeId);
}