import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/blocs/details/details_events.dart';
import '../../blocs/details/details_bloc.dart';
import '../../blocs/details/details_state.dart';
import '../../config/color/colors.dart';
import '../../config/componets/text_custom.dart';

class DetailedPage extends StatelessWidget {
  final int recipeId;

  const DetailedPage({Key? key, required this.recipeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipesBloc()..add(FetchRecipesDetails(recipeId)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.darkBgColor,
          elevation: 1,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_outlined, color: AppColor.darkFontColor),
          ),
          title: TextCustom(
            text: "Recipe",
            textSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: BlocBuilder<RecipesBloc, RecipesState>(
          builder: (context, state) {
            if (state is RecipesInitial) {
              return const Center(child: Text('Initializing...'));
            } else if (state is RecipesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RecipesLoaded) {
              final data = state.recipeDetails;
              final ingredients = data['extendedIngredients'] as List;
              final recipeCardUrl = data['url'] ?? data['image'];
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display Recipe Image
                    if (recipeCardUrl != null)
                      SizedBox( width: double.infinity,
                        height: 300,
                        child: Image.network(
                          recipeCardUrl,
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.fill,
                        ),
                      )
                    else
                      const Center(
                        child: Text("No image available"),
                      ),
                    const SizedBox(height: 16),

                    // Recipe Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextCustom(
                        text: data['title'] ?? 'No Title',color: AppColor.lightFontColor,
                        textSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Ingredients List
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextCustom(
                        text: "Ingredients:",
                        textSize: 18,color: AppColor.lightFontColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: ingredients.length,
                      itemBuilder: (context, index) {
                        final ingredient = ingredients[index];
                        return ListTile(
                          leading: ingredient['image'] != null
                              ? Image.network(
                            'https://spoonacular.com/cdn/ingredients_100x100/${ingredient['image']}',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                              : const Icon(Icons.fastfood),
                          title: TextCustom(text:ingredient['name'],color: AppColor.lightFontColor,textSize: 15,),
                          subtitle: Text('${ingredient['amount']} ${ingredient['unit']}'),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Recipe Instructions
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextCustom(
                        text: "Instructions:",
                        textSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextCustom(
                        text: data['instructions'] ?? 'No instructions available',
                        textSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is RecipesError) {
              return Center(
                child: Text('Error: ${state.message}'),
              );
            }
            return const Center(child: Text('Unknown state'));
          },
        ),
      ),
    );
  }
}
