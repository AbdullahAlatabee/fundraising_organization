import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/donation_controller.dart';
import '../../views/widgets/app_drawer.dart';

class DonationsView extends GetView<DonationController> {
  const DonationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('donations'.tr)),
      drawer: AppDrawer(),
      body: Obx(() {
        if (controller.isLoading.value) return Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemCount: controller.donations.length,
          itemBuilder: (context, index) {
            final donation = controller.donations[index];
            return ListTile(
              leading: Icon(Icons.attach_money, color: Colors.green),
              title: Text('\$${donation.amount}'),
              subtitle: Text('Case ID: ${donation.caseId} | Donor ID: ${donation.donorId}'),
              trailing: Text(donation.donationDate.split('T')[0]),
            );
          },
        );
      }),
    );
  }
}
