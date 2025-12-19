import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (Get.find<AuthController>().isAuthenticated.value) {
      return null;
    } else {
      return RouteSettings(name: AppRoutes.LOGIN);
    }
  }
}
