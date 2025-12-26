import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

class LoginView extends GetView<AuthController> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Get.theme.primaryColor, Get.theme.colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
                    Icon(Icons.volunteer_activism, size: 80, color: Get.theme.primaryColor),
                    SizedBox(height: 20),
                    Text(
                      'login'.tr,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Get.theme.primaryColor,
                          ),
                    ),
                    SizedBox(height: 30),
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
                    SizedBox(height: 30),
                    Obx(() => controller.isLoading.value
                        ? CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                bool success = await controller.login(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );
                                if (success) {
                                  Get.offAllNamed(AppRoutes.HOME);
                                } else {
                                  Get.snackbar('Error', 'Invalid credentials');
                                }
                              },
                              child: Text('login'.tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          )),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.REGISTER),
                      child: Text('register'.tr),
                    ),
                    TextButton.icon(
                      onPressed: () => Get.toNamed(AppRoutes.PUBLIC_REQUEST),
                      icon: Icon(Icons.help_outline),
                      label: Text('Need Help? Submit Request', style: TextStyle(color: Colors.grey[700])),
                    ),
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
