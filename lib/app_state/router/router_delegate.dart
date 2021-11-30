import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app_state/app_shell.dart';
import '../../app_state/router/app_state.dart';
import '../../app_state/router/routes.dart';

class YummyRouterDelegate extends RouterDelegate<YummyRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<YummyRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  YummyAppState appState = YummyAppState();

  YummyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    appState.addListener(notifyListeners);
  }

  @override
  YummyRoutePath get currentConfiguration {
    if (appState.selectedIndex == 0) {
      return SearchPath();
    } else if (appState.selectedIndex == 1) {
      return CartsPath();
    } else if (appState.selectedIndex == 2) {
      return RecipesManagerPath();
    } else if (appState.selectedIndex == 3) {
      return ProfilePath();
    } else {
      return Error404Path();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: navigatorKey,
        pages: [
          MaterialPage(
            child: AppShell(appState: appState),
          ),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return true;
          }
          notifyListeners();
          return true;
        },
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(YummyRoutePath path) async {
    if (path is SearchPath) {
      appState.selectedIndex = 0;
    } else if (path is CartsPath) {
      appState.selectedIndex = 1;
    } else if (path is RecipesManagerPath) {
      appState.selectedIndex = 2;
    } else if (path is ProfilePath) {
      appState.selectedIndex = 3;
    }
  }
}
