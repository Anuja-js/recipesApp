import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/%20repositories/recipie_repo.dart';
import 'package:newsapp/blocs/home/seach_event.dart';
import 'package:newsapp/blocs/home/search_state.dart';
import 'package:newsapp/models/recipes_model.dart';


class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipieRepository recipeRepository;
  int currentPage = 0;
  bool hasMoreData = true;
  List<Result> allRecipes = [];

  RecipeBloc({required this.recipeRepository}) : super(RecipeInitial()) {
    on<FetchRecipesEvent>((event, emit) async {
      if (!hasMoreData && event.query.isEmpty) return;

      emit(RecipeLoading());

      try {
        // Fetch recipes with provided query
        final recipes = await recipeRepository.fetchRecipes(
          query: event.query,
          number: 100,
          offset: currentPage * 10,
        );

        // Handle case where no results are found
        if (recipes.results == null || recipes.results!.isEmpty) {
          emit(RecipeError(
            event.query.isEmpty
                ? 'No recipes found. Please refine your search!'
                : 'No recipes found for "${event.query}". Please try again.',
          ));
          return;
        }
        allRecipes.addAll(recipes.results!);
        currentPage++;
        hasMoreData = recipes.results!.length == 10;
        emit(RecipeLoaded(allRecipes));
      } catch (e) {
        emit(RecipeError('Failed to fetch recipes: $e'));
      }
    });
  }
}
