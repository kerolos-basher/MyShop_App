import 'package:MyShop_App/Provider/Orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/ShopingCard.dart';
import '../widgets/Cart_Item.dart';

class Cart extends StatefulWidget {
  static const rootName = '/cart.dart';

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    bool isload = false;
    final cart = Provider.of<Cardd>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  Chip(
                    label: Text(
                      '\$${cart.totalprice.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColorDark,
                  ),
                  FlatButton(
                  
                    onPressed: cart.totalprice <= 0
                        ? null
                        : () async {
                            setState(() {
                              isload = true;
                            });
                            await Provider.of<Orders>(context).addorder(
                                cart.totalprice, cart.items.values.toList());
                            cart.clearcard();
                            setState(() {
                              isload = false;
                            });
                          },
                          child: isload ? CircularProgressIndicator(): Text('Order Now'),
                    textColor: Theme.of(context).accentColor,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) => CartItem(
                cart.items.values.toList()[index].id,
                cart.items.keys.toList()[index],
                cart.items.values.toList()[index].price,
                cart.items.values.toList()[index].quantaty,
                cart.items.values.toList()[index].title,
              ),
              itemCount: cart.items.length,
            ),
          ),
        ],
      ),
    );
  }
}
