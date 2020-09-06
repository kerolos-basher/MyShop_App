import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavourt;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavourt = false,
  });
  Future<void> toogleIsFavourit(String authToken,String userId) async {
    final oldvalue = isFavourt;
    isFavourt = !isFavourt;
     notifyListeners();
    String url = 'https://flutterhost-9fba5.firebaseio.com/favouritproducts/$userId/$id.json?auth=$authToken';
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavourt,
          ));
      if (response.statusCode >= 400) {
        isFavourt = oldvalue;
        notifyListeners();
      }
    } catch (error) {
      isFavourt = oldvalue;
      notifyListeners();
    }
  }
}
