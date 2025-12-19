import 'package:get/get.dart';
import '../data/database/database_helper.dart';
import '../data/models/donor_model.dart';
import 'auth_controller.dart';

class DonorController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  var donors = <Donor>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDonors();
  }

  Future<void> fetchDonors() async {
    isLoading.value = true;
    donors.value = await _dbHelper.getAllDonors();
    isLoading.value = false;
  }
  
  Future<void> searchDonors(String query) async {
    if (query.isEmpty) {
      fetchDonors();
      return;
    }
    isLoading.value = true;
    donors.value = await _dbHelper.searchDonors(query);
    isLoading.value = false;
  }

  Future<void> addDonor(String fullName, String phone, String? address, String? notes) async {
    final authController = Get.find<AuthController>();
    final userId = authController.currentUser.value?.id;
    if (userId == null) return;

    isLoading.value = true;
    final newDonor = Donor(
      fullName: fullName,
      phone: phone,
      address: address,
      notes: notes,
      createdBy: userId,
      createdAt: DateTime.now().toIso8601String(),
    );
    await _dbHelper.createDonor(newDonor);
    await fetchDonors();
    isLoading.value = false;
  }

  Future<void> updateDonor(Donor donor) async {
    final authController = Get.find<AuthController>();
    final userId = authController.currentUser.value?.id;
    if (userId == null) return;

    isLoading.value = true;
    await _dbHelper.updateDonor(donor, userId);
    await fetchDonors();
    isLoading.value = false;
  }
  
  Future<void> deleteDonor(int id) async {
     final authController = Get.find<AuthController>();
    final userId = authController.currentUser.value?.id;
    if (userId == null) return;
    
    isLoading.value = true;
    await _dbHelper.deleteDonor(id, userId);
    await fetchDonors();
    isLoading.value = false;
  }
}
