import 'package:flutter/material.dart';

class CustomerItem extends StatelessWidget {
  const CustomerItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            const Expanded(
              flex: 6,
              child:  Text(
                'أسم الزبون',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
                flex: 3,
                child: Image.asset(
                  'assets/images/shopping.png',
                  height: 100,
                  width: 100,
                )),
          ],
        ),
      ),
    );
  }
}
