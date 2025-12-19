import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/donor_model.dart';
import '../../controllers/donation_controller.dart';
import '../../data/models/donation_model.dart';
import '../../routes/app_routes.dart';

class DonorDetailsView extends StatefulWidget {
  const DonorDetailsView({Key? key}) : super(key: key);

  @override
  State<DonorDetailsView> createState() => _DonorDetailsViewState();
}

class _DonorDetailsViewState extends State<DonorDetailsView> {
  final Donor donor = Get.arguments as Donor;
  final DonationController donationController = Get.find<DonationController>();
  RxList<Donation> history = <Donation>[].obs;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    history.value = await donationController.getDonationsByDonor(donor.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(donor.fullName), actions: [
        IconButton(icon: Icon(Icons.edit), onPressed: () => Get.toNamed(AppRoutes.ADD_EDIT_DONOR, arguments: donor)),
      ]),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.phone),
                title: Text(donor.phone),
                subtitle: Text(donor.address ?? 'No Address'),
              ),
            ),
            if (donor.notes != null && donor.notes!.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Notes: ${donor.notes}'),
              ),
            ),
            SizedBox(height: 20),
            Text('Donation History', style: Theme.of(context).textTheme.titleLarge),
            Divider(),
            Obx(() => ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: history.length,
              itemBuilder: (ctx, i) {
                 final d = history[i];
                 return ListTile(
                   title: Text('\$${d.amount} - ${d.donationType}'),
                   subtitle: Text(d.donationDate.split('T')[0]),
                 );
              }
            ))
          ],
        ),
      ),
    );
  }
}
