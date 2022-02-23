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

  late Future<List<Book>> futureBook;

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
        child: FutureBuilder<List<Book>>(
          future: futureBook,
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              // List of best sellers
              return ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    child: Center(child: Text(snapshot.data![index].title)),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
              );

            // error handling
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // Loading icon
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
Future<List<Book>> fetchBestSellers(category) async {
  final response = await http.get(Uri.parse('https://vbtjd5a550.execute-api.us-east-1.amazonaws.com/v1/get_best_sellers_nyt/current/' + category));

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);

    // Gets list of books from result
    final int numOfResults = json["num_results"];
    final bookList = List<Book>.filled(numOfResults, Book(rank: -1, title: "", author: ""));

    for (int i = 0; i < numOfResults; i++) {
      bookList[i] = Book.fromJson(json["results"]["books"][i]);
    }

    return bookList;
  }

  throw Exception('Failed to load best sellers');
}