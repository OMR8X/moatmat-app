import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:moatmat_app/User/Core/injection/banks_inj.dart';
import 'package:moatmat_app/User/Core/injection/cache_assets_inj.dart';
import 'package:moatmat_app/User/Core/injection/cash_inj.dart';
import 'package:moatmat_app/User/Core/injection/controllers_inj.dart';
import 'package:moatmat_app/User/Core/injection/notifications_inf.dart';
import 'package:moatmat_app/User/Core/injection/notifications_inj.dart';
import 'package:moatmat_app/User/Core/injection/reports_inj.dart';
import 'package:moatmat_app/User/Core/injection/results_inj.dart';
import 'package:moatmat_app/User/Core/injection/school_inj.dart';
import 'package:moatmat_app/User/Core/injection/tests_inj.dart';
import 'package:moatmat_app/User/Core/injection/update_inj.dart';
import 'package:moatmat_app/User/Core/injection/video_inj.dart';
import 'package:moatmat_app/User/Core/services/api/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_inj.dart';
import 'codes_inj.dart';
import 'purchases_inj.dart';

var locator = GetIt.instance;
initGetIt() async {
  //
  var sp = await SharedPreferences.getInstance();
  if (!locator.isRegistered<SharedPreferences>()) {
    locator.registerSingleton<SharedPreferences>(sp);
  } //
  if (!locator.isRegistered<SupabaseClient>()) {
    locator.registerSingleton<SupabaseClient>(Supabase.instance.client);
  }
  locator.registerSingleton<ApiManager>(ApiManager());

  injectAuth();
  await injectNotifications();
  codesInjector();
  await injectCacheAssets();
  injectBanks();
  injectTests();
  purchasesInjector();
  injectReports();
  // injectNotifications2();
  injectResults();
  injectUpdate();
  injectCache();
  injectSchool();
  injectControllers();
  injectVideo();
}
