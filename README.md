# g2x_named_route

A new Flutter package project.

## Getting Started

    //create intance
    var g2xRoute = G2xRoute();
    
    //define routes
    g2xRoute.define(RouteDefinition(
      route: "/",
      page: (_, __) => SplashPage()
    ));
    g2xRoute.define(RouteDefinition(
      route: "/home",
      page: (_, __) => HomePage()
    ));
    //route parameters
    g2xRoute.define(RouteDefinition(
      route: "/home/details/:id/:n/:oo",
      page: (Map<String, String>? parameters, dynamic args) {
        //parameters: visible on route
        if(parameters == null) return ErrorPage();
        Widget? internalParameter;
        if(args != null){
          //args: not visible on route
          internalParameter = args["center"];
        }
        return HomeDetailsPage(id: int.parse(parameters["id"].toString()));
      }
    ));

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      onGenerateRoute: g2xRoute.generate,// insert route into the app
    );

## Navigator
    //use native navigator
    //"/home/details/:id/:n/:oo"
    Navigator.pushNamed(context, "/home/details/10/12/01", arguments: {"center": Center()});