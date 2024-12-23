import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/blocs/home/seach_event.dart';
import 'package:newsapp/blocs/home/search_state.dart';

import '../../ repositories/news_repo.dart';


class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipieRepository recipeRepository;

  RecipeBloc({required this.recipeRepository}) : super(RecipeInitial());

  @override
  Stream<RecipeState> mapEventToState(RecipeEvent event) async* {
    if (event is FetchRecipesEvent) {
      yield RecipeLoading();
      try {
        final recipes = await recipeRepository.fetchRecipes(query: event.query);
        if (recipes.results != null && recipes.results!.isNotEmpty) {
          yield RecipeLoaded(recipes.results!);
        } else {
          yield RecipeError('No recipes found for "${event.query}".');
        }
      } catch (e) {
        yield RecipeError('Failed to fetch recipes: $e');
      }
    }

    // if (event is FetchRecipesEvent) {
    //   yield RecipeLoading();
    //   try {
    //     final recipes = await recipeRepository.fetchRecipes(query: event.query);
    //     yield RecipeLoaded(recipes.results ?? []);
    //   } catch (e) {
    //     yield RecipeError('Failed to fetch recipes');
    //   }
    // }
    else if (event is FilterRecipesEvent) {
      if (state is RecipeLoaded) {
        final currentState = state as RecipeLoaded;
        final filteredRecipes = currentState.recipes.where((recipe) =>
        recipe.title?.toLowerCase().contains(event.query.toLowerCase()) ?? false).toList();
        yield RecipeLoaded(filteredRecipes);
      }
    }
  }
}
