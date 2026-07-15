import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
  }

  /// Open a box dynamically if not already opened
  static Future<Box<T>> openBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<T>(boxName);
    }
    return Hive.box<T>(boxName);
  }

  /// Save data to a specified box
  static Future<void> saveData<T>(String boxName, String key, T value) async {
    final box = await openBox<T>(boxName);
    await box.put(key, value);
  }

  /// Get data from a specified box
  static Future<T?> getData<T>(String boxName, String key) async {
    final box = await openBox<T>(boxName);
    return box.get(key);
  }

  /// Get all values from a box
  static Future<List<T>> getAllData<T>(String boxName) async {
    final box = await openBox<T>(boxName);
    return box.values.toList().cast<T>();
  }

  /// Delete an item by key
  static Future<void> deleteData<T>(String boxName, String key) async {
    final box = await openBox<T>(boxName);
    await box.delete(key);
  }

  /// Clear all data from a box
  static Future<void> clearBox<T>(String boxName) async {
    final box = await openBox<T>(boxName);
    await box.clear();
  }
}
