
import 'package:flutter/material.dart';
import 'package:newsapp/config/componets/text_custom.dart';
import 'package:newsapp/config/routes/routes_names.dart';
import 'package:newsapp/views/details/detailed_page.dart';
import 'package:newsapp/views/splash/splash_screen.dart';
import '../../views/home/home_screen.dart';
class Routes{
  static Route<dynamic> generateRoute(RouteSettings settings){
switch(settings.name){
  case RoutesName.splashScreen:
    return MaterialPageRoute(builder: (context)=>SplashScreen());
  case RoutesName.homeScreen:
    return MaterialPageRoute(builder: (context)=>HomeScreen());
  case RoutesName.detailScreen:
    return MaterialPageRoute(builder: (context)=>DetailedPage());
  default:return MaterialPageRoute(builder: (context){
    return Scaffold(
      body: Center(child: TextCustom(text: "No Route Generated"),),
    );
  });
}
  }
}