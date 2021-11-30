import 'package:flutter/material.dart';
import '../../app_state/router/routes.dart';

class YummyRouteInformationParser
    extends RouteInformationParser<YummyRoutePath> {
  @override
  Future<YummyRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);

    if (uri.pathSegments[0] == 'search') {
      return SearchPath();
    } else if (uri.pathSegments[0] == 'carts') {
      return CartsPath();
    } else if (uri.pathSegments[0] == 'recipes-manager') {
      return RecipesManagerPath();
    } else if (uri.pathSegments[0] == 'profile') {
      return ProfilePath();
    } else {
      return Error404Path();
    }
  }

  @override
  RouteInformation restoreRouteInformation(YummyRoutePath configuration) {
    if (configuration is SearchPath) {
      return const RouteInformation(location: '/search');
    } else if (configuration is CartsPath) {
      return const RouteInformation(location: '/carts');
    } else if (configuration is RecipesManagerPath) {
      return const RouteInformation(location: '/recipes-manager');
    } else if (configuration is ProfilePath) {
      return const RouteInformation(location: '/profile');
    } else {
      return null;
    }
  }
}
