import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/app_drawer.dart';

class ProfileView extends GetView<AuthController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = controller.currentUser.value;
    return Scaffold(
      appBar: AppBar(title: Text('profile'.tr)),
      drawer: AppDrawer(),
      body: Center(
        child: user == null 
            ? Text('Not logged in')
            : Card(
                margin: EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(radius: 40, child: Text(user.name[0].toUpperCase(), style: TextStyle(fontSize: 40))),
                      SizedBox(height: 20),
                      Text(user.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(user.email, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Chip(label: Text(user.role.toUpperCase())),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => controller.logout(),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: Text('logout'.tr),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
