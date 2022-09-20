import 'package:fluro/fluro.dart';
import 'package:pomar_app/core/presentation/pages/loading_page.dart';
import 'package:pomar_app/core/presentation/routes/fluro_handlers.dart';

class FluroRoutes {
  static FluroRouter router = FluroRouter.appRouter;

  static String loadingRoute = "loading";
  static String loginRoute = "login";
  static String homeAdminRoute = "homeAdmin";
  static String homeEmployeeRoute = "homeEmployee";
  static String employeesRoute = "employees";
  static String addEmployeeRoute = "addEmployee";
  static String editEmployeeRoute = "editEmployee";

  static void setupRouter() {
    router.notFoundHandler =
        Handler(handlerFunc: (context, Map<String, dynamic> params) {
      return const LoadingPage();
    });
    router.define(loadingRoute, handler: FluroHandlers.loadingHandler);
    router.define(loginRoute, handler: FluroHandlers.loginHandler);
    router.define(homeAdminRoute, handler: FluroHandlers.homeAdminHandler);
    router.define(homeEmployeeRoute,
        handler: FluroHandlers.homeEmployeeHandler);
    router.define(employeesRoute, handler: FluroHandlers.employeesHandler);
    router.define(addEmployeeRoute, handler: FluroHandlers.addEmployeeHandler);
    router.define(editEmployeeRoute,
        handler: FluroHandlers.editEmployeeHandler);
  }
}
