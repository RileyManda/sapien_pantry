import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String kCacheExpirationKey = 'cache_expiration';
  static const String kCacheDataKeyPrefix = 'cache_data_';
  static const Duration kDefaultCacheDuration = Duration(minutes: 5);

  final SharedPreferences _preferences;
  CacheService(this._preferences);

   static Map<String, Object> cache = new HashMap<String, Object>();

  static String setCacheData({required String cacheKey, required String cacheData, Duration? cacheDuration}) {
    cache[cacheKey] = cacheData;
    if (cacheDuration != null) {
      // TODO: Set expiration for the cache entry
    }
    return cacheData;
  }



  static Object? getCacheData(String key) {
    return cache[key];
  }

  bool isExpired(String key) {
    final expiration = _preferences.getString('$kCacheExpirationKey$key');
    if (expiration == null) return true;

    final expirationDate = DateTime.parse(expiration);
    return DateTime.now().isAfter(expirationDate);
  }

  String? getData(String key) {
    return _preferences.getString('$kCacheDataKeyPrefix$key');
  }


  Future<void> setData(String key, String data, [Duration? duration]) async {
    await _preferences.setString('$kCacheDataKeyPrefix$key', data);
    final expirationDate = DateTime.now().add(duration ?? kDefaultCacheDuration);
    await _preferences.setString('$kCacheExpirationKey$key', expirationDate.toString());
  }
}
