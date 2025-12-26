import 'package:get/get.dart';
import '../controllers/admin_request_controller.dart';

class AdminRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminRequestController>(() => AdminRequestController());
  }
}
