class OrderModel {
  String orderID;
  String itemID;
  String userID;
  String status;
  double? rate;
  Map<String, bool> ingredients;

  OrderModel({
    required this.orderID,
    required this.itemID,
    required this.userID,
    required this.status,
    required this.ingredients,
    this.rate,
  });

  Map<String, dynamic> toMap() => {
    'orderID': orderID,
    'itemID': itemID,
    'userID': userID,
    'status': status,
    'rate': rate,
    'ingredients': ingredients,
  };

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderID: json['orderID'] as String,
      itemID: json['itemID'] as String? ?? '',
      userID: json['userID'] as String? ?? '',
      status: json['status'] as String,
      rate: (json['rate'] as num?)?.toDouble(),
      ingredients: Map<String, bool>.from(json['ingredients'] ?? {}),
    );
  }
}
