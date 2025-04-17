class Item {
  String name;
  String value;
  bool isMonitoring;

  Item({required this.name, required this.value, this.isMonitoring = false});

  // Phương thức copyWith để sao chép đối tượng với các giá trị mới
  Item copyWith({String? name, String? value, bool? isMonitoring}) {
    return Item(
      name: name ?? this.name,
      value: value ?? this.value,
      isMonitoring: isMonitoring ?? this.isMonitoring,
    );
  }

  // Phương thức chuyển đổi Item thành Map để lưu trữ dưới dạng JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'isMonitoring': isMonitoring,
    };
  }

  // Phương thức tạo Item từ Map (chuyển từ JSON)
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      value: json['value'],
      isMonitoring: json['isMonitoring'],
    );
  }
}
