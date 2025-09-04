import 'package:supabase_flutter/supabase_flutter.dart';

import '../injection/app_inj.dart';
import '../resources/supabase_r.dart';

class SupabaseServices {
  static Future<void> init() async {
    await Supabase.initialize(
      url: SupabaseResources.url,
      anonKey: SupabaseResources.key,
      debug: false,
    );
    locator.registerFactory(() => Supabase.instance.client);
  }
}
