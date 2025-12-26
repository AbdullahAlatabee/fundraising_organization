import 'package:get/get.dart';
import '../controllers/public_request_controller.dart';

class PublicRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PublicRequestController>(() => PublicRequestController());
  }
}
