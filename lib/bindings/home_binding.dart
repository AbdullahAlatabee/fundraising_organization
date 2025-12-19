import 'package:get/get.dart';
import '../controllers/donation_case_controller.dart';
import '../controllers/donation_controller.dart'; 
// Needed if we show donations in home statistics later or link navigation

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DonationCaseController>(() => DonationCaseController());
    Get.lazyPut<DonationController>(() => DonationController()); 
    Get.lazyPut<DonorController>(() => DonorController());
  }
}
