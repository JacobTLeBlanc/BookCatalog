import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
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
        title: const Text('Best Sellers NYT'),
      ),
      body: Center(
        child: FutureBuilder<List<Book>>(
          future: futureBook,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return bookListBuilder(context, snapshot.data!);

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

/// Build list of books
ListView bookListBuilder(context, List<Book> bookList) {

  // List of best sellers
  return ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: bookList.length,
    itemBuilder: (BuildContext context, int index) {

      // Expansion tile to show book description
      return ExpansionTile(
        leading: Text(bookList[index].rank.toString()),
        title: Text(bookList[index].title + " by " + bookList[index].author),
        subtitle: Image(
          image: NetworkImage(bookList[index].imageUrl)
        ),
        children: [
          bookDescriptionBuilder(context, bookList[index])
        ],
      );
    },
  );
}

/// Build description of each book
ListView bookDescriptionBuilder(context, Book book) {

  // List of book info
  return ListView(
    shrinkWrap: true,
    children: [

      // Brief description
      ListTile(
        title: const Text('Description'),
        subtitle: Container(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: Text(book.description)
        ),
      ),

      // Buy Links
      ListTile(
        title: const Text("Buy Links"),
        subtitle: ListView.builder(
            shrinkWrap: true,
            itemCount: book.buyLinks.length,
            itemBuilder: (BuildContext context, int index) {

              // Links
              return InkWell(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: Text(book.buyLinks[index].name),
                  ),
                  onTap: () => launch(book.buyLinks[index].url)
              );
            }),
      )


    ],
  );
}

/// Book Class to hold book information from API
class Book {
  final int rank;
  final String title;
  final String author;
  final String description;
  final String imageUrl;

  final List<BuyLink> buyLinks;


  const Book({
    required this.rank,
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.buyLinks
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
        rank: json['rank'],
        title: json['title'],
        author: json['author'],
        description: json['description'],
        imageUrl: json["book_image"],
        buyLinks: List<BuyLink>.from(
          json["buy_links"]
              .map((data) => BuyLink.fromJson(data))
        )
    );
  }
}

/// Represents a buy link item
class BuyLink {
  final String name;
  final String url;

  const BuyLink({
    required this.name,
    required this.url
  });

  factory BuyLink.fromJson(Map<String, dynamic> json) {
    return BuyLink(
      name: json['name'],
      url: json['url']
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
    final bookList = List<Book>.filled(numOfResults, Book(rank: -1, title: "", author: "", description: "",imageUrl: "",  buyLinks: List<BuyLink>.empty()));

    for (int i = 0; i < numOfResults; i++) {
      bookList[i] = Book.fromJson(json["results"]["books"][i]);
    }

    return bookList;
  }

  throw Exception('Failed to load best sellers');
}