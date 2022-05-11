import 'package:flutter/material.dart';

import '../../Models/category_model.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel categoryModel;

  // final  myFunction;

  const CategoryItem({
    Key? key,
    required this.categoryModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: myFunction,
      child: Card(
        elevation: 20.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              categoryModel.name.toString(),
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              "${categoryModel.priceByPoint!.toInt()}",
              style: const TextStyle(fontSize: 12.0, color: Colors.blue),
            ),
            SizedBox(height: 8,),
            const Text(
              "( نـقـطـة )",
              style:  TextStyle(fontSize: 10.0, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
