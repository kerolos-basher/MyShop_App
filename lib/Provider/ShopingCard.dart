// ignore: unused_import
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CardItem {
  final String id;
  final String title;
  final int quantaty;
  final double price;
  CardItem(
      {@required this.id,
      @required this.price,
      @required this.title,
      @required this.quantaty});
}

class Cardd with ChangeNotifier {
  Map<String, CardItem> _items = {};

  Map<String, CardItem> get items {
    return {..._items};
  }

  double get totalprice {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantaty;
    });
    return total;
  }

  int get itemCount {
    return _items.length;
  }

  void deleteItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void deleteSingleItem(String proId) {
    if (!_items.containsKey(proId)) {
      return;
    }
    if (_items[proId].quantaty > 1) {
      _items.update(
          proId,
          (existanse) => CardItem(
              id: existanse.id,
              title: existanse.title,
              price: existanse.price,
              quantaty: existanse.quantaty - 1));
    } else {
      _items.remove(proId);
    }
    notifyListeners();
  }

  void addItem(String productid, String titlee, double prise) {
    if (_items.containsKey(productid)) {
      _items.update(
          productid,
          (existanse) => CardItem(
              id: existanse.id,
              title: existanse.title,
              price: existanse.price,
              quantaty: existanse.quantaty + 1));
    } else {
      _items.putIfAbsent(
          productid,
          () => CardItem(
              id: DateTime.now().toString(),
              title: titlee,
              price: prise,
              quantaty: 1));
    }
    notifyListeners();
  }

  void clearcard() {
    _items = {};
    notifyListeners();
  }
}
