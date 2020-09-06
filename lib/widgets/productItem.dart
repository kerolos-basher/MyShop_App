import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/Product.dart';
import '../screens/Product_dtail_Screen.dart';
import '../Provider/ShopingCard.dart';
import '../Provider/auth.dart';
class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imgUrl;
  // ProductItem(this.id, this.title, this.imgUrl);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cardd>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailScreen.rootName, arguments: product.id);
          },
          child: Hero(
            tag: product.id,
                      child: FadeInImage(placeholder: AssetImage('lib/assets/images/product-placeholder.png'),
            image: NetworkImage(
              product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                product.isFavourt ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                product.toogleIsFavourit(auth.token,auth.userId);
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                content: Text(
                  'Add To Your Cart',
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds:2),
                action: SnackBarAction(label: 'UNDO', onPressed: (){
                  cart.deleteSingleItem(product.id);
                }),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
