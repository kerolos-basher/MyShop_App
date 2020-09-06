import 'package:MyShop_App/Provider/Products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/ProductGrid.dart';
import '../widgets/badge.dart';
import '../Provider/ShopingCard.dart';
import '../screens/Cart.dart';
import '../widgets/Drawer.dart';

enum FilterOPtion { Favourit, All }

class ProductOverOiwewScreen extends StatefulWidget {
  @override
  _ProductOverOiwewScreenState createState() => _ProductOverOiwewScreenState();
  
}

class _ProductOverOiwewScreenState extends State<ProductOverOiwewScreen> {
  
  bool _isFavouritSelected = false;
  bool isinit =true;
  bool isload = false;
  @override
  void didChangeDependencies() {
   if(isinit)
   {
     setState(() {
        isload = true;
     });
     Provider.of<Products>(context).fetchproductdatafromfireoasw().then((_) {
       setState(() {
          isload = false;
       });
     });
   }
   isinit=false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            color: Colors.white,
            onSelected: (FilterOPtion selectedValue) {
              setState(() {
                if (selectedValue == FilterOPtion.Favourit) {
                  _isFavouritSelected = true;
                } else {
                  _isFavouritSelected = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only Favourt'), value: FilterOPtion.Favourit),
              PopupMenuItem(child: Text('Show All'), value: FilterOPtion.All),
            ],
          ),
        Consumer<Cardd>(
            builder: (ctx ,cart,child)=>   Badge(
            // ignore: missing_required_param
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: (){
                Navigator.of(context).pushNamed(Cart.rootName);
              },
            ),
            value: cart.itemCount.toString(),
            
          ),
        )
        ],
          
      ),
    drawer:   DrawerPage(),
      body: isload? Center(child: CircularProgressIndicator(),):  ProductGrid(_isFavouritSelected),
    );
    return scaffold;
  }
}
