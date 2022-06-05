// ignore_for_file: constant_identifier_names

class UserData {
  static const String COLLECTION_NAME = 'Users';
  String id;
  String name;
  String email;
  String password;

  UserData(
      {required this.id,
      required this.name,
      required this.email,
      required this.password});

  UserData.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          name: json['name'] as String,
          email: json['email'] as String,
          password: json['password'] as String,
        );

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'password': password};
  }
}
