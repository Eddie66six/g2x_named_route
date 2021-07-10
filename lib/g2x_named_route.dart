library g2x_named_route;

import 'package:flutter/material.dart';

class G2xRoute {
  var _routeList = <RouteDefinition>[];
  void define(RouteDefinition route) => _routeList..add(route);
  Map<String, String>? _parameters;

  int _currentIndexPage = -1;
  Route<dynamic>? generate(RouteSettings settings) {
      _currentIndexPage = _routeList.indexWhere((e) => matchRoute(e.route, settings.name!));
    if(_currentIndexPage == -1) return null;
    var page = _routeList[_currentIndexPage].page(_parameters, settings.arguments);
    return MaterialPageRoute(builder: (context) => page,  settings: settings);
  }

  String _prepareToRegex(String url) {
    final newUrl = <String>[];
    for (var part in url.split('/')) {
      var url = part.contains(":") ? "(.*?)" : part;
      newUrl.add(url);
    }
    return newUrl.join("/");
  }

  void _generateParameters (String routeNamed, String url){
     var arrayRouteWithParameter = url.split("/");
    var arrayRouteWithoutParameter = routeNamed.split("/");
    _parameters = Map<String, String>();
    for (var i = 0; i < arrayRouteWithoutParameter.length; i++) {
      if(arrayRouteWithoutParameter[i].indexOf(":") > -1){
        _parameters![arrayRouteWithoutParameter[i].replaceFirst(":", "")] = arrayRouteWithParameter[i];
      }
    }
  }

  bool matchRoute(String routeNamed, String url){
    if(routeNamed == url) return true;
    if (!routeNamed.contains('/:')) return false;
    final regExp = RegExp(
      "^${_prepareToRegex(routeNamed)}\$",
      caseSensitive: true,
    );
    if(regExp.hasMatch(url)){
      _generateParameters(routeNamed, url);
      return true;
    }
    return false;
  }
}
class RouteDefinition {
  String route;
  Widget Function(Map<String, String>? parameters, Object? arguments) page;
  RouteDefinition({
    required this.route,
    required this.page,
  });
}