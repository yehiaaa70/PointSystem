
import 'package:flutter/material.dart';
import 'package:test_project/UI/splash/splash_screen.dart';

class AppRouters{



  Route? generateRouter(RouteSettings settings){
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_)=>  SplashScreen());
    }
    return null;
  }
}