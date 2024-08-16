import 'package:get_it/get_it.dart';
import 'package:moatmat_app/User/Core/injection/banks_inj.dart';
import 'package:moatmat_app/User/Core/injection/notifications_inf.dart';
import 'package:moatmat_app/User/Core/injection/reports_inj.dart';
import 'package:moatmat_app/User/Core/injection/results_inj.dart';
import 'package:moatmat_app/User/Core/injection/tests_inj.dart';
import 'package:moatmat_app/User/Core/injection/update_inj.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_inj.dart';
import 'codes_inj.dart';
import 'purchases_inj.dart';

var locator = GetIt.instance;
initGetIt() async {
  //
  var sp = await SharedPreferences.getInstance();
  locator.registerSingleton(sp);
  //

  injectAuth();
  codesInjector();
  injectBanks();
  injectTests();
  purchasesInjector();
  injectReports();
  injectNotifications();
  injectResults();
  injectUpdate();
}
