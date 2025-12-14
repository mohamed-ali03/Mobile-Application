class Modification {
  int userVersion;
  int menuVersion;
  int cartVersion;

  Modification({
    required this.userVersion,
    required this.menuVersion,
    required this.cartVersion,
  });

  Map<String, dynamic> toMap() => {
    'userVersion': userVersion,
    'menuVersion': menuVersion,
    'cartVersion': cartVersion,
  };

  factory Modification.fromJson(Map<String, dynamic> json) => Modification(
    userVersion: json['userVersion'] ?? 0,
    menuVersion: json['menuVersion'] ?? 0,
    cartVersion: json['cartVersion'] ?? 0,
  );
}
