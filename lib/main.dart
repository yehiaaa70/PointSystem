import 'package:flutter/material.dart';
import 'package:test_project/app_Route.dart';

void main() {
  runApp( MyApp(appRouters: AppRouters(),));
}

class MyApp extends StatelessWidget {
   final AppRouters appRouters;
   const MyApp({Key? key, required this.appRouters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark, fontFamily: 'Almarai'),
     onGenerateRoute: appRouters.generateRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
