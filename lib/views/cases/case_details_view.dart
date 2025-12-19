import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/donation_case_model.dart';
import '../../controllers/donation_controller.dart';
import '../../controllers/donor_controller.dart';
import '../../data/models/donation_model.dart';
import '../../routes/app_routes.dart';

class CaseDetailsView extends StatefulWidget {
  const CaseDetailsView({Key? key}) : super(key: key);

  @override
  State<CaseDetailsView> createState() => _CaseDetailsViewState();
}

class _CaseDetailsViewState extends State<CaseDetailsView> {
  final DonationCase donationCase = Get.arguments as DonationCase;
  final DonationController donationController = Get.find<DonationController>();
  final DonorController donorController = Get.find<DonorController>();
  
  RxList<Donation> caseDonations = <Donation>[].obs;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    caseDonations.value = await donationController.getDonationsByCase(donationCase.id!);
  }

  String _getDonorName(int donorId) {
    var donor = donorController.donors.firstWhereOrNull((d) => d.id == donorId);
    return donor?.fullName ?? 'Unknown Donor';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(donationCase.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             if (donationCase.imagePath != null && donationCase.imagePath!.isNotEmpty)
              Image.network(
                donationCase.imagePath!, 
                height: 200, 
                width: double.infinity, 
                fit: BoxFit.cover,
                errorBuilder: (_,__,___) => Container(height: 200, color: Colors.grey, child: Icon(Icons.broken_image)),
              ),
              
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(donationCase.title, style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(height: 8),
                  Text(donationCase.description, style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: 16),
                  
                  // Progress
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Target: \$${donationCase.targetAmount}'),
                    Text('Collected: \$${donationCase.collectedAmount}'),
                  ]),
                  SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: donationCase.collectedAmount / donationCase.targetAmount,
                    minHeight: 10,
                  ),
                  
                  SizedBox(height: 24),
                  Text('Donations', style: Theme.of(context).textTheme.titleLarge),
                  Divider(),
                ],
              ),
            ),
             Obx(() => ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: caseDonations.length,
                itemBuilder: (ctx, i) {
                  final d = caseDonations[i];
                  return ListTile(
                    leading: Icon(Icons.monetization_on, color: Colors.green),
                    title: Text(_getDonorName(d.donorId)),
                    subtitle: Text(d.donationDate.split('T')[0]),
                    trailing: Text('\$${d.amount}'),
                  );
                },
              )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to add donation with this case pre-selected
          Get.toNamed(AppRoutes.ADD_DONATION, arguments: {'case': donationCase});
        }, 
        label: Text('Donate'),
        icon: Icon(Icons.volunteer_activism),
      ),
    );
  }
}
