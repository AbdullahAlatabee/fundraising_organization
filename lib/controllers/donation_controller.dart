import 'package:get/get.dart';
import '../data/database/database_helper.dart';
import '../data/models/donation_model.dart';
import 'auth_controller.dart';
import 'donation_case_controller.dart';

class DonationController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  var donations = <Donation>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDonations();
  }

  Future<void> fetchDonations() async {
    isLoading.value = true;
    donations.value = await _dbHelper.getAllDonations();
    isLoading.value = false;
  }
  
  Future<List<Donation>> getDonationsByCase(int caseId) async {
    return await _dbHelper.getDonationsByCase(caseId);
  }
  
  Future<List<Donation>> getDonationsByDonor(int donorId) async {
    return await _dbHelper.getDonationsByDonor(donorId);
  }

  Future<void> addDonation(int donorId, int caseId, double amount, String type) async {
    final authController = Get.find<AuthController>();
    final userId = authController.currentUser.value?.id;
    if (userId == null) return;

    isLoading.value = true;
    final newDonation = Donation(
      donorId: donorId,
      caseId: caseId,
      amount: amount,
      donationType: type,
      donationDate: DateTime.now().toIso8601String(),
      addedBy: userId,
    );
    await _dbHelper.createDonation(newDonation);
    await fetchDonations();
    
    // Refresh cases to show updated amounts
    if (Get.isRegistered<DonationCaseController>()) {
      Get.find<DonationCaseController>().fetchCases();
    }
    
    isLoading.value = false;
  }
}
