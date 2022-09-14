class ServerRouteInfo {
  final String path;
  final String method;

  ServerRouteInfo({required this.path, required this.method});
}

class ServerRoutes {
  static ServerRouteInfo login = ServerRouteInfo(path: "login", method: "post");
  static ServerRouteInfo logout =
      ServerRouteInfo(path: "logout", method: "post");
  static ServerRouteInfo readEmployees =
      ServerRouteInfo(path: "employees", method: "get");
  static ServerRouteInfo createEmployee =
      ServerRouteInfo(path: "employee", method: "post");
}
