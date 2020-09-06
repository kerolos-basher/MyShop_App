import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/OrderItem_design.dart';
import '../Provider/Orders.dart';
import '../widgets/Drawer.dart';

class OrderScreen extends StatelessWidget {
  static const rootName = '/order.dart';

  // @override
//  _OrderScreenState createState() => _OrderScreenState();
//}

//class _OrderScreenState extends State<OrderScreen> {
  // bool isload = false;
  /*
  @override
  void initState() {
    isload = true;

    Provider.of<Orders>(context,listen: false).featchorderData().then((_) {
      setState(() {
        isload = false;
      });
    });

    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    // final order = Provider.of<Orders>(context);//لو سبتو هيدخل ف لوب ملها نهاية
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: DrawerPage(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).featchorderData(),
          builder: (ctx, datasnap) {
            if (datasnap.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (datasnap.error != null) {
                return Center(
                  child: Text('An Error Happend'),
                );
              } else {
                return Consumer<Orders>(
                    builder: (ctx, order, child) => ListView.builder(
                          itemBuilder: (ctx, index) =>
                              OrderItemDesign(order.orders[index]),
                          itemCount: order.orders.length,
                        ));
              }
            }
          },
        ));
  }
}
