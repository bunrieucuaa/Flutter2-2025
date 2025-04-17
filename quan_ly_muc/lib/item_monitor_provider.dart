import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'item_model.dart';

class ItemMonitorProvider extends InheritedWidget {
  final List<Item> items;
  final List<Item> monitoringItem;
  final void Function(Item item) toggleMonitoring;
  final void Function() notifyListeners;

  const ItemMonitorProvider({
    super.key,
    required super.child,
    required this.items,
    required this.monitoringItem,
    required this.toggleMonitoring,
    required this.notifyListeners,
  });

  static ItemMonitorProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ItemMonitorProvider>();
  }

  @override
  bool updateShouldNotify(ItemMonitorProvider oldWidget) {
    return items != oldWidget.items ||
        monitoringItem != oldWidget.monitoringItem;
  }

  // Phương thức lưu danh sách item vào SharedPreferences
  Future<void> saveItems() async {
    final prefs = await SharedPreferences.getInstance();

    // Chuyển đổi danh sách thành JSON
    List<String> itemsJson =
        items.map((item) => jsonEncode(item.toJson())).toList();

    // Lưu trữ danh sách items vào SharedPreferences
    await prefs.setStringList('items', itemsJson);
  }

  // Phương thức khôi phục danh sách item từ SharedPreferences
  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? itemsJson = prefs.getStringList('items');

    if (itemsJson != null) {
      items.clear();
      for (var itemJson in itemsJson) {
        items.add(Item.fromJson(jsonDecode(itemJson)));
      }
      notifyListeners(); // Cập nhật giao diện sau khi load dữ liệu
    }
  }
}
