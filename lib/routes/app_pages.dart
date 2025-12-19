import 'package:fundraising_organization/views/profile/profile_view.dart';
import 'package:get/get.dart';
import '../views/main/main_view.dart';
import '../bindings/main_binding.dart';
import 'app_routes.dart';
import '../middleware/auth_middleware.dart';
import '../bindings/initial_binding.dart'; 
import '../bindings/home_binding.dart';
import '../bindings/donor_binding.dart';
import '../bindings/donation_binding.dart';

import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';
import '../views/home/home_view.dart';
import '../views/cases/add_case_view.dart';
import '../views/cases/case_details_view.dart';
import '../views/donors/donors_view.dart';
import '../views/donors/add_edit_donor_view.dart';
import '../views/donors/donor_details_view.dart';
import '../views/donations/donations_view.dart';
import '../views/donations/add_donation_view.dart';
import '../views/settings/settings_view.dart';
import '../views/settings/activity_logs_view.dart';
import '../views/splash_view.dart';

class AppPages {
  static const INITIAL = AppRoutes.SPLASH;

  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashView(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginView(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => RegisterView(),
    ),


    GetPage(
      name: AppRoutes.HOME,
      page: () => MainView(),
      binding: MainBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.ADD_CASE,
      page: () => AddCaseView(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.CASE_DETAILS,
      page: () => CaseDetailsView(),
      binding: HomeBinding(), // Needs DonationController too, which HomeBinding has
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.DONORS,
      page: () => DonorsView(),
      binding: DonorBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.ADD_EDIT_DONOR,
      page: () => AddEditDonorView(),
      binding: DonorBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.DONOR_DETAILS,
      page: () => DonorDetailsView(),
      binding: DonorBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.DONATIONS,
      page: () => DonationsView(),
      binding: DonationBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.ADD_DONATION,
      page: () => AddDonationView(),
      binding: DonationBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => ProfileView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.SETTINGS,
      page: () => SettingsView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.LOGS,
      page: () => ActivityLogsView(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
