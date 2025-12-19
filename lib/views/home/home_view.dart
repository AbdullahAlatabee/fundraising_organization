import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/donation_case_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import '../widgets/app_drawer.dart';

class HomeView extends GetView<DonationCaseController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('dashboard'.tr),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: () => controller.fetchCases()),
        ],
      ),
      drawer: AppDrawer(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.cases.isEmpty) {
          return Center(child: Text('No active cases'));
        }
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: controller.cases.length,
          itemBuilder: (context, index) {
            final donationCase = controller.cases[index];
            final percent = donationCase.targetAmount > 0 
                ? (donationCase.collectedAmount / donationCase.targetAmount) 
                : 0.0;
            
            return Card(
              margin: EdgeInsets.only(bottom: 16),
              elevation: 4,
              child: InkWell(
                onTap: () => Get.toNamed(AppRoutes.CASE_DETAILS, arguments: donationCase),
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Placeholder image or file image
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        image: donationCase.imagePath != null
                          ? DecorationImage(
                              image: NetworkImage(donationCase.imagePath!), // Or FileImage if local
                              fit: BoxFit.cover,
                              onError: (_, __) => Icon(Icons.broken_image), // Fallback
                            ) 
                          : null,
                      ),
                      child: donationCase.imagePath == null 
                          ? Icon(Icons.image, size: 50, color: Colors.grey[500]) 
                          : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  donationCase.title,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Chip(
                                label: Text(donationCase.status.toUpperCase()),
                                backgroundColor: donationCase.status == 'completed' ? Colors.green[100] : Colors.blue[100],
                                labelStyle: TextStyle(
                                  color: donationCase.status == 'completed' ? Colors.green : Colors.blue,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 8),
                          Text('collected'.tr + ': \$${donationCase.collectedAmount} / \$${donationCase.targetAmount}'),
                          SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: percent > 1.0 ? 1.0 : percent,
                            backgroundColor: Colors.grey[200],
                            color: Get.theme.primaryColor,
                            minHeight: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.ADD_CASE), 
        child: Icon(Icons.add),
      ),
    );
  }
}
