// ignore_for_file: constant_identifier_names

class UserData {
  static const String COLLECTION_NAME = 'Users';
  String id;
  String userInput;

  UserData(
      {required this.id,
      required this.userInput,});

  UserData.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          userInput: json['email'] as String,
        );

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': userInput,};
  }
}
