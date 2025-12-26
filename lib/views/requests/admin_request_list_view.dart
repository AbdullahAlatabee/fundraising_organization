import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_request_controller.dart';
import '../../routes/app_routes.dart';

class AdminRequestListView extends GetView<AdminRequestController> {
  const AdminRequestListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Requests')),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        if (controller.requests.isEmpty) return const Center(child: Text('No pending requests'));
        
        return ListView.builder(
          itemCount: controller.requests.length,
          itemBuilder: (context, index) {
             final req = controller.requests[index];
             return Card(
               margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
               child: ListTile(
                 leading: CircleAvatar(
                   backgroundColor: Colors.blue.withOpacity(0.1),
                   child: Icon(req.imagePath != null ? Icons.image : Icons.description, color: Colors.blue),
                 ),
                 title: Text(req.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                 subtitle: Text(req.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                 trailing: Icon(Icons.arrow_forward_ios, size: 16),
                 onTap: () {
                   Get.toNamed(AppRoutes.ADMIN_REQUEST_DETAILS, arguments: req);
                 },
               ),
             );
          },
        );
      }),
    );
  }
}
