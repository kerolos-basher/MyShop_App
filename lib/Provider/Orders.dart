import 'dart:convert';
import 'package:MyShop_App/Provider/ShopingCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CardItem> products;
  final DateTime datetime;
  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.datetime,
      @required this.products});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String authToken;
  String userId;
  Orders(this.authToken,this.userId,this._orders);
  List<OrderItem> get orders {
    return [..._orders];
  }
Future<void> featchorderData () async {
   String url = 'https://flutterhost-9fba5.firebaseio.com/order/$userId.json?auth=$authToken';
      final response = await http.get(url);
      final firepaseorder =
          json.decode(response.body) as Map<String, dynamic>;
      List<OrderItem> loadedorders = [];
    if(firepaseorder == null)
    {
      return false;
    }
      firepaseorder.forEach((orderid, orderinfo) {
        loadedorders.add(OrderItem(
            id: orderid,
            amount: orderinfo['amount'],
            datetime: DateTime.parse(orderinfo['datetime']),
            products : (orderinfo['products'] as List<dynamic>).map((pro) => CardItem(
              id:pro['id'] ,
              price: pro['price'],
              quantaty: pro['quantaty'],
              title: pro['title']
            )).toList(),
         ));
      });
      _orders = loadedorders.reversed.toList();
      notifyListeners();
}
  Future<void> addorder(double amount, List<CardItem> products) async {
    String url = 'https://flutterhost-9fba5.firebaseio.com/order/$userId.json?auth=$authToken';
    var datetime = DateTime.now();
    var response = await http.post(url,
        body: json.encode({
          'amount': amount,
          'datetime': datetime.toIso8601String(),
          'products': products.map((pr) => {
                'id': pr.id,
                'title': pr.title,
                'quantaty': pr.quantaty,
                'price': pr.price
              }).toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: amount,
            products: products,
            datetime: datetime));
    notifyListeners();
  }
}
