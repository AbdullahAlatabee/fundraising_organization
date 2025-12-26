import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
// import '../../routes/app_routes.dart';

class RegisterView extends GetView<AuthController> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // Role selection defaulting to staff, usually admin is special but let's allow choice for demo
  final RxString selectedRole = 'staff'.obs;

  RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('register'.tr), backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.black),
      extendBodyBehindAppBar: true,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
           gradient: LinearGradient(
            colors: [Get.theme.primaryColor.withOpacity(0.8), Get.theme.colorScheme.secondary.withOpacity(0.8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'register'.tr,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Get.theme.primaryColor,
                          ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'name'.tr,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'email'.tr,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'password'.tr,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    Obx(() => DropdownButtonFormField<String>(
                      value: selectedRole.value,
                      items: [
                        DropdownMenuItem(child: Text('Staff'), value: 'staff'),
                        DropdownMenuItem(child: Text('Admin'), value: 'admin'),
                      ], 
                      onChanged: (v) => selectedRole.value = v!,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        labelText: 'Role'
                      ),
                    )),
                    SizedBox(height: 30),
                    Obx(() => controller.isLoading.value
                        ? CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
                                  Get.snackbar('Error', 'required_field'.tr);
                                  return;
                                }
                                await controller.register(
                                  nameController.text.trim(),
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                  selectedRole.value,
                                );
                                Get.back(); // Go back to login
                                Get.snackbar('Success', 'Registered successfully. Please login.');
                              },
                              child: Text('register'.tr, style: TextStyle(fontSize: 18)),
                            ),
                          )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
