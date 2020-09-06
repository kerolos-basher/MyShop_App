import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import '../Provider/Orders.dart';
class OrderItemDesign extends StatefulWidget {
  final OrderItem orderItem;
  OrderItemDesign(this.orderItem);

  @override
  _OrderItemDesignState createState() => _OrderItemDesignState();
}

class _OrderItemDesignState extends State<OrderItemDesign> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: expanded ? min(widget.orderItem.products.length * 20.0 + 200, 220 ) : 110,
          child: Card(
        elevation: 8,
        margin: EdgeInsets.all(15),
        child: Column(children: <Widget>[
          ListTile(
            title: Text('\$${widget.orderItem.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.orderItem.datetime)),
            trailing: IconButton(icon: Icon(expanded? Icons.expand_less:Icons.expand_more),onPressed: (){
              setState(() {
                expanded = !expanded;
              });
            },),
          ),
        AnimatedContainer(
            duration: Duration(milliseconds: 400),
         height: expanded ? min(widget.orderItem.products.length * 10.0+100, 110 ) : 0,
           
            child: ListView(children: widget.orderItem.products.map((pro) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('${pro.title}',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                Text('${pro.quantaty} x \$${pro.price}')
              ],
            )).toList()),
          ),
        ],),
        
      ),
    );
  }
}