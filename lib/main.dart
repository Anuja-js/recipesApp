import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/%20repositories/recipie_repo.dart';
import 'package:newsapp/config/routes/routes.dart';
import 'package:newsapp/config/routes/routes_names.dart';
import 'blocs/home/seach_event.dart';
import 'blocs/home/search_bloc.dart';
import 'blocs/splash/splash.cubit.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SplashCubit()..startSplash(),
        ),
        BlocProvider(
        create: (_) => RecipeBloc(
    recipeRepository: RecipieRepository(),
    )..add(FetchRecipesEvent(query: '',)),),
      ],
      child: MaterialApp(
        title: 'Recipe App',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        initialRoute: RoutesName.splashScreen,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
