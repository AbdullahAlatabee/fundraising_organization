import 'package:get/get.dart';
import '../controllers/donor_controller.dart';
import '../controllers/donation_controller.dart';

class DonorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DonorController>(() => DonorController());
    Get.lazyPut<DonationController>(() => DonationController());
  }
}
