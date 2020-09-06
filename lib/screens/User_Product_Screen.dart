import '../Provider/Products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/User_Product_Item.dart';
import '../widgets/Drawer.dart';
import '../screens/Edit_Product_Screen.dart';

class UserProductScreen extends StatelessWidget {
  static const rootName = '/UserProduct';
  // ignore: unused_element
  Future<void> _fetchNew(BuildContext context) async {
    await Provider.of<Products>(context,listen: false).fetchproductdatafromfireoasw(true);
  }

  @override
  Widget build(BuildContext context) {
    //final products = Provider.of<Products>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: DrawerPage(),
      body: FutureBuilder(
        future: _fetchNew(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _fetchNew(context),
                    child: Consumer<Products>(
                      builder: (ctx,productsload,_)=> ListView.builder(
                          itemCount: productsload.items.length,
                          itemBuilder: (_, i) => Column(
                                children: [
                                  UserProductItem(productsload.items[i].id,
                                      productsload.items[i].title, productsload.items[i].imageUrl),
                                  Divider(),
                                ],
                              )),
                    ),
                  ),
      ),
    );
  }
}
