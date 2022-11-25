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
  static ServerRouteInfo readEventsByEmployee =
      ServerRouteInfo(path: "events/employee", method: "post");
  static ServerRouteInfo addEvent =
      ServerRouteInfo(path: "event", method: "post");
  static ServerRouteInfo editEvent =
      ServerRouteInfo(path: "event", method: "put");
  static ServerRouteInfo deleteEvent =
      ServerRouteInfo(path: "event", method: "delete");

  //WHATSAPP
  static ServerRouteInfo checkConnectionWhats =
      ServerRouteInfo(path: "whatsapp/check_connection", method: "get");
  static ServerRouteInfo disconnectWhats =
      ServerRouteInfo(path: "whatsapp/disconnect", method: "get");
  static ServerRouteInfo sendMessages =
      ServerRouteInfo(path: "whatsapp/send", method: "post");
}
