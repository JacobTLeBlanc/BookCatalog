import 'dart:convert';

import 'package:flutter/material.dart';
import 'route.dart' as route;
import 'package:http/http.dart' as http;

/// Home Page of app
class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Best Sellers'),
          onPressed: () => Navigator.pushNamed(context, route.bestSellersPage),
        )
      )
    );
  }
}