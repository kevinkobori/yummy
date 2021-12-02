import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yummy/utils/constants.dart';

import './app_state/router/route_information_parser.dart';
import './app_state/router/router_delegate.dart';
import './controllers/brands/brand_manager.dart';
import './controllers/carts/cart_manager.dart';
import './controllers/user/user_manager.dart';
import './utils/theme.dart';
import 'controllers/ingredients/ingredient.dart';
import 'controllers/ingredients/ingredient_manager.dart';
import 'controllers/recipes/recipe.dart';
import 'controllers/recipes/recipe_manager.dart';
import 'controllers/search/search_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(YummyApp());
}

class YummyApp extends StatelessWidget {
  final YummyRouterDelegate _routerDelegate = YummyRouterDelegate();
  final YummyRouteInformationParser _routeInformationParser =
      YummyRouteInformationParser();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.azulMarinhoEscuro,
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => SearchManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => BrandManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => Recipe(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => RecipeManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => Ingredient(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => IngredientManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
              cartManager..updateUser(userManager),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: theme(),
        title: 'Yummy',
        routerDelegate: _routerDelegate,
        routeInformationParser: _routeInformationParser,
      ),
    );
  }
}
