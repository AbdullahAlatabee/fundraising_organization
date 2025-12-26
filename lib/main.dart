import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
// import 'routes/app_routes.dart';
import 'bindings/initial_binding.dart';
import 'themes/app_theme.dart';
import 'translations/app_translations.dart';
// import 'controllers/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We can access SettingsController via Get because we will put it in initialBinding
    // But InitialBinding runs when app starts. To set initial theme correctly from start, 
    // we might need to load prefs in main or just let GetX handle it with a flicker or default.
    // For simplicity, we assume default light/en and then controller updates it.
    
    return GetMaterialApp(
      title: 'Charity Management',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      
      // Theme
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system, // Controlled by SettingsController later
      
      // Localization
      translations: AppTranslations(),
      locale: Locale('ar', 'SA'), 
      fallbackLocale: Locale('en', 'US'),
      
      // Routes
      initialRoute: AppPages.INITIAL,
      // Actually AuthMiddleware logic redirects to Login if NOT logged in.
      // But if we start at HOME, middleware checks.
      // If we start at LOGIN, we should check if already logged in to redirect to HOME.
      // My AuthController checks login status on init.
      // Let's set initialRoute to HOME and let middleware redirect to LOGIN if failed.
      getPages: AppPages.routes,
    );
  }
}
