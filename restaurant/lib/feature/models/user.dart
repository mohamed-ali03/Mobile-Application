class UserModel {
  String? name;
  String? email;
  String? phoneNumber;
  String? location;
  String? uid;
  String? imageUrl;
  String? providerId;
  String? role;

  UserModel({
    this.name,
    this.email,
    this.phoneNumber,
    this.location,
    this.uid,
    this.imageUrl,
    this.providerId,
    this.role = 'customer',
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'providerId': providerId,
    'name': name,
    'role': role,
    'email': email,
    'phoneNumber': phoneNumber,
    'location': location,
    'image': imageUrl,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      providerId: json['providerId'],
      name: json['name'],
      role: json['role'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      location: json['location'],
      imageUrl: json['image'],
    );
  }
}
