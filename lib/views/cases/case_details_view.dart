import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/donation_case_model.dart';
import '../../controllers/donation_controller.dart';
import '../../controllers/donor_controller.dart';
import '../../data/models/donation_model.dart';
import '../../routes/app_routes.dart';

import 'dart:io';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/full_screen_map.dart';

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

  Widget _buildImage(String? path) {
    if (path == null || path.isEmpty) {
      return Container(height: 200, color: Colors.grey[300], child: Icon(Icons.image, size: 50));
    }
    if (Uri.parse(path).isAbsolute && path.startsWith('http')) {
      return Image.network(path, height: 200, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_,__,___) => Icon(Icons.broken_image));
    } else {
      return Image.file(File(path), height: 200, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_,__,___) => Icon(Icons.broken_image));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(donationCase.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             _buildImage(donationCase.imagePath),
              
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
                    Text('${'target'.tr}: \$${donationCase.targetAmount}'),
                    Text('${'collected'.tr}: \$${donationCase.collectedAmount}'),
                  ]),
                  SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: donationCase.collectedAmount / donationCase.targetAmount,
                    minHeight: 10,
                  ),
                  
                  if (donationCase.hasLocation && donationCase.latitude != null && donationCase.longitude != null) ...[
                    SizedBox(height: 24),
                    Text('Location', style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => FullScreenMap(latitude: donationCase.latitude!, longitude: donationCase.longitude!));
                      },
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: IgnorePointer( // Ignore map interactions so tap goes to GestureDetector
                             ignoring: true, 
                             child: FlutterMap(
                               options: MapOptions(
                                 initialCenter: LatLng(donationCase.latitude!, donationCase.longitude!),
                                 initialZoom: 13,
                               ),
                               children: [
                                 TileLayer(
                                   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                   userAgentPackageName: 'com.charity.organization',
                                 ),
                                 MarkerLayer(markers: [
                                   Marker(
                                     point: LatLng(donationCase.latitude!, donationCase.longitude!), 
                                     width: 80,
                                     height: 80,
                                     child: Icon(Icons.location_on, color: Colors.red, size: 40)
                                   )
                                 ])
                               ]
                             ),
                          ),
                        ),
                      ),
                    )
                  ],
                  
                  SizedBox(height: 24),
                  Text('donations'.tr, style: Theme.of(context).textTheme.titleLarge),
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
          Get.toNamed(AppRoutes.ADD_DONATION, arguments: {'case': donationCase});
        }, 
        label: Text('donate'.tr),
        icon: Icon(Icons.volunteer_activism),
      ),
    );
  }
}
