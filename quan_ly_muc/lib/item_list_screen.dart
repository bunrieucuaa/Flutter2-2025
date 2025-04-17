import 'package:flutter/material.dart';
import 'package:quan_ly_muc/item_model.dart';
import 'package:quan_ly_muc/shared_preferences_manager.dart';
import 'item_monitor_provider.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});
  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = ItemMonitorProvider.of(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Danh sách mục'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await _showAddItemDialog(
                    context, provider!); // Mở dialog thêm mục
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: provider?.items.length ?? 0,
          itemBuilder: (context, index) {
            final item = provider!.items[index];
            return Dismissible(
              key: Key(item.name), // Dùng item name làm key duy nhất
              direction:
                  DismissDirection.endToStart, // Vuốt từ phải qua trái để xóa
              onDismissed: (direction) {
                // Xóa item khi vuốt
                provider.items.removeAt(index);
                provider.notifyListeners(); // Cập nhật lại danh sách
              },
              background: Container(
                color: Colors.red, // Màu nền khi vuốt
                child: const Icon(Icons.delete,
                    color: Colors.white), // Biểu tượng thùng rác
              ),
              child: ListTile(
                title: Text(item.name),
                subtitle: Text(item.value),
                trailing: Icon(
                  item.isMonitoring
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                ),
                onTap: () => provider.toggleMonitoring(item),
              ),
            );
          },
        ));
  }

  Future<void> _showAddItemDialog(
      BuildContext context, ItemMonitorProvider provider) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thêm mục mới'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên mục'),
              ),
              TextField(
                controller: _valueController,
                decoration: const InputDecoration(labelText: 'Giá trị'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            // Nút thêm
            TextButton(
              onPressed: () async {
                final name = _nameController.text.trim();
                final value = _valueController.text.trim();

                if (name.isNotEmpty && value.isNotEmpty) {
                  final newItem = Item(name: name, value: value);
                  provider.items.add(newItem); // Thêm vào danh sách
                  await SharedPreferencesManager.saveItems(
                      provider.items); // Lưu vào SharedPreferences
                  provider.notifyListeners(); // Cập nhật giao diện
                }

                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }
}
