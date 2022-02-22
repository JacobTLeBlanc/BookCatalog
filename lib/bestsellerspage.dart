import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Best Sellers Page, shows the current top trending books
class BestSellersPage extends StatefulWidget {
  const BestSellersPage({Key? key}) : super(key: key);

  @override
  _BestSellersPageState createState() => _BestSellersPageState();
}

/// Best Sellers State, attempts to fetch best sellers
/// on init
class _BestSellersPageState extends State<BestSellersPage> {

  late Future<Book> futureBook;

  @override
  void initState() {
    futureBook = fetchBestSellers('young-adult');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Best Sellers NYT'),
      ),
      body: Center(
        child: FutureBuilder<Book>(
          future: futureBook,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.title);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

/// Book Class to hold book information from API
class Book {
  final int rank;
  final String title;
  final String author;

  const Book({
    required this.rank,
    required this.title,
    required this.author
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
        rank: json['rank'],
        title: json['title'],
        author: json['author']
    );
  }
}

/// Fetches best sellers from NYT API
Future<Book> fetchBestSellers(category) async {
  final response = await http.get(Uri.parse('https://vbtjd5a550.execute-api.us-east-1.amazonaws.com/v1/get_best_sellers_nyt/current/' + category));

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);

    return Book.fromJson(json["results"]["books"][0]);
  }

  throw Exception('Failed to load best sellers');
}