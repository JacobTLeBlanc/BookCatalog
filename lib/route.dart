import 'package:flutter/material.dart';

import 'package:book_catalog/bestsellerspage.dart';
import 'package:book_catalog/homepage.dart';

const String bestSellersPage = 'bestsellerspage';
const String homePage = 'homepage';

/// Route controller, handles navigation
Route<dynamic> controller(RouteSettings settings) {
  switch(settings.name) {
    case bestSellersPage:
      return MaterialPageRoute(builder: (context) => BestSellersPage());

    case homePage:
      return MaterialPageRoute(builder: (context) => HomePage());

    default:
      throw('this route name does not exist');
  }
}