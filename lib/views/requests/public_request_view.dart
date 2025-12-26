import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:latlong2/latlong.dart';
import 'dart:io';
import '../../controllers/public_request_controller.dart';
import '../widgets/map_picker.dart';

class PublicRequestView extends GetView<PublicRequestController> {
  const PublicRequestView({Key? key}) : super(key: key);

  void _showMapPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Container(
        height: Get.height * 0.8,
        child: MapPicker(
          initialLocation: controller.pickedLocation.value,
          onLocationPicked: (location) {
            controller.setLocation(location);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Request'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Case Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              return Column(
                children: [
                  if (controller.pickedImage.value != null)
                    Stack(
                       alignment: Alignment.topRight,
                       children: [
                         Image.file(File(controller.pickedImage.value!), height: 150, fit: BoxFit.cover),
                         IconButton(
                           icon: const Icon(Icons.close, color: Colors.white, size: 30), // Simple visual remove
                           onPressed: () => controller.pickedImage.value = null,
                         )
                       ]
                    ),
                  ElevatedButton.icon(
                    onPressed: controller.pickImage,
                    icon: const Icon(Icons.image),
                    label: Text(controller.pickedImage.value == null ? 'Attach Proof Image' : 'Change Image'),
                  ),
                ],
              );
            }),
            const SizedBox(height: 16),
            Obx(() {
              final loc = controller.pickedLocation.value;
              return Column(
                children: [
                  if (loc != null)
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.location_on, color: Colors.blue),
                        title: Text('Location Selected'),
                        subtitle: Text('${loc.latitude.toStringAsFixed(4)}, ${loc.longitude.toStringAsFixed(4)}'),
                        trailing: IconButton(icon: Icon(Icons.edit), onPressed: () => _showMapPicker(context)),
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: () => _showMapPicker(context),
                    icon: const Icon(Icons.map),
                    label: Text(loc == null ? 'Select Location on Map' : 'Change Location'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: loc != null ? Colors.green : null,
                      foregroundColor: loc != null ? Colors.white : null,
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 32),
            Obx(() => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: controller.submitRequest,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Submit Request'),
                  )),
          ],
        ),
      ),
    );
  }
}
