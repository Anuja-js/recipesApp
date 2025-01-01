import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/config/color/colors.dart';
import 'package:newsapp/config/componets/text_custom.dart';
import 'package:newsapp/views/add_recipe/add_recipie.dart';
import '../../ repositories/recipie_repo.dart';
import '../../blocs/home/seach_event.dart';
import '../../blocs/home/search_bloc.dart';
import '../../blocs/home/search_state.dart';
import '../details/detailed_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipieRepository recipeRepository = RecipieRepository();

  final RecipeBloc recipeBloc = RecipeBloc(
    recipeRepository: RecipieRepository(),
  );

  @override
  void initState() {
    super.initState();
    context.read<RecipeBloc>().add(FetchRecipesEvent(query: ''));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.darkBgColor,automaticallyImplyLeading: false,
        elevation: 1,
        title: TextCustom(text: "Items",color: AppColor.darkFontColor,textSize: 18,fontWeight: FontWeight.bold,),
      //   TextField(
      //   controller: searchController,
      //   decoration:  InputDecoration(
      //     hintText: 'Search...',
      //     hintStyle: TextStyle(color: AppColor.darkFontColor),
      //     border: InputBorder.none,
      //     prefixIcon: IconButton(onPressed: (){
      //       searchController.clear();
      //       context.read<RecipeBloc>().add(FetchRecipesEvent(query: ''));
      //     },
      //         icon: Icon(Icons.search, color: AppColor.darkLabelColor)),
      //   ),
      //   style: const TextStyle(color: AppColor.darkFontColor),
      //   onChanged: (value) {
      //     context.read<RecipeBloc>().add(FetchRecipesEvent(query: value.trim()));
      //     print('Search Submitted: $value');
      //   },
      //
      // ),
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is RecipeLoading && context.read<RecipeBloc>().allRecipes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RecipeLoaded) {
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {

                if (scrollNotification is ScrollEndNotification &&
                    scrollNotification.metrics.pixels ==
                        scrollNotification.metrics.maxScrollExtent) {

                  context.read<RecipeBloc>().add(FetchRecipesEvent(query: " ",));
                }
                return false;
              },
              child: ListView.builder(
                itemCount: state.recipes.length + 1,shrinkWrap: true,

                itemBuilder: (context, index) {
                  if (index < state.recipes.length) {
                    final recipe = state.recipes[index];
                    return Column(
                      children: [
                        RecipieCard(
                          title: recipe.title ?? 'No Title',
                          imageUrl: recipe.image ?? '',
                          onSeeMore: () { if (recipe.id != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => DetailedPage(recipeId: recipe.id!),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Invalid recipe ID')),
                            );
                          }
                          },
                        ),
                        if(index==state.recipes.length-1&& state.isLoading)CircularProgressIndicator()
                      ],
                    );
                  } else {
                    return context.read<RecipeBloc>().hasMoreData
                        ? const Center(child: CircularProgressIndicator())
                        :
                    const SizedBox.shrink();
                  }
                },
              ),
            );
          } else if (state is RecipeError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Search for recipes.'));
          }
        },
      ),



      floatingActionButton: Align(
        alignment: AlignmentDirectional.bottomCenter,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return AddRecipe();
            }));
          },
          child: Icon(Icons.add),
        ),
      ),
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
      margin:  EdgeInsets.all( 16),
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
                  child: SizedBox(width: 40,
                    child: TextCustom(text:
                      title,
                   textSize: 15,color: AppColor.lightFontColor,
                        fontWeight: FontWeight.bold,

                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: onSeeMore,
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
