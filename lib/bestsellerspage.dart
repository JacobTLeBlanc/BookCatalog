import 'package:flutter/material.dart';
import 'route.dart' as route;

// Best Sellers Page, shows the current top trending books
class BestSellersPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Best Sellers NYT'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Home"),
          onPressed: () => Navigator.pushNamed(context, route.homePage),
        ),
      ),
    );
  }
}
