import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'item_model.dart';

class SharedPreferencesManager {
  // Lấy instance của SharedPreferences
  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // Lưu danh sách item vào SharedPreferences
  static Future<void> saveItems(List<Item> items) async {
    final prefs = await _getPrefs();
    List<String> itemsJson =
        items.map((item) => jsonEncode(item.toJson())).toList();

    // In ra danh sách trước khi lưu để kiểm tra
    print("Saving items to SharedPreferences: $itemsJson");

    // Lưu vào SharedPreferences
    await prefs.setStringList('items', itemsJson);
  }

  // Tải danh sách item từ SharedPreferences
  static Future<List<Item>> loadItems() async {
    final prefs = await _getPrefs();
    List<String>? itemsJson = prefs.getStringList('items');

    // Kiểm tra xem có dữ liệu trong SharedPreferences không
    if (itemsJson != null) {
      print("Loaded items from SharedPreferences: $itemsJson");

      // Chuyển đổi dữ liệu từ JSON thành danh sách item
      return itemsJson
          .map((itemJson) => Item.fromJson(jsonDecode(itemJson)))
          .toList();
    }

    // Nếu không có dữ liệu
    print("No data found in SharedPreferences.");
    return [];
  }
}
