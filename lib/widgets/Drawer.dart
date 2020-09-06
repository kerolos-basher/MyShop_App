import 'package:MyShop_App/helpers/Custom_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/Order_Screen.dart';
import '../helpers/Custom_helper.dart';
import '../Provider/auth.dart';
import '../screens/User_Product_Screen.dart';
class DrawerPage extends StatelessWidget {
  Widget buldlisttilewid(String text, IconData icon, Function taphandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        text,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      onTap: taphandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(15),
            alignment: Alignment.bottomCenter,
            color: Theme.of(context).primaryColor,
            child: Text(
              'Hellow Frind !',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900),
            ),
          ),
          buldlisttilewid('Shop', Icons.shop, () {
            Navigator.of(context).pushReplacementNamed('/');
          }),
          Divider(),
          buldlisttilewid('Orders', Icons.payment, () {
           //  Navigator.of(context).pushReplacementNamed(OrderScreen.rootName);
           Navigator.of(context).pushReplacement(CustomRoute(builder: (context)=>OrderScreen()));
          }),
           Divider(),
          buldlisttilewid('Manage Products', Icons.edit, () {
             Navigator.of(context).pushReplacementNamed(UserProductScreen.rootName);
          }),
          Divider(),
          buldlisttilewid('Log Out', Icons.exit_to_app, () {
            Navigator.of(context).pop();
             Provider.of<Auth>(context).logoout();
          }),
        ],
      ),
    );
  }
}
