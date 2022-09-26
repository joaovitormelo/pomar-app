class ServerRouteInfo {
  final String path;
  final String method;

  ServerRouteInfo({required this.path, required this.method});
}

class ServerRoutes {
  //AUTH
  static ServerRouteInfo login = ServerRouteInfo(path: "login", method: "post");
  static ServerRouteInfo logout =
      ServerRouteInfo(path: "logout", method: "post");

  //EMPLOYEE
  static ServerRouteInfo readEmployees =
      ServerRouteInfo(path: "employees", method: "get");
  static ServerRouteInfo createEmployee =
      ServerRouteInfo(path: "employee", method: "post");
  static ServerRouteInfo updateEmployee =
      ServerRouteInfo(path: "employee", method: "put");
  static ServerRouteInfo deleteEmployee =
      ServerRouteInfo(path: "employee", method: "delete");

  //SCHEDULE
  static ServerRouteInfo readEvents =
      ServerRouteInfo(path: "events", method: "get");
}
