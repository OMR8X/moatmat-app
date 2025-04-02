import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';

import 'cache_constant.dart';

abstract class CacheClient {
  /// initiate client
  Future<void> init(Directory appDir);

  /// check if key exist in cache
  bool exist(String key);

  /// write to cache
  Future<void> write(String key, dynamic data);

  /// read from cache
  Future<dynamic> read(String key);

  /// read all values from cache
  Future<dynamic> values();

  /// read all keys from cache
  Future<dynamic> keys();

  /// clear data of the passed key from cache
  Future<void> remove(String key);

  /// clear all data in cache
  Future<void> clear();
}

class HiveClient implements CacheClient {
  Box? _box;

  /// initiate hive box
  @override
  Future<void> init(Directory appDir) async {
    await Hive.initFlutter(appDir.path + CacheConstant.cacheSubDir);
    _box ??= await Hive.openBox(CacheConstant.boxName);
  }

  /// check if key exist in cache
  @override
  bool exist(String key) {
    return _box!.containsKey(key);
  }

  /// write to hive box
  @override
  Future<void> write(String key, dynamic data) async {
    await _box!.put(key, data);
  }

  /// read from hive box
  @override
  Future<dynamic> read(String key) async {
    final data = await _box!.get(key);
    return data;
  }

  /// read all values from hive box
  @override
  Future<dynamic> values() async {
    final data = await _box!.values.toList();
    return data;
  }

  /// read all keys from hive box
  @override
  Future<dynamic> keys() async {
    final data = await _box!.keys.toList();
    return data;
  }

  /// clear data of the passed key from hive box
  @override
  Future<void> remove(String key) async {
    await _box!.delete(key);
  }

  /// clear all data
  @override
  Future<void> clear() async {
    await Hive.deleteFromDisk();
  }
}
