import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../data/database/database_helper.dart';
import '../data/models/donation_case_model.dart';
import 'auth_controller.dart';

class DonationCaseController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  var cases = <DonationCase>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch cases only if needed or called explicitly. 
    // Usually called from bindings or view init.
    fetchCases();
  }

  Future<void> fetchCases() async {
    isLoading.value = true;
    cases.value = await _dbHelper.getAllCases();
    isLoading.value = false;
  }

  var pickedImagePath = Rxn<String>();

  void clearForm() {
    pickedImagePath.value = null;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImagePath.value = image.path;
    }
  }

  Future<void> addCase(String title, String description, double targetAmount, String? imagePath) async {
    final authController = Get.find<AuthController>();
    final userId = authController.currentUser.value?.id;
    if (userId == null) return;
    
    isLoading.value = true;
    final newCase = DonationCase(
      title: title,
      description: description,
      targetAmount: targetAmount,
      status: 'open',
      imagePath: imagePath ?? pickedImagePath.value,
      createdBy: userId,
      createdAt: DateTime.now().toIso8601String(),
    );
    await _dbHelper.createCase(newCase);
    await fetchCases();
    isLoading.value = false;
    clearForm();
  }

  Future<void> updateCase(DonationCase dCase) async {
    final authController = Get.find<AuthController>();
    final userId = authController.currentUser.value?.id;
    if (userId == null) return;

    isLoading.value = true;
    await _dbHelper.updateCase(dCase, userId);
    await fetchCases();
    isLoading.value = false;
  }
}
