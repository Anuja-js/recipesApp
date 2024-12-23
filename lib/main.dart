import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/%20repositories/news_repo.dart';
import 'package:newsapp/screens/home_screen.dart';
import 'package:newsapp/screens/splash_screen.dart';

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
        // Uncomment the following line if you are using NewsBloc
        BlocProvider(
        create: (_) => SplashCubit()..startSplash(),),
    BlocProvider(
    create: (context) => RecipeBloc( recipeRepository: RecipieRepository()),)
      ],
      child: MaterialApp(
        title: 'News App',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/news': (context) => HomeScreen(),
        },
      ),
    );
  }
}
