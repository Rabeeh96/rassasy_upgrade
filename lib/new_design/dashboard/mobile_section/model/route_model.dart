class RouteModelClass {
  final String routeName,routeUID;
  int routeID;


  RouteModelClass({
    required this.routeName,
    required this.routeUID,
    required this.routeID

  });

  factory RouteModelClass.fromJson(Map<dynamic, dynamic> json) {
    return RouteModelClass(
        routeName: json['RouteName'],
        routeUID: json['id'],
        routeID: json['RouteID']

    );
  }
}
