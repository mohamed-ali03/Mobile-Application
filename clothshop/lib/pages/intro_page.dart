import 'package:clothshop/utils/mybutton.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag, size: 100),
            SizedBox(height: 20),
            Text(
              'Minimal Shop',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Premium Quailty Products',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            SizedBox(height: 20),
            Mybutton(
              onTap: () => Navigator.pushNamed(context, '/shopPage'),
              child: Icon(Icons.arrow_forward_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
