import 'package:MyShop_App/Provider/Products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/Edit_Product_Screen.dart';
class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;
  UserProductItem(this.id,this.title,this.imgUrl);
  @override
  Widget build(BuildContext context) {
    final scaffol = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(imgUrl),),
      title:Text(title),
      trailing: Container(width: 100,child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(icon: Icon(Icons.edit),onPressed: (){
            Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: id);
          
          },color: Theme.of(context).primaryColorDark,),
           IconButton(icon: Icon(Icons.delete),onPressed: () async{
             try
             {
                 await Provider.of<Products>(context).deletproduct(id);
             }catch(error)
             {
              scaffol.showSnackBar(
                SnackBar(
                content: Text('Cant Delete',textAlign: TextAlign.center,),
              ));
             }

           }
           
           ,color: Theme.of(context).errorColor,)
        ],
      ),) ,
    );
  }
}