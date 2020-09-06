import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/product_OverView_Screen.dart';
import './screens/Product_dtail_Screen.dart';
import './Provider/Products.dart';
import './Provider/ShopingCard.dart';
import './screens/Cart.dart';
import './screens/Order_Screen.dart';
import 'screens/User_Product_Screen.dart';
import './Provider/Orders.dart';
import './screens/16.1 splash_screen.dart';
import './screens/Edit_Product_Screen.dart';
import './screens/4.1 auth_screen.dart';
import './Provider/auth.dart';
import './helpers/Custom_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            //هو دة الى بيغير كل الويدجت المستعمعة له فقط ومش بيخلى كل الابكليشن يعمل ريبلد
            create: (ctx) => Auth(),
          ),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider <Auth, Products> (
                                                                   //هو دة الى بيغير كل الويدجت المستعمعة له فقط ومش بيخلى كل الابكليشن يعمل ريبلد
            update: (ctx, auth, prevousproducts) => Products(auth.token,auth.userId,
                prevousproducts == null ? [] : prevousproducts.items,
                ),
          ),
          ChangeNotifierProvider(
            //هو دة الى بيغير كل الويدجت المستعمعة له فقط ومش بيخلى كل الابكليشن يعمل ريبلد
            create: (ctx) => Cardd(),
          ),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth,Orders>(
            //هو دة الى بيغير كل الويدجت المستعمعة له فقط ومش بيخلى كل الابكليشن يعمل ريبلد
            update: (ctx,authh,prevoisOrder) => Orders(authh.token,authh.userId,prevoisOrder == null ? [] : prevoisOrder.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.cyan,
              accentColor: Colors.red,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              pageTransitionsTheme: PageTransitionsTheme(builders:{
              TargetPlatform.android:CustomPageTransitionBuilder(),
              TargetPlatform.iOS:CustomPageTransitionBuilder()
              }),
            ),
            home: auth.isAuth ? ProductOverOiwewScreen() :FutureBuilder(
               future: auth.tryToAoutoLogIn(),
               builder: (ctx,snapshotdata)=>
               snapshotdata.connectionState == ConnectionState.waiting ? 
               SplashScreen()
               :AuthScreen()),
            routes: {
              ProductDetailScreen.rootName: (ctx) => ProductDetailScreen(),
              OrderScreen.rootName: (ctx) => OrderScreen(),
              Cart.rootName: (ctx) => Cart(),
              UserProductScreen.rootName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen()
            },
          ),
        ));
  }
}
