// recipe_event.dart
abstract class RecipeEvent {}

class FetchRecipesEvent extends RecipeEvent {
  final String query;

  FetchRecipesEvent({this.query = ''});
}

class FilterRecipesEvent extends RecipeEvent {
  final String query;

  FilterRecipesEvent(this.query);
}
