class OrderItem {
  final String itemId;
  final String name;
  final double price;
  final int qty;

  OrderItem({
    required this.itemId,
    required this.name,
    required this.price,
    required this.qty,
  });

  Map<String, dynamic> toMap() => {
    'itemId': itemId,
    'name': name,
    'price': price,
    'qty': qty,
  };

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      itemId: json['itemId'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      qty: json['qty'],
    );
  }
}
