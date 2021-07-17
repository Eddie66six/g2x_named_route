library g2x_named_route;

import 'package:flutter/material.dart';

class G2xRoute {
  var _routeList = <RouteDefinition>[];
  void define(RouteDefinition route) => _routeList..add(route);
  Map<String, String>? _parameters;

  int _currentIndexPage = -1;
  Route<dynamic>? generate(RouteSettings settings) {
      _currentIndexPage = _routeList.indexWhere((e) => matchRoute(e.route, settings));
    if(_currentIndexPage == -1) return null;
    var _settings = settings;
    if(_routeList[_currentIndexPage].showQueryParameters){
       if (_settings.arguments != null && _settings.arguments is Map<String, String>) {
        _settings = RouteSettings(name: Uri(path: _settings.name, queryParameters: _settings.arguments as Map<String, String>).toString());
      }
    }
    var page = _routeList[_currentIndexPage].page(_parameters, _settings.arguments);
    return MaterialPageRoute(builder: (context) => page,  settings: _settings);
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
    if(_parameters == null)
      _parameters = Map<String, String>();
    for (var i = 0; i < arrayRouteWithoutParameter.length; i++) {
      if(arrayRouteWithoutParameter[i].indexOf(":") > -1){
        _parameters![arrayRouteWithoutParameter[i].replaceFirst(":", "")] = arrayRouteWithParameter[i];
      }
    }
  }

  bool matchRoute(String routeNamed, RouteSettings routeSettings){
    if(routeNamed == routeSettings.name) return true;
    if(routeSettings.name!.indexOf("?") > -1){
      var uriData = Uri.parse(routeSettings.name!);
      routeSettings = RouteSettings(name: uriData.path);
      _parameters = Map<String, String>();
      _parameters = Map.of(uriData.queryParameters);
    }
    if (!routeNamed.contains('/:')){
      return routeNamed == routeSettings.name;
    };
    final regExp = RegExp(
      "^${_prepareToRegex(routeNamed)}\$",
      caseSensitive: true,
    );
    if(regExp.hasMatch(routeSettings.name!)){
      _generateParameters(routeNamed, routeSettings.name!);
      return true;
    }
    return false;
  }
}

///Config route
///[showQueryParameters] if true, the [arguments] must be of type Map <String, String>
class RouteDefinition {
  String route;
  bool showQueryParameters;
  Widget Function(Map<String, String>? parameters, Object? arguments) page;
  RouteDefinition({
    required this.route,
    required this.page,
    this.showQueryParameters = false
  });
}