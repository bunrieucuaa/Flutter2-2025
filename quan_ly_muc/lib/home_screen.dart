import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as custom_badge;
import 'package:quan_ly_muc/shared_preferences_manager.dart';
import 'item_list_screen.dart';
import 'item_monitor_provider.dart';
import 'item_monitoring_screen.dart';
import 'item_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  List<Item> _items = [];

  @override
  void initState() {
    super.initState();
    // Khởi tạo TabController với vsync là this (vì chúng ta dùng SingleTickerProviderStateMixin)
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void toggleMonitoring(Item item) {
    setState(() {
      final index = _items.indexWhere((d) => d == item);
      if (index != -1) {
        _items[index] = _items[index].copyWith(
          isMonitoring: !_items[index].isMonitoring,
        );
      }
    });
  }

  void notifyListeners() {
    setState(() {});
  }

  Future<List<Item>> _loadItems() async {
    return await SharedPreferencesManager
        .loadItems(); // Tải dữ liệu từ SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    final monitoredCount = _items.where((d) => d.isMonitoring).length;

    return ItemMonitorProvider(
      items: _items,
      monitoringItem: _items.where((item) => item.isMonitoring).toList(),
      toggleMonitoring: toggleMonitoring,
      notifyListeners: notifyListeners,
      child: Scaffold(
        appBar: AppBar(title: const Text('Ứng dụng của tôi')),
        body: FutureBuilder<List<Item>>(
          future: _loadItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator()); // Đợi dữ liệu
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text('Lỗi: ${snapshot.error}')); // In lỗi nếu có
            }

            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('Không có dữ liệu!')); // Nếu không có dữ liệu
            }

            // Sau khi dữ liệu được tải, cập nhật lại _items
            _items = snapshot.data ?? [];

            return TabBarView(
              controller: _tabController,
              children: const [ItemListScreen(), ItemMonitoringScreen()],
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _tabController.animateTo(index); // Di chuyển đến tab tương ứng
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.devices),
              label: 'Danh sách mục',
            ),
            BottomNavigationBarItem(
              icon: monitoredCount > 0
                  ? custom_badge.Badge(
                      badgeContent: Text(
                        '$monitoredCount',
                        style: const TextStyle(color: Colors.white),
                      ),
                      child: const Icon(Icons.bar_chart),
                    )
                  : const Icon(Icons.bar_chart),
              label: 'Theo dõi',
            ),
          ],
        ),
      ),
    );
  }
}
