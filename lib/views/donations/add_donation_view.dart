import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/donation_controller.dart';
import '../../controllers/donation_case_controller.dart';
import '../../controllers/donor_controller.dart';
import '../../data/models/donation_case_model.dart';
import '../../data/models/donor_model.dart';

class AddDonationView extends StatefulWidget {
  const AddDonationView({Key? key}) : super(key: key);

  @override
  State<AddDonationView> createState() => _AddDonationViewState();
}

class _AddDonationViewState extends State<AddDonationView> {
  final DonationController donationController = Get.find<DonationController>();
  final DonationCaseController caseController = Get.find<DonationCaseController>();
  final DonorController donorController = Get.find<DonorController>();

  DonationCase? selectedCase;
  Donor? selectedDonor;
  final TextEditingController amountController = TextEditingController();
  String selectedType = 'cash'; // cash, in-kind

  @override
  void initState() {
    super.initState();
    // Pre-select case if passed
    if (Get.arguments != null && Get.arguments is Map && Get.arguments['case'] != null) {
      final passedCase = Get.arguments['case'] as DonationCase;
      // We need to match it with the list from controller to ensure equality works for Dropdown
      // Or just set ID
      // Assuming controller has loaded cases.
      selectedCase = caseController.cases.firstWhereOrNull((c) => c.id == passedCase.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('add_donation'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Case Dropdown
            Obx(() {
               if (caseController.isLoading.value) return LinearProgressIndicator();
               return DropdownButtonFormField<DonationCase>(
                 value: selectedCase,
                 items: caseController.cases.map((c) => DropdownMenuItem(
                   child: Text(c.title, overflow: TextOverflow.ellipsis), 
                   value: c
                 )).toList(),
                 onChanged: (val) {
                   setState(() {
                     selectedCase = val;
                   });
                 },
                 decoration: InputDecoration(
                   labelText: 'Select Case',
                   border: OutlineInputBorder(),
                 ),
                 isExpanded: true,
               );
            }),
            SizedBox(height: 16),
            
            // Donor Dropdown
             Obx(() {
               if (donorController.isLoading.value) return LinearProgressIndicator();
               return DropdownButtonFormField<Donor>(
                 value: selectedDonor,
                 items: donorController.donors.map((d) => DropdownMenuItem(
                   child: Text(d.fullName), 
                   value: d
                 )).toList(),
                 onChanged: (val) {
                   setState(() {
                     selectedDonor = val;
                   });
                 },
                 decoration: InputDecoration(
                   labelText: 'Select Donor',
                   border: OutlineInputBorder(),
                 ),
                 isExpanded: true,
               );
            }),
             SizedBox(height: 16),

            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: selectedType,
              items: [
                DropdownMenuItem(child: Text('Cash'), value: 'cash'),
                DropdownMenuItem(child: Text('In-Kind'), value: 'in-kind'),
              ],
              onChanged: (v) => setState(() => selectedType = v!),
              decoration: InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
            ),
            
            SizedBox(height: 24),
            Obx(() => donationController.isLoading.value
              ? CircularProgressIndicator()
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (selectedCase == null || selectedDonor == null || amountController.text.isEmpty) {
                         Get.snackbar('Error', 'Please fill all fields');
                         return;
                      }
                      double? amount = double.tryParse(amountController.text);
                      if (amount == null) {
                         Get.snackbar('Error', 'Invalid amount');
                         return;
                      }
                      
                      await donationController.addDonation(
                        selectedDonor!.id!, 
                        selectedCase!.id!, 
                        amount, 
                        selectedType
                      );
                      Get.back();
                      Get.snackbar('Success', 'Donation added');
                    }, 
                    child: Text('Add Donation')
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
