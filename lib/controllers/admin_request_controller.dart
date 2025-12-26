import 'package:get/get.dart';
import '../data/database/database_helper.dart';
import '../data/models/donation_request_model.dart';
// import '../data/models/donation_case_model.dart';
// import 'auth_controller.dart';

class AdminRequestController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  var requests = <DonationRequest>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    isLoading.value = true;
    requests.value = await _dbHelper.getPendingRequests();
    isLoading.value = false;
  }

  Future<void> rejectRequest(DonationRequest request) async {
    await _dbHelper.updateRequestStatus(request.id!, 'rejected');
    fetchRequests();
    Get.back();
    Get.snackbar('Rejected', 'Request marked as rejected');
  }

  // Acceptance logic is handled via navigation to AddCaseView
}
