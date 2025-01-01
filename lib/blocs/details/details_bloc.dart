import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/blocs/details/details_events.dart';
import 'package:newsapp/blocs/details/details_state.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  RecipesBloc() : super(RecipesInitial()) {
    // Register the handler for FetchRecipesDetails event
    on<FetchRecipesDetails>(_fetchRecipeDetails);
  }

  Future<void> _fetchRecipeDetails(
      FetchRecipesDetails event, Emitter<RecipesState> emit) async {
    emit(RecipesLoading());
    try {
      final String apiKey = '5f49213d91e34457a121d6ad3892e0c8';
      final String apiUrl =
          'https://api.spoonacular.com/recipes/${event.recipeId}/information?apiKey=$apiKey&includeNutrition=false';

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(RecipesLoaded(data));
      } else {
        emit(RecipesError('Failed to load recipe details'));
      }
    } catch (e) {
      emit(RecipesError('Error: $e'));
    }
  }
}
