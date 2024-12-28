import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/config/routes/routes_names.dart';
import '../../blocs/splash/splash.cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocListener<SplashCubit, bool>(
        listener: (context, state) {
          if (state) {
            Navigator.pushReplacementNamed(context,RoutesName.homeScreen);
          }
        },
        child: Scaffold(
          body: Center(
            child: Image.asset(
              "assets/images/logo.png",
              height: 70,
              width: 70,
            ),
          ),
        ),
      );
  }
}
