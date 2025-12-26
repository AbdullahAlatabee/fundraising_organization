import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';
import '../../controllers/admin_request_controller.dart';
import '../../data/models/donation_request_model.dart';
import '../../routes/app_routes.dart';

class AdminRequestDetailView extends GetView<AdminRequestController> {
  const AdminRequestDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     final DonationRequest req = Get.arguments as DonationRequest;
     
     return Scaffold(
       appBar: AppBar(title: const Text('Request Details')),
       body: SingleChildScrollView(
         padding: const EdgeInsets.all(16),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
             Text(req.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
             const SizedBox(height: 8),
             Row(
               children: [
                 const Icon(Icons.phone, size: 20, color: Colors.grey),
                 const SizedBox(width: 8),
                 Text(req.phone, style: const TextStyle(fontSize: 16)),
               ],
             ),
             const SizedBox(height: 16),
             const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
             Text(req.description, style: const TextStyle(fontSize: 16)),
             const SizedBox(height: 16),
             if (req.imagePath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(File(req.imagePath!), height: 200, fit: BoxFit.cover)
                ),
             
             if (req.latitude != null && req.longitude != null) ...[
                const SizedBox(height: 16),
                const Text('Location:', style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  height: 200,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(req.latitude!, req.longitude!),
                      initialZoom: 13,
                    ),
                    children: [
                       TileLayer(
                         urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                         userAgentPackageName: 'com.charity.organization.admin',
                       ),
                       MarkerLayer(markers: [
                         Marker(
                           point: LatLng(req.latitude!, req.longitude!),
                           width: 80,
                           height: 80,
                           child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                         )
                       ])
                    ]
                  )
                )
             ],
             
             const SizedBox(height: 30),
             Row(
               children: [
                 Expanded(
                   child: ElevatedButton(
                     style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                     onPressed: () => controller.rejectRequest(req),
                     child: const Text('Reject'),
                   ),
                 ),
                 const SizedBox(width: 16),
                 Expanded(
                   child: ElevatedButton(
                     style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                     onPressed: () {
                        // Go to AddCaseView pre-filled
                        Get.toNamed(AppRoutes.ADD_CASE, arguments: {
                          'name': req.name,
                          'description': req.description,
                          'imagePath': req.imagePath,
                          'latitude': req.latitude,
                          'longitude': req.longitude,
                          'requestId': req.id,
                        })?.then((_) => controller.fetchRequests()); // Refresh list on return
                     },
                     child: const Text('Approve'),
                   ),
                 ),
               ],
             )
           ],
         ),
       ),
     );
  }
}
