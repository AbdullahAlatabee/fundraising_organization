import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/donor_controller.dart';
import '../../routes/app_routes.dart';

class DonorsView extends GetView<DonorController> {
  final TextEditingController searchController = TextEditingController();

  DonorsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('donors'.tr)),
      // drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'search_donor'.tr,
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(icon: Icon(Icons.clear), onPressed: () {
                   searchController.clear();
                   controller.fetchDonors();
                }),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (val) => controller.searchDonors(val),
            ),
          ),
          Expanded(
            child: Obx(() => controller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: controller.donors.length,
                  itemBuilder: (context, index) {
                    final donor = controller.donors[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(donor.fullName[0].toUpperCase())),
                      title: Text(donor.fullName),
                      subtitle: Text(donor.phone),
                      onTap: () => Get.toNamed(AppRoutes.DONOR_DETAILS, arguments: donor),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    );
                  },
              )
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.ADD_EDIT_DONOR),
        child: Icon(Icons.person_add),
      ),
    );
  }
}
