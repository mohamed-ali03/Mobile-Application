class OrderModel {
  String? orderID;
  String itemID;
  String userID;
  String? status;
  double? rate;
  List<String>? ingredients;

  OrderModel({
    this.orderID,
    required this.itemID,
    required this.userID,
    this.status,
    this.rate,
    this.ingredients,
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
      orderID: json['orderID'] as String?,
      itemID: json['itemID'] as String? ?? '',
      userID: json['userID'] as String? ?? '',
      status: json['status'] as String?,
      rate: (json['rate'] as num?)?.toDouble(),
      ingredients: json['ingredients'] != null
          ? List<String>.from(json['ingredients'] as List)
          : null,
    );
  }
}
