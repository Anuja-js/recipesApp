import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/screens/detailed_page.dart';
import 'package:newsapp/widgets/text_custom.dart';
import '../ repositories/news_repo.dart';
import '../blocs/home/seach_event.dart';
import '../blocs/home/search_bloc.dart';
import '../blocs/home/search_state.dart';
import '../utils/colors.dart';

class HomeScreen extends StatelessWidget {
  final RecipieRepository recipeRepository = RecipieRepository();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBgColor,
        elevation: 1,
        title: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: darkFontColor),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: darkLabelColor),
          ),
          style: const TextStyle(color: darkFontColor),
          onChanged: (value) {
            context.read<RecipeBloc>().add(FilterRecipesEvent(value));
          },
        ),
      ),
      body:BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is RecipeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RecipeLoaded) {
            if (state.recipes.isEmpty) {
              return const Center(child: Text('No recipes found.'));
            }
            return ListView.builder(
              itemCount: state.recipes.length,
              itemBuilder: (context, index) {
                final recipe = state.recipes[index];
                return RecipieCard(
                  title: recipe.title ?? 'No Title',
                  imageUrl: recipe.image ?? '',
                  onSeeMore: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return const DetailedPage();
                    }));
                  },
                );
              },
            );
          } else if (state is RecipeError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unexpected error occurred.'));
          }
        },
      )

    );
  }
}

class RecipieCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final VoidCallback onSeeMore;

  const RecipieCard({
    Key? key,
    required this.title,
    this.imageUrl,
    required this.onSeeMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              image: imageUrl != null
                  ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
                  : null,
              color: Colors.grey, // Fallback color if no image
            ),
            alignment: Alignment.center,
            child: imageUrl == null
                ? TextCustom(
              text: 'No Image',
              color: Colors.white,
              textSize: 20,
              fontWeight: FontWeight.bold,
            )
                : const SizedBox.shrink(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: onSeeMore,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('See More >'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
