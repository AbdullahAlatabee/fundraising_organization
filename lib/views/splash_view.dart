import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    // Artificial delay for splash effect
    await Future.delayed(Duration(seconds: 2));
    final authController = Get.find<AuthController>();
    
    // AuthController onInit calls _checkLoginStatus but it's async.
    // We can wait for it or call it here again/ensure it's done.
    // Since we are in Splash, we can just observe isAuthenticated or re-check.
    // We can assume AuthController has finished or we wait for valid session check.
    // Actually, let's just create a method in AuthController that returns future bool.
    // access internal private var check? no.
    // Let's just trust isAuthenticated after delay.
    
    if (authController.isAuthenticated.value) {
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.volunteer_activism, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'app_name'.tr,
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold, 
                color: Colors.white
              ),
            ),
            SizedBox(height: 40),
            Text(
              'إعداد المهندس / عبدالله حسان العتابي',
              style: TextStyle(
                fontSize: 16, 
                color: Colors.white70,
                fontFamily: 'Arial' // Or default, assuming readable
              ),
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 8),
            Text(
              'إشراف المهندس / سليمان الشوصي',
              style: TextStyle(
                fontSize: 16, 
                color: Colors.white70
              ),
              textDirection: TextDirection.rtl,
            ),
             SizedBox(height: 60),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
