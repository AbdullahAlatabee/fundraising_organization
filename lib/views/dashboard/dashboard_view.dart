import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/donation_case_controller.dart';
import '../../controllers/donation_controller.dart';
import '../../controllers/donor_controller.dart';
import '../../routes/app_routes.dart';

class DashboardView extends StatelessWidget {
  DashboardView({Key? key}) : super(key: key);

  final caseController = Get.find<DonationCaseController>();
  final donationController = Get.find<DonationController>();
  final donorController = Get.find<DonorController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('app_name'.tr)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('welcome'.tr, style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 20),
            // Stats Cards
            Row(
              children: [
                Expanded(child: _buildStatCard('cases'.tr, caseController.cases.length.toString(), Icons.folder, Colors.orange)),
                SizedBox(width: 16),
                Expanded(child: Obx(() => _buildStatCard('donors'.tr, donorController.donors.length.toString(), Icons.people, Colors.blue))),
              ],
            ),
            SizedBox(height: 16),
            Obx(() {
                 double total = donationController.donations.fold(0, (sum, item) => sum + item.amount);
                 return _buildStatCard('total_donations'.tr, '\$${total.toStringAsFixed(2)}', Icons.monetization_on, Colors.green);
            }),
            SizedBox(height: 24),
            Text('recent_activity'.tr, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            // Recent Donations List (Top 5)
            Obx(() {
              if (donationController.isLoading.value) return Center(child: CircularProgressIndicator());
              if (donationController.donations.isEmpty) return Text('No recent activity');
              
              final recent = donationController.donations.take(5).toList();
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: recent.length,
                itemBuilder: (context, index) {
                  final donation = recent[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.history, color: Colors.grey),
                      title: Text('\$${donation.amount} - ${donation.donationType}'),
                      subtitle: Text(donation.donationDate.split('T')[0]),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Obx(() => Card( // Obx here just in case parent rebuilds, but mostly value handles it if it's obx
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 10),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            SizedBox(height: 5),
            Text(title, style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    ));
  }
}
