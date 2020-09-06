

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Product.dart';
import '../model/http_Exption.dart';

class Products with ChangeNotifier //يمكنك من اعلام بقيت الودجت انة حصل تعيير فى قائمة المنتجات
{
  List<Product> _items = [
    /* Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
        id: 'p2',
        title: 'Trousers',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageUrl:
            'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg'),
    Product(
        id: 'p3',
        title: 'redvg',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageUrl:
            'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg'),
    Product(
      id: 'p4',
      title: 'dse Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://blogs.edweek.org/edweek/finding_common_ground/6%20Books.jpg',
    ),*/
  ];
  final String userId;
final String authToken;
Products(this.authToken,this.userId,this._items);

  List<Product>
      get items //بعملها علشان اعمل الفنكسن بتاعت انى ابعت للسنرز الى مسجلين معايا
  {
    return [..._items];
  }

  List<Product>
      get favouritItems //بعملها علشان اعمل الفنكسن بتاعت انى ابعت للسنرز الى مسجلين معايا
  {
    return _items.where((element) => element.isFavourt == true).toList();
  }

  Future<void> fetchproductdatafromfireoasw([bool filterByUser = false]) async {
    final filterstring = filterByUser ? 'orderBy="userId"&equalTo="$userId"': '';
    String url = 'https://flutterhost-9fba5.firebaseio.com/products.json?auth=$authToken&$filterstring';
    try {
      final response = await http.get(url);
      final firepaseproduct =
          json.decode(response.body) as Map<String, dynamic>;

    String urll = 'https://flutterhost-9fba5.firebaseio.com/favouritproducts/$userId.json?auth=$authToken';
     final responsefav = await http.get(urll);
      final firepaseproductfav = json.decode(responsefav.body) ;
      List<Product> loadedproduct = [];
      firepaseproduct.forEach((proid, proindo) {
        loadedproduct.add(Product(
            id: proid,
            title: proindo['title'],
            description: proindo['description'],
            imageUrl: proindo['imgurl'],
            price: proindo['price'],
            isFavourt: firepaseproductfav == null ?false :firepaseproductfav[proid] ?? false
            ));
      });
      _items = loadedproduct;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product pro) async {
    String url = 'https://flutterhost-9fba5.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': pro.title,
          'description': pro.description,
          'imgurl': pro.imageUrl,
          'price': pro.price,
          'userId':userId
        }),
      );

      final newproo = Product(
        title: pro.title,
        description: pro.description,
        price: pro.price,
        imageUrl: pro.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newproo);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product pro) async {
    final proindex = _items.indexWhere((pro) => pro.id == id);
    String url = 'https://flutterhost-9fba5.firebaseio.com/products/$id.json?auth=$authToken';
    await http.patch(url,
        body: json.encode({
          'title': pro.title,
          'description': pro.description,
          'imgurl': pro.imageUrl,
          'price': pro.price,
        }));
    _items[proindex] = pro;
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((pro) => pro.id == id);
  }

  Future<void> deletproduct(String id) async {
    String url = 'https://flutterhost-9fba5.firebaseio.com/products/$id.json?auth=$authToken';
    final productindex = _items.indexWhere((pro) => pro.id == id);
    var product = _items[productindex];
    _items.removeAt(productindex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 300) {
      _items.insert(productindex, product);
      notifyListeners();
      throw HttpExption('cantdelete this productt');
    }
    product = null;
  }
}
