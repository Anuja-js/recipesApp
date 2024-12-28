import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/blocs/home/seach_event.dart';
import 'package:newsapp/blocs/home/search_state.dart';
import 'package:newsapp/models/recipes_model.dart';

import '../../ repositories/recipie_repo.dart';


class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipieRepository recipeRepository;
  int currentPage = 0;
  bool hasMoreData = true;
  List<Result> allRecipes = [];

  RecipeBloc({required this.recipeRepository}) : super(RecipeInitial()) {
    on<FetchRecipesEvent>((event, emit) async {
      if (!hasMoreData) return;

      emit(RecipeLoading());
      try {
        final recipes = await recipeRepository.fetchRecipes(
          query: event.query,
          number: 10,
          offset: currentPage * 10,
        );
        if (recipes.results != null && recipes.results!.isNotEmpty) {
          allRecipes.addAll(recipes.results!);
          currentPage++;
          hasMoreData = recipes.results!.length == 10;
          emit(RecipeLoaded(allRecipes));
        } else {
          hasMoreData = false;
          emit(RecipeLoaded(allRecipes));
        }
      } catch (e) {
        emit(RecipeError('Failed to fetch recipes: $e'));
      }
    });
  }
}
