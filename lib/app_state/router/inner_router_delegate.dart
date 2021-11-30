import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yummy/screens/recipes/recipes_screen.dart';

import '../../screens/carts/carts_page.dart';
import '../../screens/profile/profile_page.dart';
import '../../screens/recipes_manager/recipes_manager_page.dart';
import '../router/animations/fade_animation_page.dart';
import '../router/app_state.dart';
import '../router/routes.dart';

class InnerRouterDelegate extends RouterDelegate<YummyRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<YummyRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  YummyAppState get appState => _appState;
  YummyAppState _appState;
  set appState(YummyAppState value) {
    if (value == _appState) {
      return;
    }
    _appState = value;
    notifyListeners();
  }

  InnerRouterDelegate(this._appState);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (appState.selectedIndex == 0)
          FadeAnimationPage(
            child: RecipesScreen(),
            key: const ValueKey('searchPage'),
          )
        else if (appState.selectedIndex == 1)
          FadeAnimationPage(
            child: CartsPage(),
            key: const ValueKey('cartsPage'),
          ),
        if (appState.selectedIndex == 2)
          FadeAnimationPage(
            child: RecipesManagerPage(),
            key: const ValueKey('storePage'),
          ),
        if (appState.selectedIndex == 3)
          FadeAnimationPage(
            child: ProfilePage(),
            key: const ValueKey('profilePage'),
          ),
      ],
      onPopPage: (route, result) {
        notifyListeners();
        return route.didPop(result);
      },
    );
  }

  @override
  Future<void> setNewRoutePath(YummyRoutePath path) async {
    assert(false);
  }
}
