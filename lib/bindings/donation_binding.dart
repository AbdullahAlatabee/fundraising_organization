import 'package:get/get.dart';
import '../controllers/donation_controller.dart';
import '../controllers/donation_case_controller.dart';
import '../controllers/donor_controller.dart';

class DonationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DonationController>(() => DonationController());
    Get.lazyPut<DonationCaseController>(() => DonationCaseController());
    Get.lazyPut<DonorController>(() => DonorController());
  }
}
