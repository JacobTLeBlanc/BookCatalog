import 'package:flutter/material.dart';
import 'route.dart' as route;

/// Home Page of app
class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Best Sellers'),
          onPressed: () => Navigator.pushNamed(context, route.bestSellersPage),
        )
      )
    );
  }
}
