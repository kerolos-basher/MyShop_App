import '../Provider/ShopingCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String proId;
  final String title;
  final double price;

  final int quantaty;
  CartItem(this.id, this.proId, this.price, this.quantaty, this.title);
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cardd>(context, listen: false);
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(id),

      confirmDismiss: (direction){
        return showDialog(context: context,builder:(ctx)=> AlertDialog(
          title: Text('Are You shure To Delete This'),
          content: Text('Do You Want To Remove Item From Card Item'),
          actions: <Widget>[
            FlatButton(child: Text('YES'),onPressed: (){
              Navigator.of(context).pop(true);
            },),
             FlatButton(child: Text('NO'),onPressed: (){
                Navigator.of(context).pop(false);
             },),
          ],
        ));
      },
      onDismissed: (dir) {
        cart.deleteItem(proId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.all(8),
      ),
      child: Card(
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Text(
                  '\$$price',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              backgroundColor: Theme.of(context).primaryColorDark,
            ),
            title: Text(title),
            subtitle: Text('Total :\$${price * quantaty}'),
            trailing: Text('${quantaty}x'),
          ),
        ),
        elevation: 5,
      ),
    );
  }
}
