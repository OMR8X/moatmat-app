class CacheConstant {
  static const String cacheSubDir = '/app_cache';
  static const String boxName = 'hive_cache';
  static const int cacheValidSeconds = (60 * 60) * (24);

  ///ad
  static String userCreateKey(String email) => 'user_create_$email';
  static String userDataKey(String email) => 'user_data_$email';
  // purchases
  static String get resultsKey => 'results_key';
  //
  static String get purchasedItemsCreateKey => 'purchased_items_create_key';
  static String get purchasedItemsDataKey => 'purchased_items_data_key';
}
