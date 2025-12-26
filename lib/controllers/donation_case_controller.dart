import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../data/database/database_helper.dart';
import '../data/models/donation_case_model.dart';
import 'auth_controller.dart';
import 'package:latlong2/latlong.dart';

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
  var pickedLocation = Rxn<LatLng>(); // Use LatLng from latlong2

  void clearForm() {
    pickedImagePath.value = null;
    pickedLocation.value = null;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImagePath.value = image.path;
    }
  }

  void setLocation(LatLng location) {
    pickedLocation.value = location;
  }

  Future<void> addCase(String title, String description, double targetAmount, String? imagePath, 
      {double? lat, double? lng, String? address, bool hasLoc = false}) async {
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
      latitude: lat ?? pickedLocation.value?.latitude,
      longitude: lng ?? pickedLocation.value?.longitude,
      addressDescription: address,
      hasLocation: hasLoc || pickedLocation.value != null,
    );
    await _dbHelper.createCase(newCase);
    await fetchCases();
    isLoading.value = false;
    clearForm();
  }

  Future<void> completeRequest(int requestId) async {
    await _dbHelper.updateRequestStatus(requestId, 'approved');
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
