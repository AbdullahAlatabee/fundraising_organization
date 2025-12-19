import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../controllers/donation_case_controller.dart';
import '../controllers/donation_controller.dart';
import '../controllers/donor_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/auth_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<DonationCaseController>(() => DonationCaseController());
    Get.lazyPut<DonationController>(() => DonationController());
    Get.lazyPut<DonorController>(() => DonorController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    // AuthController is permanent
  }
}
