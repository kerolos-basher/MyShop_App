import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/Products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const rootName = '/productDetailScreen';
  @override
  Widget build(BuildContext context) {
    final proId = ModalRoute.of(context).settings.arguments as String;
    final loadedproduct =
        Provider.of<Products>(context, listen: false).findById(proId);
    return Scaffold(
      //  appBar: AppBar(title: Text(loadedproduct.title)),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedproduct.title),
              background: Hero(
                tag: loadedproduct.id,
                child: Image.network(
                  loadedproduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Container(
                child: Center(
                  child: Text(
                    '${loadedproduct.price}',
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Center(
                  child: Text(
                    '${loadedproduct.description}',
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ),
                ),
              ), SizedBox(
                height: 800,
              ),
            ]),
          )
        ],
      ),
    );
  }
}
