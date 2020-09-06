import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/productItem.dart';
import '../Provider/Products.dart';
// ignore: must_be_immutable
class ProductGrid extends StatelessWidget {
  bool isfavourit;
  ProductGrid(this.isfavourit);
  @override
  Widget build(BuildContext context) { //<=====================||
    final productData = Provider.of<Products>(context);//lisne اول ما البرودكت يتغير هيعمل ريبلد للودجت دى
    final loadedproducts = isfavourit? productData.favouritItems:productData.items;
    
    return GridView.builder(
        padding: EdgeInsets.all(15),
        itemCount: loadedproducts.length,
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        //  create: (c)=>loadedproducts[index],
        value: loadedproducts[index],
                  child: ProductItem(
          //  loadedproducts[index].id,
             // loadedproducts[index].title,
              // loadedproducts[index].imageUrl
               ),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      );
  }
}